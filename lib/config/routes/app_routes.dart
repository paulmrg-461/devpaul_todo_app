import 'package:devpaul_todo_app/presentation/ui/screens/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final loggingIn = state.uri.toString() == '/login';

    if (user == null && !loggingIn) {
      return '/login';
    }
    if (user != null && loggingIn) {
      return '/';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      name: LoginScreen.name,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/user-register',
      name: UserRegisterScreen.name,
      builder: (context, state) => const UserRegisterScreen(),
    ),
    GoRoute(
      path: '/developer-information',
      name: DeveloperInformationScreen.name,
      builder: (context, state) => const DeveloperInformationScreen(),
    ),
  ],
);
