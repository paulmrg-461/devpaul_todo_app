import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
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

class _TaskManagementTabState extends State<TaskManagementTab> {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(GetTasksEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TaskLoaded) {
              final tasks = state.tasks;
              if (tasks.isEmpty) {
                return const Center(child: Text('No tasks found'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TaskCard(
                    task: task,
                    onEdit: () => _showTaskFormDialog(context, task),
                    onDelete: () => _deleteTask(context, task.id),
                  );
                },
              );
            } else if (state is TaskError) {
              return Center(
                  child: Text(state.message,
                      style: const TextStyle(color: Colors.red)));
            }
            return const Center(child: Text('Loading tasks...'));
          },
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () => _showTaskFormDialog(context, null),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  void _showTaskFormDialog(BuildContext context, Task? task) {
    showDialog(
      context: context,
      builder: (context) => TaskFormDialog(
        task: task,
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

  void _deleteTask(BuildContext context, String taskId) {
    context.read<TaskBloc>().add(DeleteTaskEvent(taskId));
  }
}
