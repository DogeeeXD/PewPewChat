import 'dart:developer';

import 'package:PewPewChat/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddFriendDialog extends StatefulWidget {
  @override
  _AddFriendDialogState createState() => _AddFriendDialogState();
}

class _AddFriendDialogState extends State<AddFriendDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  String _email = '';
  final currentUser = FirebaseAuth.instance.currentUser;
  String errorMsg;

  void _trySubmit() async {
    final isValid = _formKey.currentState.validate();

    // Closes soft keyboard
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();

      await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: _email)
          .get()
          .then((value) {
        if (value.docs.length == 0) {
          print('email not registered');
          setState(() {
            errorMsg = 'Email not registered';
          });
        } else {
          setState(() {
            errorMsg = '';
          });
          UserService().addUser(_email);
          Navigator.pop(context);
        }
      }).catchError((e) {
        print(e);
      });

      // UserService().addUser(_email);
      // Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Add friend'),
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15),
                prefixIcon: Icon(Icons.mail_outline_rounded),
                labelText: 'Email',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(
                    color: Theme.of(context).accentColor,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(
                    color: Theme.of(context).errorColor,
                    width: 1,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(
                    color: Theme.of(context).errorColor,
                    width: 1,
                  ),
                ),
              ),
              validator: (value) {
                if (value.isEmpty || !value.contains('@')) {
                  return 'Please enter a valid email';
                } else if (value == currentUser.email) {
                  return 'Cannot add your own email';
                }
                return null;
              },
              onSaved: (value) {
                _email = value;
              },
            ),
          ),
        ),
        Center(
            child: Text(
          errorMsg ?? '',
          style: TextStyle(color: Theme.of(context).errorColor),
        )),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: RaisedButton(
            child: Text('Add'),
            onPressed: _trySubmit,
          ),
        ),
      ],
    );
  }
}
