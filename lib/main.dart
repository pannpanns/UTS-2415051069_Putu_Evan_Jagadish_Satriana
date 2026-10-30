import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'screens/main_navigation_screen.dart';

import 'providers/course_provider.dart';
import 'providers/task_provider.dart';

import 'repositories/course_repository.dart';
import 'repositories/task_repository.dart';

import 'services/course_api_service.dart';
import 'services/in_memory_task_data_source.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );

  final courseRepository = CourseRepository(CourseApiService());
  final taskRepository = TaskRepository(InMemoryTaskDataSource());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CourseProvider(courseRepository)..loadCourses(),
        ),
        ChangeNotifierProvider(
          create: (_) => TaskProvider(taskRepository)..loadTasks(),
        ),
      ],
      child: const TuntasKuliahApp(),
    ),
  );
}

class TuntasKuliahApp extends StatelessWidget {
  const TuntasKuliahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TuntasKuliah',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF3F8F4),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E8B57),
          primary: const Color(0xFF2E8B57),
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF3F8F4),
          foregroundColor: Color(0xFF25372B),
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: Color(0xFFE5F3E8),
          elevation: 0,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}
