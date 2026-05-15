import 'package:devpaul_todo_app/config/themes/custom_theme.dart';
import 'package:devpaul_todo_app/config/themes/design_tokens.dart';
import 'package:devpaul_todo_app/domain/entities/group_entity.dart';
import 'package:devpaul_todo_app/domain/entities/project_entity.dart';
import 'package:devpaul_todo_app/presentation/blocs/group_bloc/group_bloc.dart';
import 'package:devpaul_todo_app/presentation/blocs/project_bloc/project_bloc.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/tabs/groups/widgets/group_card.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/tabs/groups/widgets/group_form_dialog.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/tabs/projects/widgets/project_card.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/tabs/projects/widgets/project_form_dialog.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/tabs/projects/widgets/project_tasks_screen.dart';
import 'package:devpaul_todo_app/presentation/ui/widgets/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupManagementTab extends StatefulWidget {
  const GroupManagementTab({super.key});

  @override
  State<GroupManagementTab> createState() => _GroupManagementTabState();
}

class _GroupManagementTabState extends State<GroupManagementTab> {
  @override
  void initState() {
    super.initState();
    context.read<GroupBloc>().add(const GetGroupsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupBloc, GroupState>(
      builder: (context, state) {
        if (state is GroupLoading) {
          return _buildShimmer();
        }

        if (state is GroupLoaded) {
          return StreamBuilder<List<Group>>(
            stream: state.groups,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _buildEmptyState(context);
              }

              return Stack(
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 80),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final group = snapshot.data![index];
                      return AnimatedFadeSlide(
                        index: index,
                        delay: const Duration(milliseconds: 40),
                        child: GroupCard(
                          group: group,
                          onTap: () => _openGroupDetail(context, group),
                          onEdit: () =>
                              _showForm(context, group: group),
                          onDelete: () =>
                              _deleteGroup(context, group),
                          onShare: (id) =>
                              _shareGroup(context, group),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: AppSpacing.lg,
                    right: AppSpacing.lg,
                    child: FloatingActionButton(
                      onPressed: () => _showForm(context),
                      child: const Icon(Icons.add_rounded, size: 24),
                    ),
                  ),
                ],
              );
            },
          );
        }

        if (state is GroupError) {
          return _buildError(context, state.message);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildShimmer() {
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
                    const ShimmerWidget(width: 40, height: 40, radius: 8),
                    const SizedBox(width: AppSpacing.md),
                    const Expanded(child: ShimmerWidget(height: 16)),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: const [
                    ShimmerWidget(width: 48, height: 14),
                    SizedBox(width: AppSpacing.md),
                    ShimmerWidget(width: 48, height: 14),
                  ],
                ),
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
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withAlpha(80),
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              child: Icon(Icons.folder_open_outlined,
                  size: 36, color: colorScheme.primary),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text('No groups yet',
                style: textTheme.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.sm),
            Text('Create a group to organize your projects.',
                style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.xxl),
            FilledButton.icon(
              onPressed: () => _showForm(context),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Create group'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80, height: 80,
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
                context.read<GroupBloc>().add(const GetGroupsEvent());
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showForm(BuildContext context, {Group? group}) {
    showDialog(
      context: context,
      builder: (ctx) => GroupFormDialog(
        group: group,
        onSave: (g) {
          if (g.id.isEmpty) {
            context.read<GroupBloc>().add(CreateGroupEvent(g));
          } else {
            context.read<GroupBloc>().add(UpdateGroupEvent(g));
          }
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _deleteGroup(BuildContext context, Group group) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete group'),
        content: Text('Delete "${group.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context
                  .read<GroupBloc>()
                  .add(DeleteGroupEvent(group.id));
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

  void _shareGroup(BuildContext context, Group group) {
    showDialog(
      context: context,
      builder: (ctx) {
        final emailCtrl = TextEditingController();
        return AlertDialog(
          title: const Text('Share group'),
          content: TextFormField(
            controller: emailCtrl,
            decoration: const InputDecoration(
              labelText: 'User email',
              prefixIcon: Icon(Icons.email_outlined, size: 20),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton.icon(
              onPressed: () {
                final email = emailCtrl.text.trim();
                if (email.isNotEmpty) {
                  context.read<GroupBloc>().add(
                        ShareGroupWithUserEvent(group.id, email),
                      );
                }
                Navigator.pop(ctx);
              },
              icon: const Icon(Icons.share, size: 18),
              label: const Text('Share'),
            ),
          ],
        );
      },
    );
  }

  void _openGroupDetail(BuildContext context, Group group) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _GroupProjectsScreen(group: group),
      ),
    );
  }
}

class _GroupProjectsScreen extends StatefulWidget {
  final Group group;
  const _GroupProjectsScreen({required this.group});

  @override
  State<_GroupProjectsScreen> createState() => _GroupProjectsScreenState();
}

class _GroupProjectsScreenState extends State<_GroupProjectsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProjectBloc>().add(const GetProjectsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(widget.group.name)),
      body: BlocBuilder<ProjectBloc, ProjectState>(
        builder: (context, state) {
          if (state is ProjectLoaded) {
            return StreamBuilder<List<Project>>(
              stream: state.projects,
              builder: (context, snapshot) {
                final allProjects = snapshot.data ?? [];
                final groupProjects = allProjects
                    .where((p) => p.groupId == widget.group.id)
                    .toList();

                if (groupProjects.isEmpty) {
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
                              borderRadius:
                                  BorderRadius.circular(AppRadius.xl),
                            ),
                            child: Icon(Icons.folder_open_outlined,
                                size: 36, color: colorScheme.primary),
                          ),
                          const SizedBox(height: AppSpacing.xxl),
                          Text('No projects in this group',
                              style: textTheme.titleMedium,
                              textAlign: TextAlign.center),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                              'Create a project and assign it to this group.',
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
                  itemCount: groupProjects.length,
                  itemBuilder: (context, index) {
                    final project = groupProjects[index];
                    return AnimatedFadeSlide(
                      index: index,
                      delay: const Duration(milliseconds: 40),
                      child: ProjectCard(
                        project: project,
                        onEdit: () => _showProjectForm(
                            context, project: project),
                        onDelete: () =>
                            _deleteProject(context, project),
                        onTap: () => _openProjectTasks(
                            context, project),
                        onStatusChanged: (status) {},
                      ),
                    );
                  },
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProjectForm(context),
        child: const Icon(Icons.add_rounded, size: 24),
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

  void _showProjectForm(BuildContext context, {Project? project}) {
    showDialog(
      context: context,
      builder: (ctx) => ProjectFormDialog(
        project: project,
        onSave: (saved) {
          final projectBloc = context.read<ProjectBloc>();
          if (saved.id.isEmpty) {
            projectBloc.add(CreateProjectEvent(saved));
          } else {
            projectBloc.add(UpdateProjectEvent(saved));
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
        content:
            Text('Delete "${project.name}"?'),
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
