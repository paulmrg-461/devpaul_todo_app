import 'package:devpaul_todo_app/domain/entities/ai_suggestion_entity.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';

abstract class AiSuggestionRepository {
  Future<AiSuggestion> getTaskSuggestion(Task task, {String? technology});
  Future<AiSuggestion> improveDescription(String description);
}
