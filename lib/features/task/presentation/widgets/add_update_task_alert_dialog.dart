import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:task_app/core/prefs_repo.dart';
import 'package:task_app/core/service_locater.dart';

import '../../../../common/custom_app_text_field.dart';
import '../../data/models/todo_model.dart';
import '../manager/task_bloc.dart';

class AddUpdateTodoAlertDialog extends StatefulWidget {
  const AddUpdateTodoAlertDialog({
    super.key,
    required this.bloc,
    this.todoModel,
  });

  final TodoBloc bloc;
  final Todo? todoModel;

  @override
  State<AddUpdateTodoAlertDialog> createState() => _AddUpdateTodoAlertDialogState();
}

class _AddUpdateTodoAlertDialogState extends State<AddUpdateTodoAlertDialog> {
  /// THIS KEY TO WRAP THE FORM WITH IT AND GET DATA USING IT
  final GlobalKey<FormBuilderState> key = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('add New todo item'),
      content: FormBuilder(
        key: key,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              initialValue: widget.todoModel?.todo,

              /// THIS VALIDATE MAKE SURE THAT THIS FIELD IS NOT EMPTY
              validator: FormBuilderValidators.required(),
              name: 'title',
              hint: 'enter the title of todo',
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        ElevatedButton(
            onPressed: () {
              /// THIS CONDITION TO CHECK IF THE FIELD FILLED CORRECTLY
              if (key.currentState!.validate()) {
                /// THIS CONDITION TO CHECK IF WE NOW UPDATE MODEL OR ADD NEW ONE
                if (widget.todoModel == null) {
                  widget.bloc.add(AddTodoEvent(
                    todoModel: Todo(
                      id: 0,
                      userId: getIt<PrefsRepository>().user!.id!,
                      todo: key.currentState?.fields['title']?.value,
                      completed: false,
                    ),
                    onSuccess: () => Navigator.of(context).pop(),
                  ));
                }
                /*else {
                  widget.bloc.add(UpdateTodoEvent(
                    todoModel: widget.todoModel!.copyWith(
                      todo: key.currentState?.fields['title']?.value,
                      // completed: !(widget.todoModel?.completed ?? false),
                    ),
                    onSuccess: () => Navigator.of(context).pop(),
                  ));
                }*/
              }
            },
            child: Text(widget.todoModel != null ? 'Update' : 'Add')),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('cancel')),
      ],
    );
  }
}
