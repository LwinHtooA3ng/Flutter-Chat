import 'package:flutter/material.dart';

import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';

class MessageCard extends StatelessWidget {
  String text;
  String sender;
  String name;
  bool isSendByMe;
  MessageCard(
      {Key? key,
      required this.text,
      required this.sender,
      required this.name,
      required this.isSendByMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isSendByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
          ChatBubble(
            clipper: ChatBubbleClipper5(
                type: (isSendByMe)
                    ? BubbleType.sendBubble
                    : BubbleType.receiverBubble),
            alignment:
                isSendByMe ? Alignment.bottomRight : Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 4, bottom: 4),
            backGroundColor: isSendByMe ? Colors.teal : Colors.white,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Text(
                text,
                style: TextStyle(
                    color: isSendByMe ? Colors.white : Colors.grey[900]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
