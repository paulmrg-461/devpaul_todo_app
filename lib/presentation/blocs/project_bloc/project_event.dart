// lib/presentation/blocs/project_bloc/project_event.dart
part of 'project_bloc.dart';

abstract class ProjectEvent extends Equatable {
  const ProjectEvent();

  @override
  List<Object> get props => [];
}

class GetProjectsEvent extends ProjectEvent {
  const GetProjectsEvent();
}

class GetProjectByIdEvent extends ProjectEvent {
  final String projectId;
  const GetProjectByIdEvent(this.projectId);
  @override
  List<Object> get props => [projectId];
}

class CreateProjectEvent extends ProjectEvent {
  final Project project;
  const CreateProjectEvent(this.project);
  @override
  List<Object> get props => [project];
}

class UpdateProjectEvent extends ProjectEvent {
  final Project project;
  const UpdateProjectEvent(this.project);
  @override
  List<Object> get props => [project];
}

class DeleteProjectEvent extends ProjectEvent {
  final String projectId;
  const DeleteProjectEvent(this.projectId);
  @override
  List<Object> get props => [projectId];
}

class AddUserToProjectEvent extends ProjectEvent {
  final String projectId;
  final String userId;
  const AddUserToProjectEvent(this.projectId, this.userId);
  @override
  List<Object> get props => [projectId, userId];
}

class RemoveUserFromProjectEvent extends ProjectEvent {
  final String projectId;
  final String userId;
  const RemoveUserFromProjectEvent(this.projectId, this.userId);
  @override
  List<Object> get props => [projectId, userId];
}

class AddTaskToProjectEvent extends ProjectEvent {
  final String projectId;
  final String taskId;
  const AddTaskToProjectEvent(this.projectId, this.taskId);
  @override
  List<Object> get props => [projectId, taskId];
}

class RemoveTaskFromProjectEvent extends ProjectEvent {
  final String projectId;
  final String taskId;
  const RemoveTaskFromProjectEvent(this.projectId, this.taskId);
  @override
  List<Object> get props => [projectId, taskId];
}
