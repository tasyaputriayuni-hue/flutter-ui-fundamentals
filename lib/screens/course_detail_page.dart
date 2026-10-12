import 'package:flutter/material.dart';

const String studentName = 'Putu Tasya Putri Ayuni';
const String studentId = '2415051031';

class CourseDetailPage extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final code = course['code'] as String;
    final status = course['status'];
    final statusText = status == 'done'
        ? 'Selesai'
        : status == 'active'
            ? 'Aktif'
            : 'Belum';

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FF),
      appBar: AppBar(
        title: const Text('Detail Course'),
        backgroundColor: const Color(0xFFFFF7FF),
        surfaceTintColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: const Color(0xFFFFF8FF),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('$studentId - $studentName', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                Text(course['title'] as String, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text('Kode: $code'),
                const SizedBox(height: 8),
                Text('SKS: ${course['credits']}'),
                const SizedBox(height: 8),
                Text('Status: $statusText'),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context, true),
                    icon: const Icon(Icons.favorite_border),
                    label: const Text('Pilih / Favorite'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
