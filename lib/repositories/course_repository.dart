import '../models/course.dart';
import '../services/course_data_source.dart';

class CourseRepository {
  CourseRepository(this.dataSource);

  final CourseDataSource dataSource;

  Future<List<Course>> getCourses() {
    return dataSource.getCourses();
  }

  Future<Course> createCourse(Course course) {
    final source = dataSource;

    if (source is! CourseWritableDataSource) {
      throw UnsupportedError('Sumber data tidak mendukung Create.');
    }

    return source.createCourse(course);
  }

  Future<Course> updateCourse(Course course) {
    final source = dataSource;

    if (source is! CourseWritableDataSource) {
      throw UnsupportedError('Sumber data tidak mendukung Update.');
    }

    return source.updateCourse(course);
  }
}
