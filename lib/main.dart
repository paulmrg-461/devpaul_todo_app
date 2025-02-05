import 'package:devpaul_todo_app/config/routes/app_routes.dart';
import 'package:devpaul_todo_app/config/themes/custom_theme.dart';
import 'package:devpaul_todo_app/presentation/blocs/operator_bloc/operator_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:devpaul_todo_app/core/firebase/firebase_options.dart';
import 'package:devpaul_todo_app/core/service_locator.dart';
import 'package:devpaul_todo_app/presentation/blocs/user_bloc/auth_bloc.dart';
import 'core/service_locator.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
          create: (context) => sl<AuthBloc>()..add(AuthCheckUserEvent()),
        ),
        BlocProvider(create: (context) => sl<OperatorBloc>()),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter,
        title: 'DevPaul ToDo App',
        theme: CustomTheme.theme,
      ),
    );
  }
}
