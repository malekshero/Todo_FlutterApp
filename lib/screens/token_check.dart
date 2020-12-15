import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'first_screen.dart';
import 'todo_list.dart';

class TokenCheckScreen extends StatefulWidget {
  static const String id = 'token_check';

  @override
  _TokenCheckScreenState createState() => _TokenCheckScreenState();
}

class _TokenCheckScreenState extends State<TokenCheckScreen> {
  @override
  @override
  Widget build(context) {
    return FutureBuilder<String>(
        future: tokenCheck(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data);
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Future<String> tokenCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    if (token == null) {
      Navigator.pushReplacementNamed(context, FirstScreen.id);
    } else {
      Navigator.pushReplacementNamed(context, TodoScreen.id);
    }
    return "";
  }
}
