import 'package:flutter_test/flutter_test.dart';
import 'package:tuntas_kuliah/models/task.dart';

void main() {
  group('Task Model', () {
    test('parses JSON correctly', () {
      final task = Task.fromJson({
        'id': 'task-001',
        'title': 'Membuat Makalah',
        'course_id': 1,
        'deadline': '2026-11-02',
        'priority': 'Tinggi',
        'status': 'Dikerjakan',
      });

      expect(task.id, 'task-001');
      expect(task.title, 'Membuat Makalah');
      expect(task.courseId, '1');
      expect(task.deadline.day, 2);
      expect(task.priority, Task.priorityHigh);
      expect(task.status, Task.statusInProgress);
    });

    test('converts model to Supabase JSON', () {
      final task = Task(
        title: 'Laporan Praktikum',
        courseId: '2',
        deadline: DateTime(2026, 11, 4),
      );

      final json = task.toJson();

      expect(json['title'], 'Laporan Praktikum');
      expect(json['course_id'], 2);
      expect(json['deadline'], '2026-11-04');
      expect(json['priority'], 'Sedang');
      expect(json['status'], 'Belum Mulai');
      expect(json.containsKey('id'), false);
    });
  });
}
