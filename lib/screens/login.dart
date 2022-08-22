import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                              "Welcome Back",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23,
                                  color: Colors.grey[800]),
                            ),
                            Text(
                              "Hello again you've been missed!",
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
                                  return "Password required";
                                }
                                return null;
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

                                    final loginValidate =
                                        _formKey.currentState!.validate();

                                    if (loginValidate) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      try {
                                        
                                        final auth = FirebaseAuth.instance;
                                        final prefs = await SharedPreferences.getInstance();

                                        UserCredential currentUser = await auth
                                            .signInWithEmailAndPassword(
                                                email: emailController.text,
                                                password:
                                                    passwordController.text);
                                        setState(() {
                                          _submitted = false;
                                          isLoading = false;
                                        });

                                        await prefs.setString('email', emailController.text);
                                        
                                        showSnackbar(context,"Login successful !",3,Colors.green);
                                        Navigator.pushReplacementNamed(context, '/home');
                                        emailController.clear();
                                        passwordController.clear();
                                      } on FirebaseAuthException catch (e) {
                                        // print(e);
                                        // print(e.hashCode);

                                        String errorMessage = "";
                                        String code = e.code;

                                        if (code == "invalid-email") {
                                          errorMessage = "Invalid email.";
                                        } else if (code == "user-not-found") {
                                          errorMessage = "User not found.";
                                        } else if (code == "wrong-password") {
                                          errorMessage = "Invalid password.";
                                        } else if (code ==
                                            "too-many-requests") {
                                          errorMessage =
                                              "Too many request try again later";
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
                                          ))
                                      : const Text("Login")),
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
                                "Don't have an account? ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[800],
                                  fontSize: 12,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/register');
                                },
                                child: const Text(
                                  "Reigster here!",
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
