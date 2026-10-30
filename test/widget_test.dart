import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:tuntas_kuliah/main.dart';

import 'package:tuntas_kuliah/providers/course_provider.dart';
import 'package:tuntas_kuliah/providers/task_provider.dart';

import 'package:tuntas_kuliah/repositories/course_repository.dart';
import 'package:tuntas_kuliah/repositories/task_repository.dart';

import 'package:tuntas_kuliah/services/in_memory_course_data_source.dart';
import 'package:tuntas_kuliah/services/in_memory_task_data_source.dart';

void main() {
  testWidgets('TuntasKuliah dashboard renders correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) =>
                CourseProvider(CourseRepository(InMemoryCourseDataSource()))
                  ..loadCourses(),
          ),
          ChangeNotifierProvider(
            create: (_) =>
                TaskProvider(TaskRepository(InMemoryTaskDataSource()))
                  ..loadTasks(),
          ),
        ],
        child: const TuntasKuliahApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('TuntasKuliah'), findsOneWidget);
    expect(find.text('Halo, Mahasiswa!'), findsOneWidget);
    expect(find.text('Tugas Minggu Ini'), findsOneWidget);
  });
}
