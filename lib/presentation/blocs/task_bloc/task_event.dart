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

class GetTasksEvent extends TaskEvent {
  final String userId;
  const GetTasksEvent(this.userId);
  @override
  List<Object?> get props => [userId];
}

class UpdateTaskEvent extends TaskEvent {
  final Task task;
  const UpdateTaskEvent(this.task);
  @override
  List<Object?> get props => [task];
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;
  final String? userId;
  const DeleteTaskEvent(this.taskId, {this.userId});
  @override
  List<Object?> get props => [taskId, userId];
}
