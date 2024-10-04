import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:task_app/features/task/domain/use_cases/login_use_case.dart';
import 'package:task_app/features/task/presentation/manager/task_bloc.dart';
import 'package:task_app/features/task/presentation/pages/my_tasks_screen.dart';

import '../../../../common/custom_app_text_field.dart';
//TODO: SHOULD MOVE IT TO SEPARETER FEATURES

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormBuilderState> key = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FormBuilder(
        key: key,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(flex: 2),
              CustomTextField(
                /// THIS VALIDATE MAKE SURE THAT THIS FIELD IS NOT EMPTY
                validator: FormBuilderValidators.required(),
                name: 'userName',
                hint: 'enter user name',
                textInputAction: TextInputAction.next,
              ),
              // TODO:  SHOULD USE ANOTHER WAY FOR RESPONSIVE
              const SizedBox(height: 20),
              CustomTextField(
                /// THIS VALIDATE MAKE SURE THAT THIS FIELD IS NOT EMPTY
                validator: FormBuilderValidators.required(),
                name: 'password',
                hint: 'enter password',
              ),
              const Spacer(flex: 2),
              BlocSelector<TodoBloc, TodoState, GetDataStatus>(
                selector: (state) => state.loginStatus,
                builder: (context, isLoadingLogin) {
                  return ElevatedButton(
                      onPressed: () {
                        /// THIS CONDITION TO CHECK IF THE FIELD FILLED CORRECTLY
                        if (key.currentState!.validate()) {
                          context.read<TodoBloc>().add(LoginUserEvent(
                                loginParams: LoginParams(
                                  username: key.currentState?.fields['userName']?.value,
                                  password: key.currentState?.fields['password']?.value,
                                ),
                                onSuccess: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const MyTodoScreen(),
                                  ));
                                },
                              ));
                        }
                      },
                      child: isLoadingLogin == GetDataStatus.loading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(margin: EdgeInsetsDirectional.only(end: 20), width: 20, height: 20, child: CircularProgressIndicator()),
                                const Text('loading'),
                              ],
                            )
                          : const Text('login'));
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
