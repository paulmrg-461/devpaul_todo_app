import 'package:devpaul_todo_app/core/extensions/string_extension.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:flutter/material.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(TaskStatus) onStatusChanged;

  const TaskDetailScreen({
    Key? key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.onStatusChanged,
  }) : super(key: key);

  String get formattedDueDate =>
      "${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}";

  Color _getStatusColor() {
    switch (task.status) {
      case TaskStatus.pending:
        return Colors.orange;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.completed:
        return Colors.green;
    }
  }

  IconData _getStatusIcon() {
    switch (task.status) {
      case TaskStatus.pending:
        return Icons.pending;
      case TaskStatus.inProgress:
        return Icons.play_circle;
      case TaskStatus.completed:
        return Icons.check_circle;
    }
  }

  String _getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'Pendiente';
      case TaskStatus.inProgress:
        return 'En Progreso';
      case TaskStatus.completed:
        return 'Realizada';
    }
  }

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'Baja';
      case TaskPriority.medium:
        return 'Media';
      case TaskPriority.high:
        return 'Alta';
    }
  }

  String _getTypeText(TaskType type) {
    switch (type) {
      case TaskType.work:
        return 'Trabajo';
      case TaskType.personal:
        return 'Personal';
      case TaskType.academic:
        return 'Académico';
      case TaskType.leisure:
        return 'Ocio';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Tarea'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
          ),
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
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  decoration: task.status == TaskStatus.completed
                      ? TextDecoration.lineThrough
                      : null,
                  color:
                      task.status == TaskStatus.completed ? Colors.grey : null,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Descripción',
              content: Text(
                task.description,
                style: TextStyle(
                  decoration: task.status == TaskStatus.completed
                      ? TextDecoration.lineThrough
                      : null,
                  color:
                      task.status == TaskStatus.completed ? Colors.grey : null,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Estado',
              content: PopupMenuButton<TaskStatus>(
                child: Row(
                  children: [
                    Icon(
                      _getStatusIcon(),
                      color: _getStatusColor(),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getStatusText(task.status),
                      style: TextStyle(
                        color: _getStatusColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                onSelected: onStatusChanged,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: TaskStatus.pending,
                    child: Row(
                      children: [
                        Icon(Icons.pending, color: Colors.orange),
                        const SizedBox(width: 8),
                        const Text('Pendiente'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: TaskStatus.inProgress,
                    child: Row(
                      children: [
                        Icon(Icons.play_circle, color: Colors.blue),
                        const SizedBox(width: 8),
                        const Text('En Progreso'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: TaskStatus.completed,
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 8),
                        const Text('Realizada'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
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
                    _getPriorityText(task.priority),
                    style: TextStyle(
                      color: _getPriorityColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Tipo',
              content: Row(
                children: [
                  Icon(
                    _getTypeIcon(),
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getTypeText(task.type),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Fecha de Vencimiento',
              content: Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    formattedDueDate,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: task.status == TaskStatus.completed
                          ? Colors.grey
                          : null,
                    ),
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
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        content,
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
