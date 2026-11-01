import 'package:flutter/material.dart';

import 'priority_badge.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String subject;
  final String deadline;
  final String priority;
  final String status;
  final VoidCallback? onEdit;

  const TaskCard({
    super.key,
    required this.title,
    required this.subject,
    required this.deadline,
    required this.priority,
    required this.status,
    this.onEdit,
  });

  Color get _priorityColor {
    switch (priority.toLowerCase()) {
      case 'tinggi':
        return const Color(0xFFD94C4C);
      case 'sedang':
        return const Color(0xFFE49A32);
      default:
        return const Color(0xFF279B72);
    }
  }

  Color get _statusColor {
    switch (status.toLowerCase()) {
      case 'selesai':
        return const Color(0xFF279B72);
      case 'dikerjakan':
        return const Color(0xFFD18A24);
      default:
        return const Color(0xFF718075);
    }
  }

  Color get _statusBackground {
    switch (status.toLowerCase()) {
      case 'selesai':
        return const Color(0xFFE5F6EF);
      case 'dikerjakan':
        return const Color(0xFFFFF1DD);
      default:
        return const Color(0xFFEDF2EE);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE2EBE4)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B5E3B).withValues(alpha: 0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: _priorityColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BARIS 1: JUDUL DAN EDIT
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF25372B),
                          ),
                        ),
                      ),

                      if (onEdit != null) ...[
                        const SizedBox(width: 8),

                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE8F4EC),
                            shape: BoxShape.circle,
                          ),
                          child: InkWell(
                            onTap: onEdit,
                            customBorder: const CircleBorder(),
                            child: const Center(
                              child: Icon(
                                Icons.edit_outlined,
                                size: 16,
                                color: Color(0xFF2E8B57),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 8),

                  // BARIS 2: MATA KULIAH DAN PRIORITAS
                  Row(
                    children: [
                      Icon(
                        Icons.menu_book_outlined,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),

                      const SizedBox(width: 6),

                      Expanded(
                        child: Text(
                          subject,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      PriorityBadge(priority: priority),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // BARIS 3: DEADLINE DAN STATUS
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 13,
                        color: Colors.grey.shade500,
                      ),

                      const SizedBox(width: 6),

                      Expanded(
                        child: Text(
                          deadline,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: _statusBackground,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: 10,
                            color: _statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
