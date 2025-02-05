import 'package:devpaul_todo_app/data/datasources/firebase_storage_data_source.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:devpaul_todo_app/data/datasources/user_data_source.dart';
import 'package:devpaul_todo_app/data/repositories/user_repository_impl.dart';
import 'package:devpaul_todo_app/domain/repositories/user_repository.dart';
import 'package:devpaul_todo_app/domain/usecases/users/user_use_cases.dart';
import 'package:devpaul_todo_app/presentation/blocs/operator_bloc/operator_bloc.dart';
import 'package:devpaul_todo_app/data/datasources/auth_storage.dart';
import 'package:devpaul_todo_app/data/datasources/firebase_auth_data_source.dart';
import 'package:devpaul_todo_app/data/repositories/auth_repository_impl.dart';
import 'package:devpaul_todo_app/domain/repositories/auth_repository.dart';
import 'package:devpaul_todo_app/domain/usecases/authentication/authentication_use_cases.dart';
import 'package:devpaul_todo_app/presentation/blocs/user_bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Firebase
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // Registros de Data sources
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<FirebaseStorageDataSource>(
    () => FirebaseStorageDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<OperatorDataSource>(
    () => OperatorDataSourceImpl(sl<FirebaseFirestore>()),
  );

  // Repositorios
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      dataSource: sl<OperatorDataSource>(),
      storageDataSource: sl<FirebaseStorageDataSource>(),
    ),
  );

  // Casos de Uso
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => Register(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(
    () => CreateUser(
      repository: sl<UserRepository>(),
      authRepository: sl<AuthRepository>(),
    ),
  );
  sl.registerLazySingleton(() => GetUsers(sl<UserRepository>()));
  sl.registerLazySingleton(() => UpdateUser(sl<UserRepository>()));
  sl.registerLazySingleton(() => DeleteUser(sl<UserRepository>()));
  sl.registerLazySingleton(() => UploadFile(sl()));

  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      registerUseCase: sl(),
      getCurrentUserUseCase: sl(),
      authStorage: sl(),
    ),
  );

  sl.registerFactory(
    () => OperatorBloc(
      createOperatorUseCase: sl<CreateUser>(),
      getOperatorsUseCase: sl<GetUsers>(),
      updateOperatorUseCase: sl<UpdateUser>(),
      deleteOperatorUseCase: sl<DeleteUser>(),
      uploadFileUseCase: sl<UploadFile>(),
    ),
  );

  // Data storage
  sl.registerLazySingleton<AuthStorage>(() => AuthStorage());
}
