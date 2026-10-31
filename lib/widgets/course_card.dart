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
    final statusText = course.status == 'done'
        ? 'Selesai'
        : course.status == 'active'
        ? 'Aktif'
        : 'Belum';
    final statusColor = course.status == 'done'
        ? Colors.green
        : course.status == 'active'
        ? Colors.blue
        : Colors.orange;
    final isFavorite = context.watch<CourseProvider>().isFavorite(course.code);

    return Card(
      color: const Color(0xFFFFF8FF),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.menu_book, color: statusColor),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${course.code} • ${course.credits} user • $statusText',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: isFavorite
                    ? 'Hapus dari favorite'
                    : 'Tambah ke favorite',
                onPressed: () {
                  context.read<CourseProvider>().toggleFavorite(course.code);
                },
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.pink : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
