import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_app/CustomWidget.dart';
import 'package:chat_app/screens/ChatScreen.dart';
import 'package:chat_app/screens/RegisterScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  String _email = '', _password = '';
  TextEditingController _emailController = TextEditingController(),
      _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: _isLoading,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(25, 40, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'logo',
                      child: Icon(
                        FontAwesomeIcons.facebookMessenger,
                        color: Colors.lightBlueAccent,
                        size: 50,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 30.0,
                        fontFamily: 'Agne',
                      ),
                      child: AnimatedTextKit(
                        repeatForever: true,
                        animatedTexts: [
                          TypewriterAnimatedText('My Messenger',
                              speed: Duration(milliseconds: 100),
                              textStyle: TextStyle(color: Colors.black)),
                        ],
                        onTap: () {
                          print("Tap Event");
                        },
                      ),
                    )
                  ],
                ),
              ),
              inputText(
                  paddingTop: 80,
                  keyboardType: TextInputType.emailAddress,
                  hint: 'Enter your Email',
                  controller: _emailController,
                  onChanged: (value) {
                    _email = value;
                  }),
              inputText(
                  paddingTop: 10,
                  hint: 'Enter your Password',
                  obscureText: true,
                  controller: _passwordController,
                  onChanged: (value) {
                    _password = value;
                  }),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: btn(
                            text: 'Login',
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              if (_email == '' || _password == '')
                                alert(context,
                                    title: 'Error',
                                    desc: 'Input Email and Password');
                              else
                                try {
                                  await Firebase.initializeApp();
                                  final user = await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: _email, password: _password);
                                  if (user != null) {
                                    Navigator.popUntil(
                                        context, (route) => false);
                                    Navigator.pushNamed(context, ChatScreen.id);
                                  }
                                } catch (e) {
                                  alert(context,
                                      title: 'Error',
                                      desc: 'Wrong Email or Password');
                                }
                              setState(() {
                                _email = '';
                                _password = '';
                                _isLoading = false;
                                _emailController.clear();
                                _passwordController.clear();
                              });
                            })),
                    Expanded(
                        child: btn(
                            text: 'Register',
                            onPressed: () {
                              Navigator.pushNamed(context, RegisterScreen.id);
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
