import 'package:PewPewChat/providers/friends_provider.dart';
import 'package:PewPewChat/screens/chat_screen.dart';
import 'package:PewPewChat/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:PewPewChat/AppTheme.dart';
import 'package:PewPewChat/screens/home_screen.dart';
import 'package:PewPewChat/screens/landing_screen.dart';
import 'package:PewPewChat/screens/auth_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    return FutureBuilder(
        future: _initialization,
        builder: (context, appSnapshot) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'PewPewChat',
            theme: AppTheme.lightTheme,
            home: appSnapshot.connectionState != ConnectionState.done
                ? SplashScreen()
                : SafeArea(child: LandingScreen()),
          );
        });
  }
}
