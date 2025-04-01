part of 'ai_suggestion_bloc.dart';

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
