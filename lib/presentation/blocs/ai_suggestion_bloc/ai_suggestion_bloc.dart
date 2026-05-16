import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:devpaul_todo_app/domain/entities/ai_suggestion_entity.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/domain/entities/task_improvement_entity.dart';
import 'package:devpaul_todo_app/domain/usecases/ai/get_task_suggestion.dart';
import 'package:devpaul_todo_app/domain/usecases/ai/improve_description.dart';
import 'package:devpaul_todo_app/domain/usecases/ai/improve_task.dart';

part 'ai_suggestion_event.dart';
part 'ai_suggestion_state.dart';

class AiSuggestionBloc extends Bloc<AiSuggestionEvent, AiSuggestionState> {
  final GetTaskSuggestion getTaskSuggestionUseCase;
  final ImproveDescription improveDescriptionUseCase;
  final ImproveTask improveTaskUseCase;

  AiSuggestionBloc({
    required this.getTaskSuggestionUseCase,
    required this.improveDescriptionUseCase,
    required this.improveTaskUseCase,
  }) : super(AiSuggestionInitial()) {
    on<GetTaskSuggestionEvent>(_onGetTaskSuggestion);
    on<ImproveDescriptionEvent>(_onImproveDescription);
    on<ImproveTaskEvent>(_onImproveTask);
  }

  Future<void> _onGetTaskSuggestion(
    GetTaskSuggestionEvent event,
    Emitter<AiSuggestionState> emit,
  ) async {
    emit(AiSuggestionLoading());
    try {
      final suggestion = await getTaskSuggestionUseCase(
        event.task,
        technology: event.technology,
      );
      emit(AiSuggestionLoaded(suggestion));
    } catch (e) {
      emit(AiSuggestionError(e.toString()));
    }
  }

  Future<void> _onImproveDescription(
    ImproveDescriptionEvent event,
    Emitter<AiSuggestionState> emit,
  ) async {
    emit(AiSuggestionLoading());
    try {
      final suggestion = await improveDescriptionUseCase(event.description);
      emit(AiSuggestionLoaded(suggestion));
    } catch (e) {
      emit(AiSuggestionError(e.toString()));
    }
  }

  Future<void> _onImproveTask(
    ImproveTaskEvent event,
    Emitter<AiSuggestionState> emit,
  ) async {
    emit(AiSuggestionLoading());
    try {
      final improvement =
          await improveTaskUseCase(event.name, event.description);
      emit(TaskImprovementLoaded(improvement));
    } catch (e) {
      emit(AiSuggestionError(e.toString()));
    }
  }
}
