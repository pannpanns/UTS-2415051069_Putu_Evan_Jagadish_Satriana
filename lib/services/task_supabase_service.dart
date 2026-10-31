import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/task.dart';
import 'task_data_source.dart';

class TaskSupabaseService implements TaskDataSource {
  TaskSupabaseService({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<List<Task>> getTasks() async {
    final data = await _client.from('tasks').select().order('deadline');

    return data.map((row) => Task.fromJson(row)).toList();
  }
}
