import 'package:devpaul_todo_app/config/themes/custom_theme.dart';
import 'package:devpaul_todo_app/config/themes/design_tokens.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/domain/entities/task_metrics_entity.dart';
import 'package:devpaul_todo_app/presentation/blocs/metrics_bloc/metrics_bloc.dart';
import 'package:devpaul_todo_app/presentation/ui/widgets/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MetricsTab extends StatefulWidget {
  const MetricsTab({super.key});

  @override
  State<MetricsTab> createState() => _MetricsTabState();
}

class _MetricsTabState extends State<MetricsTab> {
  @override
  void initState() {
    super.initState();
    context.read<MetricsBloc>().add(const LoadMetricsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MetricsBloc, MetricsState>(
      builder: (context, state) {
        if (state is MetricsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MetricsError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48),
                const SizedBox(height: AppSpacing.md),
                Text('Error: ${state.message}'),
                const SizedBox(height: AppSpacing.lg),
                FilledButton(
                  onPressed: () => context
                      .read<MetricsBloc>()
                      .add(const LoadMetricsEvent()),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is MetricsLoaded) {
          return _buildDashboard(context, state.metrics);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildDashboard(BuildContext context, TaskMetrics metrics) {
    final isWide = MediaQuery.of(context).size.width >= 900;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<MetricsBloc>().add(const LoadMetricsEvent());
      },
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _buildHeader(context),
          const SizedBox(height: AppSpacing.xl),
          _buildKpiGrid(context, metrics, isWide),
          const SizedBox(height: AppSpacing.xl),
          _buildDeadlineSection(context, metrics, isWide),
          const SizedBox(height: AppSpacing.xl),
          _buildDistributionSection(context, metrics, isWide),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(25),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: const Icon(Icons.analytics_outlined,
              size: 22, color: AppColors.primary),
        ),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Performance Metrics', style: textTheme.titleLarge),
            Text('Task completion & deadline analysis',
                style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant)),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () =>
              context.read<MetricsBloc>().add(const LoadMetricsEvent()),
          icon: const Icon(Icons.refresh_rounded),
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  Widget _buildKpiGrid(
      BuildContext context, TaskMetrics metrics, bool isWide) {
    final kpis = [
      _KpiData(
        label: 'Total Tasks',
        value: '${metrics.totalTasks}',
        icon: Icons.assignment_outlined,
        color: AppColors.primary,
      ),
      _KpiData(
        label: 'Completed',
        value: '${metrics.completedTasks}',
        icon: Icons.check_circle_outline,
        color: AppColors.statusCompleted,
      ),
      _KpiData(
        label: 'Completion Rate',
        value: '${(metrics.completionRate * 100).toStringAsFixed(0)}%',
        icon: Icons.trending_up,
        color: AppColors.statusCompleted,
      ),
      _KpiData(
        label: 'On-Time Rate',
        value: '${(metrics.onTimeRate * 100).toStringAsFixed(0)}%',
        icon: Icons.schedule,
        color: AppColors.primary,
      ),
      _KpiData(
        label: 'Overdue',
        value: '${metrics.overdueTasks}',
        icon: Icons.warning_amber_rounded,
        color: AppColors.priorityHigh,
      ),
      _KpiData(
        label: 'In Progress',
        value: '${metrics.inProgressTasks}',
        icon: Icons.play_circle_outline,
        color: AppColors.statusInProgress,
      ),
      _KpiData(
        label: 'Pending',
        value: '${metrics.pendingTasks}',
        icon: Icons.radio_button_unchecked,
        color: AppColors.statusPending,
      ),
      _KpiData(
        label: 'Avg Duration',
        value: metrics.averageTaskDurationDays > 0
            ? '${metrics.averageTaskDurationDays.toStringAsFixed(1)}d'
            : '—',
        icon: Icons.hourglass_bottom,
        color: AppColors.accent,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWide ? 4 : 2,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.6,
      ),
      itemCount: kpis.length,
      itemBuilder: (context, index) {
        return AnimatedFadeSlide(
          index: index,
          delay: Duration(milliseconds: 50 * index),
          child: _KpiCard(data: kpis[index]),
        );
      },
    );
  }

  Widget _buildDeadlineSection(
      BuildContext context, TaskMetrics metrics, bool isWide) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Deadline Performance', style: textTheme.titleMedium),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildStatusCard(
                context,
                title: 'Completed On Time',
                value: '${metrics.completedOnTime}',
                subtitle:
                    '${(metrics.onTimeRate * 100).toStringAsFixed(0)}% of completed',
                color: AppColors.statusCompleted,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildStatusCard(
                context,
                title: 'Completed Late',
                value: '${metrics.completedLate}',
                subtitle: '${((1 - metrics.onTimeRate) * 100).toStringAsFixed(0)}% of completed',
                color: AppColors.statusPending,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildStatusCard(
                context,
                title: 'Overdue',
                value: '${metrics.overdueTasks}',
                subtitle: 'Not completed, past deadline',
                color: AppColors.priorityHigh,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDistributionSection(
      BuildContext context, TaskMetrics metrics, bool isWide) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Distribution', style: textTheme.titleMedium),
        const SizedBox(height: AppSpacing.md),
        if (isWide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildProgressBars(context, 'By Priority', metrics.tasksByPriority,
                  priorityColorMap, metrics.totalTasks)),
              const SizedBox(width: AppSpacing.lg),
              Expanded(child: _buildProgressBars(context, 'By Type', metrics.tasksByType,
                  typeColorMap, metrics.totalTasks)),
              const SizedBox(width: AppSpacing.lg),
              Expanded(child: _buildProgressBars(context, 'By Status', metrics.tasksByStatus,
                  statusColorMap, metrics.totalTasks)),
            ],
          )
        else
          Column(
            children: [
              _buildProgressBars(context, 'By Priority', metrics.tasksByPriority,
                  priorityColorMap, metrics.totalTasks),
              const SizedBox(height: AppSpacing.lg),
              _buildProgressBars(context, 'By Type', metrics.tasksByType,
                  typeColorMap, metrics.totalTasks),
              const SizedBox(height: AppSpacing.lg),
              _buildProgressBars(context, 'By Status', metrics.tasksByStatus,
                  statusColorMap, metrics.totalTasks),
            ],
          ),
      ],
    );
  }

  Widget _buildProgressBars<T>(
    BuildContext context,
    String title,
    Map<T, int> distribution,
    Map<T, Color> colorMap,
    int total,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: textTheme.titleSmall),
          const SizedBox(height: AppSpacing.md),
          ...distribution.entries.map((entry) {
            final pct = total > 0 ? entry.value / total : 0.0;
            final color = colorMap[entry.key] ?? colorScheme.primary;
            final label = entry.key.toString().split('.').last;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_capitalize(label),
                          style: textTheme.bodySmall),
                      Text('${entry.value} (${(pct * 100).toStringAsFixed(0)}%)',
                          style: textTheme.labelSmall),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: pct,
                      backgroundColor: colorScheme.outlineVariant,
                      valueColor: AlwaysStoppedAnimation(color),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              )),
          const SizedBox(height: AppSpacing.xs),
          Text(title,
              style: textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurface,
              )),
          const SizedBox(height: AppSpacing.xs),
          Text(subtitle,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              )),
        ],
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static const Map<TaskPriority, Color> priorityColorMap = {
    TaskPriority.low: AppColors.priorityLow,
    TaskPriority.medium: AppColors.priorityMedium,
    TaskPriority.high: AppColors.priorityHigh,
  };

  static const Map<TaskType, Color> typeColorMap = {
    TaskType.work: AppColors.typeWork,
    TaskType.personal: AppColors.typePersonal,
    TaskType.academic: AppColors.typeAcademic,
    TaskType.leisure: AppColors.typeLeisure,
  };

  static const Map<TaskStatus, Color> statusColorMap = {
    TaskStatus.pending: AppColors.statusPending,
    TaskStatus.inProgress: AppColors.statusInProgress,
    TaskStatus.completed: AppColors.statusCompleted,
  };
}

class _KpiData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiData({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class _KpiCard extends StatelessWidget {
  final _KpiData data;

  const _KpiCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: data.color.withAlpha(25),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(data.icon, size: 18, color: data.color),
              ),
              const Spacer(),
              Text(data.value,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: data.color,
                  )),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(data.label,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              )),
        ],
      ),
    );
  }
}
