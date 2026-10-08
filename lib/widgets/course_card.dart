import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback? onTap;

  const CourseCard({super.key, required this.course, this.onTap});

  @override
  Widget build(BuildContext context) {
    String statusText;
    Color statusColor;

    if (course.status == 'done') {
      statusText = 'Selesai';
      statusColor = Colors.green;
    } else if (course.status == 'active') {
      statusText = 'Aktif';
      statusColor = Colors.blue;
    } else {
      statusText = 'Belum';
      statusColor = Colors.orange;
    }

    final provider = context.watch<CourseProvider>();
    final isFavorite = provider.isFavorite(course.code);

    return Card(
      color: const Color(0xFFFFF8FF),
      child: ListTile(
        onTap: onTap,
        leading: Icon(Icons.menu_book, color: statusColor),
        title: Text(course.title),
        subtitle: Text('${course.code} • ${course.credits} SKS • $statusText'),
        trailing: IconButton(
          tooltip: isFavorite ? 'Hapus dari favorite' : 'Tambah ke favorite',
          onPressed: () {
            context.read<CourseProvider>().toggleFavorite(course.code);
          },
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.pink : Colors.grey,
          ),
        ),
      ),
    );
  }
}
