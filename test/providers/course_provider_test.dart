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

      expect(provider.courseNameById('1'), 'Pemrograman Mobile');
    });

    test('updates course successfully without changing its ID', () async {
      final provider = CourseProvider(
        CourseRepository(InMemoryCourseDataSource()),
      );

      await provider.loadCourses();

      final originalCourse = provider.courses.first;

      final updatedCourse = originalCourse.copyWith(
        title: 'Pemrograman Mobile Revisi',
        code: 'IF204',
      );

      final success = await provider.updateCourse(updatedCourse);

      expect(success, true);
      expect(provider.courses.length, 4);
      expect(provider.isUpdating, false);
      expect(provider.updateError, isNull);

      final result = provider.courses.firstWhere(
        (course) => course.id == originalCourse.id,
      );

      expect(result.id, originalCourse.id);
      expect(result.title, 'Pemrograman Mobile Revisi');
      expect(result.code, 'IF204');

      expect(provider.courseNameById('1'), 'Pemrograman Mobile Revisi');
    });
  });
}
