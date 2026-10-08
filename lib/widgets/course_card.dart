import 'package:flutter/material.dart';

import '../models/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    IconData statusIcon;
    String statusText;
    Color statusColor;

    if (course.status == 'done') {
      statusIcon = Icons.check_circle;
      statusText = 'Selesai';
      statusColor = Colors.green;
    } else if (course.status == 'active') {
      statusIcon = Icons.play_circle;
      statusText = 'Aktif';
      statusColor = Colors.blue;
    } else {
      statusIcon = Icons.schedule;
      statusText = 'Belum';
      statusColor = Colors.orange;
    }

    return Card(
      color: const Color(0xFFFFF8FF),
      child: ListTile(
        leading: Icon(statusIcon, color: statusColor),
        title: Text(course.title),
        subtitle: Text('${course.code} • ${course.credits} SKS'),
        trailing: Text(
          statusText,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: statusColor,
          ),
        ),
      ),
    );
  }
}
