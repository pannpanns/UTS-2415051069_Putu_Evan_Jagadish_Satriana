import '../models/course.dart';

abstract class CourseDataSource {
  Future<List<Course>> getCourses();
}
