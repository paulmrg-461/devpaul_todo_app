import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:devpaul_todo_app/presentation/blocs/task_bloc/task_bloc.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/tabs/tasks/widgets/task_card.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/tabs/tasks/widgets/task_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskManagementTab extends StatefulWidget {
  const TaskManagementTab({Key? key}) : super(key: key);

  @override
  _TaskManagementTabState createState() => _TaskManagementTabState();
}

class _TaskManagementTabState extends State<TaskManagementTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
    _loadTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadTasks() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<TaskBloc>().add(GetTasksEvent(authState.user.uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is AuthAuthenticated) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Tareas'),
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Pendientes'),
                  Tab(text: 'Completadas'),
                ],
              ),
            ),
            body: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state is TaskLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is TaskError) {
                  return Center(child: Text(state.message));
                }
                if (state is TaskLoaded) {
                  final tasks = state.tasks
                      .where((task) => _currentTabIndex == 0
                          ? !task.isCompleted
                          : task.isCompleted)
                      .toList();

                  if (tasks.isEmpty) {
                    return Center(
                      child: Text(_currentTabIndex == 0
                          ? 'No hay tareas pendientes'
                          : 'No hay tareas completadas'),
                    );
                  }

                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskCard(
                        task: task,
                        onEdit: () => _showTaskFormDialog(context, task),
                        onDelete: () => _deleteTask(context, task.id),
                        onToggleComplete: () =>
                            _toggleTaskComplete(context, task),
                      );
                    },
                  );
                }
                return const Center(child: Text('No hay tareas'));
              },
            ),
            floatingActionButton: _currentTabIndex == 0
                ? FloatingActionButton(
                    onPressed: () => _showTaskFormDialog(context, null),
                    child: const Icon(Icons.add),
                  )
                : null,
          );
        }
        return const Center(child: Text('Usuario no autenticado'));
      },
    );
  }

  void _showTaskFormDialog(BuildContext context, Task? task) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      showDialog(
        context: context,
        builder: (context) => TaskFormDialog(
          task: task,
          userId: authState.user.uid,
          onSave: (Task newTask) {
            if (task == null) {
              context.read<TaskBloc>().add(CreateTaskEvent(newTask));
            } else {
              context.read<TaskBloc>().add(UpdateTaskEvent(newTask));
            }
          },
        ),
      );
    }
  }

  void _deleteTask(BuildContext context, String taskId) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context
          .read<TaskBloc>()
          .add(DeleteTaskEvent(taskId, userId: authState.user.uid));
    }
  }

  void _toggleTaskComplete(BuildContext context, Task task) {
    final updatedTask = Task(
      id: task.id,
      name: task.name,
      description: task.description,
      priority: task.priority,
      type: task.type,
      startDate: task.startDate,
      dueDate: task.dueDate,
      userId: task.userId,
      isCompleted: !task.isCompleted,
    );
    context.read<TaskBloc>().add(UpdateTaskEvent(updatedTask));
  }
}
