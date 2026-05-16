import 'package:devpaul_todo_app/domain/entities/task_improvement_entity.dart';
import 'package:devpaul_todo_app/domain/repositories/ai_suggestion_repository.dart';

class ImproveTask {
  final AiSuggestionRepository repository;

  ImproveTask(this.repository);

  Future<TaskImprovement> call(String name, String description) async {
    return await repository.improveTask(name, description);
  }
}
