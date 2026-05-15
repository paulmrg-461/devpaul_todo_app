import 'package:devpaul_todo_app/config/themes/custom_theme.dart';
import 'package:devpaul_todo_app/config/themes/design_tokens.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:devpaul_todo_app/presentation/blocs/ai_suggestion_bloc/ai_suggestion_bloc.dart';
import 'package:devpaul_todo_app/presentation/blocs/task_bloc/task_bloc.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/tabs/tasks/widgets/task_form_dialog.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Task _task;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
    if (_task.aiSuggestion == null) {
      context.read<AiSuggestionBloc>().add(GetTaskSuggestionEvent(_task));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final task = _task;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Task detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit',
            onPressed: () => _showTaskFormDialog(context),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: colorScheme.error),
            tooltip: 'Delete',
            onPressed: () => _deleteTask(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.giant,
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, task),
              const SizedBox(height: AppSpacing.lg),
              _buildStatusChanger(context, task),
              const SizedBox(height: AppSpacing.lg),
              _buildMetaGrid(context, task),
              if (task.description.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                _buildDescriptionCard(context, task),
              ],
              const SizedBox(height: AppSpacing.lg),
              _buildAiSection(context, task),
            ],
          ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Task task) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final statusColor = _statusColor(task.status);

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(width: 5, color: statusColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(task.name,
                              style: textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  height: AppFontScale.lineHeightTight)),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        _statusBadge(context, task.status, statusColor),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChanger(BuildContext context, Task task) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
        child: Row(
          children: [
            Icon(Icons.swap_horiz_rounded, size: 20, color: colorScheme.primary),
            const SizedBox(width: AppSpacing.md),
            Text('Status:', style: textTheme.bodyLarge),
            const Spacer(),
            ...TaskStatus.values.map((s) => Padding(
              padding: const EdgeInsets.only(left: AppSpacing.sm),
              child: _statusChip(context, task.status, s),
            )),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(
      BuildContext context, TaskStatus current, TaskStatus status) {
    final isActive = current == status;
    final color = _statusColor(status);
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isActive ? null : () => _changeStatus(status),
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: isActive ? color.withAlpha(25) : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: Border.all(
              color: isActive ? color : colorScheme.outlineVariant,
              width: 1.5,
            ),
          ),
          child: Text(_statusLabel(status),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isActive ? color : colorScheme.onSurfaceVariant,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  )),
        ),
      ),
    );
  }

  Widget _buildMetaGrid(BuildContext context, Task task) {
    return _metaCard(context, task);
  }

  Widget _metaCard(BuildContext context, Task task) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            _metaRow(context, Icons.flag_outlined,
                _priorityLabel(task.priority), _priorityColor(task.priority)),
            const Divider(height: AppSpacing.xxl),
            _metaRow(context, Icons.label_outlined, _typeLabel(task.type),
                _typeColor(task.type)),
            const Divider(height: AppSpacing.xxl),
            _metaRow(context, Icons.play_arrow_outlined, 'Start',
                null, value: _formatDate(task.startDate)),
            const SizedBox(height: AppSpacing.md),
            _metaRow(context, Icons.flag_outlined, 'Due', AppColors.error,
                value: _formatDate(task.dueDate)),
          ],
        ),
      ),
    );
  }

  Widget _metaRow(BuildContext context, IconData icon, String label, Color? color,
      {String? value}) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final iconColor = color ?? colorScheme.onSurfaceVariant;

    return Row(
      children: [
        Container(
          width: 34, height: 34,
          decoration: BoxDecoration(
            color: iconColor.withAlpha(20),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: AppSpacing.md),
        Text(label, style: textTheme.bodyMedium),
        const Spacer(),
        if (value != null)
          Text(value,
              style: textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurface, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildDescriptionCard(BuildContext context, Task task) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.description_outlined, size: 20, color: colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                Text('Description',
                    style: textTheme.titleSmall?.copyWith(color: colorScheme.primary)),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(task.description,
                style: textTheme.bodyLarge?.copyWith(height: AppFontScale.lineHeightRelaxed)),
          ],
        ),
      ),
    );
  }

  Widget _buildAiSection(BuildContext context, Task task) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withAlpha(8),
              AppColors.accent.withAlpha(12),
            ],
          ),
        ),
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(Icons.psychology_outlined, size: 20, color: Colors.white),
                ),
                const SizedBox(width: AppSpacing.md),
                Text('AI Suggestions',
                    style: textTheme.titleSmall?.copyWith(
                        color: AppColors.primary, fontWeight: FontWeight.w700)),
                const Spacer(),
                if (task.aiSuggestion != null)
                  TextButton.icon(
                    onPressed: () {
                      context.read<AiSuggestionBloc>().add(GetTaskSuggestionEvent(task));
                    },
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Regenerate'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      textStyle: textTheme.labelSmall,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            if (task.aiSuggestion != null)
              MarkdownBody(
                data: task.aiSuggestion!,
                styleSheet: MarkdownStyleSheet(
                  p: textTheme.bodyMedium,
                  h3: textTheme.titleSmall,
                  listBullet: textTheme.bodyMedium,
                ),
              )
            else
              BlocBuilder<AiSuggestionBloc, AiSuggestionState>(
                builder: (context, state) {
                  if (state is AiSuggestionLoading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (state is AiSuggestionLoaded) {
                    final updatedTask = task.copyWith(
                      aiSuggestion: state.suggestion.suggestion,
                    );
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.read<TaskBloc>().add(UpdateTaskEvent(updatedTask));
                    });
                    _task = updatedTask;
                    return MarkdownBody(
                      data: state.suggestion.suggestion,
                      styleSheet: MarkdownStyleSheet(
                        p: textTheme.bodyMedium,
                        h3: textTheme.titleSmall,
                        listBullet: textTheme.bodyMedium,
                      ),
                    );
                  }
                  if (state is AiSuggestionError) {
                    return Column(
                      children: [
                        Text('Could not generate suggestions',
                            style: textTheme.bodyMedium?.copyWith(color: colorScheme.error)),
                        const SizedBox(height: AppSpacing.sm),
                        OutlinedButton.icon(
                          onPressed: () {
                            context.read<AiSuggestionBloc>()
                                .add(GetTaskSuggestionEvent(task));
                          },
                          icon: const Icon(Icons.refresh, size: 16),
                          label: const Text('Retry'),
                        ),
                      ],
                    );
                  }
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                      child: FilledButton.icon(
                        onPressed: () {
                          context.read<AiSuggestionBloc>()
                              .add(GetTaskSuggestionEvent(task));
                        },
                        icon: const Icon(Icons.psychology_outlined, size: 18),
                        label: const Text('Generate AI Suggestions'),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  void _changeStatus(TaskStatus newStatus) {
    final updated = _task.copyWith(status: newStatus);
    context.read<TaskBloc>().add(UpdateTaskEvent(updated));
    setState(() => _task = updated);
  }

  Color _statusColor(TaskStatus s) {
    switch (s) {
      case TaskStatus.pending: return AppColors.statusPending;
      case TaskStatus.inProgress: return AppColors.statusInProgress;
      case TaskStatus.completed: return AppColors.statusCompleted;
    }
  }

  String _statusLabel(TaskStatus s) {
    switch (s) {
      case TaskStatus.pending: return 'Pending';
      case TaskStatus.inProgress: return 'In Progress';
      case TaskStatus.completed: return 'Done';
    }
  }

  String _priorityLabel(TaskPriority p) {
    switch (p) {
      case TaskPriority.low: return 'Low';
      case TaskPriority.medium: return 'Medium';
      case TaskPriority.high: return 'High';
    }
  }

  String _typeLabel(TaskType t) {
    switch (t) {
      case TaskType.work: return 'Work';
      case TaskType.personal: return 'Personal';
      case TaskType.academic: return 'Academic';
      case TaskType.leisure: return 'Leisure';
    }
  }

  Color _priorityColor(TaskPriority p) {
    switch (p) {
      case TaskPriority.low: return AppColors.priorityLow;
      case TaskPriority.medium: return AppColors.priorityMedium;
      case TaskPriority.high: return AppColors.priorityHigh;
    }
  }

  Color _typeColor(TaskType t) {
    switch (t) {
      case TaskType.work: return AppColors.typeWork;
      case TaskType.personal: return AppColors.typePersonal;
      case TaskType.academic: return AppColors.typeAcademic;
      case TaskType.leisure: return AppColors.typeLeisure;
    }
  }

  Widget _statusBadge(BuildContext context, TaskStatus status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(_statusLabel(status),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color, fontWeight: FontWeight.w700,
              )),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month]}, ${date.year}';
  }

  void _showTaskFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => TaskFormDialog(
        task: _task,
        onSave: (updated) {
          context.read<TaskBloc>().add(UpdateTaskEvent(updated));
          setState(() => _task = updated);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _deleteTask(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete task'),
        content: Text('Delete "${_task.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<TaskBloc>().add(DeleteTaskEvent(_task));
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
