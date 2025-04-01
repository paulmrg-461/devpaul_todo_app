import 'package:devpaul_todo_app/core/extensions/string_extension.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/data/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  @override
  void initState() {
    super.initState();
    final taskModel = widget.task as TaskModel;
    if (taskModel.aiSuggestion == null) {
      context.read<AiSuggestionBloc>().add(GetTaskSuggestionEvent(widget.task));
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskModel = widget.task as TaskModel;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Tarea'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showTaskFormDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteTask(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: 'Nombre',
              content: Text(widget.task.name),
            ),
            _buildSection(
              title: 'Descripción',
              content: Text(widget.task.description),
            ),
            _buildSection(
              title: 'Estado',
              content: Row(
                children: [
                  Icon(
                    _getStatusIcon(widget.task.status),
                    color: _getStatusColor(widget.task.status),
                  ),
                  const SizedBox(width: 8),
                  Text(_getStatusText(widget.task.status)),
                ],
              ),
            ),
            _buildSection(
              title: 'Prioridad',
              content: Row(
                children: [
                  Icon(
                    _getPriorityIcon(widget.task.priority),
                    color: _getPriorityColor(widget.task.priority),
                  ),
                  const SizedBox(width: 8),
                  Text(_getPriorityText(widget.task.priority)),
                ],
              ),
            ),
            _buildSection(
              title: 'Tipo',
              content: Row(
                children: [
                  Icon(
                    _getTypeIcon(widget.task.type),
                    color: _getTypeColor(widget.task.type),
                  ),
                  const SizedBox(width: 8),
                  Text(_getTypeText(widget.task.type)),
                ],
              ),
            ),
            _buildSection(
              title: 'Fechas',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Inicio: ${widget.task.startDate.day}/${widget.task.startDate.month}/${widget.task.startDate.year}',
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Vencimiento: ${widget.task.dueDate.day}/${widget.task.dueDate.month}/${widget.task.dueDate.year}',
                  ),
                ],
              ),
            ),
            _buildSection(
              title: 'Sugerencia AI',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (taskModel.aiSuggestion != null)
                    Text(taskModel.aiSuggestion!)
                  else
                    BlocBuilder<AiSuggestionBloc, AiSuggestionState>(
                      builder: (context, state) {
                        if (state is AiSuggestionLoading) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }
                        if (state is AiSuggestionLoaded) {
                          // Actualizar la tarea con la sugerencia
                          final updatedTask = taskModel.copyWith(
                            aiSuggestion: state.suggestion.suggestion,
                          );
                          context
                              .read<TaskBloc>()
                              .add(UpdateTaskEvent(updatedTask));
                          return Text(state.suggestion.suggestion);
                        }
                        if (state is AiSuggestionError) {
                          return Text(
                            'Error: ${state.message}',
                            style: const TextStyle(color: Colors.red),
                          );
                        }
                        return const Text('Generando sugerencia...');
                      },
                    ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () {
                      context
                          .read<AiSuggestionBloc>()
                          .add(GetTaskSuggestionEvent(widget.task));
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Regenerar Sugerencia'),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
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
    return priority.toString().split('.').last.capitalize();
  }

  String _getTypeText(TaskType type) {
    return type.toString().split('.').last.capitalize();
  }

  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Icons.pending;
      case TaskStatus.inProgress:
        return Icons.play_circle;
      case TaskStatus.completed:
        return Icons.check_circle;
    }
  }

  IconData _getPriorityIcon(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Icons.arrow_downward;
      case TaskPriority.medium:
        return Icons.remove;
      case TaskPriority.high:
        return Icons.arrow_upward;
    }
  }

  IconData _getTypeIcon(TaskType type) {
    switch (type) {
      case TaskType.personal:
        return Icons.person;
      case TaskType.work:
        return Icons.work;
      case TaskType.academic:
        return Icons.school;
      case TaskType.leisure:
        return Icons.sports_esports;
    }
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Colors.orange;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.completed:
        return Colors.green;
    }
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
    }
  }

  Color _getTypeColor(TaskType type) {
    switch (type) {
      case TaskType.personal:
        return Colors.purple;
      case TaskType.work:
        return Colors.blue;
      case TaskType.academic:
        return Colors.green;
      case TaskType.leisure:
        return Colors.orange;
    }
  }

  void _showTaskFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => TaskFormDialog(
        task: widget.task,
        onSave: (task) {
          context.read<TaskBloc>().add(UpdateTaskEvent(task));
                  Navigator.pop(context);
        },
      ),
    );
  }

  void _deleteTask(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Tarea'),
        content: const Text('¿Estás seguro de que deseas eliminar esta tarea?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<TaskBloc>().add(DeleteTaskEvent(widget.task));
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
