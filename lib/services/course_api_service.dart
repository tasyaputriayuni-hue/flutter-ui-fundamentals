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
        code: 'Post #${post['id']}',
        title: _formatTitle(post['title'] as String),
        credits: post['userId'] as int,
        status: 'active',
      );
    }).toList();
  }

  Future<Course> createCourse(Course course) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': course.title,
        'body': course.code,
        'userId': course.credits,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Gagal membuat post');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return Course(
      id: data['id'] as int?,
      code: 'Post #${data['id']}',
      title: _formatTitle(data['title'] as String),
      credits: data['userId'] as int? ?? course.credits,
      status: 'active',
    );
  }

  String _formatTitle(String title) {
    if (title.isEmpty) return title;
    return title[0].toUpperCase() + title.substring(1);
  }
}
