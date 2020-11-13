import 'dart:async';
import 'dart:io';

import 'package:PewPewChat/services/auth_service.dart';
import 'package:PewPewChat/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
    BuildContext context,
  ) async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        //AuthService().loginUser(email, password);

        authResult = await _auth
            .signInWithEmailAndPassword(
          email: email,
          password: password,
        )
            .catchError((err) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('An error occured, please check your credentials!'),
              backgroundColor: Theme.of(context).errorColor,
            ),
          );
          setState(() {
            _isLoading = false;
          });
        });
      } else {
        AuthService().createUser(email, password, username, image);
      }
    } on PlatformException catch (err) {
      var message = 'An error occured, please check your credentials!';
      if (err.message != null) {
        message = err.message;
      }

      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });

      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(err),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).backgroundColor,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            Image.asset(
              'assets/icons/pewpewchat.png',
              width: 200,
              height: 200,
            ),
            SingleChildScrollView(
              child: AuthForm(
                _isLoading,
                _submitAuthForm,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
