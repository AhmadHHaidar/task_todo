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
  final PagingController<int, Todo> todoPaginationController;

  TodoState({
    this.todoDataStatus = GetDataStatus.init,
    this.loginStatus = GetDataStatus.init,
    this.todos = const [],
    this.currentUser = const UserModel(),
    final PagingController<int, Todo>? todoPaginationController,
  }) : todoPaginationController = todoPaginationController ?? PagingController(firstPageKey: 0);

  @override
  List<Object> get props => [todoDataStatus, todos, loginStatus, currentUser,todoPaginationController];

  TodoState copyWith({
    GetDataStatus? todoDataStatus,
    List<Todo>? todos,
    UserModel? currentUser,
    GetDataStatus? loginStatus,
    final PagingController<int, Todo>? todoPaginationController,
  }) {
    return TodoState(
      todoDataStatus: todoDataStatus ?? this.todoDataStatus,
      todos: todos ?? this.todos,
      todoPaginationController: todoPaginationController ?? this.todoPaginationController,
      loginStatus: loginStatus ?? this.loginStatus,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}
