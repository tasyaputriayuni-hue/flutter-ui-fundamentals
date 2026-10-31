import 'package:flutter/material.dart';
import 'models/course.dart';
import 'services/course_api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Explorer v2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CourseListScreen(),
    );
  }
}

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final CourseApiService _apiService =
      CourseApiService('https://jsonplaceholder.typicode.com');
  late Future<List<Course>> _futureCourses;

  @override
  void initState() {
    super.initState();
    _futureCourses = _apiService.getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Course (REST API)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<List<Course>>(
        future: _futureCourses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Terjadi Kesalahan: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Data course kosong'));
          }

          final courses = snapshot.data!;
          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return ListTile(
                title: Text(course.title),
                subtitle: Text(course.description ?? ''),
              );
            },
          );
        },
      ),
    );
  }
}