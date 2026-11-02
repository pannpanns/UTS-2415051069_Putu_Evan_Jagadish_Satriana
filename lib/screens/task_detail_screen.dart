import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/course_provider.dart';
import '../providers/task_provider.dart';
import '../widgets/priority_badge.dart';
import '../widgets/confirm_delete_dialog.dart';
import 'edit_task_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  static const Color background = Color(0xFFF3F8F4);
  static const Color darkGreen = Color(0xFF25372B);
  static const Color primaryGreen = Color(0xFF2E8B57);

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

  void _showMessage(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red.shade700 : primaryGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // UPDATE STATUS
  Future<void> _updateStatus(
    BuildContext context,
    Task currentTask,
    String newStatus,
  ) async {
    if (currentTask.status == newStatus) return;

    final provider = context.read<TaskProvider>();

    final updatedTask = currentTask.copyWith(status: newStatus);

    final success = await provider.updateTask(updatedTask);

    if (!context.mounted) return;

    if (success) {
      _showMessage(context, 'Status tugas berhasil diubah menjadi $newStatus.');
    } else {
      _showMessage(
        context,
        provider.updateError ?? 'Gagal mengubah status tugas.',
        isError: true,
      );
    }
  }

  // DELETE TASK
  Future<void> _deleteTask(BuildContext context, Task currentTask) async {
    final confirmed = await showDeleteConfirmation(
      context: context,
      title: 'Hapus Tugas?',
      message:
          'Tugas "${currentTask.title}" akan dihapus secara permanen. '
          'Tindakan ini tidak dapat dibatalkan.',
    );

    if (!confirmed || !context.mounted) return;

    final taskId = currentTask.id;

    if (taskId == null || taskId.isEmpty) {
      _showMessage(context, 'ID tugas tidak valid.', isError: true);
      return;
    }

    final provider = context.read<TaskProvider>();

    final success = await provider.deleteTask(taskId);

    if (!context.mounted) return;

    if (success) {
      Navigator.pop(context, true);
    } else {
      _showMessage(
        context,
        provider.deleteError ?? 'Gagal menghapus tugas.',
        isError: true,
      );
    }
  }

  Widget _buildInformation(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primaryGreen, size: 21),
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
                    color: darkGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // STATUS DROPDOWN
  Widget _buildStatusSelector(
    BuildContext context,
    Task currentTask,
    TaskProvider provider,
  ) {
    final selectedStatus = Task.statuses.contains(currentTask.status)
        ? currentTask.status
        : Task.statusNotStarted;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2EBE4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status Pengerjaan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: darkGreen,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Perbarui perkembangan tugasmu di sini.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),

          const SizedBox(height: 14),

          DropdownButtonFormField<String>(
            key: ValueKey(selectedStatus),
            initialValue: selectedStatus,
            isExpanded: true,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.pending_actions,
                color: primaryGreen,
              ),
              filled: true,
              fillColor: background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: const BorderSide(color: Color(0xFFE2EBE4)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 13,
              ),
            ),
            items: Task.statuses.map((status) {
              return DropdownMenuItem<String>(
                value: status,
                child: Text(status, style: const TextStyle(fontSize: 13)),
              );
            }).toList(),
            onChanged:
                provider.isUpdating ||
                    provider.isDeleting ||
                    currentTask.id == null
                ? null
                : (value) {
                    if (value == null) return;

                    _updateStatus(context, currentTask, value);
                  },
          ),

          if (provider.isUpdating) ...[
            const SizedBox(height: 12),
            const LinearProgressIndicator(color: primaryGreen, minHeight: 3),
            const SizedBox(height: 5),
            const Text(
              'Menyimpan perubahan...',
              style: TextStyle(fontSize: 11, color: primaryGreen),
            ),
          ],
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
      color: background,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: background,

          appBar: AppBar(
            title: const Text('Detail Tugas'),
            backgroundColor: background,
            surfaceTintColor: Colors.transparent,
            actions: [
              IconButton(
                tooltip: 'Hapus tugas',
                onPressed: taskProvider.isDeleting || taskProvider.isUpdating
                    ? null
                    : () => _deleteTask(context, currentTask),
                icon: taskProvider.isDeleting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(
                        Icons.delete_outline,
                        color: Color(0xFFD94C4C),
                      ),
              ),
              const SizedBox(width: 8),
            ],
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
                              color: darkGreen,
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
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    _buildStatusSelector(context, currentTask, taskProvider),

                    const SizedBox(height: 22),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed:
                            taskProvider.isUpdating || taskProvider.isDeleting
                            ? null
                            : () {
                                Navigator.push<bool>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EditTaskScreen(task: currentTask),
                                  ),
                                );
                              },
                        style: FilledButton.styleFrom(
                          backgroundColor: primaryGreen,
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
