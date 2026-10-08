import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

const String studentName = 'Putu Tasya Putri Ayuni';
const String studentId = '2415051031';

Future<Map<String, dynamic>> loadStudentData() async {
  final jsonString = await rootBundle.loadString(
    'assets/data/student_data.json',
  );

  return jsonDecode(jsonString) as Map<String, dynamic>;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Map<String, dynamic>> studentFuture;

  // local state: hanya digunakan untuk mengatur
  // tampil/sembunyinya detail profil di DashboardPage.
  bool showProfileDetails = true;

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

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

  // reusable widget 2
  Widget buildCourseCard(Map<String, dynamic> course) {
    final String status = course['status'] as String;

    IconData statusIcon;
    String statusText;
    Color statusColor;

    if (status == 'done') {
      statusIcon = Icons.check_circle;
      statusText = 'Selesai';
      statusColor = Colors.green;
    } else if (status == 'active') {
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
        title: Text(course['title'] as String),
        subtitle: Text('${course['code']} • ${course['credits']} SKS'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FF),

      appBar: AppBar(
        title: const Text('Flutter UI Fundamentals'),
        backgroundColor: const Color(0xFFFFF7FF),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),

      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,
        builder: (context, snapshot) {
          // loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // error state
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Gagal memuat data: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final data = snapshot.data!;

          final student = data['student'] as Map<String, dynamic>;

          final courses = data['courses'] as List<dynamic>;

          final int completed = courses
              .where(
                (course) =>
                    (course as Map<String, dynamic>)['status'] == 'done',
              )
              .length;

          final int totalCredits = courses.fold<int>(
            0,
            (total, course) =>
                total + ((course as Map<String, dynamic>)['credits'] as int),
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

                            Text(
                              student['name'] as String,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              student['nim'] as String,
                              style: const TextStyle(fontSize: 12),
                            ),

                            const SizedBox(height: 4),

                            if (showProfileDetails) ...[
                              Text(
                                student['semester'] as String,
                                style: const TextStyle(
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

                const FavoriteSection(),

                const SizedBox(height: 16),

                const FavoriteCounterSection(),

                const SizedBox(height: 16),

                // summary

                // summary
                const Text(
                  'Ringkasan Pembelajaran',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    buildSummaryCard(
                      '${courses.length}',
                      'Jumlah Materi',
                      Icons.menu_book,
                    ),

                    buildSummaryCard(
                      '$totalCredits',
                      'Total SKS',
                      Icons.school,
                    ),

                    buildSummaryCard(
                      '$completed',
                      'Selesai',
                      Icons.check_circle,
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
                    final course = courses[index] as Map<String, dynamic>;

                    return buildCourseCard(course);
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

class FavoriteSection extends StatefulWidget {
  const FavoriteSection({super.key});

  @override
  State<FavoriteSection> createState() => _FavoriteSectionState();
}

class _FavoriteSectionState extends State<FavoriteSection> {
  // Single source of truth untuk favorite.
  // Dua child membaca nilai yang sama dari parent ini.
  bool isFavorite = false;

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Eksperimen Single Source of Truth',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        FavoriteStatusCard(isFavorite: isFavorite),

        const SizedBox(height: 8),

        FavoriteActionCard(isFavorite: isFavorite, onToggle: toggleFavorite),
      ],
    );
  }
}

class FavoriteCounterSection extends StatefulWidget {
  const FavoriteCounterSection({super.key});

  @override
  State<FavoriteCounterSection> createState() => _FavoriteCounterSectionState();
}

class _FavoriteCounterSectionState extends State<FavoriteCounterSection> {
  final ValueNotifier<int> favoriteCount = ValueNotifier<int>(0);

  @override
  void dispose() {
    favoriteCount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFF8FF),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Eksperimen ValueNotifier',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            ValueListenableBuilder<int>(
              valueListenable: favoriteCount,
              builder: (context, value, child) {
                return Text(
                  'Jumlah favorite sementara: $value',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),

            const SizedBox(height: 8),

            ElevatedButton.icon(
              onPressed: () {
                favoriteCount.value++;
              },
              icon: const Icon(Icons.add),
              label: const Text('Tambah Favorite'),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteStatusCard extends StatelessWidget {
  final bool isFavorite;

  const FavoriteStatusCard({super.key, required this.isFavorite});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFF8FF),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.pink : Colors.grey,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isFavorite
                    ? 'Status favorit: Dipilih'
                    : 'Status favorit: Belum dipilih',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteActionCard extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onToggle;

  const FavoriteActionCard({
    super.key,
    required this.isFavorite,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFF8FF),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                isFavorite
                    ? 'Course sudah menjadi favorit'
                    : 'Course belum menjadi favorit',
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: onToggle,
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
              tooltip: 'Toggle favorite',
            ),
          ],
        ),
      ),
    );
  }
}
