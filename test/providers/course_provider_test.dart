import 'package:flutter_test/flutter_test.dart';

import 'package:tuntas_kuliah/models/course.dart';
import 'package:tuntas_kuliah/providers/course_provider.dart';
import 'package:tuntas_kuliah/repositories/course_repository.dart';
import 'package:tuntas_kuliah/services/in_memory_course_data_source.dart';

void main() {
  group('CourseProvider', () {
    test('loads course data successfully', () async {
      final provider = CourseProvider(
        CourseRepository(InMemoryCourseDataSource()),
      );

      await provider.loadCourses();

      expect(provider.isLoading, false);
      expect(provider.error, isNull);
      expect(provider.courses.length, 4);
    });

    test('finds course name using course ID', () async {
      final provider = CourseProvider(
        CourseRepository(InMemoryCourseDataSource()),
      );

      await provider.loadCourses();

      expect(provider.courseNameById('1'), 'Pemrograman Mobile');
    });

    test('creates course successfully', () async {
      final provider = CourseProvider(
        CourseRepository(InMemoryCourseDataSource()),
      );

      await provider.loadCourses();

      final success = await provider.createCourse(
        const Course(
          code: 'IF210',
          title: 'Pemrograman Web',
          credits: 3,
          status: 'planned',
        ),
      );

      expect(success, true);
      expect(provider.courses.length, 5);
      expect(provider.courses.any((course) => course.code == 'IF210'), true);
      expect(provider.isCreating, false);
    });
  });
}
