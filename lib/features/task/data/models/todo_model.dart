import 'package:equatable/equatable.dart';

import '../../../../core/prefs_repo.dart';
import '../../../../core/service_locater.dart';

class Todo extends Equatable {
  int id;
  String todo;
  bool completed;
  int userId;

  Todo({
    required this.id,
    required this.userId,
    required this.todo,
    this.completed = false, // Default is false
  });


  @override
  List<Object> get props => [id,todo,completed,userId];

  // Convert Todo object to a Map (for SQLite insertion)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'todo': todo,
      'completed': completed ? 1 : 0, // SQLite uses 0 or 1 for boolean values
    };
  }

  Map<String, dynamic> addToJson() {
    return {
      'todo': todo,
      'completed': completed,
      'userId': getIt<PrefsRepository>().user!.id!,
    };
  }


  Map<String, dynamic> updateToJson() {
    return {
      'completed': completed,
    };
  }


  // Convert a Map from SQLite to a Todo object
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      userId: map['userId'],
      todo: map['todo'],
      completed: map['completed'] == 1, // If 1, set as true
    );
  }
  factory Todo.fromJsonApi(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      userId: map['userId'],
      todo: map['todo'],
      completed: map['completed'],
    );
  }

  Todo copyWith({
    String? todo,
    bool? completed,
    int? userId,
  }) {
    return Todo(
      id: id,
      todo: todo ?? this.todo,
      completed: completed ?? this.completed,
      userId: userId ?? this.userId,
    );
  }
}
