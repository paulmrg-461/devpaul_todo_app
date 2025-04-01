import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/data/models/task_model.dart';
import 'package:devpaul_todo_app/presentation/blocs/task_bloc/task_bloc.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/tabs/tasks/widgets/task_card.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/tabs/tasks/widgets/task_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskManagementTab extends StatefulWidget {
  const TaskManagementTab({Key? key}) : super(key: key);

  @override
  State<TaskManagementTab> createState() => _TaskManagementTabState();
}

class _TaskManagementTabState extends State<TaskManagementTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<TaskBloc>().add(GetTasksEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pendientes'),
            Tab(text: 'En Progreso'),
            Tab(text: 'Realizadas'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTaskList(TaskStatus.pending),
          _buildTaskList(TaskStatus.inProgress),
          _buildTaskList(TaskStatus.completed),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskFormDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskList(TaskStatus status) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TaskError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<TaskBloc>().add(GetTasksEvent());
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (state is TaskLoaded) {
          final filteredTasks =
              state.tasks.where((task) => task.status == status).toList();

          if (filteredTasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getEmptyStateIcon(status),
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getEmptyStateMessage(status),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              final task = filteredTasks[index];
              return TaskCard(
                task: task,
                onEdit: () => _showTaskFormDialog(context, task: task),
                onDelete: () => _deleteTask(context, task),
                onStatusChanged: (newStatus) {
                  context.read<TaskBloc>().add(
                        UpdateTaskEvent(
                          task.copyWith(status: newStatus),
                        ),
                      );
                },
              );
            },
          );
        }

        return const Center(child: Text('No hay tareas'));
      },
    );
  }

  IconData _getEmptyStateIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Icons.pending;
      case TaskStatus.inProgress:
        return Icons.play_circle;
      case TaskStatus.completed:
        return Icons.check_circle;
    }
  }

  String _getEmptyStateMessage(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'No hay tareas pendientes';
      case TaskStatus.inProgress:
        return 'No hay tareas en progreso';
      case TaskStatus.completed:
        return 'No hay tareas realizadas';
    }
  }

  void _showTaskFormDialog(BuildContext context, {Task? task}) {
    showDialog(
      context: context,
      builder: (context) => TaskFormDialog(
        task: task,
        onSave: (task) {
          if (task != null) {
            if (task is TaskModel) {
              if (task.id.isEmpty) {
                context.read<TaskBloc>().add(CreateTaskEvent(task));
              } else {
                context.read<TaskBloc>().add(UpdateTaskEvent(task));
              }
            }
          }
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _deleteTask(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Tarea'),
        content: const Text('¿Estás seguro de que deseas eliminar esta tarea?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<TaskBloc>().add(DeleteTaskEvent(task));
              Navigator.of(context).pop();
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
