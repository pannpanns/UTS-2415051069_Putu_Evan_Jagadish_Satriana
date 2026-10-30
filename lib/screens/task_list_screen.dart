
import 'package:flutter/material.dart';

import '../widgets/task_card.dart';
import 'task_detail_screen.dart';
import 'add_task_screen.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  void _openAddTask(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddTaskScreen(),
      ),
    );
  }

  void _openDetail(
    BuildContext context, {
    required String title,
    required String subject,
    required String deadline,
    required String priority,
    required String status,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaskDetailScreen(
          title: title,
          subject: subject,
          deadline: deadline,
          priority: priority,
          status: status,
        ),
      ),
    );
  }

  Widget _buildTaskItem(
    BuildContext context, {
    required String title,
    required String subject,
    required String deadline,
    required String priority,
    required String status,
  }) {
    return GestureDetector(
      onTap: () => _openDetail(
        context,
        title: title,
        subject: subject,
        deadline: deadline,
        priority: priority,
        status: status,
      ),
      child: TaskCard(
        title: title,
        subject: subject,
        deadline: deadline,
        priority: priority,
        status: status,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 700;

        final horizontalPadding =
            constraints.maxWidth >= 700 ? 32.0 : 20.0;

        final contentWidth =
            constraints.maxWidth - horizontalPadding * 2;

        final cardWidth = isWide
            ? (contentWidth - 12) / 2
            : contentWidth;

        return Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                16,
                horizontalPadding,
                12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Daftar Tugas',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF25372B),
                          ),
                        ),
                      ),

                      FilledButton.icon(
                        onPressed: () => _openAddTask(context),
                        icon: const Icon(
                          Icons.add,
                          size: 19,
                        ),
                        label: const Text('Tambah'),
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF2E8B57),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 11,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 7),

                  Text(
                    'Kelola seluruh tugas perkuliahanmu.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // Task list
            Expanded(
              child: ListView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  8,
                  horizontalPadding,
                  20,
                ),
                children: [
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      SizedBox(
                        width: cardWidth,
                        child: _buildTaskItem(
                          context,
                          title: 'Membuat Makalah',
                          subject: 'Pemrograman Mobile',
                          deadline: '02 November 2026',
                          priority: 'Tinggi',
                          status: 'Dikerjakan',
                        ),
                      ),

                      SizedBox(
                        width: cardWidth,
                        child: _buildTaskItem(
                          context,
                          title: 'Laporan Praktikum',
                          subject: 'Basis Data',
                          deadline: '04 November 2026',
                          priority: 'Sedang',
                          status: 'Belum Mulai',
                        ),
                      ),

                      SizedBox(
                        width: cardWidth,
                        child: _buildTaskItem(
                          context,
                          title: 'Presentasi Individu',
                          subject: 'Analisis Sistem',
                          deadline: '06 November 2026',
                          priority: 'Rendah',
                          status: 'Belum Mulai',
                        ),
                      ),
                    ],
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
