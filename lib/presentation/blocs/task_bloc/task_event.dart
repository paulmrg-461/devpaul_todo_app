// lib/presentation/blocs/task_bloc/task_event.dart
part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();
  @override
  List<Object?> get props => [];
}

class CreateTaskEvent extends TaskEvent {
  final Task task;
  const CreateTaskEvent(this.task);
  @override
  List<Object?> get props => [task];
}

class GetTasksEvent extends TaskEvent {}

class UpdateTaskEvent extends TaskEvent {
  final Task task;
  const UpdateTaskEvent(this.task);
  @override
  List<Object?> get props => [task];
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;
  const DeleteTaskEvent(this.taskId);
  @override
  List<Object?> get props => [taskId];
}
