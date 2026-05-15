import 'package:devpaul_todo_app/config/themes/custom_theme.dart';
import 'package:devpaul_todo_app/config/themes/design_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:devpaul_todo_app/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:devpaul_todo_app/presentation/blocs/theme_bloc/theme_bloc.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          final user = state.user;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xxl,
              vertical: AppSpacing.xxxl,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxWidth: AppMaxWidth.card),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.massive),

                    // Avatar
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.primary,
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withAlpha(70),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          user.name.isNotEmpty
                              ? user.name[0].toUpperCase()
                              : '?',
                          style: textTheme.headlineLarge?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    Text(user.name,
                        style: textTheme.headlineSmall,
                        textAlign: TextAlign.center),
                    const SizedBox(height: AppSpacing.xs),
                    Text(user.email,
                        style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant),
                        textAlign: TextAlign.center),

                    const SizedBox(height: AppSpacing.xxxl),

                    // Stats cards
                    _buildStatCard(context, 'Tasks', '--',
                        Icons.task_alt_outlined, colorScheme.primary),
                    const SizedBox(height: AppSpacing.md),
                    _buildStatCard(context, 'Completed', '--',
                        Icons.check_circle_outline, AppColors.statusCompleted),
                    const SizedBox(height: AppSpacing.md),
                    _buildStatCard(context, 'Projects', '--',
                        Icons.folder_outlined, AppColors.typeWork),

                    const SizedBox(height: AppSpacing.xxxl),

                    // Theme toggle
                    BlocBuilder<ThemeBloc, ThemeState>(
                      builder: (context, themeState) {
                        return Card(
                          child: SwitchListTile(
                            secondary: Icon(
                              themeState.isDarkMode
                                  ? Icons.dark_mode_rounded
                                  : Icons.light_mode_rounded,
                              color: AppColors.accent,
                            ),
                            title: Text(
                              themeState.isDarkMode
                                  ? 'Dark mode'
                                  : 'Light mode',
                              style: textTheme.bodyLarge,
                            ),
                            value: themeState.isDarkMode,
                            onChanged: (val) {
                              context
                                  .read<ThemeBloc>()
                                  .add(ThemeChanged(val));
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Logout
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          context
                              .read<AuthBloc>()
                              .add(AuthLogoutEvent());
                        },
                        icon: const Icon(Icons.logout_rounded, size: 18),
                        label: const Text('Sign out'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.massive),
                  ],
                ),
              ),
            ),
          );
        }

        if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return const Center(child: Text('Not authenticated'));
      },
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value,
      IconData icon, Color color) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Text(title, style: textTheme.bodyLarge),
            ),
            Text(value,
                style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
