import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/summary_card.dart';

const String studentName = 'Putu Tasya Putri Ayuni';
const String studentId = '2415051031';
const String studentSemester = 'Semester 5';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool showProfileDetails = true;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final courses = provider.courses;

    final completed = courses.where((course) => course.status == 'done').length;

    final totalCredits = courses.fold<int>(
      0,
      (total, course) => total + course.credits,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Home',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 4),

          const Text(
            'Ringkasan Course Explorer',
            style: TextStyle(color: Colors.black54),
          ),

          const SizedBox(height: 20),

          Center(
            child: SizedBox(
              width: 280,
              child: Card(
                color: const Color(0xFFFFF8FF),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 44,
                        backgroundImage: AssetImage(
                          'assets/images/profile.jpg',
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        studentName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      const Text(studentId, style: TextStyle(fontSize: 12)),

                      if (showProfileDetails) ...[
                        const SizedBox(height: 4),

                        const Text(
                          studentSemester,
                          style: TextStyle(fontSize: 11, color: Colors.black54),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Mahasiswa yang tertarik pada pemrograman mobile dan desain.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10),
                        ),
                      ],

                      const SizedBox(height: 8),

                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            showProfileDetails = !showProfileDetails;
                          });
                        },
                        icon: Icon(
                          showProfileDetails
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        label: Text(
                          showProfileDetails
                              ? 'Sembunyikan Detail'
                              : 'Tampilkan Detail',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Ringkasan Pembelajaran',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              SummaryCard(
                value: '${courses.length}',
                label: 'Course',
                icon: Icons.menu_book,
              ),
              SummaryCard(
                value: '$totalCredits',
                label: 'Total SKS',
                icon: Icons.school,
              ),
              SummaryCard(
                value: '$completed',
                label: 'Selesai',
                icon: Icons.check_circle,
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              SummaryCard(
                value: '${provider.favoriteCount}',
                label: 'Favorite',
                icon: Icons.favorite,
              ),
              const Spacer(),
              const Spacer(),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Course Explorer v2',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text('State Management: Provider'),
                Text('Data Flow: Provider → Repository → Service'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
