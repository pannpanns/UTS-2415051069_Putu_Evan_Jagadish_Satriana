import '../models/course.dart';
import 'course_data_source.dart';

class InMemoryCourseDataSource implements CourseDataSource {
  final List<Course> _courses = [
    const Course(
      id: 1,
      code: 'IF204',
      title: 'Pemrograman Mobile',
      credits: 3,
      status: 'active',
    ),
    const Course(
      id: 2,
      code: 'IF202',
      title: 'Basis Data',
      credits: 3,
      status: 'active',
    ),
    const Course(
      id: 3,
      code: 'IF206',
      title: 'Analisis Sistem',
      credits: 3,
      status: 'planned',
    ),
    const Course(
      id: 4,
      code: 'IF208',
      title: 'Rekayasa Perangkat Lunak',
      credits: 3,
      status: 'done',
    ),
  ];

  int _nextId = 5;

  @override
  Future<List<Course>> getCourses() async {
    return List.unmodifiable(_courses);
  }

  @override
  Future<Course> createCourse(Course course) async {
    final createdCourse = course.copyWith(id: _nextId);

    _nextId++;
    _courses.add(createdCourse);

    return createdCourse;
  }
}
