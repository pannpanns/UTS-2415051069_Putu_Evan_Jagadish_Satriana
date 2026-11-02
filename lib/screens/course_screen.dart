
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../providers/task_provider.dart';
import '../widgets/error_view.dart';
import '../widgets/confirm_delete_dialog.dart';
import 'add_course_screen.dart';
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
          backgroundColor: isError
              ? Colors.red.shade700
              : const Color(0xFF2E8B57),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _openAddCourse(BuildContext context) async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddCourseScreen(),
      ),
    );
  }

  Future<void> _openEditCourse(
    BuildContext context,
    Course course,
  ) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EditCourseScreen(course: course),
      ),
    );

    if (!context.mounted) return;

    if (result == true) {
      _showMessage(
        context,
        'Mata kuliah berhasil diperbarui.',
      );
    }
  }

  Future<void> _deleteCourse(
    BuildContext context,
    Course course,
  ) async {
    final taskProvider = context.read<TaskProvider>();

    if (taskProvider.isLoading || taskProvider.error != null) {
      _showMessage(
        context,
        'Data tugas belum siap. Coba lagi setelah data dimuat.',
        isError: true,
      );
      return;
    }

    final isUsed = taskProvider.tasks.any(
      (task) => task.courseId == course.id.toString(),
    );

    if (isUsed) {
      _showMessage(
        context,
        'Mata kuliah masih digunakan oleh tugas. '
        'Ubah atau hapus tugas terkait terlebih dahulu.',
        isError: true,
      );
      return;
    }

    final confirmed = await showDeleteConfirmation(
      context: context,
      title: 'Hapus Mata Kuliah?',
      message:
          'Mata kuliah "${course.title}" akan dihapus secara permanen. '
          'Tindakan ini tidak dapat dibatalkan.',
    );

    if (!confirmed || !context.mounted) return;

    final courseId = course.id;

    if (courseId == null) {
      _showMessage(
        context,
        'ID mata kuliah tidak valid.',
        isError: true,
      );
      return;
    }

    final provider = context.read<CourseProvider>();
    final success = await provider.deleteCourse(courseId);

    if (!context.mounted) return;

    if (success) {
      _showMessage(
        context,
        'Mata kuliah berhasil dihapus.',
      );
    } else {
      _showMessage(
        context,
        provider.deleteError ?? 'Gagal menghapus mata kuliah.',
        isError: true,
      );
    }
  }

  Widget _buildHeader(
    BuildContext context,
    double horizontalPadding,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        20,
        horizontalPadding,
        16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mata Kuliah',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF25372B),
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  'Kelola daftar mata kuliahmu.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF718075),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          FilledButton.icon(
            onPressed: () => _openAddCourse(context),
            icon: const Icon(Icons.add, size: 18),
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
    );
  }

  Widget _buildCourseCard(
    BuildContext context,
    Course course,
    int index,
    bool isDeleting,
  ) {
    final color = _colors[index % _colors.length];
    final statusColor = _statusColor(course.status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2EBE4),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B5E3B).withValues(alpha: 0.025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _icons[index % _icons.length],
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    height: 1.3,
                    color: Color(0xFF25372B),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${course.code} • ${course.credits} SKS',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
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
          const SizedBox(width: 4),
          IconButton(
            tooltip: 'Edit mata kuliah',
            visualDensity: VisualDensity.compact,
            constraints: const BoxConstraints(
              minWidth: 36,
              minHeight: 36,
            ),
            onPressed: isDeleting
                ? null
                : () => _openEditCourse(context, course),
            icon: const Icon(
              Icons.edit_outlined,
              size: 19,
            ),
            color: const Color(0xFF2E8B57),
          ),
          PopupMenuButton<String>(
            enabled: !isDeleting,
            tooltip: 'Pilihan mata kuliah',
            padding: EdgeInsets.zero,
            iconSize: 20,
            onSelected: (value) {
              if (value == 'delete') {
                _deleteCourse(context, course);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      color: Color(0xFFD94C4C),
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Hapus mata kuliah',
                      style: TextStyle(
                        color: Color(0xFFD94C4C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: const Color(0xFFE5F3E8),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.menu_book_outlined,
                size: 38,
                color: Color(0xFF2E8B57),
              ),
            ),
            const SizedBox(height: 17),
            const Text(
              'Belum Ada Mata Kuliah',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF25372B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tambahkan mata kuliah terlebih dahulu '
              'agar kamu bisa menghubungkannya dengan tugas.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: () => _openAddCourse(context),
              icon: const Icon(Icons.add),
              label: const Text('Tambah Mata Kuliah'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2E8B57),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final taskProvider = context.read<TaskProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding =
            constraints.maxWidth >= 700 ? 32.0 : 20.0;

        final contentWidth =
            constraints.maxWidth - horizontalPadding * 2;

        final crossAxisCount = contentWidth >= 700 ? 2 : 1;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, horizontalPadding),
            Expanded(
              child: RefreshIndicator(
                color: const Color(0xFF2E8B57),
                onRefresh: () async {
                  await Future.wait([
                    provider.loadCourses(),
                    taskProvider.loadTasks(),
                  ]);
                },
                child: Builder(
                  builder: (context) {
                    if (provider.isLoading) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(
                            height: 300,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF2E8B57),
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    if (provider.error != null) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: 360,
                            child: ErrorView(
                              message: provider.error!,
                              onRetry: provider.loadCourses,
                            ),
                          ),
                        ],
                      );
                    }

                    if (provider.courses.isEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: 400,
                            child: _buildEmptyState(context),
                          ),
                        ],
                      );
                    }

                    return GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        4,
                        horizontalPadding,
                        24,
                      ),
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        mainAxisExtent: 124,
                      ),
                      itemCount: provider.courses.length,
                      itemBuilder: (context, index) {
                        return _buildCourseCard(
                          context,
                          provider.courses[index],
                          index,
                          provider.isDeleting,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
