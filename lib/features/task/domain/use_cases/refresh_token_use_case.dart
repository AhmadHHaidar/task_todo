import 'package:injectable/injectable.dart';
import 'package:task_app/features/task/data/models/todo_model.dart';
import 'package:task_app/features/task/data/models/user_model.dart';
import '../../../../core/usecase.dart';

import '../repositories/task_repository.dart';

//TODO: SHOULD MOVE IT TO SEPARETER FEATURES
@injectable
class RefreshTokenUseCase implements UseCase<UserModel, RefreshTokenParams> {
  final TaskRepository repository;

  RefreshTokenUseCase({required this.repository});

  @override
  FutureResult<UserModel> call(RefreshTokenParams params) async {
    return repository.refreshToken(params);
  }
}

class RefreshTokenParams {
  final String refreshToken;
  final int expiresInMins;

  const RefreshTokenParams({
    required this.refreshToken,
    this.expiresInMins = 60,
  });

  Map<String, dynamic> toJson() {
    return {
      'refreshToken': refreshToken,
      'expiresInMins': expiresInMins,
    };
  }
}
