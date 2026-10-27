import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course.dart';

class CourseApiService {
  final String baseUrl;

  CourseApiService(this.baseUrl);

  // 1. Method GET (Mengambil daftar course)
  Future<List<Course>> getCourses() async {
    final response = await http.get(Uri.parse('$baseUrl/courses'));
    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil course');
    }
    final List data = jsonDecode(response.body) as List;
    return data
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // 2. Method POST (Membuat course baru)
  Future<Course> createCourse(Course course) async {
    final response = await http.post(
      Uri.parse('$baseUrl/courses'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(course.toJson()),
    );
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Course.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }
    throw Exception('Gagal membuat course');
  }

  // 3. Method PUT (Memperbarui course berdasarkan ID)
  Future<void> updateCourse(int id, Course course) async {
    final response = await http.put(
      Uri.parse('$baseUrl/courses/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(course.toJson()),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Gagal memperbarui course');
    }
  }

  // 4. Method DELETE (Menghapus course berdasarkan ID) -> DITAMBAHKAN
  Future<void> deleteCourse(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/courses/$id'),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Gagal menghapus course');
    }
  }
}