import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  createUser(
    String email,
    String password,
    String username,
    File image,
  ) async {
    UserCredential authResult;

    authResult = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (image != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child(authResult.user.uid + '.jpg');

      await ref.putFile(image).onComplete;

      final imageUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user.uid)
          .set({
        'username': username,
        'email': email,
        'image_url': imageUrl,
      });
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user.uid)
          .set({
        'username': username,
        'email': email,
        'image_url':
            'https://firebasestorage.googleapis.com/v0/b/pewpewchat-ad9b0.appspot.com/o/user_images%2Fplaceholder_profile_pic.png?alt=media&token=55fb05c6-e33c-4684-8270-3a2d71f68b86',
      });
    }
  }

  loginUser(
    String email,
    String password,
  ) async {
    UserCredential authResult;

    authResult = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
