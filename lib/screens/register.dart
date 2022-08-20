import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/snackbar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var isVisible = true;

  bool _submitted = false;

  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: DefaultTextStyle(
            style: TextStyle(color: Colors.grey[900]),
            child: Form(
              key: _formKey,
              autovalidateMode: _submitted
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Create Account",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23,
                                  color: Colors.grey[800]),
                            ),
                            Text(
                              "Connect with your friends today!",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Colors.grey[700]),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 3),
                              child: Text(
                                "Email Address",
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: emailController,
                              cursorColor: Colors.teal,
                              // style: TextStyle(color: Colors.grey[800]),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Email required";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "Enter your email",
                                hintStyle: const TextStyle(fontSize: 12),
                                labelStyle: TextStyle(color: Colors.grey[800]),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 3),
                              child: Text(
                                "Password",
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12),
                              ),
                            ),
                            TextFormField(
                              controller: passwordController,
                              cursorColor: Colors.teal,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Password can't be empty";
                                } else if (value.length < 6) {
                                  return "Password need 6 character";
                                } else {
                                  return null;
                                }
                              },
                              obscureText: isVisible,
                              decoration: InputDecoration(
                                hintText: "Enter your password",
                                hintStyle: const TextStyle(fontSize: 12),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isVisible = !isVisible;
                                    });
                                  },
                                  icon: (isVisible)
                                      ? Icon(
                                          Icons.visibility,
                                          color: Colors.grey[800],
                                        )
                                      : Icon(Icons.visibility_off,
                                          color: Colors.grey[800]),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0, primary: Colors.teal),
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();

                                    setState(() {
                                      _submitted = true;
                                    });

                                    final registerValid =
                                        _formKey.currentState!.validate();

                                    if (registerValid) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      try {
                                        final auth = FirebaseAuth.instance;

                                        final newUser = await auth
                                            .createUserWithEmailAndPassword(
                                                email: emailController.text,
                                                password:
                                                    passwordController.text,
                                              
                                                );
                                                
                                        // print(newUser);
                                        setState(() {
                                          isLoading = false;
                                          _submitted = false;
                                        });
                                        showSnackbar(context,"Register successful !",3,Colors.green);
                                        Navigator.pushReplacementNamed(context, '/login');
                                        emailController.clear();
                                        passwordController.clear();
                                      } on FirebaseAuthException catch (e) {
                                        String errorMessage = "";
                                        String code = e.code;

                                        if (code == "invalid-email") {
                                          errorMessage = "Invalid email.";
                                        } else if (code ==
                                            "email-already-in-use") {
                                          errorMessage =
                                              "Email was already in use.";
                                        } else if (code ==
                                            "too-many-requests") {
                                          errorMessage =
                                              "Too many request try again later.";
                                        } else if (code ==
                                            "network-request-failed") {
                                          errorMessage =
                                              "Your are currently offline.";
                                        } else {
                                          errorMessage =
                                              "Something went wrong please try again.";
                                        }

                                        showSnackbar(context, errorMessage, 1,
                                            Colors.red);
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    }
                                  },
                                  child: (isLoading)
                                      ? const SizedBox(
                                          width: 15,
                                          height: 15,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text("Register")),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Row(children: <Widget>[
                              const Expanded(
                                  child: Divider(
                                thickness: 1,
                              )),
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    "Or",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[700]),
                                  )),
                              const Expanded(
                                  child: Divider(
                                thickness: 1,
                              )),
                            ]),
                            const SizedBox(
                              height: 25,
                            ),
                            SizedBox(
                              height: 45,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    primary: Colors.grey,
                                    side: const BorderSide(
                                        width: 1, color: Colors.grey)),
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "images/ok.png",
                                      width: 30,
                                    ),
                                    Text(
                                      "  Login With Google",
                                      style: TextStyle(color: Colors.grey[800]),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 60),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account? ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[800],
                                  fontSize: 12,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/login');
                                },
                                child: const Text(
                                  " Login",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.teal,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
