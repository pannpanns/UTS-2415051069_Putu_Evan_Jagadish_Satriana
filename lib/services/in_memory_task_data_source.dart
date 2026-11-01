import '../models/task.dart';
import 'task_data_source.dart';

class InMemoryTaskDataSource implements TaskDataSource {
  final List<Task> _tasks = [
    Task(
      id: 'task-001',
      title: 'Membuat Makalah',
      courseId: '1',
      deadline: DateTime(2026, 11, 2),
      priority: Task.priorityHigh,
      status: Task.statusInProgress,
    ),
    Task(
      id: 'task-002',
      title: 'Laporan Praktikum',
      courseId: '2',
      deadline: DateTime(2026, 11, 4),
      priority: Task.priorityMedium,
      status: Task.statusNotStarted,
    ),
    Task(
      id: 'task-003',
      title: 'Presentasi Individu',
      courseId: '3',
      deadline: DateTime(2026, 11, 6),
      priority: Task.priorityLow,
      status: Task.statusNotStarted,
    ),
  ];

  @override
  Future<List<Task>> getTasks() async {
    return List<Task>.from(_tasks);
  }

  @override
  Future<Task> createTask(Task task) async {
    final createdTask = task.copyWith(
      id: task.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
    );

    _tasks.add(createdTask);

    return createdTask;
  }

  @override
  Future<Task> updateTask(Task task) async {
    final taskId = task.id;

    if (taskId == null || taskId.isEmpty) {
      throw ArgumentError('ID tugas tidak valid.');
    }

    final index = _tasks.indexWhere((item) => item.id == taskId);

    if (index == -1) {
      throw StateError('Tugas tidak ditemukan.');
    }

    _tasks[index] = task;

    return task;
  }
}
