import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/summary_card.dart';

import 'course_detail_page.dart';
import 'favorites_page.dart';

const String studentName = 'Putu Tasya Putri Ayuni';
const String studentId = '2415051031';
const String studentSemester = 'Semester 5';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // local state: hanya digunakan untuk mengatur
  // tampil/sembunyinya detail profil di DashboardPage.
  bool showProfileDetails = true;

  // reusable widget 1
  Widget buildSummaryCard(String value, String label, IconData icon) {
    return Expanded(
      child: Card(
        color: const Color(0xFFFFF8FF),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, size: 24),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FF),

      appBar: AppBar(
        title: const Text('Flutter UI Fundamentals'),
        backgroundColor: const Color(0xFFFFF7FF),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actions: [
          Consumer<CourseProvider>(
            builder: (context, provider, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      tooltip: 'Favorite Courses',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FavoritesPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.favorite),
                    ),
                    if (provider.favoriteCount > 0)
                      Positioned(
                        right: 2,
                        top: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.pink,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${provider.favoriteCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),

      body: Consumer<CourseProvider>(
        builder: (context, provider, child) {
          // loading state
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // error state
          if (provider.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'Gagal memuat data:\n${provider.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: provider.loadCourses,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final courses = provider.courses;

          if (courses.isEmpty) {
            return const Center(child: Text('Belum ada data course.'));
          }

          final int completed = courses
              .where((course) => course.status == 'done')
              .length;

          final int totalCredits = courses.fold<int>(
            0,
            (total, course) => total + course.credits,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // profile
                Center(
                  child: SizedBox(
                    width: 230,
                    child: Card(
                      elevation: 3,
                      color: const Color(0xFFFFF8FF),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
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

                            const Text(
                              studentId,
                              style: TextStyle(fontSize: 12),
                            ),

                            const SizedBox(height: 4),

                            if (showProfileDetails) ...[
                              const Text(
                                studentSemester,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black54,
                                ),
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
                                size: 18,
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

                // Row(
                //   children: [
                //     const Icon(Icons.info),
                //     const SizedBox(width: 8),
                //     Expanded(
                //       child: Text(
                //         '${student['nim']} - ${student['name']} - '
                //         'Ini adalah teks yang sangat panjang untuk menguji layout Flutter',
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 16),

                // summary

                // summary

                // summary
                const Text(
                  'Ringkasan Pembelajaran',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    SummaryCard(
                      value: '${courses.length}',
                      label: 'Jumlah Materi',
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

                // list materi
                const Text(
                  'Materi Pembelajaran',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 4),

                Text(
                  '$completed dari ${courses.length} materi selesai',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),

                const SizedBox(height: 8),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];

                    return CourseCard(
                      course: course,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CourseDetailPage(course: course),
                          ),
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 16),

                // informasi sumber data
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8FF),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.storage, size: 18),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Data dimuat dari assets/data/student_data.json',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
