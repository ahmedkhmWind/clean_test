
import 'package:clean_flutter_poc/features/auth/login/data/remote_data_sources/login_remote_data_source.dart';
import 'package:clean_flutter_poc/features/auth/login/data/repositories/login_repository_impl.dart';
import 'package:clean_flutter_poc/features/auth/login/domain/repositories/login_repository.dart';
import 'package:clean_flutter_poc/features/auth/login/domain/usecases/login_user.dart';
import 'package:clean_flutter_poc/features/auth/login/presenters/bloc/auth_bloc.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

import 'api/api_config.dart';

final locator = GetIt.instance;

void init() {
  // bloc
  locator.registerFactory(() => AuthBloc(locator()));

  // usecase
  locator.registerLazySingleton(() => LoginUser(locator()));

  // repository
  locator.registerLazySingleton<LoginRepository>(
        () => LoginRepositoryImpl(
      locator(),
    ),
  );
  locator.registerLazySingleton<Dio>(() => ApiConfig.createDio());


  // data source
  locator.registerLazySingleton<LoginRemoteDataSource>(
        () => LoginRemoteDataSourceImpl(
          dio: locator(),
    ),
  );

  // external
  locator.registerLazySingleton(() => http.Client());
}