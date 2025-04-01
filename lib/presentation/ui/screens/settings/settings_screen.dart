import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:devpaul_todo_app/presentation/blocs/blocs.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Perfil',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthAuthenticated) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: theme.colorScheme.primary,
                            child: Text(
                              state.user.name.substring(0, 1).toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(state.user.name),
                          subtitle: Text(state.user.email),
                        );
                      }
                      return const ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text('Usuario'),
                        subtitle: Text('correo@ejemplo.com'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Apariencia',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<ThemeBloc, ThemeState>(
                    builder: (context, state) {
                      return SwitchListTile(
                        title: const Text('Modo Oscuro'),
                        value: state.isDarkMode,
                        onChanged: (value) {
                          context.read<ThemeBloc>().add(ThemeChanged(value));
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cuenta',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Cerrar Sesión'),
                    onTap: () {
                      context.read<AuthBloc>().add(AuthLogoutEvent());
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
