import 'package:chat_app/CustomWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'ChatScreen.dart';

class RegisterScreen extends StatefulWidget {
  static String id = 'RegisterScreen';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _email = '', _password = '', _rePassword = '';
  bool _isLoading = false;
  TextEditingController _emailController = TextEditingController(),
      _passController = TextEditingController(),
      _rePassController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: _isLoading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Icon(
                    FontAwesomeIcons.facebookMessenger,
                    color: Colors.lightBlueAccent,
                    size: 150,
                  ),
                ),
              ),
              inputText(
                  controller: _emailController,
                  onChanged: (value) => _email = value,
                  hint: 'Email address',
                  keyboardType: TextInputType.emailAddress,
                  paddingTop: 60),
              inputText(
                  controller: _passController,
                  hint: 'New Password',
                  paddingTop: 10,
                  obscureText: true,
                  onChanged: (value) => _password = value),
              inputText(
                  controller: _rePassController,
                  hint: ' Re-Enter new password',
                  onChanged: (value) => _rePassword = value,
                  paddingTop: 10,
                  obscureText: true),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                child: Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: btn(
                            text: 'Register',
                            onPressed: () async {
                              setState(() => _isLoading = true);
                              if (_email == '' ||
                                  _password == '' ||
                                  _rePassword == '')
                                alert(context,
                                    title: 'Error', desc: 'Input all fields');
                              else if (_password != _rePassword)
                                alert(context,
                                    title: 'Error', desc: 'Password not match');
                              else {
                                try {
                                  await Firebase.initializeApp();
                                  final user = await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                          email: _email, password: _password);
                                  if (user != null) {
                                    Navigator.popUntil(
                                        context, (route) => false);
                                    Navigator.pushNamed(context, ChatScreen.id);
                                  }
                                } catch (e) {
                                  alert(context,
                                      title: 'Error',
                                      desc: 'Email already in use');
                                  _email = '';
                                  _password = '';
                                  _rePassword = '';
                                  _emailController.clear();
                                  _passController.clear();
                                  _rePassController.clear();
                                }
                              }
                              setState(() => _isLoading = false);
                            })),
                    Expanded(
                        flex: 2,
                        child: btn(
                            text: 'Back',
                            onPressed: () {
                              Navigator.pop(context);
                            })),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
