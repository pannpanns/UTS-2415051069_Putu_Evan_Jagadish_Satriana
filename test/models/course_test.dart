import 'package:flutter_test/flutter_test.dart';
import 'package:tuntas_kuliah/models/course.dart';

void main() {
  group('Course Model', () {
    test('parses JSON correctly', () {
      final course = Course.fromJson({
        'id': 'course-001',
        'name': 'Pemrograman Mobile',
        'code': 'IF204',
        'lecturer': 'Dosen Pengampu',
      });

      expect(course.id, 'course-001');
      expect(course.name, 'Pemrograman Mobile');
      expect(course.code, 'IF204');
      expect(course.lecturer, 'Dosen Pengampu');
    });

    test('converts model to JSON', () {
      const course = Course(
        name: 'Basis Data',
        code: 'IF202',
        lecturer: 'Dosen Pengampu',
      );

      final json = course.toJson();

      expect(json['name'], 'Basis Data');
      expect(json['code'], 'IF202');
      expect(json['lecturer'], 'Dosen Pengampu');
    });
  });
}
