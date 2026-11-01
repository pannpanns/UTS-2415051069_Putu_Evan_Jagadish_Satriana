import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/course_provider.dart';
import '../providers/task_provider.dart';
import '../widgets/summary_card.dart';
import '../widgets/task_card.dart';
import 'edit_task_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const double maxContentWidth = 1200;
  static const Color darkGreen = Color(0xFF25372B);
  static const Color primaryGreen = Color(0xFF2E8B57);

  Future<void> _openEditTask(BuildContext context, Task task) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => EditTaskScreen(task: task)),
    );

    if (!context.mounted) return;

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tugas berhasil diperbarui.'),
          backgroundColor: primaryGreen,
        ),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final courseProvider = context.watch<CourseProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape = constraints.maxWidth > constraints.maxHeight;
        final horizontalPadding = constraints.maxWidth >= 700 ? 32.0 : 20.0;

        final contentWidth =
            (constraints.maxWidth > maxContentWidth
                ? maxContentWidth
                : constraints.maxWidth) -
            horizontalPadding * 2;

        final isWide = contentWidth >= 680;

        return Column(
          children: [
            _buildHeader(isLandscape, horizontalPadding),
            Expanded(
              child: RefreshIndicator(
                color: primaryGreen,
                onRefresh: () async {
                  await Future.wait([
                    taskProvider.loadTasks(),
                    courseProvider.loadCourses(),
                  ]);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: maxContentWidth,
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          isLandscape ? 12 : 22,
                          horizontalPadding,
                          12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildGreeting(isLandscape),
                            SizedBox(height: isLandscape ? 14 : 22),
                            if (taskProvider.isLoading ||
                                courseProvider.isLoading)
                              _buildLoadingState()
                            else if (taskProvider.error != null ||
                                courseProvider.error != null)
                              _buildErrorState(taskProvider, courseProvider)
                            else ...[
                              _buildSummary(
                                contentWidth,
                                isLandscape,
                                taskProvider,
                              ),
                              SizedBox(height: isLandscape ? 14 : 20),
                              _buildProgressCard(taskProvider),
                              SizedBox(height: isLandscape ? 18 : 28),
                              _buildUpcomingHeader(taskProvider.totalTasks),
                              const SizedBox(height: 14),
                              _buildUpcomingTasks(
                                context,
                                isWide,
                                taskProvider.upcomingTasks,
                                courseProvider,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(bool isLandscape, double horizontalPadding) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF14532D), Color(0xFF2E8B57)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: isLandscape ? 7 : 10,
            ),
            child: SizedBox(
              height: 48,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      color: primaryGreen,
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TuntasKuliah',
                          style: TextStyle(
                            fontSize: 18,
                            height: 1.2,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Academic Assignment Tracker',
                          style: TextStyle(
                            fontSize: 10,
                            height: 1.2,
                            color: Color(0xFFDCEFE2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: Color(0xFF247A45),
                      size: 21,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting(bool isLandscape) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Halo, Mahasiswa!',
          style: TextStyle(
            fontSize: isLandscape ? 19 : 22,
            fontWeight: FontWeight.bold,
            color: darkGreen,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Pantau dan selesaikan tugas kuliahmu.',
          style: TextStyle(
            fontSize: isLandscape ? 12 : 13,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildSummary(
    double contentWidth,
    bool isLandscape,
    TaskProvider provider,
  ) {
    final crossAxisCount = contentWidth >= 680 ? 4 : 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ringkasan Tugas',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: darkGreen,
          ),
        ),
        const SizedBox(height: 10),
        GridView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: isLandscape ? 116 : 128,
          ),
          children: [
            SummaryCard(
              title: 'Total Tugas',
              value: provider.totalTasks.toString(),
              icon: Icons.assignment_outlined,
              color: const Color(0xFF247A45),
              backgroundColor: const Color(0xFFE5F3E8),
            ),
            SummaryCard(
              title: 'Selesai',
              value: provider.completedTasks.toString(),
              icon: Icons.check_circle_outline,
              color: const Color(0xFF198754),
              backgroundColor: const Color(0xFFDDF4E6),
            ),
            SummaryCard(
              title: 'Dikerjakan',
              value: provider.inProgressTasks.toString(),
              icon: Icons.pending_actions,
              color: const Color(0xFFC17A1B),
              backgroundColor: const Color(0xFFFFF1D8),
            ),
            SummaryCard(
              title: 'Belum Mulai',
              value: provider.notStartedTasks.toString(),
              icon: Icons.schedule_outlined,
              color: const Color(0xFF667A6B),
              backgroundColor: const Color(0xFFE9F0EA),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressCard(TaskProvider provider) {
    final progress = provider.completionRate.clamp(0.0, 1.0);
    final percentage = (progress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2EBE4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progres Penyelesaian',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: darkGreen,
                ),
              ),
              Text(
                '$percentage%',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress.toDouble(),
              minHeight: 8,
              backgroundColor: const Color(0xFFE2ECE4),
              valueColor: const AlwaysStoppedAnimation<Color>(primaryGreen),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            '${provider.completedTasks} dari '
            '${provider.totalTasks} tugas telah diselesaikan.',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingHeader(int totalTasks) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Tugas Minggu Ini',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: darkGreen,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2E7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$totalTasks tugas',
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF236B43),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingTasks(
    BuildContext context,
    bool isWide,
    List<Task> tasks,
    CourseProvider courseProvider,
  ) {
    if (tasks.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: const Color(0xFFE2EBE4)),
        ),
        child: Center(
          child: Text(
            'Belum ada tugas.',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;

        final itemWidth = isWide
            ? (constraints.maxWidth - spacing) / 2
            : constraints.maxWidth;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: tasks.map((task) {
            return SizedBox(
              width: itemWidth,
              child: TaskCard(
                title: task.title,
                subject: courseProvider.courseNameById(task.courseId),
                deadline: _formatDate(task.deadline),
                priority: task.priority,
                status: task.status,
                onEdit: () => _openEditTask(context, task),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return const SizedBox(
      height: 260,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorState(
    TaskProvider taskProvider,
    CourseProvider courseProvider,
  ) {
    final message = taskProvider.error ?? courseProvider.error;

    return SizedBox(
      height: 260,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 42,
              color: Color(0xFFD96A6A),
            ),
            const SizedBox(height: 12),
            const Text(
              'Gagal memuat Dashboard',
              style: TextStyle(fontWeight: FontWeight.bold, color: darkGreen),
            ),
            const SizedBox(height: 7),
            Text(
              message ?? 'Terjadi kesalahan.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () {
                taskProvider.loadTasks();
                courseProvider.loadCourses();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
