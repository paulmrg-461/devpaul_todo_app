import 'package:devpaul_todo_app/domain/entities/project_entity.dart';
import 'package:devpaul_todo_app/data/models/project_model.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/presentation/blocs/project_bloc/project_bloc.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/tabs/projects/widgets/project_card.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/tabs/projects/widgets/project_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectManagementTab extends StatefulWidget {
  const ProjectManagementTab({super.key});

  @override
  State<ProjectManagementTab> createState() => _ProjectManagementTabState();
}

class _ProjectManagementTabState extends State<ProjectManagementTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // final _formKey = GlobalKey<FormState>(); // Uncomment if a form is used directly in this tab

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 3,
        vsync: this); // Assuming 3 states: Pending, In Progress, Completed
    context
        .read<ProjectBloc>()
        .add(const GetProjectsEvent()); // Assuming GetProjectsEvent exists
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
        title: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pendientes'),
            Tab(text: 'En Progreso'),
            Tab(text: 'Completados'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProjectList(
              TaskStatus.pending), // Assuming TaskStatus enum exists
          _buildProjectList(TaskStatus.inProgress),
          _buildProjectList(TaskStatus.completed),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProjectFormDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProjectList(TaskStatus status) {
    return BlocBuilder<ProjectBloc, ProjectState>(
      // Assuming ProjectState exists
      builder: (context, state) {
        if (state is ProjectLoading) {
          // Assuming ProjectLoading state exists
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProjectError) {
          // Assuming ProjectError state exists
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
                    context.read<ProjectBloc>().add(const GetProjectsEvent());
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (state is ProjectLoaded) {
          // Assuming ProjectLoaded state exists
          final filteredProjects = state.projects
              .where((project) => project.status == status)
              .toList();

          if (filteredProjects.isEmpty) {
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
            itemCount: filteredProjects.length,
            itemBuilder: (context, index) {
              final project = filteredProjects[index];
              return ProjectCard(
                project: project,
                onEdit: () => _showProjectFormDialog(context, project: project),
                onDelete: () => _deleteProject(context, project),
                onStatusChanged: (TaskStatus newStatus) {
                  if (project is ProjectModel) {
                    context.read<ProjectBloc>().add(
                          UpdateProjectEvent(
                            // Assuming UpdateProjectEvent exists
                            project.copyWith(status: newStatus),
                          ),
                        );
                  } else {
                    // This else block might need adjustment based on how ProjectEntity/Model are structured
                    final projectModel = ProjectModel(
                      id: project.id,
                      name: project.name,
                      description: project.description,
                      userIds: project.userIds,
                      taskIds: project.taskIds,
                      createdAt: project.createdAt,
                      status: newStatus,
                    );
                    context
                        .read<ProjectBloc>()
                        .add(UpdateProjectEvent(projectModel));
                  }
                },
              );
            },
          );
        }

        return const Center(child: Text('No hay proyectos'));
      },
    );
  }

  IconData _getEmptyStateIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Icons.folder_outlined; // Changed icon for projects
      case TaskStatus.inProgress:
        return Icons.construction_outlined; // Changed icon for projects
      case TaskStatus.completed:
        return Icons.check_circle_outline; // Changed icon for projects
    }
  }

  String _getEmptyStateMessage(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'No hay proyectos pendientes';
      case TaskStatus.inProgress:
        return 'No hay proyectos en progreso';
      case TaskStatus.completed:
        return 'No hay proyectos completados';
    }
  }

  void _showProjectFormDialog(BuildContext context, {Project? project}) {
    // Changed to ProjectEntity
    showDialog(
      context: context,
      builder: (context) => ProjectFormDialog(
        project: project,
        onSave: (projectToSave) {
          // Renamed for clarity
          if (projectToSave is ProjectModel) {
            if (projectToSave.id.isEmpty) {
              // Assuming id is a String and empty means new
              context.read<ProjectBloc>().add(CreateProjectEvent(
                  projectToSave)); // Assuming CreateProjectEvent exists
            } else {
              context
                  .read<ProjectBloc>()
                  .add(UpdateProjectEvent(projectToSave));
            }
          }
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _deleteProject(BuildContext context, Project project) {
    // Changed to ProjectEntity
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Proyecto'),
        content:
            const Text('¿Estás seguro de que deseas eliminar este proyecto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<ProjectBloc>().add(DeleteProjectEvent(
                  project.id)); // Assuming DeleteProjectEvent exists
              Navigator.of(context).pop();
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
