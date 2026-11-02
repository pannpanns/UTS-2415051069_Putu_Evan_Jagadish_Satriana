import 'package:flutter/foundation.dart';

import '../models/task.dart';
import '../repositories/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  TaskProvider(this._repository);

  final TaskRepository _repository;

  List<Task> _tasks = [];

  bool _isLoading = false;
  bool _isCreating = false;
  bool _isUpdating = false;
  bool _isDeleting = false;

  String? _error;
  String? _createError;
  String? _updateError;
  String? _deleteError;

  List<Task> get tasks => List.unmodifiable(_tasks);

  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  bool get isUpdating => _isUpdating;
  bool get isDeleting => _isDeleting;

  String? get error => _error;
  String? get createError => _createError;
  String? get updateError => _updateError;
  String? get deleteError => _deleteError;

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

      _tasks = [..._tasks, createdTask];

      _tasks.sort((a, b) => a.deadline.compareTo(b.deadline));

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

  Future<bool> updateTask(Task task) async {
    if (_isUpdating) return false;

    final taskId = task.id;

    if (taskId == null || taskId.isEmpty) {
      _updateError = 'ID tugas tidak valid.';
      notifyListeners();
      return false;
    }

    _isUpdating = true;
    _updateError = null;
    notifyListeners();

    try {
      final updatedTask = await _repository.updateTask(task);

      final index = _tasks.indexWhere((item) => item.id == updatedTask.id);

      if (index == -1) {
        throw StateError('Tugas tidak ditemukan.');
      }

      _tasks[index] = updatedTask;

      _tasks.sort((a, b) => a.deadline.compareTo(b.deadline));

      _error = null;

      return true;
    } catch (e) {
      _updateError = e.toString().replaceFirst('Exception: ', '');

      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  Future<bool> deleteTask(String id) async {
    if (_isDeleting) return false;

    if (id.isEmpty) {
      _deleteError = 'ID tugas tidak valid.';
      notifyListeners();
      return false;
    }

    _isDeleting = true;
    _deleteError = null;
    notifyListeners();

    try {
      await _repository.deleteTask(id);

      _tasks = _tasks.where((task) => task.id != id).toList();

      _error = null;

      return true;
    } catch (e) {
      _deleteError = e.toString().replaceFirst('Exception: ', '');

      return false;
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
  }
}
