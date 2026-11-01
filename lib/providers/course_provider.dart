import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  CourseProvider(this._repository);

  final CourseRepository _repository;

  List<Course> _courses = [];

  bool _isLoading = false;
  bool _isCreating = false;

  String? _error;
  String? _createError;

  List<Course> get courses => List.unmodifiable(_courses);

  bool get isLoading => _isLoading;

  bool get isCreating => _isCreating;

  String? get error => _error;

  String? get createError => _createError;

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

  Future<bool> createCourse(Course course) async {
    if (_isCreating) return false;

    _isCreating = true;
    _createError = null;
    notifyListeners();

    try {
      final createdCourse = await _repository.createCourse(course);

      final updatedCourses = [..._courses, createdCourse];

      updatedCourses.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));

      _courses = updatedCourses;
      _error = null;

      return true;
    } catch (e) {
      _createError = e.toString().replaceFirst('Exception: ', '');

      return false;
    } finally {
      _isCreating = false;
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
