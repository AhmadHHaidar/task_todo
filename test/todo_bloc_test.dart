import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:task_app/core/service_locater.dart';
import 'package:task_app/features/task/data/data_sources/locale_data_source.dart';
import 'package:task_app/features/task/data/models/todo_model.dart';
import 'package:task_app/features/task/domain/use_cases/add_task_use_case.dart';
import 'package:task_app/features/task/domain/use_cases/delete_task_use_case.dart';
import 'package:task_app/features/task/domain/use_cases/get_all_task_use_case.dart';
import 'package:task_app/features/task/domain/use_cases/login_use_case.dart';
import 'package:task_app/features/task/domain/use_cases/refresh_token_use_case.dart';
import 'package:task_app/features/task/domain/use_cases/update_task_use_case.dart';
import 'package:task_app/features/task/presentation/manager/task_bloc.dart';

import 'todo_bloc_test.mocks.dart';

@GenerateMocks([AddTaskUseCase, UpdateTaskUseCase, GetAllTaskUseCase, DeleteTaskUseCase, LoginUseCase, RefreshTokenUseCase, DatabaseHelper])
void main() {
  MockAddTaskUseCase? mockAddTaskUseCase;
  MockUpdateTaskUseCase? mockUpdateTaskUseCase;
  MockDeleteTaskUseCase? mockDeleteTaskUseCase;
  MockGetAllTaskUseCase? mockGetAllTaskUseCase;
  MockLoginUseCase? mockLoginUseCase;
  MockRefreshTokenUseCase? mockRefreshTokenUseCase;
  MockDatabaseHelper? mockDatabaseHelper;

  TodoBloc? todoBloc;

  setUpAll(() async => getIt.registerLazySingleton<DatabaseHelper>(
        () => mockDatabaseHelper!,
      ));

  setUp(() async {
    mockAddTaskUseCase = MockAddTaskUseCase();
    mockUpdateTaskUseCase = MockUpdateTaskUseCase();
    mockDeleteTaskUseCase = MockDeleteTaskUseCase();
    mockGetAllTaskUseCase = MockGetAllTaskUseCase();
    mockLoginUseCase = MockLoginUseCase();
    mockRefreshTokenUseCase = MockRefreshTokenUseCase();
    mockDatabaseHelper = MockDatabaseHelper();
    todoBloc = TodoBloc(
      mockGetAllTaskUseCase!,
      mockAddTaskUseCase!,
      mockUpdateTaskUseCase!,
      mockDeleteTaskUseCase!,
      mockLoginUseCase!,
      mockRefreshTokenUseCase!,
    );
    provideDummy<Either<dynamic, Todo>>(Right(Todo(id: 1, todo: 'Test Todo', completed: false, userId: 1)));
    provideDummy<Either<dynamic, List<Todo>>>(Right([Todo(id: 1, todo: 'Test Todo', completed: false, userId: 1)]));
  });

  // TODO:NOTE TO RUN TEST RUN THIS IN TERMINAL flutter test --name "BLOC TEST DESCRIPTION"

  group(
    'Success group test',
    () {
      var todoItem1 = Todo(id: 1, userId: 1, todo: 'todo1');
      var todoItem2 = Todo(id: 2, userId: 1, todo: 'todo2');
      var todoItem3 = Todo(id: 3, userId: 1, todo: 'todo3');
      TodoState? seed;
      blocTest(
        'Success test get all items todo list if there is locale data stored before',
        build: () => todoBloc!,
        act: (bloc) {
          when(mockGetAllTaskUseCase!.call(any)).thenAnswer(
            (realInvocation) async => Right([
              todoItem1,
              todoItem2,
              todoItem3,
            ]),
          );
          when(mockDatabaseHelper!.getTodosWithPagination(10, 0)).thenAnswer((realInvocation) async => [todoItem1, todoItem2, todoItem3]);
          bloc.add(GetAllTodoEvent());
        },
        seed: () => seed = TodoState(),
        verify: (bloc) {
          verify(mockDatabaseHelper!.getTodosWithPagination(10, 0)).called(1);
        },
        expect: () => [
          seed!.copyWith(todos: [todoItem1, todoItem2, todoItem3], todoDataStatus: GetDataStatus.loaded)
        ],
      );
      blocTest(
        'Success test get all items todo list if there is no locale data stored before',
        build: () => todoBloc!,
        act: (bloc) {
          when(mockGetAllTaskUseCase!.call(any)).thenAnswer(
            (realInvocation) async => Right([
              todoItem1,
              todoItem2,
              todoItem3,
            ]),
          );
          when(mockDatabaseHelper!.getTodosWithPagination(10, 0)).thenAnswer((realInvocation) async => []);
          when(mockDatabaseHelper!.insertTodos([
            todoItem1,
            todoItem2,
            todoItem3,
          ])).thenAnswer((realInvocation) async => 1);
          bloc.add(GetAllTodoEvent());
        },
        seed: () => seed = TodoState(),
        verify: (bloc) {
          verify(mockGetAllTaskUseCase!.call(any)).called(1);
          verify(mockDatabaseHelper!.insertTodos([todoItem1, todoItem2, todoItem3])).called(1);
        },
        expect: () => [
          seed!.copyWith(todos: [todoItem1, todoItem2, todoItem3], todoDataStatus: GetDataStatus.loaded)
        ],
      );
      blocTest(
        'Success test add new Item to todo list ',
        build: () => todoBloc!,
        act: (bloc) {
          when(mockAddTaskUseCase!.call(any)).thenAnswer(
            (realInvocation) async => Right(todoItem1),
          );
          when(mockDatabaseHelper!.insertTodo(todoItem1)).thenAnswer((realInvocation) async => 1);
          bloc.add(AddTodoEvent(
            todoModel: todoItem1,
            onSuccess: () {},
          ));
        },
        seed: () => seed = TodoState(),
        verify: (bloc) {
          verify(mockAddTaskUseCase!.call(any)).called(1);
          verify(mockDatabaseHelper!.insertTodo(todoItem1)).called(1);
        },
        expect: () => [
          seed!.copyWith(todos: [todoItem1], todoDataStatus: GetDataStatus.loaded)
        ],
      );
      blocTest<TodoBloc, TodoState>(
        'Success test update Item to todo list ',
        build: () => todoBloc!,
        act: (bloc) {
          when(mockUpdateTaskUseCase!.call(any)).thenAnswer(
            (realInvocation) async => Right(todoItem1),
          );
          when(mockDatabaseHelper!.updateTodoById(todoItem1)).thenAnswer((realInvocation) async => 1);
          bloc.add(UpdateTodoEvent(
            todoModel: todoItem1.copyWith(todo: 'qwertyuiop'),
            onSuccess: () {},
          ));
        },
        seed: () => seed = TodoState(todoDataStatus: GetDataStatus.loaded, todos: [todoItem1]),
        verify: (bloc) {
          verify(mockUpdateTaskUseCase!.call(any)).called(1);
          verify(mockDatabaseHelper!.updateTodoById(todoItem1)).called(1);
        },
        expect: () => [
          seed!.copyWith(todos: [todoItem1.copyWith(todo: 'qwertyuiop')], todoDataStatus: GetDataStatus.loaded)
        ],
      );
      blocTest<TodoBloc, TodoState>(
        'Success test delete Item from todo list ',
        build: () => todoBloc!,
        act: (bloc) {
          when(mockDeleteTaskUseCase!.call(any)).thenAnswer(
            (realInvocation) async => Right(todoItem1),
          );
          when(mockDatabaseHelper!.deleteTodoById(todoItem1.id)).thenAnswer((realInvocation) async => 1);
          bloc.add(DeleteTodoEvent(
            todoItem1,
          ));
        },
        seed: () => seed = TodoState(todoDataStatus: GetDataStatus.loaded, todos: [todoItem1]),
        verify: (bloc) {
          verify(mockDeleteTaskUseCase!.call(any)).called(1);
          verify(mockDatabaseHelper!.deleteTodoById(todoItem1.id)).called(1);
        },
        expect: () => [seed!.copyWith(todos: [], todoDataStatus: GetDataStatus.loaded)],
      );
    },
  );
  group(
    'Failed group test',
    () {
      var todoItem1 = Todo(id: 1, userId: 1, todo: 'todo1');
      var todoItem2 = Todo(id: 2, userId: 1, todo: 'todo2');
      var todoItem3 = Todo(id: 3, userId: 1, todo: 'todo3');
      TodoState? seed;
      blocTest(
        'failed test get all items todo list if there is locale data stored before',
        build: () => todoBloc!,
        act: (bloc) {
          when(mockGetAllTaskUseCase!.call(any)).thenAnswer(
            (realInvocation) async => Left(Exception('message')),
          );
          when(mockDatabaseHelper!.getTodosWithPagination(10, 0)).thenAnswer((realInvocation) async => []);
          bloc.add(GetAllTodoEvent());
        },
        seed: () => seed = TodoState(),
        verify: (bloc) {
          verify(mockDatabaseHelper!.getTodosWithPagination(10, 0)).called(1);
        },
        expect: () => [seed!.copyWith(todos: [], todoDataStatus: GetDataStatus.failed)],
      );
      blocTest(
        'failed test add new Item to todo list ',
        build: () => todoBloc!,
        act: (bloc) {
          when(mockAddTaskUseCase!.call(any)).thenAnswer(
            (realInvocation) async => Left(Exception('message')),
          );
          when(mockDatabaseHelper!.insertTodo(todoItem1)).thenAnswer((realInvocation) async => 1);
          bloc.add(AddTodoEvent(
            todoModel: todoItem1,
            onSuccess: () {},
          ));
        },
        seed: () => seed = TodoState(),
        verify: (bloc) {
          verify(mockAddTaskUseCase!.call(any)).called(1);
          // verify(mockDatabaseHelper!.insertTodo(todoItem1)).called(1);
        },
        expect: () => [seed!.copyWith(todos: [], todoDataStatus: GetDataStatus.failed)],
      );
      blocTest<TodoBloc, TodoState>(
        'failed test update Item to todo list ',
        build: () => todoBloc!,
        act: (bloc) {
          when(mockUpdateTaskUseCase!.call(any)).thenAnswer(
            (realInvocation) async => Left(Exception('message')),
          );
          when(mockDatabaseHelper!.updateTodoById(todoItem1)).thenAnswer((realInvocation) async => 1);
          bloc.add(UpdateTodoEvent(
            todoModel: todoItem1.copyWith(todo: 'qwertyuiop'),
            onSuccess: () {},
          ));
        },
        seed: () => seed = TodoState(todoDataStatus: GetDataStatus.loaded, todos: [todoItem1]),
        verify: (bloc) {
          verify(mockUpdateTaskUseCase!.call(any)).called(1);
          // verify(mockDatabaseHelper!.updateTodoById(todoItem1)).called(1);
        },
        expect: () => [
          seed!.copyWith(todos: [todoItem1], todoDataStatus: GetDataStatus.failed)
        ],
      );
      blocTest<TodoBloc, TodoState>(
        'failed test delete  Item from todo list ',
        build: () => todoBloc!,
        act: (bloc) {
          when(mockDeleteTaskUseCase!.call(any)).thenAnswer(
            (realInvocation) async => Left(Exception('message')),
          );
          when(mockDatabaseHelper!.deleteTodoById(todoItem1.id)).thenAnswer((realInvocation) async => 1);
          bloc.add(DeleteTodoEvent(
            todoItem1,
          ));
        },
        seed: () => seed = TodoState(todoDataStatus: GetDataStatus.loaded, todos: [todoItem1]),
        verify: (bloc) {
          verify(mockDeleteTaskUseCase!.call(any)).called(1);
          // verify(mockDatabaseHelper!.deleteTodoById(todoItem1.id)).called(1);
        },
        expect: () => [
          seed!.copyWith(todos: [todoItem1], todoDataStatus: GetDataStatus.failed)
        ],
      );
    },
  );
}
