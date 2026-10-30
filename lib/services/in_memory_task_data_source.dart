import '../models/task.dart';
import 'task_data_source.dart';

class InMemoryTaskDataSource implements TaskDataSource {
  @override
  Future<List<Task>> getTasks() async {
    return [
      Task(
        id: 'task-001',
        title: 'Membuat Makalah',
        courseId: 'course-001',
        deadline: DateTime(2026, 11, 2),
        priority: Task.priorityHigh,
        status: Task.statusInProgress,
      ),
      Task(
        id: 'task-002',
        title: 'Laporan Praktikum',
        courseId: 'course-002',
        deadline: DateTime(2026, 11, 4),
        priority: Task.priorityMedium,
        status: Task.statusNotStarted,
      ),
      Task(
        id: 'task-003',
        title: 'Presentasi Individu',
        courseId: 'course-003',
        deadline: DateTime(2026, 11, 6),
        priority: Task.priorityLow,
        status: Task.statusNotStarted,
      ),
    ];
  }
}
