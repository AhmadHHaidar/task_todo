import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:task_app/core/prefs_repo.dart';
import 'package:task_app/core/service_locater.dart';
import 'package:task_app/features/task/data/data_sources/locale_data_source.dart';
import 'package:task_app/features/task/data/models/todo_model.dart';
import 'package:task_app/features/task/data/models/user_model.dart';

import '../../../../core/usecase.dart';
import '../../../../main.dart';

import '../../domain/use_cases/add_task_use_case.dart';
import '../../domain/use_cases/delete_task_use_case.dart';
import '../../domain/use_cases/get_all_task_use_case.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../../domain/use_cases/refresh_token_use_case.dart';
import '../../domain/use_cases/update_task_use_case.dart';
import 'package:equatable/equatable.dart';

part 'task_event.dart';

part 'task_state.dart';

@lazySingleton
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetAllTaskUseCase getAllTodoUseCase;
  final AddTaskUseCase addTodoUseCase;
  final UpdateTaskUseCase updateTodoUseCase;
  final DeleteTaskUseCase deleteTodoUseCase;
  final LoginUseCase loginUseCase;
  final RefreshTokenUseCase refreshTokenUseCase;

  TodoBloc(
    this.getAllTodoUseCase,
    this.addTodoUseCase,
    this.updateTodoUseCase,
    this.deleteTodoUseCase,
    this.loginUseCase,
    this.refreshTokenUseCase,
  ) : super(TodoState()) {
    on<GetAllTodoEvent>(_onGetAllTodoEvent);
    on<AddTodoEvent>(_onAddTodoEvent);
    on<UpdateTodoEvent>(_onUpdateTodoEvent);
    on<DeleteTodoEvent>(_onDeleteTodoEvent);
    on<LoginUserEvent>(_onLoginUserEvent);
    on<RefreshTokenUserEvent>(_onRefreshTokenUserEvent);
  }

  FutureOr<void> _onGetAllTodoEvent(GetAllTodoEvent event, Emitter<TodoState> emit) async {
    var list = await getIt<DatabaseHelper>().getTodosWithPagination(event.per_page, event.page_key * event.per_page);
    if (list.isNotEmpty || event.page_key > 0) {
      emit(state.copyWith(todoDataStatus: GetDataStatus.loaded, todos: list));

      print(list.length);
      final isLastPage = list.length < event.per_page;

      if (isLastPage) {
        state.todoPaginationController.appendLastPage(list);
      } else {
        final nextPageKey = event.page_key + 1;
        state.todoPaginationController.appendPage(list, nextPageKey.toInt());
      }

      return;
    } else {
      final result = await getAllTodoUseCase(NoParams());
      result.fold(
        (l) {
          emit(state.copyWith(todoDataStatus: GetDataStatus.failed, todos: []));
        },
        (r) async {
          if (r.isNotEmpty) {
            print(r.length);
            final isLastPage = r.length < event.per_page;

            if (isLastPage) {
              state.todoPaginationController.appendLastPage(r);
            } else {
              final nextPageKey = event.page_key + 1;
              state.todoPaginationController.appendPage(r, nextPageKey.toInt());
            }
            emit(state.copyWith(todoDataStatus: GetDataStatus.loaded, todos: r));
            await getIt<DatabaseHelper>().insertTodos(r);
          } else {
            emit(state.copyWith(todoDataStatus: GetDataStatus.empty));
          }
        },
      );
    }
  }

  FutureOr<void> _onAddTodoEvent(AddTodoEvent event, Emitter<TodoState> emit) async {
    final result = await addTodoUseCase(event.todoModel);
    result.fold(
      (l) {
        emit(state.copyWith(todoDataStatus: GetDataStatus.failed, todos: []));
      },
      (r) async {
        emit(state.copyWith(todoDataStatus: GetDataStatus.loaded, todos: List.of(state.todos)..add(r)));
        event.onSuccess();
        await getIt<DatabaseHelper>().insertTodo(r).then(
          (value) {
            state.todoPaginationController.refresh();
          },
        );
      },
    );
  }

  FutureOr<void> _onUpdateTodoEvent(UpdateTodoEvent event, Emitter<TodoState> emit) async {
    final result = await updateTodoUseCase(event.todoModel);
    result.fold(
      (l) {
        emit(state.copyWith(
          todoDataStatus: GetDataStatus.failed,
        ));
      },
      (r) async {
        emit(state.copyWith(
          todoDataStatus: GetDataStatus.loaded,
        ));
        event.onSuccess?.call();
        await getIt<DatabaseHelper>().updateTodoById(r).then(
          (value) {
            // state.todoPaginationController.refresh();
            state.todoPaginationController.itemList =
                state.todoPaginationController.itemList?.map((element) => element.id == r.id ? r : element).toList();
          },
        );
      },
    );
  }

  FutureOr<void> _onDeleteTodoEvent(DeleteTodoEvent event, Emitter<TodoState> emit) async {
    // await getIt<DatabaseHelper>().deleteTodoById(event.todoModel.id).then(
    //   (value) {
    //     state.todoPaginationController.itemList=List.of(state.todoPaginationController.itemList??[])..removeWhere((element) => element.id==event.todoModel.id,);
    //   },
    // );

    final result = await deleteTodoUseCase(event.todoModel);
    result.fold(
      (l) {
        emit(state.copyWith(todoDataStatus: GetDataStatus.failed));
      },
      (r) async {
        emit(state.copyWith(
            todoDataStatus: GetDataStatus.loaded, todos: List.of(state.todos)..removeWhere((element) => element.id == event.todoModel.id)));
        await getIt<DatabaseHelper>().deleteTodoById(r.id).then((value) {
          state.todoPaginationController.itemList = List.of(state.todoPaginationController.itemList ?? [])
            ..removeWhere(
              (element) => element.id == event.todoModel.id,
            );
        });
      },
    );
  }

  FutureOr<void> _onLoginUserEvent(LoginUserEvent event, Emitter<TodoState> emit) async {
    emit(state.copyWith(loginStatus: GetDataStatus.loading));
    final result = await loginUseCase(event.loginParams);
    result.fold(
      (l) {
        emit(state.copyWith(loginStatus: GetDataStatus.failed));
      },
      (r) async {
        emit(state.copyWith(currentUser: r, loginStatus: GetDataStatus.loaded));
        event.onSuccess();
        await getIt<PrefsRepository>().setUser(r);
      },
    );
  }

  FutureOr<void> _onRefreshTokenUserEvent(RefreshTokenUserEvent event, Emitter<TodoState> emit) async {
    emit(state.copyWith(loginStatus: GetDataStatus.loading));
    final result = await refreshTokenUseCase(event.refreshTokenParams);
    result.fold(
      (l) {
        emit(state.copyWith(loginStatus: GetDataStatus.failed));
      },
      (r) async {
        emit(state.copyWith(currentUser: r, loginStatus: GetDataStatus.loaded));
        event.onSuccess();
        await getIt<PrefsRepository>().setUser(r);
      },
    );
  }
}
