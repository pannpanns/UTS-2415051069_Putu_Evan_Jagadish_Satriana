import '../models/course.dart';

abstract class CourseDataSource {
  Future<List<Course>> getCourses();
}

abstract class CourseWritableDataSource extends CourseDataSource {
  Future<Course> createCourse(Course course);

  Future<Course> updateCourse(Course course);
}
