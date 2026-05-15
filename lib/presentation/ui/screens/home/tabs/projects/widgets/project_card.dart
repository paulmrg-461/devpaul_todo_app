import 'package:devpaul_todo_app/config/themes/custom_theme.dart';
import 'package:devpaul_todo_app/config/themes/design_tokens.dart';
import 'package:devpaul_todo_app/domain/entities/project_entity.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(TaskStatus) onStatusChanged;
  final VoidCallback? onTap;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onEdit,
    required this.onDelete,
    required this.onStatusChanged,
    this.onTap,
  });

  Color _statusColor() {
    switch (project.status) {
      case TaskStatus.pending:
        return AppColors.statusPending;
      case TaskStatus.inProgress:
        return AppColors.statusInProgress;
      case TaskStatus.completed:
        return AppColors.statusCompleted;
    }
  }

  String _statusLabel() {
    switch (project.status) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Done';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.cardBorder,
      ),
      child: InkWell(
        onTap: onTap,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(width: 4, color: _statusColor()),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            project.name,
                            style: textTheme.titleSmall?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Status badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm + 2,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor().withAlpha(25),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Text(
                            _statusLabel(),
                            style: textTheme.labelSmall?.copyWith(
                              color: _statusColor(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (project.description.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        project.description,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (project.groupId != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      _buildMetaChip(
                        context,
                        Icons.folder_rounded,
                        'In group',
                        color: AppColors.primary,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        // Member count
                        _buildMetaChip(
                          context,
                          Icons.people_outline,
                          '${project.userIds.length} ${project.userIds.length == 1 ? 'member' : 'members'}',
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        // Task count
                        _buildMetaChip(
                          context,
                          Icons.task_outlined,
                          '${project.taskIds.length} ${project.taskIds.length == 1 ? 'task' : 'tasks'}',
                        ),
                        const Spacer(),
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

  Widget _buildMetaChip(BuildContext context, IconData icon, String text,
      {Color? color}) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final chipColor = color ?? colorScheme.onSurfaceVariant;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: chipColor),
        const SizedBox(width: 4),
        Text(
          text,
          style: textTheme.labelSmall?.copyWith(
            color: chipColor,
          ),
        ),
      ],
    );
  }
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
