import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/course_provider.dart';
import '../providers/task_provider.dart';
import '../widgets/priority_badge.dart';
import 'edit_task_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  static const Color _background = Color(0xFFF3F8F4);
  static const Color _darkGreen = Color(0xFF25372B);

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

    return '${date.day.toString().padLeft(2, '0')} '
        '${months[date.month - 1]} ${date.year}';
  }

  Widget _buildInformation(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF2E8B57), size: 21),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _darkGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = context.watch<CourseProvider>();
    final taskProvider = context.watch<TaskProvider>();

    final currentTask = taskProvider.tasks.firstWhere(
      (item) => item.id == task.id,
      orElse: () => task,
    );

    final subject = courseProvider.courseNameById(currentTask.courseId);

    return ColoredBox(
      color: _background,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: _background,
          appBar: AppBar(
            title: const Text('Detail Tugas'),
            backgroundColor: _background,
            surfaceTintColor: Colors.transparent,
          ),
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE2EBE4)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PriorityBadge(priority: currentTask.priority),
                          const SizedBox(height: 15),
                          Text(
                            currentTask.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: _darkGreen,
                            ),
                          ),
                          const SizedBox(height: 25),
                          _buildInformation(
                            'Mata Kuliah',
                            subject,
                            Icons.menu_book_outlined,
                          ),
                          _buildInformation(
                            'Deadline',
                            _formatDate(currentTask.deadline),
                            Icons.calendar_today_outlined,
                          ),
                          _buildInformation(
                            'Prioritas',
                            currentTask.priority,
                            Icons.flag_outlined,
                          ),
                          _buildInformation(
                            'Status',
                            currentTask.status,
                            Icons.pending_actions,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditTaskScreen(task: currentTask),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF2E8B57),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('Edit Tugas'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
