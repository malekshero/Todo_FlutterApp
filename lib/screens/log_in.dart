import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/utils/rounded_button.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;
import 'todo_list.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  String hintEmail = 'Enter Your Email';
  String hintPass = 'Enter Your Password';
  bool showSpinner = false;
  String pass = "", email1 = "";

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
              height: 200.0,
              child: Image.asset('images/logo.png'),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                email = value;
              },
              style: new TextStyle(color: Colors.black),
              decoration: KtextFieldDecoration.copyWith(
                hintText: hintEmail,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              obscureText: true,
              textAlign: TextAlign.center,
              onChanged: (value) {
                password = value;
              },
              style: new TextStyle(color: Colors.black),
              decoration: KtextFieldDecoration.copyWith(
                hintText: hintPass,
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundedButton(
                title: 'Log In',
                colour: Colors.blueGrey[700],
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    if (email != null && password != null) {
                      final Map<String, dynamic> successInfo =
                          await loginFireBase(email, password);
                      if (successInfo['success']) {
                          Navigator.pushReplacementNamed(context, TodoScreen.id);
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('An Error occurred'),
                                content: Text(successInfo['message']),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('Okay!'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                      }
                    }
                  } catch (e) {
                    print(e);
                    if (e != null) {
                      _showLoginError(context);
                    }
                  }
                  setState(() {
                    showSpinner = false;
                  });
                }),
          ],
        ),
      ),
    );
  }

  _showLoginError(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("SomeThing Wrong "),
          content: Text("Please re enter Email and password"),
          actions: [
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          elevation: 50,
        ),
      );

  Future<Map<String, dynamic>> loginFireBase(
      String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };
    final http.Response response = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDsdMrJ2KAU6OfppPCrHx7KEuk9PWqutSo',
        body: jsonEncode(authData),
        headers: {'Content-Type': 'application/json'});
    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Authentication succeeded!';
    if (responseData.containsKey('idToken')) {
      hasError = false;
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString('token', responseData['idToken']);
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'this email was not found';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'this password is invalid';
    } else
      message = 'some thing went wrong';
    return {'success': !hasError, 'message': message};
  }
}
