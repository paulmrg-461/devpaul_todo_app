// lib/presentation/blocs/task_bloc/task_bloc.dart
import 'package:devpaul_todo_app/domain/usecases/tasks/tasks_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:equatable/equatable.dart';
part 'task_event.dart';
part 'task_state.dart';

// Bloc
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasksUseCase;
  final CreateTask createTaskUseCase;
  final UpdateTask updateTaskUseCase;
  final DeleteTask deleteTaskUseCase;

  TaskBloc({
    required this.getTasksUseCase,
    required this.createTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
  }) : super(TaskInitial()) {
    on<GetTasksEvent>(_onGetTasks);
    on<CreateTaskEvent>(_onCreateTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
  }

  Future<void> _onGetTasks(
    GetTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      final tasks = await getTasksUseCase();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onCreateTask(
    CreateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await createTaskUseCase(event.task);
      add(GetTasksEvent());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await updateTaskUseCase(event.task);
      add(GetTasksEvent());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await deleteTaskUseCase(event.task.id);
      add(GetTasksEvent());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
