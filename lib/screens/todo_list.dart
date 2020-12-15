import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/DB/todo_model.dart';
import 'package:todo_app/DB/todo_model_services.dart';
import 'package:todo_app/screens/todo_list_service.dart';

import 'add_todo.dart';


class TodoScreen extends StatelessWidget {
  static const String id = 'todo_screen';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoScreenHelper(),
      routes: {
        AddTodo.id: (context) => AddTodo(),
        TodoScreen.id: (context) => TodoScreen(),
      },
    );
  }
}

class TodoScreenHelper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoListService>(
      create: (context) => TodoListService(),
      child: Scaffold(
        appBar: new AppBar(
            title: new Text('Todos'),
            backgroundColor: Colors.blueGrey,
            actions: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.add),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AddTodo.id);
                  }),
            ]),
        body: Builder(builder: (_) {
          return ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<TodoListService>(builder: (context, todoService, child) {
                  return FutureBuilder<List<TodoModel>>(
                    future: TodoModelServices.getAllTodos(),
                    builder: (context, todos) {
                      if (todos.hasData) {
                        return Column(
                            children: todos.data.map((todo) => buildItem(todo, context, todoService)).toList());
                      } else {
                        return Center(
                            child: Text(
                          "No Todo Yet!!",
                          style: TextStyle(fontSize: 24, color: Colors.blueGrey),
                        ));
                      }
                    },
                  );
                }),
              )
            ],

          );
        }),
      ),
    );
  }

  Card buildItem(
      TodoModel dbs, BuildContext context, TodoListService todoService) {
    return Card(
      color: Colors.white70,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white70, width: 5),
        borderRadius: BorderRadius.circular(24),
      ),
      margin: EdgeInsets.all(4.0),
      child:  InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                elevation: 50.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                backgroundColor: Colors.blueGrey[700],
                title: new Text(dbs.title),
                content: Container(
                height: 150,
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                      TextField(
                        onChanged: (value) {
                          dbs.title = value;
                        },
                        autofocus: true,
                        decoration: new InputDecoration(
                            hintText: dbs.title, fillColor: Colors.blueGrey),
                      ),
                      TextField(
                        onChanged: (value) {
                          dbs.createdTime = value;
                        },
                        autofocus: true,
                        decoration: new InputDecoration(
                            hintText: dbs.createdTime, fillColor: Colors.blueGrey),
                      ),
                      TextField(
                        onChanged: (value) {
                          dbs.description = value;
                          print(value);
                        },
                        autofocus: true,
                        decoration: new InputDecoration(
                            hintText: dbs.description, fillColor: Colors.blueGrey),
                      ),
                    ]),
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("Save"),
                    onPressed: () {
                      todoService.updateTodo(dbs);
                      Navigator.of(context).pop();
                    },
                  ),
                  new FlatButton(
                    child: new Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],

              );
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Title:  ${dbs.title}\n'
                'Created Time:  ${dbs.createdTime}\n',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    onPressed: () => todoService.deleteTodo(dbs),
                    child: Text('Delete',style: TextStyle(color: Colors.white),),
                    color: Colors.blueGrey,
                  ),
                  Checkbox(
                    value: dbs.isComplete,
                    onChanged: (value) {
                      if (dbs.isComplete == true)
                        dbs.isComplete = false;
                      else
                        dbs.isComplete = true;
                      todoService.updateIsComplete(dbs);
                    },
                    activeColor: Colors.blueGrey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}