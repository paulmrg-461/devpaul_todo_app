import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:equatable/equatable.dart';

class TaskMetrics extends Equatable {
  final int totalTasks;
  final int completedTasks;
  final int completedOnTime;
  final int completedLate;
  final int overdueTasks;
  final int pendingTasks;
  final int inProgressTasks;
  final double completionRate;
  final double onTimeRate;
  final double averageTaskDurationDays;
  final Map<TaskPriority, int> tasksByPriority;
  final Map<TaskType, int> tasksByType;
  final Map<TaskStatus, int> tasksByStatus;

  const TaskMetrics({
    required this.totalTasks,
    required this.completedTasks,
    required this.completedOnTime,
    required this.completedLate,
    required this.overdueTasks,
    required this.pendingTasks,
    required this.inProgressTasks,
    required this.completionRate,
    required this.onTimeRate,
    required this.averageTaskDurationDays,
    required this.tasksByPriority,
    required this.tasksByType,
    required this.tasksByStatus,
  });

  factory TaskMetrics.fromTasks(List<Task> tasks, {DateTime? now}) {
    final referenceDate = now ?? DateTime.now();

    if (tasks.isEmpty) {
      return const TaskMetrics(
        totalTasks: 0,
        completedTasks: 0,
        completedOnTime: 0,
        completedLate: 0,
        overdueTasks: 0,
        pendingTasks: 0,
        inProgressTasks: 0,
        completionRate: 0,
        onTimeRate: 0,
        averageTaskDurationDays: 0,
        tasksByPriority: {},
        tasksByType: {},
        tasksByStatus: {},
      );
    }

    final completed = tasks.where((t) => t.status == TaskStatus.completed).toList();
    final pending = tasks.where((t) => t.status == TaskStatus.pending).toList();
    final inProgress = tasks.where((t) => t.status == TaskStatus.inProgress).toList();

    final onTime = completed
        .where((t) => !t.dueDate.isBefore(referenceDate))
        .length;
    final late = completed.length - onTime;

    final overdue = [...pending, ...inProgress]
        .where((t) => t.dueDate.isBefore(referenceDate))
        .length;

    final avgDuration = completed.isEmpty
        ? 0.0
        : completed
            .map((t) => t.dueDate.difference(t.startDate).inHours / 24.0)
            .reduce((a, b) => a + b) / completed.length;

    final byPriority = <TaskPriority, int>{
      for (final p in TaskPriority.values) p: tasks.where((t) => t.priority == p).length,
    };
    final byType = <TaskType, int>{
      for (final type in TaskType.values)
        type: tasks.where((t) => t.type == type).length,
    };
    final byStatus = <TaskStatus, int>{
      for (final s in TaskStatus.values) s: tasks.where((t) => t.status == s).length,
    };

    return TaskMetrics(
      totalTasks: tasks.length,
      completedTasks: completed.length,
      completedOnTime: onTime,
      completedLate: late,
      overdueTasks: overdue,
      pendingTasks: pending.length,
      inProgressTasks: inProgress.length,
      completionRate: completed.length / tasks.length,
      onTimeRate: completed.isNotEmpty ? onTime / completed.length : 0,
      averageTaskDurationDays: avgDuration,
      tasksByPriority: byPriority,
      tasksByType: byType,
      tasksByStatus: byStatus,
    );
  }

  @override
  List<Object?> get props => [
        totalTasks,
        completedTasks,
        completedOnTime,
        completedLate,
        overdueTasks,
        pendingTasks,
        inProgressTasks,
        completionRate,
        onTimeRate,
        averageTaskDurationDays,
        tasksByPriority,
        tasksByType,
        tasksByStatus,
      ];
}
