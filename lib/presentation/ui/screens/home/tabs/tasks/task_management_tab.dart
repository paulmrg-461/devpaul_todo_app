import 'package:devpaul_todo_app/config/themes/custom_theme.dart';
import 'package:devpaul_todo_app/config/themes/design_tokens.dart';
import 'package:devpaul_todo_app/domain/entities/group_entity.dart';
import 'package:devpaul_todo_app/domain/entities/project_entity.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/presentation/blocs/group_bloc/group_bloc.dart';
import 'package:devpaul_todo_app/presentation/blocs/project_bloc/project_bloc.dart';
import 'package:devpaul_todo_app/presentation/blocs/task_bloc/task_bloc.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/tabs/tasks/widgets/task_card.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/tabs/tasks/widgets/task_form_dialog.dart';
import 'package:devpaul_todo_app/presentation/ui/widgets/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskManagementTab extends StatefulWidget {
  final String? initialGroupId;
  final String? initialProjectId;

  const TaskManagementTab({
    super.key,
    this.initialGroupId,
    this.initialProjectId,
  });

  @override
  State<TaskManagementTab> createState() => _TaskManagementTabState();
}

class _TaskManagementTabState extends State<TaskManagementTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Filter state
  String? _selectedGroupId;
  String? _selectedProjectId;
  List<Group> _groups = [];
  List<Project> _projects = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectedGroupId = widget.initialGroupId;
    _selectedProjectId = widget.initialProjectId;
    _loadData();
  }

  void _loadData() {
    context.read<TaskBloc>().add(const GetTasksEvent());
    context.read<GroupBloc>().add(const GetGroupsEvent());
    context.read<ProjectBloc>().add(const GetProjectsEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onGroupChanged(String? groupId) {
    setState(() {
      _selectedGroupId = groupId;
      _selectedProjectId = null;
    });
  }

  void _onProjectChanged(String? projectId) {
    setState(() => _selectedProjectId = projectId);
  }

  List<Task> _filterTasks(List<Task> tasks) {
    if (_selectedProjectId != null) {
      return tasks
          .where((t) => t.projectId == _selectedProjectId)
          .toList();
    }
    if (_selectedGroupId != null) {
      final groupProjectIds =
          _projects.where((p) => p.groupId == _selectedGroupId).map((p) => p.id).toSet();
      return tasks
          .where((t) => t.projectId != null && groupProjectIds.contains(t.projectId!))
          .toList();
    }
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    final isKanban = MediaQuery.of(context).size.width >= 900;

    return Column(
      children: [
        _buildFilterBar(context),
        Expanded(
          child: isKanban ? _buildKanban(context) : _buildTabs(context),
        ),
      ],
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Group filter
          Expanded(
            child: _buildGroupDropdown(context),
          ),
          const SizedBox(width: AppSpacing.md),
          // Project filter
          Expanded(
            child: _buildProjectDropdown(context),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Clear filters
          if (_selectedGroupId != null || _selectedProjectId != null)
            IconButton(
              icon: const Icon(Icons.filter_alt_off, size: 20),
              tooltip: 'Clear filters',
              onPressed: () {
                setState(() {
                  _selectedGroupId = null;
                  _selectedProjectId = null;
                });
              },
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.primaryContainer,
                foregroundColor: colorScheme.primary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGroupDropdown(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<GroupBloc, GroupState>(
      builder: (context, state) {
        if (state is GroupLoaded) {
          return StreamBuilder<List<Group>>(
            stream: state.groups,
            builder: (context, snapshot) {
              _groups = snapshot.data ?? [];
              return _filterDropdown<String>(
                value: _selectedGroupId,
                hint: 'All groups',
                icon: Icons.folder_outlined,
                items: _groups
                    .map((g) => DropdownMenuItem(
                          value: g.id,
                          child: Text(g.name, overflow: TextOverflow.ellipsis),
                        ))
                    .toList(),
                onChanged: _onGroupChanged,
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildProjectDropdown(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        if (state is ProjectLoaded) {
          return StreamBuilder<List<Project>>(
            stream: state.projects,
            builder: (context, snapshot) {
              var allProjects = snapshot.data ?? [];
              // Filter projects by selected group
              if (_selectedGroupId != null) {
                allProjects = allProjects
                    .where((p) => p.groupId == _selectedGroupId)
                    .toList();
              }
              _projects = allProjects;
              return _filterDropdown<String>(
                value: _selectedProjectId,
                hint: 'All projects',
                icon: Icons.assignment_outlined,
                items: allProjects
                    .map((p) => DropdownMenuItem(
                          value: p.id,
                          child: Text(p.name, overflow: TextOverflow.ellipsis),
                        ))
                    .toList(),
                onChanged: _onProjectChanged,
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _filterDropdown<T>({
    required T? value,
    required String hint,
    required IconData icon,
    required List<DropdownMenuItem<T>> items,
    required Function(T?) onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        prefixIcon: Icon(icon, size: 18),
        isDense: true,
      ),
      hint: Text(hint, style: Theme.of(context).textTheme.bodySmall),
      items: items,
      onChanged: onChanged,
      isExpanded: true,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }

  // ─── Kanban columns ────────────────────────────────────────────

  Widget _buildKanban(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TaskLoaded) {
          final tasks = _filterTasks(state.tasks);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _kanbanColumn(context, tasks, TaskStatus.pending,
                    'Pending', Icons.radio_button_unchecked, AppColors.statusPending),
              ),
              _kanbanDivider(),
              Expanded(
                child: _kanbanColumn(context, tasks, TaskStatus.inProgress,
                    'In Progress', Icons.play_circle_outline, AppColors.statusInProgress),
              ),
              _kanbanDivider(),
              Expanded(
                child: _kanbanColumn(context, tasks, TaskStatus.completed,
                    'Done', Icons.check_circle, AppColors.statusCompleted),
              ),
            ],
          );
        }

        if (state is TaskError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _kanbanDivider() {
    return Container(
      width: 1,
      color: Theme.of(context).colorScheme.outlineVariant.withAlpha(100),
    );
  }

  String? _groupNameForTask(Task task) {
    if (task.projectId == null) return null;
    for (final p in _projects) {
      if (p.id == task.projectId && p.groupId != null) {
        for (final g in _groups) {
          if (g.id == p.groupId) return g.name;
        }
      }
    }
    return null;
  }

  String? _projectNameForTask(Task task) {
    if (task.projectId == null) return null;
    for (final p in _projects) {
      if (p.id == task.projectId) return p.name;
    }
    return null;
  }

  Widget _kanbanColumn(BuildContext context, List<Task> allTasks,
      TaskStatus status, String title, IconData icon, Color color) {
    final tasks = allTasks.where((t) => t.status == status).toList();
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            border: Border(
              bottom:
                  BorderSide(color: colorScheme.outlineVariant, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: AppSpacing.sm),
              Text(title,
                  style: textTheme.titleSmall?.copyWith(color: color)),
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text('${tasks.length}',
                    style: textTheme.labelSmall?.copyWith(
                        color: color, fontWeight: FontWeight.w700)),
              ),
              if (status == TaskStatus.pending) ...[
                const Spacer(),
                SizedBox(
                  height: 32,
                  child: FilledButton.icon(
                    onPressed: () => _showForm(context),
                    icon: const Icon(Icons.add_rounded, size: 16),
                    label: const Text('Add'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      textStyle: textTheme.labelSmall,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: tasks.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    child: Text(
                      status == TaskStatus.pending
                          ? 'No pending tasks'
                          : status == TaskStatus.inProgress
                              ? 'Nothing in progress'
                              : 'Nothing completed',
                      style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return AnimatedFadeSlide(
                      index: index,
                      delay: const Duration(milliseconds: 30),
                      duration: const Duration(milliseconds: 300),
                      child: TaskCard(
                        task: tasks[index],
                        onEdit: () =>
                            _showForm(context, task: tasks[index]),
                        onDelete: () =>
                            _deleteTask(context, tasks[index]),
                        onStatusChanged: (newStatus) =>
                            _changeStatus(context, tasks[index], newStatus),
                        groupName: _groupNameForTask(tasks[index]),
                        projectName: _projectNameForTask(tasks[index]),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ─── Tabs fallback ─────────────────────────────────────────────

  Widget _buildTabs(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Pending'),
                Tab(text: 'In Progress'),
                Tab(text: 'Done'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: TaskStatus.values.map((status) {
                  return _buildTabList(context, status);
                }).toList(),
              ),
            ),
          ],
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
  }

  Widget _buildTabList(BuildContext context, TaskStatus status) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is TaskError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        if (state is TaskLoaded) {
          final tasks =
              _filterTasks(state.tasks).where((t) => t.status == status).toList();

          if (tasks.isEmpty) {
            return _buildEmpty(context, status);
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 80),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return AnimatedFadeSlide(
                index: index,
                delay: const Duration(milliseconds: 40),
                child: TaskCard(
                  task: tasks[index],
                  onEdit: () => _showForm(context, task: tasks[index]),
                  onDelete: () => _deleteTask(context, tasks[index]),
                  onStatusChanged: (newStatus) =>
                      _changeStatus(context, tasks[index], newStatus),
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmpty(BuildContext context, TaskStatus status) {
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
              child: Icon(Icons.inbox_outlined,
                  size: 36, color: colorScheme.primary),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text('No tasks', style: textTheme.titleMedium),
          ],
        ),
      ),
    );
  }

  void _changeStatus(BuildContext context, Task task, TaskStatus newStatus) {
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
