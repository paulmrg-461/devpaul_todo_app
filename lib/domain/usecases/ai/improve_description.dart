import 'package:devpaul_todo_app/domain/entities/ai_suggestion_entity.dart';
import 'package:devpaul_todo_app/domain/repositories/ai_suggestion_repository.dart';

class ImproveDescription {
  final AiSuggestionRepository repository;

  ImproveDescription(this.repository);

  Future<AiSuggestion> call(String description) async {
    return await repository.improveDescription(description);
  }
}
