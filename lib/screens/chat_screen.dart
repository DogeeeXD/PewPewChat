import 'package:PewPewChat/widgets/chat/messages.dart';
import 'package:PewPewChat/widgets/chat/new_message.dart';
import 'package:PewPewChat/widgets/side_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  final String chatroomId;

  ChatScreen(this.chatroomId);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String chatroomName = ' ';
  String avatar;

  final currentUser = FirebaseAuth.instance.currentUser;

  Future<void> getChatroomInfo() async {
    await FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(widget.chatroomId)
        .get()
        .then((value) {
      if (value['chatroomType'] == 'personal') {
        // set chatroom name to user that is not currentUser
        //print(value['members']);
        value['members'].forEach((userRef) {
          if (userRef !=
              FirebaseFirestore.instance.doc('users/${currentUser.uid}')) {
            userRef.get().then((userData) {
              setState(() {
                chatroomName = userData['username'];
                avatar = userData['image_url'];
              });
            });
          }
        });
      } else {
        // set chatroom name to chatroom name
        setState(() {
          chatroomName = value['chatroomName'];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getChatroomInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: avatar == null
                  ? CircleAvatar(
                      child: Text(chatroomName[0] ?? ''),
                    )
                  : CircleAvatar(
                      backgroundImage: NetworkImage(avatar),
                    ),
            ),
            Text(chatroomName ?? ''),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(widget.chatroomId),
            ),
            NewMessage(widget.chatroomId),
          ],
        ),
      ),
    );
  }
}
