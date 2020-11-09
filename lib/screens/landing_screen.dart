import 'package:PewPewChat/screens/auth_screen.dart';
import 'package:PewPewChat/screens/chat_screen.dart';
import 'package:PewPewChat/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, userSnapshot) {
              if (userSnapshot.hasData) {
                return HomeScreen();
              }
              return AuthScreen();
            },
          )),
    );
  }
}
