import 'package:tuntas_kuliah/models/course.dart';
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

    test('creates course successfully', () async {
      final provider = CourseProvider(
        CourseRepository(InMemoryCourseDataSource()),
      );

      await provider.loadCourses();

      final success = await provider.createCourse(
        const Course(
          code: 'IF210',
          title: 'Pemrograman Lanjut',
          credits: 3,
          status: 'planned',
        ),
      );

      expect(success, true);
      expect(provider.courses.length, 5);
      expect(provider.isCreating, false);
      expect(provider.createError, isNull);
    });

    test('updates course successfully', () async {
      final provider = CourseProvider(
        CourseRepository(InMemoryCourseDataSource()),
      );

      await provider.loadCourses();

      final originalCourse = provider.courses.first;

      final updatedCourse = originalCourse.copyWith(
        title: 'Pemrograman Mobile Revisi',
      );

      final success = await provider.updateCourse(updatedCourse);

      expect(success, true);
      expect(provider.courses.length, 4);
      expect(provider.isUpdating, false);
      expect(provider.updateError, isNull);
    });

    test('deletes course successfully', () async {
      final provider = CourseProvider(
        CourseRepository(InMemoryCourseDataSource()),
      );

      await provider.loadCourses();

      final courseId = provider.courses.first.id!;

      final success = await provider.deleteCourse(courseId);

      expect(success, true);
      expect(provider.courses.length, 3);
      expect(
        provider.courses.any(
          (course) => course.id == courseId,
        ),
        false,
      );
      expect(provider.isDeleting, false);
      expect(provider.deleteError, isNull);
    });
  });
}
