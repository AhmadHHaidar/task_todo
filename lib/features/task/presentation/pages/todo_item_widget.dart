import 'package:flutter/material.dart';
import '../../../../common/utils.dart';
import '../../data/models/todo_model.dart';
import '../manager/task_bloc.dart';

class TodoItemWidget extends StatelessWidget {
  const TodoItemWidget({
    super.key,
    required this.bloc,
    required this.todo,
  });

  final TodoBloc bloc;
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
            alignment: AlignmentDirectional.center,
            child: (todo.completed)
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
            Text(todo.todo),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_horiz),
              onSelected: (value) {},
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: !(todo.completed) ? 'mark as Completed' : 'revert to pending',
                    child: Text(!(todo.completed) ? 'mark as Completed' : 'revert to pending'),
                    onTap: () {
                      bloc.add(UpdateTodoEvent(
                          todoModel: todo.copyWith(
                        completed: !(todo.completed),
                      )));
                    },
                  ),
                  PopupMenuItem<String>(
                    value: 'Delete',
                    child: const Text('Delete'),
                    onTap: () {
                      bloc.add(DeleteTodoEvent(todo));
                    },
                  ),
                ];
              },
            ),
          ],
        ),
      ],
    );
  }
}
