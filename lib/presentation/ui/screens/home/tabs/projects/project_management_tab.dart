import 'package:devpaul_todo_app/domain/entities/project_entity.dart';
import 'package:devpaul_todo_app/presentation/blocs/project_bloc/project_bloc.dart';
import 'package:devpaul_todo_app/presentation/ui/screens/home/tabs/projects/widgets/project_card.dart';
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
            return const Center(child: Text('No hay proyectos disponibles'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final project = snapshot.data![index];
              return ProjectCard(
                  project: project,
                  onEdit: () => {},
                  onDelete: () => {},
                  onStatusChanged: (status) => print(status));
            },
          );
        });
  }
}
