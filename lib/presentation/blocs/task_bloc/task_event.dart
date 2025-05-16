part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class GetTasksEvent extends TaskEvent {
  const GetTasksEvent();
}

class CreateTaskEvent extends TaskEvent {
  final Task task;

  const CreateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTaskEvent extends TaskEvent {
  final Task task;

  const UpdateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTaskEvent extends TaskEvent {
  final Task task;

  const DeleteTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class GetTasksByProjectEvent extends TaskEvent {
  final String projectId;

  const GetTasksByProjectEvent(this.projectId);

  @override
  List<Object?> get props => [projectId];
}
