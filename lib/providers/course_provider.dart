import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  CourseProvider(this._repository);

  final CourseRepository _repository;

  List<Course> _courses = [];

  bool _isLoading = false;
  bool _isCreating = false;
  bool _isUpdating = false;

  String? _error;
  String? _createError;
  String? _updateError;

  List<Course> get courses => List.unmodifiable(_courses);

  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  bool get isUpdating => _isUpdating;

  String? get error => _error;
  String? get createError => _createError;
  String? get updateError => _updateError;

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

      _courses = [..._courses, createdCourse];

      _courses.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));

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

  Future<bool> updateCourse(Course course) async {
    if (_isUpdating) return false;

    if (course.id == null) {
      _updateError = 'ID mata kuliah tidak valid.';
      notifyListeners();
      return false;
    }

    _isUpdating = true;
    _updateError = null;
    notifyListeners();

    try {
      final updatedCourse = await _repository.updateCourse(course);

      final index = _courses.indexWhere((item) => item.id == updatedCourse.id);

      if (index == -1) {
        throw StateError('Mata kuliah tidak ditemukan.');
      }

      _courses[index] = updatedCourse;

      _courses = List<Course>.from(_courses);

      _error = null;

      return true;
    } catch (e) {
      _updateError = e.toString().replaceFirst('Exception: ', '');

      return false;
    } finally {
      _isUpdating = false;
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
