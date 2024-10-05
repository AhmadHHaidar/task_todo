import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:task_app/core/prefs_repo.dart';
import 'package:task_app/features/task/presentation/pages/login_screen.dart';
import 'package:task_app/features/task/presentation/widgets/todo_item_widget.dart';

import '../../../../common/utils.dart';
import '../../../../core/service_locater.dart';
import '../../data/models/todo_model.dart';
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
    bloc = getIt<TodoBloc>();
    bloc.state.todoPaginationController.addPageRequestListener(
      (pageKey) => bloc.add(
        GetAllTodoEvent(page_key: pageKey),
      ),
    );

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
          return PagedListView<int, Todo>(
            pagingController: state.todoPaginationController,
            builderDelegate: PagedChildBuilderDelegate(
              itemBuilder: (context, item, index) {
                return Container(
                  decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadiusDirectional.circular(15)),
                  padding: const EdgeInsetsDirectional.all(8),
                  margin: EdgeInsetsDirectional.only(bottom: 10, end: 10, start: 10, top: index == 0 ? 10 : 0),
                  child: TodoItemWidget(bloc: bloc,todo: item,),
                );
              },
            ),

            // itemCount: state.todos.length,
          );
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
