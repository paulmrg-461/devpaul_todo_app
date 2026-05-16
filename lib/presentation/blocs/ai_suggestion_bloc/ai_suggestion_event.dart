part of 'ai_suggestion_bloc.dart';

abstract class AiSuggestionEvent extends Equatable {
  const AiSuggestionEvent();

  @override
  List<Object?> get props => [];
}

class GetTaskSuggestionEvent extends AiSuggestionEvent {
  final Task task;
  final String? technology;

  const GetTaskSuggestionEvent(this.task, {this.technology});

  @override
  List<Object?> get props => [task, technology];
}

class ImproveDescriptionEvent extends AiSuggestionEvent {
  final String description;

  const ImproveDescriptionEvent(this.description);

  @override
  List<Object?> get props => [description];
}

class ImproveTaskEvent extends AiSuggestionEvent {
  final String name;
  final String description;

  const ImproveTaskEvent(this.name, this.description);

  @override
  List<Object?> get props => [name, description];
}
