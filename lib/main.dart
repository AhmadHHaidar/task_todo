import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/features/task/presentation/manager/task_bloc.dart';
import 'package:task_app/features/task/presentation/pages/splash_screen.dart';

import 'common/utils.dart';
import 'core/service_locater.dart';
import 'features/task/data/data_sources/locale_data_source.dart';

const keyBoxHive = "HiveKey.Todos";
const tokenKey = r'__$__token__$__';
const userIdKey = r'__$__userId__$__';
const userModelKey = r'__$__userId__$__';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await getIt<DatabaseHelper>().database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TodoBloc>(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: Utils.theme,
        builder: BotToastInit(),
        home: const SplashScreen(),
      ),
    );
  }
}


