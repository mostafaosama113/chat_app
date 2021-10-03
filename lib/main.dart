import 'package:chat_app/screens/ChatScreen.dart';
import 'package:chat_app/screens/LoginScreen.dart';
import 'package:chat_app/screens/RegisterScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.lightBlue));

  runApp(MaterialApp(
    initialRoute: LoginScreen.id,
    routes: {
      LoginScreen.id: (context) => LoginScreen(),
      ChatScreen.id: (context) => ChatScreen(),
      RegisterScreen.id: (context) => RegisterScreen()
    },
  ));
}
