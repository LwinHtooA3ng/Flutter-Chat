import 'dart:math';
import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: DefaultTextStyle(
        style: TextStyle(color: Colors.grey[100]),
        child: SafeArea(
          child: Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                              top: 10,
                              left: 10,
                              child: Transform.rotate(
                                angle: -20 * pi / 180,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset("images/1.jpg",
                                        width: 100)),
                              )),
                          Positioned(
                              top: 0,
                              left: 150,
                              child: Transform.rotate(
                                angle: 10 * pi / 180,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child:
                                        Image.asset("images/2.jpg", width: 80)),
                              )),
                          Positioned(
                              bottom: 40,
                              right: 0,
                              child: Transform.rotate(
                                angle: -25 * pi / 180,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset("images/3.jpg",
                                        width: 160)),
                              )),
                          Positioned(
                              top: 150,
                              left: 0,
                              child: Transform.rotate(
                                angle: 20 * pi / 180,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset("images/4.jpg",
                                        width: 120)),
                              )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Flutter Chat",
                            style: TextStyle(
                                fontSize: 35, fontWeight: FontWeight.bold)),
                        Text(
                          "Connect with each other with flutter chat.",
                          style:
                              TextStyle(color: Colors.grey[300], fontSize: 13),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0, primary: Colors.white),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context, '/login');
                                },
                                child: const Text(
                                  "Login",
                                  style: TextStyle(color: Colors.teal),
                                ))),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    primary: Colors.white,
                                    side: const BorderSide(
                                        width: 1, color: Colors.white)),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context, '/register');
                                },
                                child: const Text("Register"))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
