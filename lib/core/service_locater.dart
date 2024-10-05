import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/core/prefs_repo.dart';
import 'package:task_app/features/task/domain/use_cases/refresh_token_use_case.dart';
import 'package:task_app/features/task/presentation/manager/task_bloc.dart';
import '../common/end_point_url.dart';
import '../common/utils.dart';
import 'dio_client.dart';
import 'service_locater.config.dart';

JsonEncoder encoder = const JsonEncoder.withIndent('  ');
final Logger logger = Logger();
final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> configureDependencies() async {
  await getIt.init();
}

@module
abstract class AppModule {
  @singleton
  DioClient get dioClient => DioClient(baseUrl: EndPoints.baseUrl, interceptors: [
        InterceptorsWrapper(
          onRequest: (options, handler) {
            options.headers[HttpHeaders.authorizationHeader] = 'Bearer ${GetIt.I<PrefsRepository>().user?.accessToken}';
            if (kDebugMode) {
              logger.i("***|| INFO Request ${options.method} ${options.path} ||***"
                  "\n param : ${options.queryParameters}"
                  "\n data : ${options.data}"
                  "\n Header: ${encoder.convert(options.headers)}"
                  "\n token: ${encoder.convert(options.headers[HttpHeaders.authorizationHeader])}"
                  "\n timeout: ${options.connectTimeout ?? 0 ~/ 1000}s"
                  // "\n curl command: ${HelperFunctions.getCurlCommandFromRequest(options)}s",
                  );
            }
            return handler.next(options);
          },
          onError: (error, handler) {
            BotToast.showText(
                text: error.response?.data['message'] ?? error.message, contentColor: AppColors.red, textStyle: TextStyle(color: AppColors.white));
            if (error.response?.statusCode == 401) {
              getIt<TodoBloc>().add(RefreshTokenUserEvent(
                refreshTokenParams: RefreshTokenParams(
                  refreshToken: getIt<PrefsRepository>().user!.refreshToken!,
                ),
                onSuccess: () {},
              ));
              // GetIt.I<LoginLocalDataSource>().deleteListOfLoggedIn();
              // router.go(SplashScreen.path);
            }

            return handler.next(error);
          },
          // onResponse: (response, handler) => handler.next(response),
        ),
      ]);

  @preResolve
  @singleton
  Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();
}
