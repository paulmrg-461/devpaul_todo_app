import 'package:devpaul_todo_app/config/themes/custom_theme.dart';
import 'package:devpaul_todo_app/config/themes/design_tokens.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/tabs/tasks/widgets/task_detail_screen.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(TaskStatus) onStatusChanged;
  final String? groupName;
  final String? projectName;

  const TaskCard({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.onStatusChanged,
    this.groupName,
    this.projectName,
  });

  bool get _isOverdue =>
      task.dueDate.isBefore(DateTime.now()) &&
      task.status != TaskStatus.completed;

  Color _statusColor() {
    switch (task.status) {
      case TaskStatus.pending:
        return AppColors.statusPending;
      case TaskStatus.inProgress:
        return AppColors.statusInProgress;
      case TaskStatus.completed:
        return AppColors.statusCompleted;
    }
  }

  IconData _statusIcon() {
    switch (task.status) {
      case TaskStatus.pending:
        return Icons.radio_button_unchecked;
      case TaskStatus.inProgress:
        return Icons.play_circle_outline;
      case TaskStatus.completed:
        return Icons.check_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isCompleted = task.status == TaskStatus.completed;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.cardBorder,
        side: _isOverdue
            ? BorderSide(color: AppColors.error.withAlpha(80), width: 1)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => _showTaskDetail(context),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Status strip
              Container(
                width: 4,
                color: _statusColor(),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Status radio button
                          GestureDetector(
                            onTap: () => _toggleStatus(context),
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCompleted
                                    ? _statusColor()
                                    : Colors.transparent,
                                border: Border.all(
                                  color: _statusColor(),
                                  width: 2,
                                ),
                              ),
                              child: isCompleted
                                  ? const Icon(Icons.check,
                                      size: 14, color: Colors.white)
                                  : null,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),

                          // Name
                          Expanded(
                            child: Text(
                              task.name,
                              style: textTheme.titleSmall?.copyWith(
                                decoration: isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: isCompleted
                                    ? colorScheme.onSurface.withAlpha(120)
                                    : colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // Priority chip
                          _buildPriorityChip(context),
                        ],
                      ),

                      if (task.description.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          task.description,
                          style: textTheme.bodySmall?.copyWith(
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: isCompleted
                                ? colorScheme.onSurface.withAlpha(80)
                                : colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (task.projectId != null || groupName != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            if (groupName != null) ...[
                              _buildLabelChip(context, Icons.folder_rounded,
                                  groupName!, AppColors.primary),
                              const SizedBox(width: AppSpacing.sm),
                            ],
                            if (task.projectId != null)
                              _buildLabelChip(
                                context,
                                Icons.assignment_outlined,
                                projectName ?? 'Project',
                                AppColors.typeWork,
                              ),
                          ],
                        ),
                      ],

                      const SizedBox(height: AppSpacing.md),

                      // Bottom metadata row
                      Row(
                        children: [
                          _buildMetaChip(
                            context,
                            Icons.calendar_today_outlined,
                            _formatDate(task.dueDate),
                            isOverdue: _isOverdue,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          _buildTypeChip(context),
                          const Spacer(),
                          // Actions (visible on hover for web)
                          _ActionButton(
                            icon: Icons.edit_outlined,
                            onTap: onEdit,
                            tooltip: 'Edit',
                          ),
                          const SizedBox(width: 4),
                          _ActionButton(
                            icon: Icons.delete_outline,
                            onTap: onDelete,
                            tooltip: 'Delete',
                            color: colorScheme.error,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleStatus(BuildContext context) {
    final newStatus = task.status == TaskStatus.completed
        ? TaskStatus.pending
        : TaskStatus.completed;
    onStatusChanged(newStatus);
  }

  Widget _buildPriorityChip(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isCompleted = task.status == TaskStatus.completed;

    Color color;
    String label;
    switch (task.priority) {
      case TaskPriority.high:
        color = AppColors.priorityHigh;
        label = 'Alta';
        break;
      case TaskPriority.medium:
        color = AppColors.priorityMedium;
        label = 'Media';
        break;
      case TaskPriority.low:
        color = AppColors.priorityLow;
        label = 'Baja';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.transparent : color.withAlpha(25),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        style: textTheme.labelSmall?.copyWith(
          color: isCompleted ? colorScheme.onSurface.withAlpha(80) : color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildMetaChip(
    BuildContext context,
    IconData icon,
    String text, {
    bool isOverdue = false,
    Color? color,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isCompleted = task.status == TaskStatus.completed;

    final chipColor = color ??
        (isOverdue
            ? AppColors.error
            : isCompleted
                ? colorScheme.onSurface.withAlpha(80)
                : colorScheme.onSurfaceVariant);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: chipColor),
        const SizedBox(width: 4),
        Text(
          text,
          style: textTheme.labelSmall?.copyWith(color: chipColor),
        ),
      ],
    );
  }

  Widget _buildTypeChip(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isCompleted = task.status == TaskStatus.completed;

    Color color;
    String label;
    switch (task.type) {
      case TaskType.work:
        color = AppColors.typeWork;
        label = 'Trabajo';
        break;
      case TaskType.personal:
        color = AppColors.typePersonal;
        label = 'Personal';
        break;
      case TaskType.academic:
        color = AppColors.typeAcademic;
        label = 'Académico';
        break;
      case TaskType.leisure:
        color = AppColors.typeLeisure;
        label = 'Ocio';
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8, height: 8,
          decoration: BoxDecoration(
            color: isCompleted
                ? colorScheme.onSurface.withAlpha(80)
                : color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: isCompleted
                ? colorScheme.onSurface.withAlpha(80)
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildLabelChip(
      BuildContext context, IconData icon, String text, Color color) {
    final textTheme = Theme.of(context).textTheme;
    final isCompleted = task.status == TaskStatus.completed;
    final chipColor =
        isCompleted ? Theme.of(context).colorScheme.onSurface.withAlpha(80) : color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.transparent : color.withAlpha(20),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: chipColor.withAlpha(isCompleted ? 50 : 80),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: chipColor),
          const SizedBox(width: 4),
          Text(text,
              style: textTheme.labelSmall?.copyWith(
                  color: chipColor, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      '',
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic'
    ];
    return '${date.day} ${months[date.month]}';
  }

  void _showTaskDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(task: task),
      ),
    );
  }

  ColorScheme get colorScheme => ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light);
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final Color? color;

  const _ActionButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor =
        color ?? Theme.of(context).colorScheme.onSurfaceVariant;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Tooltip(
          message: tooltip,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(icon, size: 18, color: iconColor),
          ),
        ),
      ),
    );
  }
}
