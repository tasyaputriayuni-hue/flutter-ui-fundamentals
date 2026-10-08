import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/course.dart';

class CourseService {
  Future<List<Course>> loadCourses() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/student_data.json',
    );

    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    final coursesJson = data['courses'] as List<dynamic>;

    return coursesJson
        .map((course) => Course.fromJson(course as Map<String, dynamic>))
        .toList();
  }
}
