import 'package:devpaul_todo_app/config/themes/custom_theme.dart';
import 'package:devpaul_todo_app/config/themes/design_tokens.dart';
import 'package:devpaul_todo_app/domain/entities/task_metrics_entity.dart';
import 'package:devpaul_todo_app/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:devpaul_todo_app/presentation/blocs/metrics_bloc/metrics_bloc.dart';
import 'package:devpaul_todo_app/presentation/blocs/theme_bloc/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  void initState() {
    super.initState();
    context.read<MetricsBloc>().add(const LoadMetricsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          final user = state.user;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<MetricsBloc>().add(const LoadMetricsEvent());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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

                      // ── Task metrics summary ─────────────────────
                      _buildMetricsSummary(context),

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

  Widget _buildMetricsSummary(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<MetricsBloc, MetricsState>(
      builder: (context, metricsState) {
        if (metricsState is MetricsLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (metricsState is MetricsError) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: AppColors.error),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text('Could not load metrics',
                        style: textTheme.bodyMedium),
                  ),
                  TextButton(
                    onPressed: () => context
                        .read<MetricsBloc>()
                        .add(const LoadMetricsEvent()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (metricsState is MetricsLoaded) {
          return _buildMetricsCards(context, metricsState.metrics);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildMetricsCards(BuildContext context, TaskMetrics metrics) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.analytics_outlined,
                size: 20, color: AppColors.primary),
            const SizedBox(width: AppSpacing.sm),
            Text('Task Summary', style: textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        _statCard(
          context,
          'Total Tasks',
          '${metrics.totalTasks}',
          Icons.assignment_outlined,
          AppColors.primary,
        ),
        const SizedBox(height: AppSpacing.sm),

        _progressCard(
          context,
          'Completed',
          metrics.completedTasks,
          metrics.totalTasks,
          Icons.check_circle_outline,
          AppColors.statusCompleted,
          subtitle: '${(metrics.completionRate * 100).toStringAsFixed(0)}% completion rate',
        ),
        const SizedBox(height: AppSpacing.sm),

        _progressCard(
          context,
          'On Time',
          metrics.completedOnTime,
          metrics.completedTasks,
          Icons.schedule,
          AppColors.primary,
          subtitle: '${(metrics.onTimeRate * 100).toStringAsFixed(0)}% of completed tasks on time',
        ),
        const SizedBox(height: AppSpacing.sm),

        _statCard(
          context,
          'Overdue',
          '${metrics.overdueTasks}',
          Icons.warning_amber_rounded,
          AppColors.priorityHigh,
          subtitle: metrics.overdueTasks > 0
              ? '${metrics.overdueTasks} tasks past their deadline'
              : 'No overdue tasks',
        ),
        const SizedBox(height: AppSpacing.sm),

        _statCard(
          context,
          'Avg Duration',
          metrics.averageTaskDurationDays > 0
              ? '${metrics.averageTaskDurationDays.toStringAsFixed(1)} days'
              : '—',
          Icons.hourglass_bottom,
          AppColors.accent,
          subtitle: 'Average planned duration per task',
        ),
        const SizedBox(height: AppSpacing.sm),

        // ── Distribution by status ──────────────
        _buildDistributionRow(context, metrics),
      ],
    );
  }

  Widget _buildDistributionRow(BuildContext context, TaskMetrics metrics) {
    final total = metrics.totalTasks;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _distributionBar(
              context,
              'Pending',
              metrics.pendingTasks,
              total,
              AppColors.statusPending,
            ),
            const SizedBox(height: AppSpacing.sm),
            _distributionBar(
              context,
              'In Progress',
              metrics.inProgressTasks,
              total,
              AppColors.statusInProgress,
            ),
            const SizedBox(height: AppSpacing.sm),
            _distributionBar(
              context,
              'Completed',
              metrics.completedTasks,
              total,
              AppColors.statusCompleted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _distributionBar(
    BuildContext context,
    String label,
    int count,
    int total,
    Color color,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final pct = total > 0 ? count / total : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: textTheme.bodySmall),
            Text(
              '$count (${(pct * 100).toStringAsFixed(0)}%)',
              style: textTheme.labelSmall,
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: pct,
            backgroundColor: Theme.of(context).colorScheme.outlineVariant,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _statCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color, {
    String? subtitle,
  }) {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.bodyLarge),
                  if (subtitle != null)
                    Text(subtitle,
                        style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
            Text(value,
                style: textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                )),
          ],
        ),
      ),
    );
  }

  Widget _progressCard(
    BuildContext context,
    String title,
    int value,
    int total,
    IconData icon,
    Color color, {
    String? subtitle,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final pct = total > 0 ? value / total : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color.withAlpha(25),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(title, style: textTheme.bodyLarge),
                ),
                Text('$value / $total',
                    style: textTheme.titleMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    )),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: pct,
                backgroundColor: colorScheme.outlineVariant,
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 8,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(subtitle,
                  style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant)),
            ],
          ],
        ),
      ),
    );
  }
}
