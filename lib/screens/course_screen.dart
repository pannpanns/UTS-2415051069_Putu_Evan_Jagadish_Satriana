import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';

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

  Widget _buildCourseCard(
    String name,
    String code,
    String lecturer,
    IconData icon,
    Color color,
  ) {
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
            child: Icon(icon, color: color, size: 23),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF25372B),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  code,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 3),
                Text(
                  lecturer,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF929B92)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape = constraints.maxWidth > constraints.maxHeight;

        final horizontalPadding = constraints.maxWidth >= 700 ? 32.0 : 20.0;

        final contentWidth = constraints.maxWidth - horizontalPadding * 2;

        final crossAxisCount = contentWidth >= 700 ? 2 : 1;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                isLandscape ? 10 : 20,
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
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Gagal memuat mata kuliah.'),
                          TextButton(
                            onPressed: provider.loadCourses,
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (provider.courses.isEmpty) {
                    return const Center(child: Text('Belum ada mata kuliah.'));
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
                    children: List.generate(provider.courses.length, (index) {
                      final course = provider.courses[index];

                      return _buildCourseCard(
                        course.name,
                        course.code ?? 'Tanpa kode',
                        course.lecturer ?? 'Dosen belum diatur',
                        _icons[index % _icons.length],
                        _colors[index % _colors.length],
                      );
                    }),
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
