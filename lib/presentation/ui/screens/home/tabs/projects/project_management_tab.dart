import 'package:devpaul_todo_app/config/themes/design_tokens.dart';
import 'package:devpaul_todo_app/domain/entities/project_entity.dart';
import 'package:devpaul_todo_app/presentation/blocs/project_bloc/project_bloc.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/tabs/projects/widgets/project_card.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/tabs/projects/widgets/project_form_dialog.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/tabs/projects/widgets/project_tasks_screen.dart';
import 'package:devpaul_todo_app/presentation/ui/widgets/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectManagementTab extends StatefulWidget {
  const ProjectManagementTab({super.key});

  @override
  State<ProjectManagementTab> createState() => _ProjectManagementTabState();
}

class _ProjectManagementTabState extends State<ProjectManagementTab> {
  @override
  void initState() {
    super.initState();
    context.read<ProjectBloc>().add(const GetProjectsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        if (state is ProjectLoading) {
          return _buildShimmerLoading();
        }

        if (state is ProjectLoaded) {
          return StreamBuilder<List<Project>>(
            stream: state.projects,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _buildEmptyState(context);
              }

              final projects = snapshot.data!;
              return Stack(
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.lg,
                      80,
                    ),
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      final project = projects[index];
                      return AnimatedFadeSlide(
                        index: index,
                        delay: const Duration(milliseconds: 40),
                        duration: const Duration(milliseconds: 350),
                        child: ProjectCard(
                          project: project,
                          onEdit: () => _showProjectFormDialog(context,
                              project: project),
                          onDelete: () =>
                              _deleteProject(context, project),
                          onTap: () => _openProjectTasks(context, project),
                          onStatusChanged: (status) {
                            final updated = ProjectModel(
                              id: project.id,
                              name: project.name,
                              description: project.description,
                              userIds: project.userIds,
                              taskIds: project.taskIds,
                              status: status,
                              createdAt: project.createdAt,
                              ownerId: project.ownerId,
                            );
                            context
                                .read<ProjectBloc>()
                                .add(UpdateProjectEvent(updated));
                          },
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: AppSpacing.lg,
                    right: AppSpacing.lg,
                    child: FloatingActionButton(
                      onPressed: () => _showProjectFormDialog(context),
                      child: const Icon(Icons.add_rounded, size: 24),
                    ),
                  ),
                ],
              );
            },
          );
        }

        if (state is ProjectError) {
          return _buildErrorState(context, state.message);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: 3,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(child: ShimmerWidget(height: 16)),
                    const SizedBox(width: AppSpacing.md),
                    const ShimmerWidget(width: 72, height: 20, radius: 4),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                const ShimmerWidget(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withAlpha(80),
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              child: Icon(Icons.folder_open_outlined,
                  size: 36, color: colorScheme.primary),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text('No projects yet',
                style: textTheme.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.sm),
            Text('Create a project to organize your tasks.',
                style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.xxl),
            FilledButton.icon(
              onPressed: () => _showProjectFormDialog(context),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Create project'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              child: Icon(Icons.error_outline,
                  size: 36, color: colorScheme.error),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(message,
                style: textTheme.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.xxl),
            OutlinedButton.icon(
              onPressed: () {
                context.read<ProjectBloc>().add(const GetProjectsEvent());
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _openProjectTasks(BuildContext context, Project project) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProjectTasksScreen(project: project),
      ),
    );
  }

  void _showProjectFormDialog(BuildContext context, {Project? project}) {
    showDialog(
      context: context,
      builder: (ctx) => ProjectFormDialog(
        project: project,
        onSave: (saved) {
          if (saved.id.isEmpty) {
            context.read<ProjectBloc>().add(CreateProjectEvent(saved));
          } else {
            context.read<ProjectBloc>().add(UpdateProjectEvent(saved));
          }
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _deleteProject(BuildContext context, Project project) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete project'),
        content: Text(
            'Are you sure you want to delete "${project.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context
                  .read<ProjectBloc>()
                  .add(DeleteProjectEvent(project.id));
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

// Local model for status updates — avoids importing data models in presentation
class ProjectModel extends Project {
  ProjectModel({
    required super.id,
    required super.name,
    required super.description,
    required super.userIds,
    required super.taskIds,
    required super.status,
    required super.createdAt,
    super.ownerId,
  });
}
