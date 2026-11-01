import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/error_view.dart';
import 'edit_course_screen.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  static const List<IconData> _icons = [
    Icons.phone_android,
    Icons.storage_outlined,
    Icons.account_tree_outlined,
    Icons.code,
  ];

  static const List<Color> _colors = [
    Color(0xFF2E8B57),
    Color(0xFF3976A8),
    Color(0xFFC17A1B),
    Color(0xFF8270AA),
  ];

  String _statusLabel(String status) {
    switch (status) {
      case 'active':
        return 'Aktif';
      case 'done':
        return 'Selesai';
      default:
        return 'Direncanakan';
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'active':
        return const Color(0xFF2E8B57);
      case 'done':
        return const Color(0xFF3976A8);
      default:
        return const Color(0xFFC17A1B);
    }
  }

  Future<void> _openEditCourse(BuildContext context, Course course) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => EditCourseScreen(course: course)),
    );

    if (!context.mounted) return;

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mata kuliah berhasil diperbarui.'),
          backgroundColor: Color(0xFF2E8B57),
        ),
      );
    }
  }

  Widget _buildCourseCard(BuildContext context, Course course, int index) {
    final color = _colors[index % _colors.length];
    final statusColor = _statusColor(course.status);

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2EBE4)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_icons[index % _icons.length], color: color, size: 23),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  course.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF25372B),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${course.code} • ${course.credits} SKS',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 7),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    _statusLabel(course.status),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Edit mata kuliah',
            onPressed: () => _openEditCourse(context, course),
            icon: const Icon(Icons.edit_outlined),
            color: const Color(0xFF2E8B57),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth >= 700 ? 32.0 : 20.0;

        final contentWidth = constraints.maxWidth - horizontalPadding * 2;

        final crossAxisCount = contentWidth >= 700 ? 2 : 1;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                20,
                horizontalPadding,
                16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mata Kuliah',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF25372B),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Daftar mata kuliah yang sedang kamu pelajari.',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.error != null) {
                    return ErrorView(
                      message: provider.error!,
                      onRetry: provider.loadCourses,
                    );
                  }

                  if (provider.courses.isEmpty) {
                    return const Center(
                      child: Text('Data mata kuliah belum tersedia.'),
                    );
                  }

                  return GridView.count(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      4,
                      horizontalPadding,
                      20,
                    ),
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: crossAxisCount == 2 ? 3.2 : 3.5,
                    children: List.generate(
                      provider.courses.length,
                      (index) => _buildCourseCard(
                        context,
                        provider.courses[index],
                        index,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
