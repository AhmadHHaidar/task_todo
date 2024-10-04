part of 'task_bloc.dart';

/// THIS ENUM TO STORE STATUS OF GETTING DATA FORM STORAGE
enum GetDataStatus {
  init,
  loading,
  loaded,
  failed,
  empty,
}

@immutable
class TodoState extends Equatable {
  final GetDataStatus todoDataStatus;
  final List<Todo> todos;
  final UserModel currentUser;
  final GetDataStatus loginStatus;

  const TodoState({
    this.todoDataStatus = GetDataStatus.init,
    this.loginStatus = GetDataStatus.init,
    this.todos = const [],
    this.currentUser = const UserModel(),
  });

  @override
  List<Object> get props => [todoDataStatus, todos,loginStatus,currentUser];

  TodoState copyWith({
    GetDataStatus? todoDataStatus,
    List<Todo>? todos,
    UserModel? currentUser,
    GetDataStatus? loginStatus,
  }) {
    return TodoState(
      todoDataStatus: todoDataStatus ?? this.todoDataStatus,
      todos: todos ?? this.todos,
      loginStatus: loginStatus ?? this.loginStatus,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}
