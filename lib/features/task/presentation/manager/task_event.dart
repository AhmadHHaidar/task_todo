part of 'task_bloc.dart';

@immutable
class TodoEvent {}

class GetAllTodoEvent extends TodoEvent {}

class AddTodoEvent extends TodoEvent {
  final Todo todoModel;
  final VoidCallback onSuccess;

  AddTodoEvent({
    required this.todoModel,
    required this.onSuccess,
  });
}

class UpdateTodoEvent extends TodoEvent {
  final Todo todoModel;
  final VoidCallback? onSuccess;

  UpdateTodoEvent({
    required this.todoModel,
    this.onSuccess,
  });
}

class DeleteTodoEvent extends TodoEvent {
  final Todo todoModel;

  DeleteTodoEvent(this.todoModel);
}

class LoginUserEvent extends TodoEvent {
  final LoginParams loginParams;
  final VoidCallback onSuccess;

   LoginUserEvent({
    required this.loginParams,
    required this.onSuccess,
  });
}
class RefreshTokenUserEvent extends TodoEvent {
  final RefreshTokenParams refreshTokenParams;
  final VoidCallback onSuccess;

  RefreshTokenUserEvent({
    required this.refreshTokenParams,
    required this.onSuccess,
  });
}
