import '../models/course.dart';
import '../services/course_data_source.dart';

class CourseRepository {
  CourseRepository(this.dataSource);

  final CourseDataSource dataSource;

  Future<List<Course>> getCourses() {
    return dataSource.getCourses();
  }

  Future<Course> createCourse(Course course) {
    return dataSource.createCourse(course);
  }
}
