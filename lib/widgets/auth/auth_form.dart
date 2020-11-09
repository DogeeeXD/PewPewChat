import 'dart:io';

import 'package:PewPewChat/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(
    this.isLoading,
    this.submitFn,
  );

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
    BuildContext context,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController(text: '');

  final _emailController = TextEditingController(text: '');

  final _passwordController = TextEditingController(text: '');

  var _isLogin = true;

  String _userName = '';
  String _userEmail = '';
  String _userPassword = '';

  File _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();

    // Closes soft keyboard
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword,
        _userName.trim(),
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _maxWidth = 500.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _isLogin ? 'Login' : 'Sign-up',
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(
          height: 20,
        ),
        if (!_isLogin) UserImagePicker(_pickedImage),
        Container(
          constraints: BoxConstraints(maxWidth: _maxWidth),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isLogin)
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        prefixIcon: Icon(Icons.account_circle_rounded),
                        labelText: 'Username',
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
                      controller: _usernameController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      prefixIcon: Icon(Icons.mail_rounded),
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
                    controller: _emailController,
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      prefixIcon: Icon(Icons.lock_rounded),
                      labelText: 'Password',
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
                    controller: _passwordController,
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Please must be at least 7 characters long';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                ),
                if (_isLogin)
                  InkWell(
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Theme.of(context).highlightColor),
                    ),
                    onTap: () {
                      // Go to reset password
                    },
                  ),
                if (widget.isLoading)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                if (!widget.isLoading)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      child: Text(_isLogin ? 'Login' : 'Sign-up'),
                      onPressed: _trySubmit,
                    ),
                  ),
                // SizedBox(
                //   height: 20,
                // ),
                // Text('- OR -'),
                // SizedBox(
                //   height: 20,
                // ),
                // Text(_isLogin ? 'Login with' : 'Sign-up with'),
                // SizedBox(
                //   height: 15,
                // ),
                // RawMaterialButton(
                //   onPressed: () {},
                //   elevation: 3.0,
                //   fillColor: Colors.white,
                //   child: Image(
                //     width: 30,
                //     height: 30,
                //     fit: BoxFit.contain,
                //     image: AssetImage('assets/icons/google_logo.png'),
                //   ),
                //   padding: EdgeInsets.all(8.0),
                //   shape: CircleBorder(),
                // ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_isLogin ? r"Don't have an account?  " : ''),
                    InkWell(
                      child: Text(
                        _isLogin ? 'Sign-up' : 'I already have an account',
                        style:
                            TextStyle(color: Theme.of(context).highlightColor),
                      ),
                      onTap: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
