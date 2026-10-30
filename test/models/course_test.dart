import 'package:flutter_test/flutter_test.dart';
import 'package:tuntas_kuliah/models/course.dart';

void main() {
  group('Course Model', () {
    test('parses API JSON correctly', () {
      final course = Course.fromJson({
        'id': 1,
        'code': 'MOB01',
        'title': 'Git & GitHub',
        'credits': 2,
        'status': 'active',
      });

      expect(course.id, 1);
      expect(course.code, 'MOB01');
      expect(course.title, 'Git & GitHub');
      expect(course.credits, 2);
      expect(course.status, 'active');
    });

    test('converts Course model to JSON', () {
      const course = Course(
        id: 1,
        code: 'MOB01',
        title: 'Git & GitHub',
        credits: 2,
        status: 'active',
      );

      final json = course.toJson();

      expect(json['code'], 'MOB01');
      expect(json['title'], 'Git & GitHub');
      expect(json['credits'], 2);
      expect(json['status'], 'active');
      expect(json.containsKey('id'), false);
    });

    test('uses planned as default status', () {
      final course = Course.fromJson({
        'id': 2,
        'code': 'DB01',
        'title': 'Database',
        'credits': 3,
      });

      expect(course.status, 'planned');
    });
  });
}
