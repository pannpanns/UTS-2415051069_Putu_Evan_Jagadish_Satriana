import '../models/task.dart';
import '../services/task_data_source.dart';

class TaskRepository {
  TaskRepository(this.dataSource);

  final TaskDataSource dataSource;

  Future<List<Task>> getTasks() {
    return dataSource.getTasks();
  }

  Future<Task> createTask(Task task) {
    return dataSource.createTask(task);
  }

  Future<Task> updateTask(Task task) {
    return dataSource.updateTask(task);
  }
}
