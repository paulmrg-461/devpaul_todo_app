import 'package:devpaul_todo_app/data/models/ai_suggestion_model.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/domain/repositories/ai_suggestion_repository.dart';

class GetTaskSuggestion {
  final AiSuggestionRepository repository;

  GetTaskSuggestion(this.repository);

  Future<AiSuggestionModel> call(Task task) async {
    return await repository.getTaskSuggestion(task);
  }
}
