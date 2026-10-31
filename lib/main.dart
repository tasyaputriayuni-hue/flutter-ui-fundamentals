import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'screens/course_explorer_page.dart';
import 'services/course_api_service.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final apiService = CourseApiService('https://jsonplaceholder.typicode.com');

  await Supabase.initialize(
    url: 'https://ebpnfhozjjtrxvcwahbp.supabase.co',
    publishableKey: 'sb_publishable_tiBe9vzG3jt4b3eY0J9o_g_mz7veTnp',
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) =>
          CourseProvider(CourseRepository(apiService))..loadCourses(),
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
