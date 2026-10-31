import '../models/course.dart';
import '../services/course_service.dart';

class CourseRepository {
  final CourseService courseService;

  CourseRepository(this.courseService);

  Future<List<Course>> getCourses() {
    return courseService.loadCourses();
  }

  Future<Course> createCourse(Course course) {
    return courseService.createCourse(course);
  }

  Future<Course> updateCourse(int id, Course course) {
    return courseService.updateCourse(id, course);
  }

  Future<void> deleteCourse(int id) {
    return courseService.deleteCourse(id);
  }
}
