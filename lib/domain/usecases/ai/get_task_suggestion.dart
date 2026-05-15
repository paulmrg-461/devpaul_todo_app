import 'package:devpaul_todo_app/domain/entities/ai_suggestion_entity.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/domain/repositories/ai_suggestion_repository.dart';

class GetTaskSuggestion {
  final AiSuggestionRepository repository;

  GetTaskSuggestion(this.repository);

  Future<AiSuggestion> call(Task task, {String? technology}) async {
    return await repository.getTaskSuggestion(task, technology: technology);
  }
}
