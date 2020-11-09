import 'dart:developer';

import 'package:PewPewChat/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewChatroom extends StatefulWidget {
  @override
  _NewChatroomState createState() => _NewChatroomState();
}

class _NewChatroomState extends State<NewChatroom> {
  final currentUser = FirebaseAuth.instance.currentUser;

  final textController = TextEditingController();

  List friendList = [];

  List _isSelected = [];

  List<Map> selectedFriends = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('friends')
          .get(),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          var item = snapshot.data.docs;

          for (var i = 0; i < item.length; i++) {
            _isSelected.add(false);
          }

          return SimpleDialog(
            title: Text('Create chatroom'),
            children: [
              Container(
                height: 300,
                width: 300,
                child: ListView.builder(
                  itemCount: item.length,
                  itemBuilder: (ctx, index) {
                    return FutureBuilder(
                      future: item[index].data()['userRef'].get(),
                      builder: (ctx, snapshot) {
                        if (snapshot.hasData) {
                          return CheckboxListTile(
                            value: _isSelected[index],
                            title: Text(snapshot.data['username']),
                            subtitle: Text(snapshot.data['email']),
                            onChanged: (value) {
                              if (value == true) {
                                selectedFriends.add({
                                  'email': snapshot.data['email'],
                                  'username': snapshot.data['username'],
                                  'image_url': snapshot.data['image_url'],
                                  'userRef': FirebaseFirestore.instance
                                      .doc('users/${snapshot.data.id}'),
                                });
                              } else if (value == false) {
                                selectedFriends.removeWhere((item) =>
                                    item.containsValue(snapshot.data.id));
                              }
                              setState(() {
                                _isSelected[index] = value;
                              });
                            },
                          );
                        }
                        return Container();
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Select'),
                  onPressed: () {
                    print(selectedFriends);
                    if (selectedFriends.length == 1) {
                      ChatService().createChatroom(
                          selectedFriends, selectedFriends[0]['username']);
                      Navigator.pop(context);
                    }

                    if (selectedFriends.length > 1) {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Container(
                            child: SimpleDialog(
                              title: Text('Chatroom name'),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(15),
                                      prefixIcon:
                                          Icon(Icons.meeting_room_rounded),
                                      labelText: 'Chatroom name',
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        borderSide: BorderSide(
                                          color: Theme.of(context).accentColor,
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 1,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        borderSide: BorderSide(
                                          color: Theme.of(context).errorColor,
                                          width: 1,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        borderSide: BorderSide(
                                          color: Theme.of(context).errorColor,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    controller: textController,
                                  ),
                                ),
                                // Container(
                                //   width: 300,
                                //   height: 200,
                                //   child: ListView.builder(
                                //     itemCount: selectedFriends.length,
                                //     itemBuilder: (context, index) {
                                //       return ListTile(
                                //         leading: CircleAvatar(
                                //           backgroundImage: NetworkImage(
                                //               selectedFriends[index]
                                //                   ['image_url']),
                                //         ),
                                //         title: Text(
                                //             selectedFriends[index]['username']),
                                //       );
                                //     },
                                //   ),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RaisedButton(
                                    child: Text('Create'),
                                    onPressed: () {
                                      // create chatroom by
                                      // passing list of selectedFriends
                                      // and chatroom name
                                      // to create chatroom function
                                      ChatService().createChatroom(
                                          selectedFriends, textController.text);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );

    // return StreamBuilder(
    //   stream: FirebaseFirestore.instance
    //       .collection('users')
    //       .doc(currentUser.uid)
    //       .collection('friends')
    //       .snapshots(),
    //   builder: (ctx, snapshot) {
    //     if (snapshot.hasData) {
    //       var item = snapshot.data.docs;

    //       for (var i = 0; i < item.length; i++) {
    //         _isSelected.add(false);
    //       }

    //       return SimpleDialog(
    //         title: Text('Create chatroom'),
    //         children: [
    //           Container(
    //             height: 300,
    //             width: 300,
    //             child: ListView.builder(
    //               itemCount: item.length,
    //               itemBuilder: (ctx, index) {
    //                 return FutureBuilder(
    //                   future: item[index].data()['userRef'].get(),
    //                   builder: (ctx, snapshot) {
    //                     return CheckboxListTile(
    //                       value: _isSelected[index],
    //                       title: Text(snapshot.data['username']),
    //                       subtitle: Text(snapshot.data['email']),
    //                       onChanged: (value) {
    //                         if (value == true) {
    //                           selectedFriends.add({
    //                             'email': snapshot.data['email'],
    //                             'username': snapshot.data['username'],
    //                             'image_url': snapshot.data['image_url'],
    //                           });
    //                         } else if (value == false) {
    //                           selectedFriends.removeWhere((item) =>
    //                               item.containsValue(snapshot.data['email']));
    //                         }
    //                         setState(() {
    //                           _isSelected[index] = value;
    //                         });
    //                       },
    //                     );
    //                   },
    //                 );
    //               },
    //             ),
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: RaisedButton(
    //               child: Text('Select'),
    //               onPressed: () {
    //                 print(selectedFriends);

    //                 if (selectedFriends.length > 1) {
    //                   Navigator.pop(context);
    //                   showDialog(
    //                     context: context,
    //                     builder: (context) {
    //                       return Container(
    //                         child: SimpleDialog(
    //                           title: Text('Chatroom name'),
    //                           children: [
    //                             Padding(
    //                               padding: const EdgeInsets.all(8.0),
    //                               child: TextField(
    //                                 decoration: InputDecoration(
    //                                   contentPadding: EdgeInsets.all(15),
    //                                   prefixIcon:
    //                                       Icon(Icons.mail_outline_rounded),
    //                                   labelText: 'Chatroom name',
    //                                   enabledBorder: OutlineInputBorder(
    //                                     borderRadius: BorderRadius.all(
    //                                         Radius.circular(30)),
    //                                     borderSide: BorderSide(
    //                                       color: Theme.of(context).accentColor,
    //                                       width: 1,
    //                                     ),
    //                                   ),
    //                                   focusedBorder: OutlineInputBorder(
    //                                     borderRadius: BorderRadius.all(
    //                                         Radius.circular(30)),
    //                                     borderSide: BorderSide(
    //                                       color: Theme.of(context).primaryColor,
    //                                       width: 1,
    //                                     ),
    //                                   ),
    //                                   errorBorder: OutlineInputBorder(
    //                                     borderRadius: BorderRadius.all(
    //                                         Radius.circular(30)),
    //                                     borderSide: BorderSide(
    //                                       color: Theme.of(context).errorColor,
    //                                       width: 1,
    //                                     ),
    //                                   ),
    //                                   focusedErrorBorder: OutlineInputBorder(
    //                                     borderRadius: BorderRadius.all(
    //                                         Radius.circular(30)),
    //                                     borderSide: BorderSide(
    //                                       color: Theme.of(context).errorColor,
    //                                       width: 1,
    //                                     ),
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                             Container(
    //                               width: 300,
    //                               height: 300,
    //                               child: ListView.builder(
    //                                 itemCount: selectedFriends.length,
    //                                 itemBuilder: (context, index) {
    //                                   return ListTile(
    //                                     leading: CircleAvatar(
    //                                       backgroundImage: NetworkImage(
    //                                           selectedFriends[index]
    //                                               ['image_url']),
    //                                     ),
    //                                     title: Text(
    //                                         selectedFriends[index]['username']),
    //                                   );
    //                                 },
    //                               ),
    //                             ),
    //                             Padding(
    //                               padding: const EdgeInsets.all(8.0),
    //                               child: RaisedButton(
    //                                 child: Text('Create'),
    //                                 onPressed: () {
    //                                   Navigator.pop(context);
    //                                 },
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       );
    //                     },
    //                   );
    //                 }
    //               },
    //             ),
    //           ),
    //         ],
    //       );
    //     }
    //     return Container();
    //   },
    // );
  }
}
