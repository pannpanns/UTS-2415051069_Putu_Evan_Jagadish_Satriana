import '../models/course.dart';
import 'course_data_source.dart';

class InMemoryCourseDataSource implements CourseDataSource {
  @override
  Future<List<Course>> getCourses() async {
    return const [
      Course(
        id: 'course-001',
        name: 'Pemrograman Mobile',
        code: 'IF204',
        lecturer: 'Dosen Pengampu',
      ),
      Course(
        id: 'course-002',
        name: 'Basis Data',
        code: 'IF202',
        lecturer: 'Dosen Pengampu',
      ),
      Course(
        id: 'course-003',
        name: 'Analisis Sistem',
        code: 'IF206',
        lecturer: 'Dosen Pengampu',
      ),
      Course(
        id: 'course-004',
        name: 'Rekayasa Perangkat Lunak',
        code: 'IF208',
        lecturer: 'Dosen Pengampu',
      ),
    ];
  }
}
