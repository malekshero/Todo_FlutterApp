import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/Component/rounded_button.dart';
import 'package:todo_app/Screens/TodoList.dart';
import '../constants.dart';
import 'dart:convert';

class SignUpScreen extends StatefulWidget {
  static const String id = 'SignUp_screen';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String email, password, type;
  bool showSpinner = false;
  String hintEmail = 'Enter Your Email';
  String hintPass = 'Enter Your Password';
  int id;


  Future<Map<String, dynamic>> signUpWithFireBase(
      String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };
    // sending request and waiting for response
    final http.Response response = await http.post('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDsdMrJ2KAU6OfppPCrHx7KEuk9PWqutSo',
      body: jsonEncode(authData),
      headers: {'Content-Type': 'application/json'},
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Authentication succeeded!';
    if (responseData.containsKey('idToken')) {
      hasError = false;
    final SharedPreferences sharedPreferences =  await SharedPreferences.getInstance();
    sharedPreferences.setString('token', responseData['idToken']);

    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'this email already exist';
    } else
      message = 'some thing went wrong';
    return {'success': !hasError, 'message': message};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
          child: Padding(
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
                  title: 'Register',
                  colour: Colors.blueGrey[700],
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      if (email != null && password != null) {
                        final Map<String, dynamic> successInfo = await signUpWithFireBase(email, password);
                        if (successInfo['success']) {
                          Navigator.pushNamed(context, TodoScreen.id);
                        } else {
                          showDialog(context:context,builder: (BuildContext context) {
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
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  },
                ),
              ],
            ),
          ),
      ),
    );
  }
}
