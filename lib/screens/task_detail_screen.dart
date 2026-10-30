
import 'package:flutter/material.dart';

import '../widgets/priority_badge.dart';
import 'edit_task_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final String title;
  final String subject;
  final String deadline;
  final String priority;
  final String status;

  const TaskDetailScreen({
    super.key,
    required this.title,
    required this.subject,
    required this.deadline,
    required this.priority,
    required this.status,
  });

  Widget _buildInformation(
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF2E8B57),
            size: 21,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF25372B),
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
    const background = Color(0xFFF3F8F4);

    return ColoredBox(
      color: background,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: background,
          appBar: AppBar(
            title: const Text('Detail Tugas'),
            backgroundColor: background,
            surfaceTintColor: Colors.transparent,
          ),
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 700,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: const Color(0xFFE2EBE4),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PriorityBadge(priority: priority),

                          const SizedBox(height: 15),

                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF25372B),
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
                            deadline,
                            Icons.calendar_today_outlined,
                          ),

                          _buildInformation(
                            'Prioritas',
                            priority,
                            Icons.flag_outlined,
                          ),

                          _buildInformation(
                            'Status',
                            status,
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditTaskScreen(
                                title: title,
                                subject: subject,
                                deadline: deadline,
                                priority: priority,
                              ),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF2E8B57),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
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
