import 'package:devpaul_todo_app/data/models/project_model.dart';
import 'package:devpaul_todo_app/domain/entities/project_entity.dart';
import 'package:devpaul_todo_app/presentation/blocs/project_bloc/project_bloc.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/tabs/projects/widgets/project_card.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/tabs/projects/widgets/project_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectManagementTab extends StatelessWidget {
  const ProjectManagementTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Dispara el evento para cargar proyectos al inicializar el tab
    context.read<ProjectBloc>().add(const GetProjectsEvent());

    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        if (state is ProjectInitial) {
          return const Center(
              child: Text('Presiona el botón para cargar proyectos'));
        }

        if (state is ProjectLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProjectLoaded) {
          return _buildProjectList(state.projects, context);
        }

        if (state is ProjectError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        return const SizedBox.shrink(); // Fallback por defecto
      },
    );
  }

  // Construye la lista de proyectos
  Widget _buildProjectList(
      Stream<List<Project>> projects, BuildContext context) {
    return StreamBuilder<List<Project>>(
        stream: projects,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No hay proyectos disponibles'),
                TextButton(
                    onPressed: () => _showProjectFormDialog(context),
                    child: Text('Crear proyecto'))
              ],
            ));
          }

          return Stack(
            children: [
              ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final project = snapshot.data![index];
                  return ProjectCard(
                      project: project,
                      onEdit: () =>
                          _showProjectFormDialog(context, project: project),
                      onDelete: () => _deleteProject(context, project),
                      onStatusChanged: (status) => print(status));
                },
              ),
              Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                      onPressed: () => _showProjectFormDialog(context),
                      child: const Icon(Icons.add)))
            ],
          );
        });
  }

  void _showProjectFormDialog(BuildContext context, {Project? project}) {
    showDialog(
      context: context,
      builder: (context) => ProjectFormDialog(
        project: project,
        onSave: (project) {
          if (project is ProjectModel) {
            print('ID: ${project.id}');
            if (project.id == '') {
              context.read<ProjectBloc>().add(CreateProjectEvent(project));
            } else {
              context.read<ProjectBloc>().add(UpdateProjectEvent(project));
            }
          }
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _deleteProject(BuildContext context, Project project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text('Eliminar proyecto'),
        content:
            const Text('¿Estás seguro de que deseas eliminar este proyecto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<ProjectBloc>().add(DeleteProjectEvent(project.id));
              Navigator.of(context).pop();
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
