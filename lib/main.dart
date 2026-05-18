import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:workmanager/workmanager.dart';
import 'package:devpaul_todo_app/presentation/blocs/blocs.dart';
import 'package:devpaul_todo_app/config/routes/app_routes.dart';
import 'package:devpaul_todo_app/config/themes/custom_theme.dart';
import 'package:devpaul_todo_app/core/firebase/firebase_options.dart';
import 'package:devpaul_todo_app/core/service_locator.dart' as di;
import 'package:devpaul_todo_app/core/notifications/scheduled_notification_work.dart';
import 'package:devpaul_todo_app/core/notifications/notification_service.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      debugPrint('[BLoC] ${bloc.runtimeType} $change');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    if (kDebugMode) {
      debugPrint('[BLoC Error] ${bloc.runtimeType}: $error');
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();

  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint('[Firebase] Init failed: $e');
    runApp(_unsupportedPlatformApp(e));
    return;
  }

  await dotenv.load(fileName: '.env');
  await di.init();

  if (!kIsWeb) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);

    final notificationService = di.sl<NotificationService>();
    await notificationService.initialize();
    await scheduleDailyNotification();
    await setupPeriodicDueCheck();
  }

  runApp(const MyApp());
}

Widget _unsupportedPlatformApp(Object error) {
  final isDesktop = defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.macOS;

  final platformName = switch (defaultTargetPlatform) {
    TargetPlatform.linux => 'Linux',
    TargetPlatform.windows => 'Windows',
    TargetPlatform.macOS => 'macOS',
    _ => 'esta plataforma',
  };

  final message = isDesktop
      ? 'Firebase no tiene soporte nativo para $platformName.\n\n'
          'Usa la versión web en tu navegador:\n'
          'devpaultodo.web.app'
      : 'Error al inicializar Firebase:\n$error';

  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: CustomTheme.getThemeData(false),
    home: Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded,
                  size: 64, color: Colors.orange),
              const SizedBox(height: 24),
              const Text(
                'Plataforma no soportada',
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    ),
  );
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
