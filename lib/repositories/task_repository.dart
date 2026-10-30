import '../models/task.dart';
import '../services/task_data_source.dart';

class TaskRepository {
  TaskRepository(this.dataSource);

  final TaskDataSource dataSource;

  Future<List<Task>> getTasks() {
    return dataSource.getTasks();
  }
}
