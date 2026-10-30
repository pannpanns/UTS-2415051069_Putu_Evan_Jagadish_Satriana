import 'package:flutter_test/flutter_test.dart';

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

      expect(provider.courseNameById('course-001'), 'Pemrograman Mobile');
    });
  });
}
