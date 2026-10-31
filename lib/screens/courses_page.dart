import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import 'course_detail_page.dart';

const String studentName = 'Putu Tasya Putri Ayuni';
const String studentId = '2415051031';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  bool isNavigating = false;

  int columnsFor(double width) {
    if (width < 600) return 1;
    if (width < 840) return 2;
    return 3;
  }

  Future<void> openCourseDetail(
    BuildContext context,
    Course course,
    Map<String, dynamic> courseData,
  ) async {
    if (isNavigating) return;

    setState(() => isNavigating = true);

    try {
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (_) => CourseDetailPage(course: courseData)),
      );

      if (result == true && context.mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('${course.title} dipilih sebagai favorite.'),
            ),
          );

        final courseProvider = context.read<CourseProvider>();
        if (!courseProvider.isFavorite(course.code)) {
          courseProvider.toggleFavorite(course.code);
        }
      }
    } finally {
      if (mounted) setState(() => isNavigating = false);
    }
  }

  void _showAddCourseDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final codeController = TextEditingController();
    final titleController = TextEditingController();
    final creditsController = TextEditingController(text: '1');
    var isSaving = false;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> save() async {
              if (!formKey.currentState!.validate()) return;
              setDialogState(() => isSaving = true);

              final course = Course(
                code: codeController.text.trim(),
                title: titleController.text.trim(),
                credits: int.parse(creditsController.text),
                status: 'active',
              );
              final success = await context.read<CourseProvider>().createCourse(
                course,
              );

              if (!dialogContext.mounted) return;
              if (success) {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(content: Text('Post berhasil dibuat.')),
                );
              } else {
                setDialogState(() => isSaving = false);
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(content: Text('Gagal membuat post.')),
                );
              }
            }

            return AlertDialog(
              title: const Text('Tambah Post'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: codeController,
                        decoration: const InputDecoration(
                          labelText: 'Code / Body',
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Code wajib diisi'
                            : null,
                      ),
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'Judul'),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Judul wajib diisi'
                            : null,
                      ),
                      TextFormField(
                        controller: creditsController,
                        decoration: const InputDecoration(labelText: 'User ID'),
                        keyboardType: TextInputType.number,
                        validator: (value) => int.tryParse(value ?? '') == null
                            ? 'User ID harus berupa angka'
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSaving
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: isSaving ? null : save,
                  child: isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final courses = provider.courses;

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = columnsFor(constraints.maxWidth);

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.person_outline),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              studentName,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'NIM: $studentId',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Daftar Course',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () => _showAddCourseDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah'),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${courses.length} course tersedia • $columns kolom',
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 128,
                  ),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    final courseData = <String, dynamic>{
                      'title': course.title,
                      'code': course.code,
                      'credits': course.credits,
                      'status': course.status,
                    };

                    return CourseCard(
                      course: course,
                      onTap: () =>
                          openCourseDetail(context, course, courseData),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
