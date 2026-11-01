import '../models/course.dart';
import 'course_data_source.dart';

class InMemoryCourseDataSource implements CourseWritableDataSource {
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

  @override
  Future<List<Course>> getCourses() async {
    return List<Course>.from(_courses);
  }

  @override
  Future<Course> createCourse(Course course) async {
    var nextId = 1;

    for (final item in _courses) {
      if (item.id != null && item.id! >= nextId) {
        nextId = item.id! + 1;
      }
    }

    final createdCourse = course.copyWith(id: nextId);

    _courses.add(createdCourse);

    return createdCourse;
  }

  @override
  Future<Course> updateCourse(Course course) async {
    if (course.id == null) {
      throw ArgumentError('ID mata kuliah tidak valid.');
    }

    final index = _courses.indexWhere((item) => item.id == course.id);

    if (index == -1) {
      throw StateError('Mata kuliah tidak ditemukan.');
    }

    _courses[index] = course;

    return course;
  }
}
