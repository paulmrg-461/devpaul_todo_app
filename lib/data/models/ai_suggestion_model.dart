class AiSuggestionModel {
  final String suggestion;
  final DateTime createdAt;

  AiSuggestionModel({
    required this.suggestion,
    required this.createdAt,
  });

  factory AiSuggestionModel.fromJson(Map<String, dynamic> json) {
    return AiSuggestionModel(
      suggestion: json['suggestion'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'suggestion': suggestion,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
