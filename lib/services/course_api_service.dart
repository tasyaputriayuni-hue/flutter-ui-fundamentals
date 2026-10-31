import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/course.dart';

class CourseApiService {
  final String baseUrl;

  CourseApiService(this.baseUrl);

  Future<List<Course>> getCourses() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));
    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil course');
    }
    final List data = jsonDecode(response.body) as List;
    return data.map((e) {
      final post = e as Map<String, dynamic>;
      return Course(
        code: 'POST-${post['id']}',
        title: post['title'] as String,
        credits: post['userId'] as int,
        status: 'active',
      );
    }).toList();
  }
}
