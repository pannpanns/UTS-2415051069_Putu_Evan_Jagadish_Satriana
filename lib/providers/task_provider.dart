import 'package:flutter/foundation.dart';

import '../models/task.dart';
import '../repositories/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  TaskProvider(this._repository);

  final TaskRepository _repository;

  List<Task> _tasks = [];

  bool _isLoading = false;
  bool _isCreating = false;

  String? _error;
  String? _createError;

  List<Task> get tasks => List.unmodifiable(_tasks);

  bool get isLoading => _isLoading;

  bool get isCreating => _isCreating;

  String? get error => _error;

  String? get createError => _createError;

  int get totalTasks => _tasks.length;

  int get completedTasks =>
      _tasks.where((task) => task.status == Task.statusCompleted).length;

  int get inProgressTasks =>
      _tasks.where((task) => task.status == Task.statusInProgress).length;

  int get notStartedTasks =>
      _tasks.where((task) => task.status == Task.statusNotStarted).length;

  double get completionRate {
    if (_tasks.isEmpty) return 0;

    return completedTasks / totalTasks;
  }

  List<Task> get upcomingTasks {
    final result = List<Task>.from(_tasks);

    result.sort((a, b) => a.deadline.compareTo(b.deadline));

    return List.unmodifiable(result);
  }

  Future<void> loadTasks() async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tasks = await _repository.getTasks();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createTask(Task task) async {
    if (_isCreating) return false;

    _isCreating = true;
    _createError = null;
    notifyListeners();

    try {
      final createdTask = await _repository.createTask(task);

      final updatedTasks = [..._tasks, createdTask];

      updatedTasks.sort((a, b) => a.deadline.compareTo(b.deadline));

      _tasks = updatedTasks;
      _error = null;

      return true;
    } catch (e) {
      _createError = e.toString().replaceFirst('Exception: ', '');

      return false;
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }
}
