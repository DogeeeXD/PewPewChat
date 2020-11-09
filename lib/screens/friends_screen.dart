import 'package:PewPewChat/screens/chat_screen.dart';
import 'package:PewPewChat/services/chat_service.dart';
import 'package:PewPewChat/services/user_service.dart';
import 'package:PewPewChat/widgets/friends/add_friend_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.person_add_alt_1_rounded),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddFriendDialog(),
          );
        },
      ),
      body: Container(
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('requestFriends')
                  .snapshots(),
              builder: (ctx, snapshot) {
                if (snapshot.hasData) {
                  var item = snapshot.data.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: item.length,
                    itemBuilder: (ctx, index) {
                      return FutureBuilder(
                        future: item[index].data()['userRef'].get(),
                        builder: (ctx, snapshot) {
                          if (snapshot.hasData) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(snapshot.data['image_url']),
                              ),
                              title: Text(snapshot.data['username']),
                              trailing: Container(
                                width: 100,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: IconButton(
                                        icon: Icon(Icons.check),
                                        onPressed: () async {
                                          await UserService()
                                              .acceptUser(item[index].id);
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: IconButton(
                                        icon: Icon(Icons.clear),
                                        onPressed: () async {
                                          await UserService()
                                              .rejectUser(item[index].id);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                          return Container();
                        },
                      );
                    },
                  );
                }
                return Container();
              },
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('friends')
                  .snapshots(),
              builder: (ctx, snapshot) {
                if (snapshot.hasData) {
                  var item = snapshot.data.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: item.length,
                    itemBuilder: (ctx, index) {
                      return FutureBuilder(
                        future: item[index].data()['userRef'].get(),
                        builder: (ctx, snapshot) {
                          if (snapshot.hasData) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(snapshot.data['image_url']),
                              ),
                              title: Text(snapshot.data['username']),
                              onTap: () {
                                ChatService()
                                    .checkChatroomExists(snapshot.data.id)
                                    .then((value) {
                                  print(value);
                                  if (value['chatroomExists'] == true) {
                                    print('Chatroom exists, redirecting...');
                                    print(value['chatroomId']);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChatScreen(value['chatroomId'])),
                                    );
                                    return;
                                  } else {
                                    print('Chatroom not exist, creating...');
                                    ChatService()
                                        .createPersonalChat(snapshot.data.id)
                                        .then((value) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChatScreen(value)),
                                      );
                                    });
                                  }
                                });
                                // ChatService()
                                //     .createPersonalChat(snapshot.data.id);
                              },
                              onLongPress: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      child: FlatButton(
                                        child: Text('Delete'),
                                        onPressed: () {
                                          UserService()
                                              .deleteUser(item[index].id);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          }
                          return Container();
                        },
                      );
                    },
                  );
                }
                return Container();
              },
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('pendingFriends')
                  .snapshots(),
              builder: (ctx, snapshot) {
                if (snapshot.hasData) {
                  var item = snapshot.data.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: item.length,
                    itemBuilder: (ctx, index) {
                      return FutureBuilder(
                        future: item[index].data()['userRef'].get(),
                        builder: (ctx, snapshot) {
                          if (snapshot.hasData) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(snapshot.data['image_url']),
                              ),
                              title: Text(snapshot.data['username']),
                              trailing: FlatButton(
                                child: Text('cancel request'),
                                onPressed: () async {
                                  await UserService()
                                      .cancelUser(item[index].id);
                                },
                              ),
                            );
                          }
                          return Container();
                        },
                      );
                    },
                  );

                  // return ListView.builder(
                  //   shrinkWrap: true,
                  //   itemCount: item.length,
                  //   itemBuilder: (ctx, index) {
                  //     return ListTile(
                  //       leading: CircleAvatar(
                  //         backgroundImage:
                  //             NetworkImage(item[index].data()['image_url']),
                  //       ),
                  //       title: Text(item[index].data()['username']),
                  //       trailing: FlatButton(
                  //         child: Text('cancel request'),
                  //         onPressed: () async {
                  //           await UserService().cancelUser(item[index].id);
                  //         },
                  //       ),
                  //     );
                  //   },
                  // );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
