import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:task_app/core/prefs_repo.dart';
import 'package:task_app/core/service_locater.dart';
import 'package:task_app/features/task/domain/use_cases/login_use_case.dart';
import 'package:task_app/features/task/presentation/manager/task_bloc.dart';
import 'package:task_app/features/task/presentation/pages/login_screen.dart';
import 'package:task_app/features/task/presentation/pages/my_tasks_screen.dart';

import '../../../../common/custom_app_text_field.dart';
//TODO: SHOULD MOVE IT TO SEPARETER FEATURES

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkWhereToGo();
    super.initState();
  }

  void checkWhereToGo() {
    Future.delayed(
      Duration(seconds: 1),
      () {
        if (getIt<PrefsRepository>().user != null) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MyTodoScreen()));
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Spacer(),
              Text("Welcome , we are happy to see you again"),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
