import '../models/course.dart';
import 'course_data_source.dart';

class InMemoryCourseDataSource implements CourseDataSource {
  @override
  Future<List<Course>> getCourses() async {
    return const [
      Course(
        id: 1,
        code: 'IF204',
        title: 'Pemrograman Mobile',
        credits: 3,
        status: 'active',
      ),
      Course(
        id: 2,
        code: 'IF202',
        title: 'Basis Data',
        credits: 3,
        status: 'active',
      ),
      Course(
        id: 3,
        code: 'IF206',
        title: 'Analisis Sistem',
        credits: 3,
        status: 'planned',
      ),
      Course(
        id: 4,
        code: 'IF208',
        title: 'Rekayasa Perangkat Lunak',
        credits: 3,
        status: 'done',
      ),
    ];
  }
}
