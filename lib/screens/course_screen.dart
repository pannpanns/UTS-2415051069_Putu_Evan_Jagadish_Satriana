
import 'package:flutter/material.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

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
        border: Border.all(
          color: const Color(0xFFE2EBE4),
        ),
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
            child: Icon(
              icon,
              color: color,
              size: 23,
            ),
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
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  lecturer,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.chevron_right,
            color: Color(0xFF929B92),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape =
            constraints.maxWidth > constraints.maxHeight;

        final horizontalPadding =
            constraints.maxWidth >= 700 ? 32.0 : 20.0;

        final contentWidth =
            constraints.maxWidth - horizontalPadding * 2;

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
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: GridView.count(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  4,
                  horizontalPadding,
                  20,
                ),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio:
                    crossAxisCount == 2 ? 3.2 : 3.5,
                children: [
                  _buildCourseCard(
                    'Pemrograman Mobile',
                    'IF204',
                    'Dosen Pengampu',
                    Icons.phone_android,
                    const Color(0xFF2E8B57),
                  ),
                  _buildCourseCard(
                    'Basis Data',
                    'IF202',
                    'Dosen Pengampu',
                    Icons.storage_outlined,
                    const Color(0xFF3976A8),
                  ),
                  _buildCourseCard(
                    'Analisis Sistem',
                    'IF206',
                    'Dosen Pengampu',
                    Icons.account_tree_outlined,
                    const Color(0xFFC17A1B),
                  ),
                  _buildCourseCard(
                    'Rekayasa Perangkat Lunak',
                    'IF208',
                    'Dosen Pengampu',
                    Icons.code,
                    const Color(0xFF8270AA),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
