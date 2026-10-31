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
  Future<Course> createCourse(Course course) async {
    final row = await supabase
        .from('courses')
        .insert(course.toJson())
        .select()
        .single()
        .timeout(const Duration(seconds: 15));

    return Course.fromJson(row);
  }

  @override
  Future<void> updateCourse(int id, Course course) async {
    await supabase
        .from('courses')
        .update(course.toJson())
        .eq('id', id)
        .timeout(const Duration(seconds: 15));
  }

  @override
  Future<void> deleteCourse(int id) {
    throw UnimplementedError('DELETE Supabase dikerjakan pada Tahap 15');
  }
}
