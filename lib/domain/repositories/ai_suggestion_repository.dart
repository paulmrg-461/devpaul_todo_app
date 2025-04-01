import 'package:devpaul_todo_app/data/models/ai_suggestion_model.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';

abstract class AiSuggestionRepository {
  Future<AiSuggestionModel> getTaskSuggestion(Task task);
}
