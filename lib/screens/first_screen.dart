import 'package:flutter/material.dart';
import 'package:todo_app/Screens/sign_up.dart';
import 'package:todo_app/utils/rounded_button.dart';
import 'log_in.dart';

class FirstScreen extends StatefulWidget {
  static const String id = 'first_screen';

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: Image.asset('images/logo.png'),
              height: 300.0,
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              title: 'Log In',
              colour: Colors.blueGrey[700],
              child: Text('Log In'),
              onPressed: () {
                Navigator.pushReplacementNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              title: 'Sign up',
              colour: Colors.blueGrey[700],
              child: Text('Sign up'),
              onPressed: () {
                Navigator.pushReplacementNamed(context, SignUpScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
