import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';
import '../utils/app_error_message.dart';

class CourseProvider extends ChangeNotifier {
  CourseProvider(this._repository);

  final CourseRepository _repository;

  List<Course> _courses = [];

  bool _isLoading = false;
  bool _isCreating = false;
  bool _isUpdating = false;
  bool _isDeleting = false;

  String? _error;
  String? _createError;
  String? _updateError;
  String? _deleteError;

  List<Course> get courses => List.unmodifiable(_courses);

  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  bool get isUpdating => _isUpdating;
  bool get isDeleting => _isDeleting;

  String? get error => _error;
  String? get createError => _createError;
  String? get updateError => _updateError;
  String? get deleteError => _deleteError;

  Future<void> loadCourses() async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _courses = await _repository.getCourses();
    } catch (error) {
      _error = AppErrorMessage.from(error);
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
    } catch (error) {
      _createError = AppErrorMessage.from(error);
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
    } catch (error) {
      _updateError = AppErrorMessage.from(error);
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  Future<bool> deleteCourse(int id) async {
    if (_isDeleting) return false;

    if (id <= 0) {
      _deleteError = 'ID mata kuliah tidak valid.';
      notifyListeners();
      return false;
    }

    _isDeleting = true;
    _deleteError = null;
    notifyListeners();

    try {
      await _repository.deleteCourse(id);

      _courses = _courses.where((course) => course.id != id).toList();

      _error = null;
      return true;
    } catch (error) {
      _deleteError = AppErrorMessage.from(error);
      return false;
    } finally {
      _isDeleting = false;
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
