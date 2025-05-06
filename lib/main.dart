import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:devpaul_todo_app/presentation/blocs/blocs.dart';
import 'package:devpaul_todo_app/config/routes/app_routes.dart';
import 'package:devpaul_todo_app/config/themes/custom_theme.dart';
import 'package:devpaul_todo_app/core/firebase/firebase_options.dart';
import 'package:devpaul_todo_app/core/service_locator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/service_locator.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: '.env');
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
          create: (context) => sl<AuthBloc>()..add(AuthCheckUserEvent()),
        ),
        BlocProvider(create: (context) => sl<UserBloc>()),
        BlocProvider(create: (context) => sl<ThemeBloc>()),
        BlocProvider(create: (context) => sl<TaskBloc>()),
        BlocProvider(create: (context) => sl<AiSuggestionBloc>()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            routerConfig: appRouter,
            title: 'DevPaul Todo Apps',
            theme: CustomTheme.getThemeData(state.isDarkMode),
          );
        },
      ),
    );
  }
}
