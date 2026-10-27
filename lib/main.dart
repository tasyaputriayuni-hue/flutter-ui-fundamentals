import 'package:flutter/material.dart';
import 'models/course.dart';
import 'services/course_api_service.dart';
import 'widgets/error_view.dart';

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
    _loadData();
  }

  void _loadData() {
    setState(() {
      _futureCourses = _apiService.getCourses();
    });
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
          // 1. Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } 
          // 2. Error State
          else if (snapshot.hasError) {
            return ErrorView(
              message: snapshot.error.toString(),
              onRetry: _loadData,
            );
          } 
          // 3. Empty State
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Data course belum tersedia'),
            );
          }

          // 4. Success State
          final courses = snapshot.data!;
          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text('${index + 1}'),
                ),
                title: Text(course.title),
                subtitle: Text('ID: ${course.id}'),
              );
            },
          );
        },
      ),
    );
  }
}