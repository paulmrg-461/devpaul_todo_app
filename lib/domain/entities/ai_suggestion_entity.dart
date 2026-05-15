import 'package:equatable/equatable.dart';

class AiSuggestion extends Equatable {
  final String suggestion;
  final DateTime createdAt;

  const AiSuggestion({
    required this.suggestion,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [suggestion, createdAt];
}
