import 'package:flutter/material.dart';
import 'package:todo_app/Screens/AddTodo.dart';
import 'package:todo_app/Screens/FirstScreen.dart';
import 'DB/DB_Creator.dart';
import 'Screens/TodoList.dart';
import 'Screens/TokenCheck.dart';
import 'Screens/logIn.dart';
import 'Screens/signUp.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseCreator().initDatabase();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: TokenCheckScreen.id,
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        SignUpScreen.id: (context) => SignUpScreen(),
        TokenCheckScreen.id: (context) => TokenCheckScreen(),
        FirstScreen.id: (context) => FirstScreen(),
        AddTodo.id: (context) => AddTodo(),
        TodoScreen.id: (context) => TodoScreen(),
      },
    );
  }
}
