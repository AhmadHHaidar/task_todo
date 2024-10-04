import 'package:injectable/injectable.dart';
import 'package:task_app/features/task/data/models/todo_model.dart';
import 'package:task_app/features/task/data/models/user_model.dart';
import 'package:task_app/features/task/domain/use_cases/login_use_case.dart';
import 'package:task_app/features/task/domain/use_cases/refresh_token_use_case.dart';
import '../../../../core/api_utils.dart';
import '../../../../core/usecase.dart';
import '../../domain/repositories/task_repository.dart';
import '../data_sources/task_remote_datasource.dart';
import '../models/task_model.dart';

@Injectable(as: TaskRepository)
class TaskRepositoryImp implements TaskRepository {
  final TaskRemoteDataSource taskRemoteDataSource;

  TaskRepositoryImp(this.taskRemoteDataSource);

  @override
  FutureResult<List<Todo>> getMyTasks() {
    return toApiResult(() async {
      final result = await taskRemoteDataSource.getMyTasks();
      return result;
    });
  }

  @override
  FutureResult<Todo> addTask(Todo todoModel) {
    return toApiResult(() async {
      final result = await taskRemoteDataSource.addTask(todoModel);
      return result;
    });
  }

  @override
  FutureResult<Todo> deleteTask(Todo todoModel) {
    return toApiResult(() async {
      final result = await taskRemoteDataSource.deleteTask(todoModel);
      return result;
    });
  }

  @override
  FutureResult<Todo> updateTask(Todo todoModel) {
    return toApiResult(() async {
      final result = await taskRemoteDataSource.updateTask(todoModel);
      return result;
    });
  }

  @override
  FutureResult<UserModel> login(LoginParams loginParams) {
    return toApiResult(() async {
      final result = await taskRemoteDataSource.loginUser(loginParams);
      return result;
    });

  }

  @override
  FutureResult<UserModel> refreshToken(RefreshTokenParams refreshTokenParams) {
    return toApiResult(() async {
      final result = await taskRemoteDataSource.refreshUserToken(refreshTokenParams);
      return result;
    });
  }

}
