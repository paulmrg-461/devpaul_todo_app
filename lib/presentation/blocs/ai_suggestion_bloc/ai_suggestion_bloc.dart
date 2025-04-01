import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:devpaul_todo_app/data/models/ai_suggestion_model.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/domain/usecases/ai/get_task_suggestion.dart';

// Eventos
abstract class AiSuggestionEvent extends Equatable {
  const AiSuggestionEvent();

  @override
  List<Object?> get props => [];
}

class GetTaskSuggestionEvent extends AiSuggestionEvent {
  final Task task;

  const GetTaskSuggestionEvent(this.task);

  @override
  List<Object?> get props => [task];
}

// Estados
abstract class AiSuggestionState extends Equatable {
  const AiSuggestionState();

  @override
  List<Object?> get props => [];
}

class AiSuggestionInitial extends AiSuggestionState {}

class AiSuggestionLoading extends AiSuggestionState {}

class AiSuggestionLoaded extends AiSuggestionState {
  final AiSuggestionModel suggestion;

  const AiSuggestionLoaded(this.suggestion);

  @override
  List<Object?> get props => [suggestion];
}

class AiSuggestionError extends AiSuggestionState {
  final String message;

  const AiSuggestionError(this.message);

  @override
  List<Object?> get props => [message];
}

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
