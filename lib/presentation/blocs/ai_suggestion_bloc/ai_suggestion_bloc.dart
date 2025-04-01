import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:devpaul_todo_app/data/models/ai_suggestion_model.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/domain/usecases/ai/get_task_suggestion.dart';

part 'ai_suggestion_event.dart';
part 'ai_suggestion_state.dart';

// Bloc
class AiSuggestionBloc extends Bloc<AiSuggestionEvent, AiSuggestionState> {
  final GetTaskSuggestion getTaskSuggestionUseCase;

  AiSuggestionBloc({
    required this.getTaskSuggestionUseCase,
  }) : super(AiSuggestionInitial()) {
    on<GetTaskSuggestionEvent>(_onGetTaskSuggestion);
  }

  Future<void> _onGetTaskSuggestion(
    GetTaskSuggestionEvent event,
    Emitter<AiSuggestionState> emit,
  ) async {
    emit(AiSuggestionLoading());
    try {
      final suggestion = await getTaskSuggestionUseCase(event.task);
      emit(AiSuggestionLoaded(suggestion));
    } catch (e) {
      emit(AiSuggestionError(e.toString()));
    }
  }
}
