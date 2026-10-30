import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  CourseProvider(this._repository);

  final CourseRepository _repository;

  List<Course> _courses = [];
  bool _isLoading = false;
  String? _error;

  List<Course> get courses => List.unmodifiable(_courses);

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> loadCourses() async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _courses = await _repository.getCourses();
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String courseNameById(String courseId) {
    for (final course in _courses) {
      if (course.id?.toString() == courseId) {
        return course.title;
      }
    }

    return 'Mata Kuliah tidak ditemukan';
  }
}
