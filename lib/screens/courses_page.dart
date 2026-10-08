import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import 'course_detail_page.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final courses = provider.courses;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Daftar Course',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 4),

        Text(
          '${courses.length} course tersedia',
          style: const TextStyle(color: Colors.black54),
        ),

        const SizedBox(height: 16),

        ...courses.map(
          (course) => CourseCard(
            course: course,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CourseDetailPage(course: course),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
