import '../models/course.dart';
import '../services/course_service.dart';

class CourseRepository {
  final CourseService courseService;

  CourseRepository(this.courseService);

  Future<List<Course>> getCourses() {
    return courseService.loadCourses();
  }
}
