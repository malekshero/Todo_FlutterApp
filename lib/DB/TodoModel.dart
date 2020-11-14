
import 'package:flutter/cupertino.dart';

import 'DB_Creator.dart';
class TodoModel{
  int id;
  String title;
  String description;
  String createdTime;
  bool isComplete;

  TodoModel(
      this.id,
      this.title,
      this.description,
      this.createdTime,
      this.isComplete,
      );

  TodoModel.fromJson(Map<String, dynamic> json) {
    this.id = json[DatabaseCreator.id];
    this.title = json[DatabaseCreator.title];
    this.description = json[DatabaseCreator.description];
    this.createdTime = json[DatabaseCreator.createdTime];
    this.isComplete = json[DatabaseCreator.isComplete] == 1;
  }
}