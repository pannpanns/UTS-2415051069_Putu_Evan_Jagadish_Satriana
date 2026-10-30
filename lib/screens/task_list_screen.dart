import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';

import 'task_detail_screen.dart';
import 'add_task_screen.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  void _openAddTask(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddTaskScreen()),
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

  String _formatDate(DateTime date) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    final day = date.day.toString().padLeft(2, '0');

    return '$day ${months[date.month - 1]} ${date.year}';
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
    final taskProvider = context.watch<TaskProvider>();
    final courseProvider = context.watch<CourseProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 700;

        final horizontalPadding = constraints.maxWidth >= 700 ? 32.0 : 20.0;

        final contentWidth = constraints.maxWidth - horizontalPadding * 2;

        final cardWidth = isWide ? (contentWidth - 12) / 2 : contentWidth;

        return Column(
          children: [
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
                        icon: const Icon(Icons.add, size: 19),
                        label: const Text('Tambah'),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF2E8B57),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 11,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Builder(
                builder: (context) {
                  if (taskProvider.isLoading || courseProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (taskProvider.error != null ||
                      courseProvider.error != null) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Gagal memuat data tugas.'),
                          TextButton(
                            onPressed: () {
                              taskProvider.loadTasks();
                              courseProvider.loadCourses();
                            },
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (taskProvider.tasks.isEmpty) {
                    return const Center(child: Text('Belum ada tugas.'));
                  }

                  return ListView(
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
                        children: taskProvider.tasks.map((task) {
                          return SizedBox(
                            width: cardWidth,
                            child: _buildTaskItem(
                              context,
                              title: task.title,
                              subject: courseProvider.courseNameById(
                                task.courseId,
                              ),
                              deadline: _formatDate(task.deadline),
                              priority: task.priority,
                              status: task.status,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
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
