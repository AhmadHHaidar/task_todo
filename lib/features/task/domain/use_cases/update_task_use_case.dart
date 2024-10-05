import 'package:injectable/injectable.dart';
import 'package:task_app/features/task/data/models/todo_model.dart';
import '../../../../core/usecase.dart';

import '../repositories/task_repository.dart';

@injectable
class UpdateTaskUseCase implements UseCase<Todo, Todo> {
  final TaskRepository repository;

  UpdateTaskUseCase({required this.repository});

  @override
  FutureResult<Todo> call(Todo params) async {
    return repository.updateTask(params);
  }
}
