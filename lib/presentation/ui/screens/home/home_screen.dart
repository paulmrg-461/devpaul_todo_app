import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:devpaul_todo_app/config/global/environment.dart';
import 'package:devpaul_todo_app/data/models/user_model.dart';
import 'package:devpaul_todo_app/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:devpaul_todo_app/presentation/blocs/theme_bloc/theme_bloc.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/widgets/bottom_bar_item.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/screens.dart';

class HomeScreen extends StatefulWidget {
  static const String name = 'home_screen';

  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go('/login');
        }
      },
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          final isAdmin = Environment.adminEmails.contains(state.user.email);
          final bottomBarItems =
              isAdmin ? getBottombarListAdmin() : getBottombarList();

          return Scaffold(
            appBar: AppBar(
              title: const Text('DevPaul To Do'),
            ),
            drawer: Drawer(
              child: _buildDrawerContent(
                context,
                state.user,
                isAdmin,
              ),
            ),
            body: bottomBarItems[currentPageIndex].widget,
            bottomNavigationBar: NavigationBar(
              onDestinationSelected: (int index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
              selectedIndex: currentPageIndex,
              destinations: bottomBarItems
                  .map(
                    (e) => NavigationDestination(
                      icon: Icon(e.icon),
                      label: e.label,
                    ),
                  )
                  .toList(),
            ),
          );
        } else if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return const Scaffold(body: Center(child: Text('Algo salió mal')));
        }
      },
    );
  }

  Widget _buildDrawerContent(
    BuildContext context,
    UserModel user,
    bool isAdmin,
  ) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Drawer Header
        DrawerHeader(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 8, bottom: 6),
                    width: 46,
                    child: Image.asset(
                      'assets/logo.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Text(
                    'DevPaul ToDo',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.white),
                  ),
                ],
              ),
              Text(
                user.email,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
        // Drawer Items
        ..._buildDrawerItems(context, isAdmin),
        const Divider(),
        BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return ListTile(
              leading: Icon(
                state.isDarkMode ? Icons.light_mode : Icons.dark_mode_outlined,
              ),
              title: Text(state.isDarkMode ? 'Tema claro' : 'Tema oscuro'),
              onTap: () {
                context.read<ThemeBloc>().add(ThemeChanged(!state.isDarkMode));
              },
              tileColor: Theme.of(context).colorScheme.surface,
              iconColor: Theme.of(context).colorScheme.onSurface,
              textColor: Theme.of(context).colorScheme.onSurface,
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.developer_mode_rounded),
          title: const Text('Acerca de'),
          onTap: () => context.pushNamed(DeveloperInformationScreen.name),
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Cerrar sesión'),
          onTap: () {
            Navigator.pop(context);
            context.read<AuthBloc>().add(AuthLogoutEvent());
          },
        ),
      ],
    );
  }

  List<Widget> _buildDrawerItems(BuildContext context, bool isAdmin) {
    final bottomBarItems =
        isAdmin ? getBottombarListAdmin() : getBottombarList();

    return List.generate(bottomBarItems.length, (index) {
      final item = bottomBarItems[index];
      return ListTile(
        leading: Icon(item.icon),
        title: Text(item.label),
        selected: currentPageIndex == index,
        onTap: () {
          setState(() {
            currentPageIndex = index;
          });
          Navigator.pop(context);
        },
      );
    });
  }
}
