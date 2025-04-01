import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:devpaul_todo_app/domain/repositories/domain_repositories.dart';
import 'package:devpaul_todo_app/domain/usecases/use_cases.dart';
import 'package:devpaul_todo_app/data/datasources/data_datasources.dart';
import 'package:devpaul_todo_app/data/repositories/data_repositories.dart';
import 'package:devpaul_todo_app/presentation/blocs/blocs.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
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
  sl.registerLazySingleton<UserDataSource>(
    () => UserDataSourceImpl(sl<FirebaseFirestore>()),
  );
  sl.registerLazySingleton<TaskDataSource>(
    () => TaskDataSourceImpl(sl<FirebaseFirestore>(), sl<FirebaseAuth>()),
  );

  // Repositorios
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      dataSource: sl<UserDataSource>(),
      storageDataSource: sl<FirebaseStorageDataSource>(),
    ),
  );
  sl.registerLazySingleton<ThemeRepository>(() => ThemeRepositoryImpl(sl()));
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(sl<TaskDataSource>()),
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
  // Theme Use Cases
  sl.registerLazySingleton(() => GetThemeModeUseCase(sl()));
  sl.registerLazySingleton(() => SaveThemeModeUseCase(sl()));

  // Tasks Use Cases
  sl.registerLazySingleton(() => GetTasks(sl<TaskRepository>()));
  sl.registerLazySingleton(() => UpdateTask(sl<TaskRepository>()));
  sl.registerLazySingleton(() => DeleteTask(sl<TaskRepository>()));
  sl.registerLazySingleton(() => CreateTask(sl<TaskRepository>()));

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
    () => UserBloc(
      createUserUseCase: sl<CreateUser>(),
      getUsersUseCase: sl<GetUsers>(),
      updateUserUseCase: sl<UpdateUser>(),
      deleteUserUseCase: sl<DeleteUser>(),
      uploadFileUseCase: sl<UploadFile>(),
    ),
  );

  // Theme Bloc
  sl.registerFactory(
    () => ThemeBloc(
      getThemeModeUseCase: sl(),
      saveThemeModeUseCase: sl(),
    ),
  );

  // Task Bloc
  sl.registerFactory(
    () => TaskBloc(
      createTaskUseCase: sl<CreateTask>(),
      getTasksUseCase: sl<GetTasks>(),
      updateTaskUseCase: sl<UpdateTask>(),
      deleteTaskUseCase: sl<DeleteTask>(),
    ),
  );

  // Data storage
  sl.registerLazySingleton<AuthStorage>(() => AuthStorage());

  // New additions
  sl.registerFactory(
    () => AiSuggestionBloc(
      getTaskSuggestionUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetTaskSuggestion(sl()));

  sl.registerLazySingleton<AiSuggestionRepository>(
    () => AiSuggestionRepositoryImpl(),
  );
}
