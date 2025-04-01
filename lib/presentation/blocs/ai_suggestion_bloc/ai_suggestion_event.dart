part of 'ai_suggestion_bloc.dart';

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
