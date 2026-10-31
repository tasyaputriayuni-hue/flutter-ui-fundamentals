import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/course.dart';
import 'course_data_source.dart';

class CourseSupabaseService implements CourseDataSource {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Future<List<Course>> getCourses() async {
    final data = await supabase
        .from('courses')
        .select()
        .order('id')
        .timeout(const Duration(seconds: 15));

    return (data as List)
        .map((row) => Course.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Course> createCourse(Course course) {
    throw UnimplementedError('INSERT Supabase dikerjakan pada Tahap 13');
  }

  @override
  Future<void> updateCourse(int id, Course course) {
    throw UnimplementedError('UPDATE Supabase dikerjakan pada Tahap 14');
  }

  @override
  Future<void> deleteCourse(int id) {
    throw UnimplementedError('DELETE Supabase dikerjakan pada Tahap 15');
  }
}
