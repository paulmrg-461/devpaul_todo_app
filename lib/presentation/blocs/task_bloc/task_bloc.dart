// lib/presentation/blocs/task_bloc/task_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/domain/usecases/tasks/tasks_use_cases.dart';
import 'package:equatable/equatable.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final CreateTask createTaskUseCase;
  final GetTasks getTasksUseCase;
  final UpdateTask updateTaskUseCase;
  final DeleteTask deleteTaskUseCase;

  TaskBloc({
    required this.createTaskUseCase,
    required this.getTasksUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
  }) : super(TaskInitial()) {
    on<CreateTaskEvent>(_onCreateTask);
    on<GetTasksEvent>(_onGetTasks);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
  }

  Future<void> _onCreateTask(
      CreateTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await createTaskUseCase(event.task);
      add(GetTasksEvent());
    } catch (e) {
      emit(TaskError('Error creating task: $e'));
    }
  }

  Future<void> _onGetTasks(GetTasksEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await getTasksUseCase();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError('Error getting tasks: $e'));
    }
  }

  Future<void> _onUpdateTask(
      UpdateTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await updateTaskUseCase(event.task);
      add(GetTasksEvent());
    } catch (e) {
      emit(TaskError('Error updating task: $e'));
    }
  }

  Future<void> _onDeleteTask(
      DeleteTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await deleteTaskUseCase(event.taskId);
      add(GetTasksEvent());
    } catch (e) {
      emit(TaskError('Error deleting task: $e'));
    }
  }
}
