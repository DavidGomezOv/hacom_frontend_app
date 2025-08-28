import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hacom_frontend_app/core/network/api_client.dart';
import 'package:hacom_frontend_app/features/auth/data/auth_repository_impl.dart';
import 'package:hacom_frontend_app/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:hacom_frontend_app/features/auth/data/datasources/local/auth_local_datasource_impl.dart';
import 'package:hacom_frontend_app/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:hacom_frontend_app/features/auth/data/datasources/remote/auth_remote_datasource_impl.dart';
import 'package:hacom_frontend_app/features/auth/domain/auth_repository.dart';
import 'package:hacom_frontend_app/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:hacom_frontend_app/features/places/data/datasources/remote/places_remote_datasource.dart';
import 'package:hacom_frontend_app/features/places/data/datasources/remote/places_remote_datasource_impl.dart';
import 'package:hacom_frontend_app/features/places/data/places_repository_impl.dart';
import 'package:hacom_frontend_app/features/places/domain/places_repository.dart';
import 'package:hacom_frontend_app/features/places/presentation/bloc/places_cubit.dart';
import 'package:hacom_frontend_app/features/supervisor/data/datasources/remote/supervisor_remote_datasource.dart';
import 'package:hacom_frontend_app/features/supervisor/data/datasources/remote/supervisor_remote_datasource_impl.dart';
import 'package:hacom_frontend_app/features/supervisor/data/supervisor_repository_impl.dart';
import 'package:hacom_frontend_app/features/supervisor/domain/supervisor_repository.dart';
import 'package:hacom_frontend_app/features/supervisor/presentation/bloc/supervisor_cubit.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(baseUrl: dotenv.env['BASE_URL']!),
  );

  // REMOTE DATA SOURCES
  getIt.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(apiClient: getIt()),
  );
  getIt.registerLazySingleton<SupervisorRemoteDatasource>(
    () => SupervisorRemoteDatasourceImpl(apiClient: getIt()),
  );
  getIt.registerLazySingleton<PlacesRemoteDatasource>(
    () => PlacesRemoteDatasourceImpl(apiClient: getIt()),
  );

  // LOCAL DATA SOURCES
  getIt.registerLazySingleton<AuthLocalDatasource>(
    () => AuthLocalDatasourceImpl(),
  );

  // REPOSITORIES
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDatasource: getIt(),
      authLocalDatasource: getIt(),
    ),
  );
  getIt.registerLazySingleton<SupervisorRepository>(
    () => SupervisorRepositoryImpl(remoteDatasource: getIt()),
  );
  getIt.registerLazySingleton<PlacesRepository>(
    () => PlacesRepositoryImpl(remoteDatasource: getIt()),
  );

  // CUBITS
  getIt.registerFactory<AuthCubit>(() => AuthCubit(authRepository: getIt()));
  getIt.registerFactory<SupervisorCubit>(
    () => SupervisorCubit(repository: getIt()),
  );
  getIt.registerFactory<PlacesCubit>(() => PlacesCubit(repository: getIt()));
}
