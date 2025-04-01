// lib/presentation/ui/tabs/tasks/widgets/task_card.dart
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/tabs/tasks/widgets/task_detail_screen.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(TaskStatus) onStatusChanged;

  const TaskCard({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.onStatusChanged,
  });

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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showTaskDetail(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.name,
                      style: TextStyle(
                        decoration: task.status == TaskStatus.completed
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.status == TaskStatus.completed
                            ? Colors.grey
                            : null,
                      ),
                    ),
                  ),
                  PopupMenuButton<TaskStatus>(
                    icon: Icon(
                      _getStatusIcon(),
                      color: _getStatusColor(),
                    ),
                    onSelected: onStatusChanged,
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: TaskStatus.pending,
                        child: Row(
                          children: [
                            Icon(Icons.pending, color: Colors.orange),
                            SizedBox(width: 8),
                            Text('Pendiente'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: TaskStatus.inProgress,
                        child: Row(
                          children: [
                            Icon(Icons.play_circle, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('En Progreso'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: TaskStatus.completed,
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            SizedBox(width: 8),
                            Text('Realizada'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                task.description,
                style: TextStyle(
                  decoration: task.status == TaskStatus.completed
                      ? TextDecoration.lineThrough
                      : null,
                  color:
                      task.status == TaskStatus.completed ? Colors.grey : null,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    "Due: $formattedDueDate",
                    style: TextStyle(
                      color: task.status == TaskStatus.completed
                          ? Colors.grey
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    _getPriorityIcon(),
                    size: 16,
                    color: _getPriorityColor(),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _getPriorityText(task.priority),
                    style: TextStyle(
                      color: task.status == TaskStatus.completed
                          ? Colors.grey
                          : _getPriorityColor(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: onEdit,
                    iconSize: 20,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: onDelete,
                    iconSize: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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

  void _showTaskDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(
          task: task,
        ),
      ),
    );
  }
}
