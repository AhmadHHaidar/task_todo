import 'package:injectable/injectable.dart';
import 'package:task_app/features/task/data/models/todo_model.dart';
import '../../../../core/usecase.dart';

import '../repositories/task_repository.dart';
@injectable
class GetAllTaskUseCase implements UseCase<List<Todo>, NoParams> {
  final TaskRepository repository;

  GetAllTaskUseCase({required this.repository});

  @override
  FutureResult<List<Todo>> call(NoParams params) async {
    return repository.getMyTasks();
  }
}
