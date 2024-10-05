import 'package:injectable/injectable.dart';
import 'package:task_app/features/task/data/models/todo_model.dart';
import 'package:task_app/features/task/data/models/user_model.dart';
import '../../../../core/usecase.dart';

import '../repositories/task_repository.dart';

//TODO: SHOULD MOVE IT TO SEPARETER FEATURES
@injectable
class LoginUseCase implements UseCase<UserModel, LoginParams> {
  final TaskRepository repository;

  LoginUseCase({required this.repository});

  @override
  FutureResult<UserModel> call(LoginParams params) async {
    return repository.login(params);
  }
}

class LoginParams {
  final String username;
  final String password;
  final int expiresInMins;

  const LoginParams({
    required this.username,
    required this.password,
    this.expiresInMins = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'expiresInMins': expiresInMins,
    };
  }
}
