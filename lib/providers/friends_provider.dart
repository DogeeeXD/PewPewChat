import 'dart:async';
import 'dart:developer';

import 'package:PewPewChat/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FriendsProvider {
  final List _pendingList = [];
  final List _requestList = [];
  final List _friendList = [];

  List get pendingList {
    return _pendingList;
  }

  List get requestList {
    return _requestList;
  }

  List get friendList {
    return _friendList;
  }

  Future<void> fetchFriends() async {
    final user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('friends')
        .snapshots()
        .listen((event) {
      var friendsDocs = event.docs;

      _pendingList.clear();
      _requestList.clear();
      _friendList.clear();

      friendsDocs.forEach((item) async {
        var friend = await UserService().getUserById(item.id);

        if (item.data()['status'] == 'pending') {
          _pendingList.add(friend);
          print('added user to pending');
        } else if (item.data()['status'] == 'request') {
          _requestList.add(friend);
          print('added user to request');
        } else if (item.data()['status'] == 'friend') {
          _friendList.add(friend);
          print('added user to friend');
        }
      });
    });
  }
}
