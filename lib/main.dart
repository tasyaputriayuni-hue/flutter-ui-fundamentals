import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'screens/course_explorer_page.dart';
import 'services/course_supabase_service.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SupabaseBootstrapApp());
}

class SupabaseBootstrapApp extends StatefulWidget {
  const SupabaseBootstrapApp({super.key});

  @override
  State<SupabaseBootstrapApp> createState() => _SupabaseBootstrapAppState();
}

class _SupabaseBootstrapAppState extends State<SupabaseBootstrapApp> {
  late final Future<void> _initialization = _initializeSupabase();

  Future<void> _initializeSupabase() async {
    await Supabase.initialize(
      url: 'https://ebpnfhozjjtrxvcwahbp.supabase.co',
      publishableKey: 'sb_publishable_tiBe9vzG3jt4b3eY0J9o_g_mz7veTnp',
    ).timeout(const Duration(seconds: 15));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.cloud_off, size: 56),
                      const SizedBox(height: 12),
                      const Text(
                        'Supabase gagal diinisialisasi.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Periksa koneksi internet lalu jalankan ulang aplikasi.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        final dataSource = CourseSupabaseService();
        return ChangeNotifierProvider(
          create: (_) =>
              CourseProvider(CourseRepository(dataSource))..loadCourses(),
          child: const MyApp(),
        );
      },
    );
  }
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
