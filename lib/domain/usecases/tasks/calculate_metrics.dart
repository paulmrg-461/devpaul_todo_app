import 'package:devpaul_todo_app/domain/entities/task_metrics_entity.dart';
import 'package:devpaul_todo_app/domain/usecases/tasks/get_tasks.dart';

class CalculateMetrics {
  final GetTasks getTasks;

  CalculateMetrics(this.getTasks);

  Future<TaskMetrics> call() async {
    final tasks = await getTasks();
    return TaskMetrics.fromTasks(tasks);
  }
}
