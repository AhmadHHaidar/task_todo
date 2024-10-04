// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../features/task/data/data_sources/locale_data_source.dart' as _i121;
import '../features/task/data/data_sources/task_remote_datasource.dart'
    as _i648;
import '../features/task/data/repositories/task_repository_imp.dart' as _i345;
import '../features/task/domain/repositories/task_repository.dart' as _i843;
import '../features/task/domain/use_cases/add_task_use_case.dart' as _i754;
import '../features/task/domain/use_cases/delete_task_use_case.dart' as _i709;
import '../features/task/domain/use_cases/get_all_task_use_case.dart' as _i264;
import '../features/task/domain/use_cases/login_use_case.dart' as _i579;
import '../features/task/domain/use_cases/refresh_token_use_case.dart' as _i83;
import '../features/task/domain/use_cases/update_task_use_case.dart' as _i708;
import '../features/task/presentation/manager/task_bloc.dart' as _i89;
import 'dio_client.dart' as _i82;
import 'prefs_repo.dart' as _i528;
import 'service_locater.dart' as _i647;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    gh.singleton<_i82.DioClient>(() => appModule.dioClient);
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i121.DatabaseHelper>(() => _i121.DatabaseHelper());
    gh.factory<_i648.TaskRemoteDataSource>(
        () => _i648.TaskRemoteDataSource(gh<_i82.DioClient>()));
    gh.factory<_i843.TaskRepository>(
        () => _i345.TaskRepositoryImp(gh<_i648.TaskRemoteDataSource>()));
    gh.lazySingleton<_i528.PrefsRepository>(
        () => _i528.PrefsRepositoryImpl(gh<_i460.SharedPreferences>()));
    gh.factory<_i754.AddTaskUseCase>(
        () => _i754.AddTaskUseCase(repository: gh<_i843.TaskRepository>()));
    gh.factory<_i709.DeleteTaskUseCase>(
        () => _i709.DeleteTaskUseCase(repository: gh<_i843.TaskRepository>()));
    gh.factory<_i264.GetAllTaskUseCase>(
        () => _i264.GetAllTaskUseCase(repository: gh<_i843.TaskRepository>()));
    gh.factory<_i579.LoginUseCase>(
        () => _i579.LoginUseCase(repository: gh<_i843.TaskRepository>()));
    gh.factory<_i708.UpdateTaskUseCase>(
        () => _i708.UpdateTaskUseCase(repository: gh<_i843.TaskRepository>()));
    gh.factory<_i83.RefreshTokenUseCase>(
        () => _i83.RefreshTokenUseCase(repository: gh<_i843.TaskRepository>()));
    gh.lazySingleton<_i89.TodoBloc>(() => _i89.TodoBloc(
          gh<_i264.GetAllTaskUseCase>(),
          gh<_i754.AddTaskUseCase>(),
          gh<_i708.UpdateTaskUseCase>(),
          gh<_i709.DeleteTaskUseCase>(),
          gh<_i579.LoginUseCase>(),
          gh<_i83.RefreshTokenUseCase>(),
        ));
    return this;
  }
}

class _$AppModule extends _i647.AppModule {}
