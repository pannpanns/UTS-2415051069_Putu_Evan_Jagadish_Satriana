import 'package:flutter_test/flutter_test.dart';

import 'package:tuntas_kuliah/models/task.dart';
import 'package:tuntas_kuliah/providers/task_provider.dart';
import 'package:tuntas_kuliah/repositories/task_repository.dart';
import 'package:tuntas_kuliah/services/in_memory_task_data_source.dart';

void main() {
  group('TaskProvider', () {
    test('loads task data successfully', () async {
      final provider = TaskProvider(TaskRepository(InMemoryTaskDataSource()));

      await provider.loadTasks();

      expect(provider.isLoading, false);
      expect(provider.error, isNull);
      expect(provider.totalTasks, 3);
    });

    test('calculates task statistics correctly', () async {
      final provider = TaskProvider(TaskRepository(InMemoryTaskDataSource()));

      await provider.loadTasks();

      expect(provider.completedTasks, 0);
      expect(provider.inProgressTasks, 1);
      expect(provider.notStartedTasks, 2);
      expect(provider.completionRate, 0);
    });

    test('creates task successfully', () async {
      final provider = TaskProvider(TaskRepository(InMemoryTaskDataSource()));

      await provider.loadTasks();

      final success = await provider.createTask(
        Task(
          title: 'Tugas Baru',
          courseId: '1',
          deadline: DateTime(2026, 11, 10),
          priority: Task.priorityHigh,
        ),
      );

      expect(success, true);
      expect(provider.totalTasks, 4);
      expect(provider.tasks.any((task) => task.title == 'Tugas Baru'), true);
      expect(provider.isCreating, false);
      expect(provider.createError, isNull);
    });

    test('updates task and recalculates dashboard statistics', () async {
      final provider = TaskProvider(TaskRepository(InMemoryTaskDataSource()));

      await provider.loadTasks();

      final originalTask = provider.tasks.first;

      final updatedTask = originalTask.copyWith(
        title: 'Makalah Pemrograman Mobile Revisi',
        status: Task.statusCompleted,
        priority: Task.priorityLow,
      );

      final success = await provider.updateTask(updatedTask);

      expect(success, true);
      expect(provider.totalTasks, 3);
      expect(provider.completedTasks, 1);
      expect(provider.inProgressTasks, 0);
      expect(provider.notStartedTasks, 2);
      expect(provider.completionRate, closeTo(1 / 3, 0.001));
      expect(provider.isUpdating, false);
      expect(provider.updateError, isNull);

      final result = provider.tasks.firstWhere(
        (task) => task.id == originalTask.id,
      );

      expect(result.title, 'Makalah Pemrograman Mobile Revisi');
      expect(result.status, Task.statusCompleted);
      expect(result.priority, Task.priorityLow);
    });
  });
}
