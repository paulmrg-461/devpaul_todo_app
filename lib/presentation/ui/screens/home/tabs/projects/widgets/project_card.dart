// lib/presentation/ui/tabs/projects/widgets/project_card.dart
import 'package:devpaul_todo_app/domain/entities/project_entity.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(TaskStatus) onStatusChanged;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onEdit,
    required this.onDelete,
    required this.onStatusChanged,
  });

  Color _getStatusColor() {
    switch (project.status) {
      case TaskStatus.pending:
        return Colors.orange;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.completed:
        return Colors.green;
    }
  }

  IconData _getStatusIcon() {
    switch (project.status) {
      case TaskStatus.pending:
        return Icons.folder_open_outlined; // Changed icon for projects
      case TaskStatus.inProgress:
        return Icons.construction; // Changed icon for projects
      case TaskStatus.completed:
        return Icons.check_circle_outline; // Changed icon for projects
    }
  }

  String _getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'Pendiente';
      case TaskStatus.inProgress:
        return 'En Progreso';
      case TaskStatus.completed:
        return 'Completado';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        // onTap: () => _showProjectDetail(context), // Detail screen not implemented for projects yet
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      project.name,
                      style: TextStyle(
                        decoration: project.status == TaskStatus.completed
                            ? TextDecoration.lineThrough
                            : null,
                        color: project.status == TaskStatus.completed
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
                      PopupMenuItem(
                        value: TaskStatus.pending,
                        child: Row(
                          children: [
                            Icon(Icons.folder_open_outlined,
                                color: Colors.orange),
                            SizedBox(width: 8),
                            Text(_getStatusText(TaskStatus.pending)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: TaskStatus.inProgress,
                        child: Row(
                          children: [
                            Icon(Icons.construction, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(_getStatusText(TaskStatus.inProgress)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: TaskStatus.completed,
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_outline,
                                color: Colors.green),
                            SizedBox(width: 8),
                            Text(_getStatusText(TaskStatus.completed)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                project.description ?? '', // Assuming description can be null
                style: TextStyle(
                  decoration: project.status == TaskStatus.completed
                      ? TextDecoration.lineThrough
                      : null,
                  color: project.status == TaskStatus.completed
                      ? Colors.grey
                      : null,
                ),
              ),
              const SizedBox(height: 8),
              // Removed due date and priority as they are not in Project
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
}
