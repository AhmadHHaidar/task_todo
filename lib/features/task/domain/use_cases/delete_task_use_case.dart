import 'package:injectable/injectable.dart';
import 'package:task_app/features/task/data/models/todo_model.dart';
import '../../../../core/usecase.dart';
import '../../data/models/task_model.dart';
import '../repositories/task_repository.dart';

@injectable
class DeleteTaskUseCase implements UseCase<Todo, Todo> {
  final TaskRepository repository;

  DeleteTaskUseCase({required this.repository});

  @override
  FutureResult<Todo> call(Todo params) async {
    return repository.deleteTask(params);
  }
}
