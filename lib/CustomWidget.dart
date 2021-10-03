import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Widget inputText(
    {double paddingTop,
    String hint,
    bool obscureText,
    Function onChanged,
    TextInputType keyboardType,
    TextEditingController controller}) {
  return Padding(
    padding: EdgeInsets.fromLTRB(25, paddingTop ?? 60, 25, 10),
    child: TextField(
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.text,
      onChanged: onChanged ?? (value) {},
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          hintText: hint ?? '',
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
    ),
  );
}

Widget btn({String text, Function onPressed}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: Material(
      elevation: 10,
      color: Colors.lightBlueAccent,
      child: MaterialButton(
        enableFeedback: true,
        onPressed: onPressed ?? () {},
        child: Text(
          text ?? '',
          style: TextStyle(fontSize: 16),
        ),
        textColor: Colors.black,
      ),
    ),
  );
}

void alert(BuildContext context, {String title, String desc}) {
  Alert(
    context: context,
    type: AlertType.error,
    title: title ?? '',
    desc: desc ?? '',
    buttons: [
      DialogButton(
        color: Colors.lightBlueAccent,
        child: Text(
          "CANCEL",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        width: 120,
      )
    ],
  ).show();
}

Widget messageBubble(String text, String sender,
    {CrossAxisAlignment crossAxisAlignment}) {
  Color c = Colors.lightBlueAccent;
  if (crossAxisAlignment == CrossAxisAlignment.start) {
    sender = '';
    // c = Color(0xFFE4E6EB);
    c = Colors.white;
  }
  return Padding(
    padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
    child: Column(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: double.infinity,
          height: 0,
        ),
        Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            sender,
            style: TextStyle(color: Colors.black45),
          ),
        ),
        Material(
          elevation: 7,
          color: c,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              )),
        ),
      ],
    ),
  );
}
