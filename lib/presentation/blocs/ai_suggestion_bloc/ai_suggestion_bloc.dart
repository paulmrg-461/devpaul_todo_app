import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:devpaul_todo_app/domain/entities/ai_suggestion_entity.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/domain/usecases/ai/get_task_suggestion.dart';
import 'package:devpaul_todo_app/domain/usecases/ai/improve_description.dart';

part 'ai_suggestion_event.dart';
part 'ai_suggestion_state.dart';

class AiSuggestionBloc extends Bloc<AiSuggestionEvent, AiSuggestionState> {
  final GetTaskSuggestion getTaskSuggestionUseCase;
  final ImproveDescription improveDescriptionUseCase;

  AiSuggestionBloc({
    required this.getTaskSuggestionUseCase,
    required this.improveDescriptionUseCase,
  }) : super(AiSuggestionInitial()) {
    on<GetTaskSuggestionEvent>(_onGetTaskSuggestion);
    on<ImproveDescriptionEvent>(_onImproveDescription);
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
}
