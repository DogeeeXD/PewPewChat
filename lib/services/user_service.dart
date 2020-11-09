import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  getUserByEmail(String email) async {
    final user = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .catchError((e) {
      print(e);
    });

    //print(user.docs[0].data()['username']);

    // the returned user is a list
    return user;
  }

  Future getUserById(String userId) async {
    final user =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    //inspect(user.data());

    return user;
  }

  checkFriendExists(String userId) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('friends')
        .doc(userId)
        .get()
        .then((value) => print(value));
  }

  addUser(String email) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    final addedUserInfo = await getUserByEmail(email);

    //inspect(addedUserInfo.docs[0].data()['username']);

    checkFriendExists(addedUserInfo.docs[0].id);

    // Add B to A pending list
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('pendingFriends')
        .doc(addedUserInfo.docs[0].id)
        .set({
      // 'userId': addedUserInfo.docs[0].id,
      // 'email': addedUserInfo.docs[0].data()['email'],
      // 'username': addedUserInfo.docs[0].data()['username'],
      // 'image_url': addedUserInfo.docs[0].data()['image_url'],
      'userRef':
          FirebaseFirestore.instance.doc('users/${addedUserInfo.docs[0].id}'),
    });

    //final currentUserInfo = await getUserByEmail(currentUser.email);

    // Add A to B request list
    await FirebaseFirestore.instance
        .collection('users')
        .doc(addedUserInfo.docs[0].id)
        .collection('requestFriends')
        .doc(currentUser.uid)
        .set({
      // 'userId': currentUser.uid,
      // 'email': currentUserInfo.docs[0].data()['email'],
      // 'username': currentUserInfo.docs[0].data()['username'],
      // 'image_url': currentUserInfo.docs[0].data()['image_url'],
      'userRef': FirebaseFirestore.instance.doc('users/${currentUser.uid}'),
    });
  }

  acceptUser(String userId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final addedUserInfo = await getUserById(userId);

    //print(addedUserInfo.id);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('requestFriends')
        .doc(userId)
        .delete();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('pendingFriends')
        .doc(currentUser.uid)
        .delete();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('friends')
        .doc(userId)
        .set({
      // 'userId': userId,
      // 'email': addedUserInfo.data()['email'],
      // 'username': addedUserInfo.data()['username'],
      // 'image_url': addedUserInfo.data()['image_url'],
      'userRef': FirebaseFirestore.instance.doc('users/$userId'),
    });

    //final currentUserInfo = await getUserById(currentUser.uid);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('friends')
        .doc(currentUser.uid)
        .set({
      // 'userId': currentUser.uid,
      // 'email': currentUserInfo.data()['email'],
      // 'username': currentUserInfo.data()['username'],
      // 'image_url': currentUserInfo.data()['image_url'],
      'userRef': FirebaseFirestore.instance.doc('users/${currentUser.uid}'),
    });
  }

  // reject a friend request
  rejectUser(String userId) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('requestFriends')
        .doc(userId)
        .delete();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('pendingFriends')
        .doc(currentUser.uid)
        .delete();
  }

  // cancel request
  cancelUser(String userId) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('pendingFriends')
        .doc(userId)
        .delete();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('requestFriends')
        .doc(currentUser.uid)
        .delete();
  }

  // delete friend
  deleteUser(String userId) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('friends')
        .doc(userId)
        .delete();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('friends')
        .doc(currentUser.uid)
        .delete();
  }
}
