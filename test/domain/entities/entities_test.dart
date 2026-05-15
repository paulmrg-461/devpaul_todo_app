import 'package:flutter_test/flutter_test.dart';
import 'package:devpaul_todo_app/domain/entities/task_entity.dart';
import 'package:devpaul_todo_app/domain/entities/ai_suggestion_entity.dart';

void main() {
  group('Task entity', () {
    final task = Task(
      id: 'task-1',
      name: 'Test Task',
      description: 'A test task',
      priority: TaskPriority.medium,
      type: TaskType.work,
      startDate: DateTime(2026, 5, 1),
      dueDate: DateTime(2026, 5, 15),
      status: TaskStatus.pending,
      aiSuggestion: 'Initial suggestion',
      projectId: 'project-1',
    );

    test('task has all required fields', () {
      expect(task.id, equals('task-1'));
      expect(task.name, equals('Test Task'));
      expect(task.priority, equals(TaskPriority.medium));
      expect(task.status, equals(TaskStatus.pending));
    });

    test('task copyWith updates aiSuggestion', () {
      final updated = task.copyWith(aiSuggestion: 'Updated suggestion');

      expect(updated.aiSuggestion, equals('Updated suggestion'));
      expect(updated.name, equals(task.name));
    });

    test('task copyWith updates status', () {
      final updated = task.copyWith(status: TaskStatus.completed);

      expect(updated.status, equals(TaskStatus.completed));
      expect(updated.id, equals(task.id));
    });

    test('task copyWith preserves fields when no changes', () {
      final updated = task.copyWith();

      expect(updated, equals(task));
    });
  });

  group('AiSuggestion entity', () {
    test('creates with suggestion and createdAt', () {
      final now = DateTime.now();
      final suggestion = AiSuggestion(
        suggestion: '1. Do X\n2. Do Y\n3. Do Z',
        createdAt: now,
      );

      expect(suggestion.suggestion, contains('Do X'));
      expect(suggestion.createdAt, equals(now));
    });

    test('Entity equality works via Equatable', () {
      final now = DateTime(2026, 1, 1);
      final a = AiSuggestion(suggestion: 'Test', createdAt: now);
      final b = AiSuggestion(suggestion: 'Test', createdAt: now);

      expect(a, equals(b));
    });

    test('Entity equality fails for different content', () {
      final now = DateTime(2026, 1, 1);
      final a = AiSuggestion(suggestion: 'Test A', createdAt: now);
      final b = AiSuggestion(suggestion: 'Test B', createdAt: now);

      expect(a, isNot(equals(b)));
    });
  });
}
