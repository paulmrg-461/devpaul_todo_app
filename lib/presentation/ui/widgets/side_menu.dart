import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:devpaul_todo_app/presentation/blocs/blocs.dart';

class SideMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;
  final VoidCallback onAboutTap;
  final bool isAdmin;

  const SideMenu({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.onAboutTap,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return NavigationDrawer(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: theme.colorScheme.primary,
                      child: Text(
                        state.user.name.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.user.name,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      state.user.email,
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                );
              }
              return Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: theme.colorScheme.primary,
                    child: const Icon(
                      Icons.person,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Usuario',
                    style: theme.textTheme.titleMedium,
                  ),
                  Text(
                    'correo@ejemplo.com',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              );
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: Divider(),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.task_alt),
          label: Text('Tareas'),
          selectedIcon: Icon(Icons.task_alt),
        ),
        if (isAdmin)
          const NavigationDrawerDestination(
            icon: Icon(Icons.people_outline_rounded),
            label: Text('Usuarios'),
            selectedIcon: Icon(Icons.people),
          ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.person_outline_rounded),
          label: Text('Perfil'),
          selectedIcon: Icon(Icons.person),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListTile(
            leading: const Icon(Icons.developer_mode_rounded),
            title: const Text('Acerca de'),
            onTap: onAboutTap,
          ),
        ),
        BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                leading: Icon(
                  state.isDarkMode
                      ? Icons.light_mode
                      : Icons.dark_mode_outlined,
                ),
                title: Text(state.isDarkMode ? 'Tema claro' : 'Tema oscuro'),
                onTap: () {
                  context
                      .read<ThemeBloc>()
                      .add(ThemeChanged(!state.isDarkMode));
                },
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: OutlinedButton.icon(
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutEvent());
            },
            icon: const Icon(Icons.logout),
            label: const Text('Cerrar Sesión'),
          ),
        ),
      ],
    );
  }
}
