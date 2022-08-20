import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/message_card.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController messageController = TextEditingController();

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // void getMessage() async {
  //   final message = await _firestore.collection("flutter_chat").get();
  //   for (var message in message.docs) {
  //     print(">>>>");
  //     print(message.data());
  //   }
  // }

  // void getMessageStream() async {
  //   await for (var snapshot
  //       in _firestore.collection("flutter_chat").snapshots()) {
  //     for (var message in snapshot.docs) {
  //       // print("...");
  //       // print(message.data());
  //     }
  //   }
  // }

  checkLogin() {
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  void initState() {
    // getMessageStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.teal,
            // title: const Text("Flutter Chat", style: TextStyle(fontSize: 17),),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Flutter Chat",
                  style: TextStyle(fontSize: 17),
                ),
                IconButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      checkLogin();
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.arrowRightFromBracket,
                      size: 18,
                    )),
              ],
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 6,
                  child: Container(
                    // padding: EdgeInsets.symmetric(vertical: 10),
                    child: StreamBuilder<QuerySnapshot>(
                      // stream: _firestore.collection("flutter_chat").orderBy('time_field', descending: true).snapshots(),
                      // stream: _firestore.collection("flutter_chat").orderBy('time_field', descending: true).snapshots(),
                      stream: _firestore.collection("flutter_chat").orderBy('timestamp', descending: false).snapshots(),
                      builder: (context, snapshot) {
                        List<MessageCard> messageWidgets = [];
                        if (snapshot.hasData) {
                          var messages = snapshot.data!.docs;
                          // for (var message in messages) {
                          //   var messageText = message;
                          //   final sender = messageText['sender'];
                          //   final text = messageText["text"];

                          //   final messageWidget = Text("$text from $sender");
                          //   messageWidgets.add(messageWidget);
                          // }
                          for (var message in messages) {
                            messageWidgets.add(MessageCard(
                                text: message['text'],
                                sender: message['sender'],
                                isSendByMe:
                                    FirebaseAuth.instance.currentUser!.email ==
                                            message['sender']
                                        ? true
                                        : false));
                          }
                        }
                        return SingleChildScrollView(
                          reverse: true,
                          child: Column(
                            children: messageWidgets,
                          ),
                        );
                      },
                    ),
                  )),
              Container(
                // color: Colors.grey[700],
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 2,
                          controller: messageController,
                          cursorColor: Colors.teal,
                          style:
                              TextStyle(color: Colors.grey[800], fontSize: 15),
                          decoration: InputDecoration(
                            // fillColor: Colors.grey[800],
                            fillColor: Colors.grey[300],
                            hintText: "Message",
                            hintStyle: const TextStyle(fontSize: 12),
                            filled: true,
                            isDense: true,
                            contentPadding:
                                const EdgeInsets.fromLTRB(15, 7, 15, 7),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                shape: const CircleBorder(),
                                primary: Colors.teal,
                                padding: EdgeInsets.zero),
                            onPressed: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              final String? email = prefs.getString('email');
                              if (messageController.text.isNotEmpty) {
                                _firestore.collection("flutter_chat").add({
                                  "sender": email,
                                  "text": messageController.text,
                                  "timestamp": DateTime.now()
                                });
                                messageController.clear();
                              }
                            },
                            child: 
                               const FaIcon(
                                    FontAwesomeIcons.arrowUp,
                                    color: Colors.white,
                                    size: 15,
                                  )
                            // child: Icon(
                            //   Icons.arrow_upward_rounded,
                            //   size: 20,
                            // ),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
