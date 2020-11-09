import 'package:PewPewChat/screens/chat_screen.dart';
import 'package:PewPewChat/widgets/chat/new_chatroom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatroomsScreen extends StatelessWidget {
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.message_rounded),
        onPressed: () {
          // Choose receipient from list (Show friend list)
          // Create new Chatroom
          // If members = 2, set chatroom name to receipient
          showDialog(
            context: context,
            builder: (context) {
              return NewChatroom();
            },
          );
        },
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.topCenter,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser.uid)
                .collection('chatrooms')
                .snapshots(),
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                var item = snapshot.data.docs;

                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: item.length,
                    itemBuilder: (ctx, index) {
                      return FutureBuilder(
                          future: item[index].data()['chatroomRef'].get(),
                          builder: (ctx, snapshot) {
                            if (snapshot.hasData) {
                              var userRef;
                              var members = snapshot.data['members'];

                              if ((snapshot.data['chatroomType'] ==
                                  'personal')) {
                                members.forEach((item) {
                                  if (item.id != currentUser.uid) {
                                    userRef = item;
                                  }
                                });
                                return FutureBuilder(
                                    future: userRef.get(),
                                    builder: (ctx, userSnapshot) {
                                      if (userSnapshot.hasData) {
                                        return ListTile(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          leading: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                userSnapshot.data['image_url']),
                                          ),
                                          title: Text(
                                              userSnapshot.data['username']),
                                          subtitle: Text('Personal message'),
                                          onTap: () {
                                            // Open Chat Screen
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatScreen(
                                                          snapshot.data.id)),
                                            );
                                          },
                                          onLongPress: () {
                                            // Pop up modal bottom sheet
                                            // Delete chatroom reference from current user
                                          },
                                        );
                                      }
                                      return Container();
                                    });
                              }

                              return ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                leading: snapshot.data['chatroomName'] != null
                                    ? CircleAvatar(
                                        child: Text(
                                            snapshot.data['chatroomName'][0]),
                                      )
                                    : CircleAvatar(
                                        backgroundImage: NetworkImage(item),
                                      ),
                                title: Text(snapshot.data['chatroomName']),
                                subtitle: Text('Group message'),
                                onTap: () {
                                  // Open Chat Screen
                                  // pass chatroom id
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChatScreen(snapshot.data.id)),
                                  );
                                },
                                onLongPress: () {
                                  // Delete chatroom reference from current user
                                },
                              );
                            }
                            return Container();
                          });
                    });
              }
              return Container();
            }),
      ),
    );
  }
}
