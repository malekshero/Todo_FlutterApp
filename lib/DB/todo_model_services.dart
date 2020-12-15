import 'dart:async';

import 'db_creator.dart';
import 'todo_model.dart';

class TodoModelServices {

  static Future<int> todosCount() async {
    final data = await db
        .rawQuery('''SELECT COUNT(*) FROM ${DatabaseCreator.todoTable}''');
    int count = data[0].values.elementAt(0);
    int idForNewItem = count++;
    return idForNewItem;
  }

  static Future<void> addTodo(TodoModel add) async {
    final sql = '''INSERT INTO ${DatabaseCreator.todoTable}
    (
      ${DatabaseCreator.id},
      ${DatabaseCreator.title},
      ${DatabaseCreator.description},
      ${DatabaseCreator.createdTime},
      ${DatabaseCreator.isComplete}
    )
    VALUES (?,?,?,?,?)''';
    List<dynamic> params = [
      add.id,
      add.title,
      add.description,
      add.createdTime,
      add.isComplete ? 1 : 0
    ];
    final result = await db.rawInsert(sql, params);
    DatabaseCreator.databaseLog('Add Todo', sql, null, result, params);
  }

  static Future<void> deleteTodo(TodoModel todo) async {
    final sql = '''DELETE FROM ${DatabaseCreator.todoTable}
    WHERE ${DatabaseCreator.id} = ?
    ''';
    List<dynamic> params = [todo.id];
    final result = await db.rawUpdate(sql, params);

    DatabaseCreator.databaseLog('Delete Todo', sql, null, result, params);
  }

  static Future<void> updateTodo(TodoModel dbs) async {
    final sql = '''UPDATE ${DatabaseCreator.todoTable}
  SET ${DatabaseCreator.title} = ?,${DatabaseCreator.description} = ?,  ${DatabaseCreator.createdTime} = ?
  WHERE ${DatabaseCreator.id} = ?
  ''';
    List<dynamic> params = [
      dbs.title,
      dbs.description,
      dbs.createdTime,
      dbs.isComplete,
      dbs.id,
    ];
    final result = await db.rawUpdate(sql, params);
    DatabaseCreator.databaseLog('Update Todo', sql, null, result, params);
  }

  static Future<List<TodoModel>> getAllTodos() async {
    final sql = '''SELECT * FROM ${DatabaseCreator.todoTable}
    WHERE ${DatabaseCreator.isComplete} = 0 
    OR ${DatabaseCreator.isComplete} = 1''';
    final data = await db.rawQuery(sql);
    List<TodoModel> todos = List();

    for (final node in data) {
      final todo = TodoModel.fromJson(node);
      todos.add(todo);
    }
    return todos;
  }
}
