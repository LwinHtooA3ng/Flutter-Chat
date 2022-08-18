import 'package:flutter/material.dart';
import './screens/landing.dart';
import './screens/login.dart';
import './screens/register.dart';
import './screens/home.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FlutterChat());
}

class FlutterChat extends StatelessWidget {
  const FlutterChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.all(10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
      title: "Flutter Chat",
      initialRoute: "/",
      routes: {
        "/": (context) => const LandingScreen(),
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
        '/home' : (context) => const Home(),
      },
    );
  }
}
