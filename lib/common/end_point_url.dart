abstract class EndPoints {
  EndPoints._();

  static const baseUrl = "https://dummyjson.com/";

  static const auth = _Auth();
  static const home = _Home();
}

class _Auth {
  const _Auth();

  final login = 'auth/login';
  final refresh = 'auth/refresh';
}

class _Home {
  const _Home();

  String getAllByUser(int userId) => 'todos/user/$userId';

  final String addNew = 'todos/add';

  String updateTodo(int todoId) => 'todos/$todoId';

  String deleteTodo(int todoId) => 'todos/$todoId';
}
