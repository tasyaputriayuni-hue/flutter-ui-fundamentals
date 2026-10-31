import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;

  CourseProvider(this.repository);

  final Set<String> _favorites = <String>{};

  List<Course> _courses = [];
  bool _isLoading = false;
  String? _error;

  List<Course> get courses => List.unmodifiable(_courses);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Set<String> get favorites => Set.unmodifiable(_favorites);

  int get favoriteCount => _favorites.length;

  List<Course> get favoriteCourses {
    return _courses
        .where((course) => _favorites.contains(course.code))
        .toList();
  }

  bool isFavorite(String code) {
    return _favorites.contains(code);
  }

  Future<void> loadCourses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _courses = await repository.getCourses();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createCourse(Course course) async {
    try {
      final createdCourse = await repository.createCourse(course);
      _courses = [createdCourse, ..._courses];
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateCourse(int id, Course course) async {
    try {
      await repository.updateCourse(id, course);
      final index = _courses.indexWhere((item) => item.id == id);
      if (index >= 0) {
        final updated = List<Course>.from(_courses);
        updated[index] = course;
        _courses = updated;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteCourse(int id) async {
    try {
      await repository.deleteCourse(id);
      _courses = _courses.where((course) => course.id != id).toList();
      _favorites.removeWhere(
        (code) => !_courses.any((course) => course.code == code),
      );
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void toggleFavorite(String code) {
    if (_favorites.contains(code)) {
      _favorites.remove(code);
    } else {
      _favorites.add(code);
    }

    notifyListeners();
  }
}
