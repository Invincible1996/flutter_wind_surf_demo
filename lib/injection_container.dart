import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'core/network/network_info.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/datasources/auth_local_storage.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();
  
  // Features - Auth
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      login: sl(),
      storage: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => Login(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(),
  );

  // Data sources
  sl.registerLazySingleton(
    () => AuthLocalStorage(sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  // External
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => prefs);
}
