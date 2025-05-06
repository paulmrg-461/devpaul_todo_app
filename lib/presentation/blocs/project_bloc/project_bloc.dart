// lib/presentation/blocs/project_bloc/project_bloc.dart
import 'package:devpaul_todo_app/domain/entities/project_entity.dart';
import 'package:devpaul_todo_app/domain/usecases/projects/project_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'project_event.dart';
part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final GetProjects getProjectsUseCase;
  final GetProjectById getProjectByIdUseCase;
  final CreateProject createProjectUseCase;
  final UpdateProject updateProjectUseCase;
  final DeleteProject deleteProjectUseCase;
  final AddUserToProject addUserToProjectUseCase;
  final RemoveUserFromProject removeUserFromProjectUseCase;
  final AddTaskToProject addTaskToProjectUseCase;
  final RemoveTaskFromProject removeTaskFromProjectUseCase;

  ProjectBloc({
    required this.getProjectsUseCase,
    required this.getProjectByIdUseCase,
    required this.createProjectUseCase,
    required this.updateProjectUseCase,
    required this.deleteProjectUseCase,
    required this.addUserToProjectUseCase,
    required this.removeUserFromProjectUseCase,
    required this.addTaskToProjectUseCase,
    required this.removeTaskFromProjectUseCase,
  }) : super(ProjectInitial()) {
    on<GetProjectsEvent>(_onGetProjects);
    on<GetProjectByIdEvent>(_onGetProjectById);
    on<CreateProjectEvent>(_onCreateProject);
    on<UpdateProjectEvent>(_onUpdateProject);
    on<DeleteProjectEvent>(_onDeleteProject);
    on<AddUserToProjectEvent>(_onAddUserToProject);
    on<RemoveUserFromProjectEvent>(_onRemoveUserFromProject);
    on<AddTaskToProjectEvent>(_onAddTaskToProject);
    on<RemoveTaskFromProjectEvent>(_onRemoveTaskFromProject);
  }

  Future<void> _onGetProjects(
    GetProjectsEvent event,
    Emitter<ProjectState> emit,
  ) async {
    emit(ProjectLoading());
    try {
      final projects = await getProjectsUseCase();
      emit(ProjectLoaded(projects));
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }

  Future<void> _onGetProjectById(
    GetProjectByIdEvent event,
    Emitter<ProjectState> emit,
  ) async {
    emit(ProjectLoading());
    try {
      final project = await getProjectByIdUseCase(event.projectId);
      if (project != null) {
        emit(SingleProjectLoaded(project));
      } else {
        emit(const ProjectError('Proyecto no encontrado'));
      }
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }

  Future<void> _onCreateProject(
    CreateProjectEvent event,
    Emitter<ProjectState> emit,
  ) async {
    // Podríamos emitir un estado de carga específico para la creación si es necesario
    try {
      await createProjectUseCase(event.project);
      emit(const ProjectOperationSuccess('Proyecto creado con éxito'));
      add(const GetProjectsEvent()); // Recargar la lista de proyectos
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }

  Future<void> _onUpdateProject(
    UpdateProjectEvent event,
    Emitter<ProjectState> emit,
  ) async {
    try {
      await updateProjectUseCase(event.project);
      emit(const ProjectOperationSuccess('Proyecto actualizado con éxito'));
      add(const GetProjectsEvent()); // Recargar la lista
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }

  Future<void> _onDeleteProject(
    DeleteProjectEvent event,
    Emitter<ProjectState> emit,
  ) async {
    try {
      await deleteProjectUseCase(event.projectId);
      emit(const ProjectOperationSuccess('Proyecto eliminado con éxito'));
      add(const GetProjectsEvent()); // Recargar la lista
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }

  Future<void> _onAddUserToProject(
    AddUserToProjectEvent event,
    Emitter<ProjectState> emit,
  ) async {
    try {
      await addUserToProjectUseCase(event.projectId, event.userId);
      emit(const ProjectOperationSuccess('Usuario añadido al proyecto'));
      // Opcionalmente, recargar el proyecto específico o la lista
      add(GetProjectByIdEvent(event.projectId));
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }

  Future<void> _onRemoveUserFromProject(
    RemoveUserFromProjectEvent event,
    Emitter<ProjectState> emit,
  ) async {
    try {
      await removeUserFromProjectUseCase(event.projectId, event.userId);
      emit(const ProjectOperationSuccess('Usuario eliminado del proyecto'));
      add(GetProjectByIdEvent(event.projectId));
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }

  Future<void> _onAddTaskToProject(
    AddTaskToProjectEvent event,
    Emitter<ProjectState> emit,
  ) async {
    try {
      await addTaskToProjectUseCase(event.projectId, event.taskId);
      emit(const ProjectOperationSuccess('Tarea añadida al proyecto'));
      add(GetProjectByIdEvent(event.projectId));
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }

  Future<void> _onRemoveTaskFromProject(
    RemoveTaskFromProjectEvent event,
    Emitter<ProjectState> emit,
  ) async {
    try {
      await removeTaskFromProjectUseCase(event.projectId, event.taskId);
      emit(const ProjectOperationSuccess('Tarea eliminada del proyecto'));
      add(GetProjectByIdEvent(event.projectId));
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }
}
