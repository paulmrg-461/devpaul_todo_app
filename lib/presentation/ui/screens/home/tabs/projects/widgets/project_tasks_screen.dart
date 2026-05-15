import 'package:devpaul_todo_app/config/themes/design_tokens.dart';
import 'package:devpaul_todo_app/domain/entities/project_entity.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/presentation/blocs/task_bloc/task_bloc.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/tabs/tasks/widgets/task_card.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/tabs/tasks/widgets/task_form_dialog.dart';
import 'package:devpaul_todo_app/presentation/ui/widgets/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectTasksScreen extends StatefulWidget {
  final Project project;
  const ProjectTasksScreen({super.key, required this.project});

  @override
  State<ProjectTasksScreen> createState() => _ProjectTasksScreenState();
}

class _ProjectTasksScreenState extends State<ProjectTasksScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<TaskBloc>()
        .add(GetTasksByProjectEvent(widget.project.id));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TasksByProjectLoaded) {
            return StreamBuilder<List<Task>>(
              stream: state.tasks,
              builder: (context, snapshot) {
                final tasks = snapshot.data ?? [];

                if (tasks.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xxxl),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80, height: 80,
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer
                                  .withAlpha(80),
                              borderRadius: BorderRadius.circular(
                                  AppRadius.xl),
                            ),
                            child: Icon(Icons.task_alt_outlined,
                                size: 36, color: colorScheme.primary),
                          ),
                          const SizedBox(height: AppSpacing.xxl),
                          Text('No tasks in this project',
                              style: textTheme.titleMedium,
                              textAlign: TextAlign.center),
                          const SizedBox(height: AppSpacing.sm),
                          Text('Create a task to get started.',
                              style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 80),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return AnimatedFadeSlide(
                      index: index,
                      delay: const Duration(milliseconds: 40),
                      child: TaskCard(
                        task: task,
                        onEdit: () => _showForm(context, task: task),
                        onDelete: () => _deleteTask(context, task),
                        onStatusChanged: (newStatus) =>
                            _changeStatus(context, task, newStatus),
                        projectName: widget.project.name,
                      ),
                    );
                  },
                );
              },
            );
          }

          if (state is TaskError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context),
        child: const Icon(Icons.add_rounded, size: 24),
      ),
    );
  }

  void _changeStatus(
      BuildContext context, Task task, TaskStatus newStatus) {
    final updated = task.copyWith(status: newStatus);
    context.read<TaskBloc>().add(UpdateTaskEvent(updated));
  }

  void _showForm(BuildContext context, {Task? task}) {
    showDialog(
      context: context,
      builder: (ctx) => TaskFormDialog(
        task: task,
        onSave: (saved) {
          final taskBloc = context.read<TaskBloc>();
          if (saved.id.isEmpty) {
            taskBloc.add(CreateTaskEvent(saved));
          } else {
            taskBloc.add(UpdateTaskEvent(saved));
          }
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _deleteTask(BuildContext context, Task task) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete task'),
        content: Text('Delete "${task.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<TaskBloc>().add(DeleteTaskEvent(task));
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
