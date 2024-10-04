import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_app/core/prefs_repo.dart';
import 'package:task_app/features/task/presentation/pages/login_screen.dart';

import '../../../../common/utils.dart';
import '../../../../core/service_locater.dart';
import '../manager/task_bloc.dart';
import '../widgets/add_update_task_alert_dialog.dart';

Random random = Random();

class MyTodoScreen extends StatefulWidget {
  const MyTodoScreen({super.key});

  @override
  State<MyTodoScreen> createState() => _MyTodoScreenState();
}

class _MyTodoScreenState extends State<MyTodoScreen> {
  late final TodoBloc bloc;
  final ValueNotifier<int> numberOfAnimation = ValueNotifier(4);
  final ValueNotifier<bool> redoAnimation = ValueNotifier(false);

// 0% position (middle of the screen)

  @override
  void initState() {
    super.initState();
    bloc = getIt<TodoBloc>()..add(GetAllTodoEvent());

    ///THIS TIME TO DO ANIMATION EVERY 250 MILLISECONDS
    Timer.periodic(const Duration(milliseconds: 250), (Timer timer) {
      if (numberOfAnimation.value > 0 && numberOfAnimation.value <= 4) {
        numberOfAnimation.value -= 1;
      } else {
        numberOfAnimation.value = 4;
      }
    });

    ///THIS TIME TO DO OR UNDO ANIMATION EVERY 10 SECOND
    Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      redoAnimation.value = !redoAnimation.value;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyLight,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
              onPressed: () async {
                await getIt<PrefsRepository>().clearUser();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              icon: Icon(Icons.exit_to_app))
        ],
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('My TODOS'),
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          return switch (state.todoDataStatus) {
            GetDataStatus.loading => const Center(child: CircularProgressIndicator()),
            GetDataStatus.loaded => ListView.builder(
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadiusDirectional.circular(15)),
                  padding: const EdgeInsetsDirectional.all(8),
                  margin: EdgeInsetsDirectional.only(bottom: 10, end: 10, start: 10, top: index == 0 ? 10 : 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                          alignment: AlignmentDirectional.center,
                          child: (state.todos[index].completed ?? false)
                              ? Text(
                                  'completed',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.orange),
                                )
                              : Text(
                                  'pending',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.red),
                                )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(state.todos[index].todo),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_horiz),
                            onSelected: (value) {},
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem<String>(
                                  value: !(state.todos[index].completed) ? 'mark as Completed' : 'revert to pending',
                                  child: Text(!(state.todos[index].completed) ? 'mark as Completed' : 'revert to pending'),
                                  onTap: () {
                                    bloc.add(UpdateTodoEvent(
                                        todoModel: state.todos[index].copyWith(
                                      completed: !(state.todos[index].completed),
                                    )));
                                  },
                                ),
                                PopupMenuItem<String>(
                                  value: 'Delete',
                                  child: const Text('Delete'),
                                  onTap: () {
                                    bloc.add(DeleteTodoEvent(state.todos[index]));
                                  },
                                ),
                              ];
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                itemCount: state.todos.length,
              ),
            GetDataStatus.empty => const Center(
                child: Text('No Data yet,Add New Todo'),
              ),
          _=>ListView.builder(
            itemBuilder: (context, index) => Container(
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadiusDirectional.circular(15)),
              padding: const EdgeInsetsDirectional.all(8),
              margin: EdgeInsetsDirectional.only(bottom: 10, end: 10, start: 10, top: index == 0 ? 10 : 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                      alignment: AlignmentDirectional.center,
                      child: (state.todos[index].completed ?? false)
                          ? Text(
                        'completed',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.orange),
                      )
                          : Text(
                        'pending',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.red),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(state.todos[index].todo),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_horiz),
                        onSelected: (value) {},
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem<String>(
                              value: !(state.todos[index].completed) ? 'mark as Completed' : 'revert to pending',
                              child: Text(!(state.todos[index].completed) ? 'mark as Completed' : 'revert to pending'),
                              onTap: () {
                                bloc.add(UpdateTodoEvent(
                                    todoModel: state.todos[index].copyWith(
                                      completed: !(state.todos[index].completed),
                                    )));
                              },
                            ),
                            PopupMenuItem<String>(
                              value: 'Delete',
                              child: const Text('Delete'),
                              onTap: () {
                                bloc.add(DeleteTodoEvent(state.todos[index]));
                              },
                            ),
                          ];
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            itemCount: state.todos.length,
          )
          };
        },
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: redoAnimation,
        builder: (context, redo, child) => ValueListenableBuilder(
          valueListenable: numberOfAnimation,
          builder: (context, value, child) => AnimatedPadding(
            padding: EdgeInsets.only(

                /// IF REDO ANIMATION IS TRUE THEN CHICK IF VALUE IS EVEN MAKE PADDING FOM BOTTOM 0 ELSE IF 3 MAKE IT 40 ELSE MAKE IT 20
                bottom: redo
                    ? value % 2 == 0
                        ? 0
                        : value == 3
                            ? 40
                            : 20
                    : 0),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AddUpdateTodoAlertDialog(bloc: bloc),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsetsDirectional.all(20),
                shape: const CircleBorder(),
                // minimumSize: Size(100, 50), // Button size
              ),
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }
}
