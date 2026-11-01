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

  int _nextId = 4;

  @override
  Future<List<Task>> getTasks() async {
    return List.unmodifiable(_tasks);
  }

  @override
  Future<Task> createTask(Task task) async {
    final createdTask = task.copyWith(
      id: 'task-${_nextId.toString().padLeft(3, '0')}',
    );

    _nextId++;
    _tasks.add(createdTask);

    return createdTask;
  }
}
