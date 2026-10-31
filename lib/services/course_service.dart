import '../models/course.dart';
import 'course_api_service.dart';

class CourseService {
  final CourseApiService apiService;

  CourseService(this.apiService);

  Future<List<Course>> loadCourses() async {
    return apiService.getCourses();
  }

  Future<Course> createCourse(Course course) {
    return apiService.createCourse(course);
  }

  Future<Course> updateCourse(int id, Course course) {
    return apiService.updateCourse(id, course);
  }
}
