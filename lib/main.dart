import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'screens/course_explorer_page.dart';
import 'services/course_api_service.dart';
import 'services/course_service.dart';

void main() {
  final apiService = CourseApiService('https://jsonplaceholder.typicode.com');

  runApp(
    ChangeNotifierProvider(
      create: (_) =>
          CourseProvider(CourseRepository(CourseService(apiService)))
            ..loadCourses(),
      child: const MyApp(),
    ),
  );
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
      home: const CourseExplorerPage(),
    );
  }
}
