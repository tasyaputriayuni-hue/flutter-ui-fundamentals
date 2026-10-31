import '../models/course.dart';

/// Contract for any backend that provides course CRUD operations.
abstract class CourseDataSource {
  Future<List<Course>> getCourses();

  Future<Course> createCourse(Course course);

  Future<void> updateCourse(int id, Course course);

  Future<void> deleteCourse(int id);
}
