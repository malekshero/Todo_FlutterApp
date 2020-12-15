import 'package:flutter/material.dart';
import 'package:todo_app/Screens/add_todo.dart';
import 'package:todo_app/screens/first_screen.dart';
import 'DB/db_creator.dart';
import 'Screens/todo_list.dart';
import 'Screens/token_check.dart';
import 'Screens/log_in.dart';
import 'Screens/sign_up.dart';

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
