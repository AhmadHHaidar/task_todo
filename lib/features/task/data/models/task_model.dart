import 'package:hive/hive.dart';
import 'package:task_app/core/prefs_repo.dart';
import 'package:task_app/core/service_locater.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
class TaskModel extends HiveObject {
  TaskModel({
    this.id,
    required this.todo,
    this.completed,
    this.userId,
  });

  @HiveField(0)
  int? id;
  @HiveField(1)
  String todo;
  @HiveField(2, defaultValue: false)
  bool? completed;
  @HiveField(3)
  int? userId;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'todo': todo,
      'completed': completed,
      'userId': userId,
    };
  }

  Map<String, dynamic> addToJson() {
    return {
      'todo': todo,
      'completed': completed,
      'userId': getIt<PrefsRepository>().user?.id,
    };
  }

  Map<String, dynamic> updateToJson() {
    return {
      'completed': completed,
    };
  }

  factory TaskModel.formJson(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as int,
      todo: map['todo'] as String,
      completed: map['completed'] as bool,
      userId: map['userId'] as int,
    );
  }

  @override
  String toString() {
    return 'TaskModel{id: $id, todo: $todo, completed: $completed, userId: $userId}';
  }

  TaskModel copyWith({
    String? todo,
    bool? completed,
    int? userId,
  }) {
    return TaskModel(
      id: id,
      todo: todo ?? this.todo,
      completed: completed ?? this.completed,
      userId: userId ?? this.userId,
    );
  }
}
