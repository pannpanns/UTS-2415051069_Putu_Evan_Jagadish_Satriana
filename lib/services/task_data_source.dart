import '../models/task.dart';

abstract class TaskDataSource {
  Future<List<Task>> getTasks();
}
