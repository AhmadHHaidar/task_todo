import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:task_app/common/end_point_url.dart';
import 'package:task_app/core/prefs_repo.dart';
import 'package:task_app/core/service_locater.dart';
import 'package:task_app/features/task/data/models/todo_model.dart';
import 'package:task_app/features/task/data/models/user_model.dart';
import 'package:task_app/features/task/domain/use_cases/login_use_case.dart';

import '../../../../core/api_utils.dart';
import '../../../../core/dio_client.dart';
import '../../../../main.dart';
import '../../domain/use_cases/refresh_token_use_case.dart';
import '../models/task_model.dart';

@injectable
class TaskRemoteDataSource {
  final DioClient dioClient;

  TaskRemoteDataSource(this.dioClient);

  Future<List<Todo>> getMyTasks() {
    return throwAppException(() async {
      final result = await dioClient.get(EndPoints.home.getAllByUser(1));
      // final result = Hive.box<TaskModel>(keyBoxHive);
      // print(result.values.toString());
      // return result.values.toList();
      return (result.data["todos"] as List<dynamic>).map((e) => Todo.fromMap(e)).toList();
    });
  }

  Future<Todo> addTask(Todo todoModel) {
    return throwAppException(() async {
      final result = await dioClient.post(EndPoints.home.addNew, data: todoModel.addToJson());
      // final result = Hive.box<TaskModel>(keyBoxHive);
      // var keeeey = await result.add(todoModel);
      // log(result.get(keeeey).toString());
      // return result.values.toList();
      return Todo.fromMap(result.data);
    });
  }

  Future<Todo> deleteTask(Todo todoModel) {
    // return throwAppException(() async {
    //   final result = Hive.box<TaskModel>(keyBoxHive);
    //   var index = Hive.box<TaskModel>(keyBoxHive).values.toList().indexWhere((element) => element.id == todoModel.id);
    //   var result1 = result..deleteAt(index);
    //   return result1.values.toList();
    // });
    return throwAppException(() async {
      final result = await dioClient.delete(EndPoints.home.deleteTodo(todoModel.id));
      return Todo.fromMap(result.data);
    });
  }

  Future<Todo> updateTask(Todo todoModel) {
    // return throwAppException(() async {
    // final result = Hive.box<TaskModel>(keyBoxHive);
    // var index = result.values.toList().indexWhere((element) => element.id == todoModel.id);
    // var result1 = Hive.box<TaskModel>(keyBoxHive)..putAt(index, todoModel);
    // return result1.values.toList();
    return throwAppException(() async {
      final result = await dioClient.put(EndPoints.home.updateTodo(todoModel.id), data: todoModel.updateToJson());
      return Todo.fromMap(result.data);
    });

    // });
  }

  Future<UserModel> loginUser(LoginParams loginParams) {
    return throwAppException(() async {
      final result = await dioClient.post(EndPoints.auth.login, data: loginParams.toJson());
      return UserModel.fromJson(result.data);
    });
  }

  Future<UserModel> refreshUserToken(RefreshTokenParams refreshTokenParams) {
    return throwAppException(() async {
      final result = await dioClient.post(EndPoints.auth.refresh, data: refreshTokenParams.toJson());
      var user = getIt<PrefsRepository>().user;
      user = user!.copyWith(accessToken: result.data["accessToken"], refreshToken: result.data["refreshToken"]);
      return user;
    });
  }
}