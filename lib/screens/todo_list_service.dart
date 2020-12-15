import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:todo_app/DB/db_creator.dart';
import 'package:todo_app/DB/todo_model.dart';
import 'package:todo_app/DB/todo_model_services.dart';

class TodoListService with ChangeNotifier {
  int id;
  String title;
  String description;
  String createdTime;
  Future<List<TodoModel>> future;

  void addTodoToDataBase() async {
    int count = await TodoModelServices.todosCount();
    final todo = TodoModel(count, title, description, createdTime, false);
    await TodoModelServices.addTodo(todo);
    id = todo.id;
    title = todo.title;
    description = todo.description;
    createdTime = todo.createdTime;
    future = TodoModelServices.getAllTodos();
    notifyListeners();
  }

  deleteTodo(TodoModel todo) async {
    await TodoModelServices.deleteTodo(todo);
    id = null;
    future = TodoModelServices.getAllTodos();
    notifyListeners();
  }

  Future<void> updateTodo(TodoModel dbs) async {
    final sql = '''UPDATE ${DatabaseCreator.todoTable}
  SET ${DatabaseCreator.title} = ?,${DatabaseCreator.description} = ?,  ${DatabaseCreator.createdTime} = ?
  WHERE ${DatabaseCreator.id} = ?
  ''';
    List<dynamic> params = [
      dbs.title,
      dbs.description,
      dbs.createdTime,
      dbs.id,
    ];
    final result = await db.rawUpdate(sql, params);
    DatabaseCreator.databaseLog('Update Todo', sql, null, result, params);
    notifyListeners();
  }

  Future<void> updateIsComplete(TodoModel dbs) async {
    final sql = '''UPDATE ${DatabaseCreator.todoTable}
  SET  ${DatabaseCreator.isComplete} = ?
  WHERE ${DatabaseCreator.id} = ?
  ''';
    List<dynamic> params = [
      dbs.isComplete,
      dbs.id,
    ];
    final result = await db.rawUpdate(sql, params);
    DatabaseCreator.databaseLog('Update Todo', sql, null, result, params);
    notifyListeners();
  }
}
