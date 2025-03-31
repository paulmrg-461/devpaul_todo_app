import 'package:devpaul_todo_app/core/extensions/string_extension.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:flutter/material.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onToggleComplete;

  const TaskDetailScreen({
    Key? key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    this.onToggleComplete,
  }) : super(key: key);

  String get formattedStartDate =>
      "${task.startDate.day}/${task.startDate.month}/${task.startDate.year}";
  String get formattedDueDate =>
      "${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Tarea'),
        actions: [
          if (onToggleComplete != null)
            IconButton(
              icon: Icon(
                task.isCompleted
                    ? Icons.check_circle
                    : Icons.check_circle_outline,
                color: task.isCompleted ? Colors.green : null,
              ),
              onPressed: onToggleComplete,
            ),
          IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
          IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: 'Título',
              content: Text(
                task.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  decoration:
                      task.isCompleted ? TextDecoration.lineThrough : null,
                  color: task.isCompleted ? Colors.grey : null,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Descripción',
              content: Text(
                task.description,
                style: theme.textTheme.bodyLarge?.copyWith(
                  decoration:
                      task.isCompleted ? TextDecoration.lineThrough : null,
                  color: task.isCompleted ? Colors.grey : null,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Estado',
              content: Row(
                children: [
                  Icon(
                    task.isCompleted ? Icons.check_circle : Icons.pending,
                    color: task.isCompleted ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    task.isCompleted ? 'Completada' : 'Pendiente',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: task.isCompleted ? Colors.green : Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Prioridad',
              content: Row(
                children: [
                  Icon(
                    _getPriorityIcon(),
                    color: _getPriorityColor(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    task.priority.toString().split('.').last.capitalize(),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: _getPriorityColor(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Tipo',
              content: Row(
                children: [
                  Icon(
                    _getTypeIcon(),
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    task.type.toString().split('.').last.capitalize(),
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Fechas',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateRow(
                    context,
                    'Fecha de inicio',
                    formattedStartDate,
                    Icons.calendar_today,
                  ),
                  const SizedBox(height: 8),
                  _buildDateRow(
                    context,
                    'Fecha límite',
                    formattedDueDate,
                    Icons.event,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        content,
      ],
    );
  }

  Widget _buildDateRow(
    BuildContext context,
    String label,
    String date,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          date,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  IconData _getPriorityIcon() {
    switch (task.priority) {
      case TaskPriority.low:
        return Icons.arrow_downward;
      case TaskPriority.medium:
        return Icons.remove;
      case TaskPriority.high:
        return Icons.arrow_upward;
    }
  }

  Color _getPriorityColor() {
    switch (task.priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
    }
  }

  IconData _getTypeIcon() {
    switch (task.type) {
      case TaskType.work:
        return Icons.work;
      case TaskType.personal:
        return Icons.person;
      case TaskType.academic:
        return Icons.school;
      case TaskType.leisure:
        return Icons.sports_esports;
    }
  }
}
