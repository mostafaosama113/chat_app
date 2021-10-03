import 'package:chat_app/CustomWidget.dart';
import 'package:chat_app/screens/LoginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'ChatScreen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  User user;
  String value = '';
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    setCurrentUser();
  }

  setCurrentUser() async {
    user = await FirebaseAuth.instance.currentUser;
    // QuerySnapshot q = await FirebaseFirestore.instance.collection('masseges').get();
    // q.size;
  }

  void addData(String txt) async {
    QuerySnapshot q =
        await FirebaseFirestore.instance.collection('message').get();
    int id = q.size;
    FirebaseFirestore.instance
        .collection('message')
        .add({'id': id, 'sender': user.email, 'text': txt});
    _controller.clear();
    value = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Row(
          children: [
            Icon(FontAwesomeIcons.facebookMessenger),
            SizedBox(
              width: 8,
            ),
            Text(
              'Group',
            )
          ],
        ),
        actions: [
          FlatButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context);
                Navigator.pushNamed(context, LoginScreen.id);
              },
              child: Text(
                'sign out',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ))
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
                child: ListView(
              reverse: true,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('message')
                      .orderBy('id', descending: false)
                      .snapshots(),
                  builder: (context, snapshots) {
                    if (snapshots.hasData) {
                      List<QueryDocumentSnapshot> messages =
                          snapshots.data.docs;
                      final List<Widget> txt = [];
                      for (QueryDocumentSnapshot qs in messages) {
                        final text = qs.data()['text'];
                        final sender = qs.data()['sender'];
                        //final MassageWideg = Text('$text from $sender');
                        txt.add(messageBubble(text, sender,
                            crossAxisAlignment: sender == user.email
                                ? CrossAxisAlignment.start
                                : CrossAxisAlignment.end));
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: txt,
                      );
                    } else {
                      return Column();
                    }
                  },
                )
              ],
            )),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top:
                          BorderSide(color: Colors.lightBlueAccent, width: 2))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) => this.value = value,
                      controller: _controller,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          hintText: 'Enter your message',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15)),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      if (value != '') {
                        addData(value);
                        // FirebaseFirestore.instance
                        //     .collection('messages')
                        //     .add({'sender': user.email, 'text': value});
                        _controller.clear();
                        value = '';
                      }
                    },
                    child: Text(
                      'Send',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
