import 'package:devpaul_todo_app/config/themes/custom_theme.dart';
import 'package:devpaul_todo_app/config/themes/design_tokens.dart';
import 'package:devpaul_todo_app/domain/entities/project_entity.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/domain/entities/task_metrics_entity.dart';
import 'package:devpaul_todo_app/presentation/blocs/task_bloc/task_bloc.dart';
import 'package:devpaul_todo_app/presentation/ui/widgets/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectMetricsScreen extends StatefulWidget {
  final Project project;

  const ProjectMetricsScreen({super.key, required this.project});

  @override
  State<ProjectMetricsScreen> createState() => _ProjectMetricsScreenState();
}

class _ProjectMetricsScreenState extends State<ProjectMetricsScreen> {
  TaskMetrics? _metrics;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchMetrics();
  }

  void _fetchMetrics() {
    setState(() {
      _loading = true;
      _error = null;
    });
    context
        .read<TaskBloc>()
        .add(GetTasksByProjectEvent(widget.project.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.project.name} · Metrics'),
        actions: [
          IconButton(
            onPressed: _fetchMetrics,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocListener<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TasksByProjectLoaded) {
            state.tasks.first.then((tasks) {
              if (!mounted) return;
              setState(() {
                _metrics = TaskMetrics.fromTasks(tasks);
                _loading = false;
              });
            }).catchError((_) {
              if (!mounted) return;
              setState(() {
                _error = 'Failed to load tasks';
                _loading = false;
              });
            });
          }
          if (state is TaskError) {
            if (!mounted) return;
            setState(() {
              _error = state.message;
              _loading = false;
            });
          }
        },
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: AppSpacing.md),
            Text('Error: $_error'),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: _fetchMetrics,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_metrics == null || _metrics!.totalTasks == 0) {
      final colorScheme = Theme.of(context).colorScheme;
      final textTheme = Theme.of(context).textTheme;

      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withAlpha(80),
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                child: Icon(Icons.analytics_outlined,
                    size: 36, color: colorScheme.primary),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text('No tasks in this project',
                  style: textTheme.titleMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.sm),
              Text('Add tasks to see performance metrics.',
                  style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    return _buildDashboard(context, _metrics!);
  }

  Widget _buildDashboard(BuildContext context, TaskMetrics metrics) {
    final isWide = MediaQuery.of(context).size.width >= 700;

    return RefreshIndicator(
      onRefresh: () async {
        _fetchMetrics();
      },
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _buildProjectHeader(context),
          const SizedBox(height: AppSpacing.xl),
          _buildKpiGrid(context, metrics, isWide),
          const SizedBox(height: AppSpacing.xl),
          _buildDeadlineSection(context, metrics),
          const SizedBox(height: AppSpacing.xl),
          _buildDistributionSection(context, metrics, isWide),
        ],
      ),
    );
  }

  Widget _buildProjectHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withAlpha(50),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: colorScheme.primaryContainer),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(25),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child:
                const Icon(Icons.assignment, size: 22, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.project.name, style: textTheme.titleMedium),
                if (widget.project.description.isNotEmpty)
                  Text(widget.project.description,
                      style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          if (widget.project.technology != null)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.code, size: 14, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(widget.project.technology!,
                      style: textTheme.labelSmall?.copyWith(
                          color: AppColors.primary)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildKpiGrid(
      BuildContext context, TaskMetrics metrics, bool isWide) {
    final kpis = [
      _MiniKpi(
        label: 'Total',
        value: '${metrics.totalTasks}',
        icon: Icons.assignment_outlined,
        color: AppColors.primary,
      ),
      _MiniKpi(
        label: 'Completed',
        value: '${metrics.completedTasks}',
        icon: Icons.check_circle_outline,
        color: AppColors.statusCompleted,
      ),
      _MiniKpi(
        label: 'Rate',
        value: '${(metrics.completionRate * 100).toStringAsFixed(0)}%',
        icon: Icons.trending_up,
        color: AppColors.statusCompleted,
      ),
      _MiniKpi(
        label: 'On Time',
        value: '${(metrics.onTimeRate * 100).toStringAsFixed(0)}%',
        icon: Icons.schedule,
        color: AppColors.primary,
      ),
      _MiniKpi(
        label: 'Overdue',
        value: '${metrics.overdueTasks}',
        icon: Icons.warning_amber_rounded,
        color: AppColors.priorityHigh,
      ),
      _MiniKpi(
        label: 'In Progress',
        value: '${metrics.inProgressTasks}',
        icon: Icons.play_circle_outline,
        color: AppColors.statusInProgress,
      ),
      _MiniKpi(
        label: 'Pending',
        value: '${metrics.pendingTasks}',
        icon: Icons.radio_button_unchecked,
        color: AppColors.statusPending,
      ),
      _MiniKpi(
        label: 'Avg Days',
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
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        childAspectRatio: 1.6,
      ),
      itemCount: kpis.length,
      itemBuilder: (context, index) {
        return AnimatedFadeSlide(
          index: index,
          delay: Duration(milliseconds: 50 * index),
          child: _buildMiniKpi(context, kpis[index]),
        );
      },
    );
  }

  Widget _buildMiniKpi(BuildContext context, _MiniKpi kpi) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(kpi.icon, size: 16, color: kpi.color),
              const Spacer(),
              Text(kpi.value,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: kpi.color,
                  )),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(kpi.label,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              )),
        ],
      ),
    );
  }

  Widget _buildDeadlineSection(BuildContext context, TaskMetrics metrics) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Deadline Compliance', style: textTheme.titleMedium),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'On Time',
                '${metrics.completedOnTime}',
                '${(metrics.onTimeRate * 100).toStringAsFixed(0)}% of completed',
                AppColors.statusCompleted,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildStatCard(
                context,
                'Late',
                '${metrics.completedLate}',
                '${((1 - metrics.onTimeRate) * 100).toStringAsFixed(0)}% of completed',
                AppColors.statusPending,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildStatCard(
                context,
                'Overdue',
                '${metrics.overdueTasks}',
                'Not completed',
                AppColors.priorityHigh,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    String subtitle,
    Color color,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withAlpha(12),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              )),
          const SizedBox(height: 2),
          Text(title,
              style: textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurface,
              )),
          const SizedBox(height: 2),
          Text(subtitle,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              )),
        ],
      ),
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
              Expanded(child: _buildBars(context, 'By Status',
                  metrics.tasksByStatus, statusColorMap, metrics.totalTasks)),
              const SizedBox(width: AppSpacing.lg),
              Expanded(child: _buildBars(context, 'By Priority',
                  metrics.tasksByPriority, priorityColorMap, metrics.totalTasks)),
            ],
          )
        else
          Column(
            children: [
              _buildBars(context, 'By Status', metrics.tasksByStatus,
                  statusColorMap, metrics.totalTasks),
              const SizedBox(height: AppSpacing.lg),
              _buildBars(context, 'By Priority', metrics.tasksByPriority,
                  priorityColorMap, metrics.totalTasks),
            ],
          ),
      ],
    );
  }

  Widget _buildBars<T>(
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
                      Text(_capitalize(label), style: textTheme.bodySmall),
                      Text(
                          '${entry.value} (${(pct * 100).toStringAsFixed(0)}%)',
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

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static const Map<TaskPriority, Color> priorityColorMap = {
    TaskPriority.low: AppColors.priorityLow,
    TaskPriority.medium: AppColors.priorityMedium,
    TaskPriority.high: AppColors.priorityHigh,
  };

  static const Map<TaskStatus, Color> statusColorMap = {
    TaskStatus.pending: AppColors.statusPending,
    TaskStatus.inProgress: AppColors.statusInProgress,
    TaskStatus.completed: AppColors.statusCompleted,
  };
}

class _MiniKpi {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MiniKpi({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}
