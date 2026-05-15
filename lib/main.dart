import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:devpaul_todo_app/presentation/blocs/blocs.dart';
import 'package:devpaul_todo_app/config/routes/app_routes.dart';
import 'package:devpaul_todo_app/config/themes/custom_theme.dart';
import 'package:devpaul_todo_app/core/firebase/firebase_options.dart';
import 'package:devpaul_todo_app/core/service_locator.dart' as di;

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('[BLoC] ${bloc.runtimeType} $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    debugPrint('[BLoC Error] ${bloc.runtimeType}: $error');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();

  if (!kIsWeb) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<AuthBloc>()..add(AuthCheckUserEvent()),
        ),
        BlocProvider(create: (context) => di.sl<UserBloc>()),
        BlocProvider(create: (context) => di.sl<ThemeBloc>()),
        BlocProvider(create: (context) => di.sl<TaskBloc>()),
        BlocProvider(create: (context) => di.sl<AiSuggestionBloc>()),
        BlocProvider(create: (context) => di.sl<ProjectBloc>()),
        BlocProvider(create: (context) => di.sl<GroupBloc>()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            routerConfig: appRouter,
            title: 'DevPaul Todo App',
            theme: CustomTheme.getThemeData(state.isDarkMode),
          );
        },
      ),
    );
  }
}
