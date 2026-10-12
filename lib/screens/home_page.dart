import 'package:flutter/material.dart';

import 'dashboard_page.dart';
import 'detail_page.dart';

const String studentName = 'Putu Tasya Putri Ayuni';
const String studentId = '2415051031';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(child: DashboardPage()),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.open_in_new),
                label: const Text('Buka Detail'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
