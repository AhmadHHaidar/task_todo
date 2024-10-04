
import 'package:flutter/material.dart';
import 'package:task_app/features/task/data/models/todo_model.dart';
import 'package:task_app/features/task/data/models/user_model.dart';

import '../../../../core/usecase.dart';
import '../../data/models/task_model.dart';
import '../use_cases/login_use_case.dart';
import '../use_cases/refresh_token_use_case.dart';

abstract class TaskRepository {
  FutureResult<List<Todo>> getMyTasks();

  FutureResult<Todo> addTask(Todo todoModel);

  FutureResult<Todo> deleteTask(Todo todoModel);

  FutureResult<Todo> updateTask(Todo todoModel);

  FutureResult<UserModel> login(LoginParams loginParams);
  FutureResult<UserModel> refreshToken(RefreshTokenParams refreshTokenParams);
}
