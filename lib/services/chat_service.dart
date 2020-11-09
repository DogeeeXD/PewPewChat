import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  createChatroom(List<Map> selectedFriends, String chatroomName) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    var chatroomRef = FirebaseFirestore.instance.collection('chatrooms').doc();

    List members = [];
    var dataMap;

    selectedFriends.forEach((item) {
      members.add(item['userRef']);
    });
    dataMap = {
      'chatroomType': 'group',
      'chatroomName': chatroomName,
      'adminRef': FirebaseFirestore.instance.doc('users/${currentUser.uid}'),
      'members': members,
    };

    // create chatroom
    await FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatroomRef.id)
        .set(dataMap)
        .catchError((e) {
      print(e);
    });

    // add reference path to chatroom to current user
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('chatrooms')
        .doc(chatroomRef.id)
        .set({
      'chatroomRef': chatroomRef,
    }).catchError((e) {
      print(e);
    });

    // add reference path to chatroom to each member
    selectedFriends.forEach((item) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(item['userRef'].id)
          .collection('chatrooms')
          .doc(chatroomRef.id)
          .set({
        'chatroomRef': chatroomRef,
      }).catchError((e) {
        print(e);
      });
    });
  }

  checkChatroomExists(selectedFriend) async {
    String chatroomId;
    bool chatroomExists = await FirebaseFirestore.instance
        .collection('chatrooms')
        .where('chatroomType', isEqualTo: 'personal')
        .where('members',
            arrayContains:
                FirebaseFirestore.instance.doc('users/$selectedFriend'))
        .get()
        .then((value) {
      print(value.docs.length);
      if (value.docs.length >= 1) {
        chatroomId = value.docs[0].id;
        return true;
      } else {
        return false;
      }
    });

    return {
      'chatroomExists': chatroomExists,
      'chatroomId': chatroomId,
    };
  }

  createPersonalChat(selectedFriend) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    var chatroomRef = FirebaseFirestore.instance.collection('chatrooms').doc();

    var members = [
      FirebaseFirestore.instance.doc('users/${currentUser.uid}'),
      FirebaseFirestore.instance.doc('users/$selectedFriend'),
    ];

    // // check if personal chat exists
    // bool chatroomExists = await checkChatroomExists(selectedFriend);

    // if (chatroomExists) {
    //   print('chatroom exists');
    //   return;
    // } else {
    //   print('chatroom does not exists');
    // }

    var dataMap;

    dataMap = {
      'chatroomType': 'personal',
      'chatroomName': 'N/A',
      'adminRef': FirebaseFirestore.instance.doc('users/${currentUser.uid}'),
      'members': members,
    };

    // create chatroom
    await FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatroomRef.id)
        .set(dataMap)
        .catchError((e) {
      print(e);
    });

    // add reference path to chatroom to current user
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('chatrooms')
        .doc(chatroomRef.id)
        .set({
      'chatroomRef': chatroomRef,
    }).catchError((e) {
      print(e);
    });

    // add reference path to chatroom to each member
    await FirebaseFirestore.instance
        .collection('users')
        .doc(selectedFriend)
        .collection('chatrooms')
        .doc(chatroomRef.id)
        .set({
      'chatroomRef': chatroomRef,
    }).catchError((e) {
      print(e);
    });

    return chatroomRef.id;
  }

  sendMessage(String chatroomId, String enteredMessage) async {
    // Current logged in user
    final currentUser = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatroomId)
        .collection('messages')
        .add({
      'text': enteredMessage,
      'createdAt': FieldValue.serverTimestamp(),
      'userId': currentUser.uid,
      'username': userData.data()['username'],
      'image_url': userData.data()['image_url'],
    });
  }

  getMessages() {}
}
