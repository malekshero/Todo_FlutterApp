import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Screens/todo_list_service.dart';
import 'package:todo_app/utils/rounded_button.dart';
import '../utils/constants.dart';
import 'first_screen.dart';
import 'todo_list.dart';

class AddTodo extends StatelessWidget {
  static const String id = 'addTodo_screen';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoProvider(),
      routes: {
        AddTodo.id: (context) => AddTodo(),
        TodoScreen.id: (context) => TodoScreen(),
      },
    );
  }
}

class TodoProvider extends StatelessWidget {
  int id;
  bool showSpinner = false;
  String title;
  String description;
  DateTime createdTime = DateTime.now();
  String hintITodoTitle = "Todo Title", hintTodoDescription = "Todo description", hintTodoDate = "Todo date";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: new Text('Add Todo'),
            backgroundColor: Colors.blueGrey,
            actions: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, TodoScreen.id);
                  }),
            ]),
        body: ChangeNotifierProvider<TodoListService>(
          create: (context) => TodoListService(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 35.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Consumer<TodoListService>(
                    builder: (context, todoService, child) {
                  return Form(
                    child: TextField(
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        todoService.title = value;
                      },
                      style: new TextStyle(color: Colors.black),
                      decoration: KtextFieldDecoration.copyWith(
                        hintText: hintITodoTitle,
                      ),
                    ),
                  );
                }),
                SizedBox(
                  height: 4.0,
                ),
                Consumer<TodoListService>(
                    builder: (context, todoService, child) {
                  return Form(
                    child: TextField(
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        todoService.description = value;
                      },
                      style: new TextStyle(color: Colors.black),
                      decoration: KtextFieldDecoration.copyWith(
                        hintText: hintTodoDescription,
                        labelText: description,
                      ),
                    ),
                  );
                }),
                SizedBox(
                  height: 4.0,
                ),
                Consumer<TodoListService>(
                    builder: (context, todoService, child) {
                  return RoundedButton(
                    title: 'Time',
                    colour: Colors.blueGrey[900],
                    onPressed: () async {
                      final DateTime picked = await showDatePicker(
                        context: context,
                        initialDate: createdTime, // Refer step 1
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2025),
                      );
                      todoService.createdTime = picked.toString().substring(0,picked.toString().length - 13);
                    },
                  );
                }),
                Consumer<TodoListService>(
                    builder: (context, todoService, child) {
                  return RoundedButton(
                      title: 'Save',
                      colour: Colors.blueGrey[900],
                      onPressed: () {
                        todoService.addTodoToDataBase();
                        Navigator.pushReplacementNamed(context, TodoScreen.id);
                      });
                }),
              ],
            ),
          ),
        ));
  }
}
