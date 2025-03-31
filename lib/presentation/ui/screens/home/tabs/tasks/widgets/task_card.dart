// lib/presentation/ui/tabs/tasks/widgets/task_card.dart
import 'package:devpaul_todo_app/core/extensions/string_extension.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/tabs/tasks/widgets/task_detail_screen.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onToggleComplete;

  const TaskCard({
    Key? key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    this.onToggleComplete,
  }) : super(key: key);

  String get formattedDueDate =>
      "${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}";

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showTaskDetail(context),
        child: ListTile(
          leading: onToggleComplete != null
              ? IconButton(
                  icon: Icon(
                    task.isCompleted
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    color: task.isCompleted ? Colors.green : null,
                  ),
                  onPressed: onToggleComplete,
                )
              : null,
          title: Text(
            task.name,
            style: TextStyle(
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              color: task.isCompleted ? Colors.grey : null,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.description,
                style: TextStyle(
                  decoration:
                      task.isCompleted ? TextDecoration.lineThrough : null,
                  color: task.isCompleted ? Colors.grey : null,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Due: $formattedDueDate",
                style: TextStyle(
                  color: task.isCompleted ? Colors.grey : null,
                ),
              ),
              Text(
                "Priority: ${task.priority.toString().split('.').last.capitalize()}",
                style: TextStyle(
                  color: task.isCompleted ? Colors.grey : null,
                ),
              ),
              Text(
                "Type: ${task.type.toString().split('.').last.capitalize()}",
                style: TextStyle(
                  color: task.isCompleted ? Colors.grey : null,
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
              IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
            ],
          ),
        ),
      ),
    );
  }

  void _showTaskDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(
          task: task,
          onEdit: onEdit,
          onDelete: onDelete,
          onToggleComplete: onToggleComplete,
        ),
      ),
    );
  }
}
