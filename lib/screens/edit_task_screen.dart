import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/course_provider.dart';
import '../providers/task_provider.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;

  late String? _selectedCourseId;
  late DateTime _selectedDate;
  late String _selectedPriority;
  late String _selectedStatus;

  static const Color _green = Color(0xFF2E8B57);
  static const Color _darkGreen = Color(0xFF25372B);
  static const Color _background = Color(0xFFF3F8F4);

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.task.title);

    _selectedCourseId = widget.task.courseId;
    _selectedDate = widget.task.deadline;

    _selectedPriority = Task.priorities.contains(widget.task.priority)
        ? widget.task.priority
        : Task.priorityMedium;

    _selectedStatus = Task.statuses.contains(widget.task.status)
        ? widget.task.status
        : Task.statusNotStarted;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
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

    return '${date.day.toString().padLeft(2, '0')} '
        '${months[date.month - 1]} ${date.year}';
  }

  InputDecoration _decoration({required IconData icon}) {
    return InputDecoration(
      prefixIcon: Icon(icon, size: 20),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2EBE4)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2EBE4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _green, width: 1.5),
      ),
    );
  }

  Widget _label(String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: _darkGreen,
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _green,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: _darkGreen,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
        );
      });
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final courseId = _selectedCourseId;

    if (courseId == null || courseId.isEmpty) return;

    final updatedTask = widget.task.copyWith(
      title: _titleController.text.trim(),
      courseId: courseId,
      deadline: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      ),
      priority: _selectedPriority,
      status: _selectedStatus,
    );

    final provider = context.read<TaskProvider>();

    final success = await provider.updateTask(updatedTask);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.updateError ?? 'Gagal memperbarui tugas.'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = context.watch<CourseProvider>();
    final taskProvider = context.watch<TaskProvider>();

    final courses = courseProvider.courses;

    final hasSelectedCourse = courses.any(
      (course) => course.id?.toString() == _selectedCourseId,
    );

    return ColoredBox(
      color: _background,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: _background,
          appBar: AppBar(
            title: const Text('Edit Tugas'),
            backgroundColor: _background,
            surfaceTintColor: Colors.transparent,
          ),
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Nama Tugas'),
                      TextFormField(
                        controller: _titleController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: _decoration(icon: Icons.assignment_outlined)
                            .copyWith(hintText: 'Masukkan nama tugas'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama tugas wajib diisi';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      _label('Mata Kuliah'),
                      DropdownButtonFormField<String>(
                        initialValue: hasSelectedCourse
                            ? _selectedCourseId
                            : null,
                        isExpanded: true,
                        decoration: _decoration(icon: Icons.menu_book_outlined),
                        hint: const Text('Pilih mata kuliah'),
                        items: courses.map((course) {
                          return DropdownMenuItem<String>(
                            value: course.id.toString(),
                            child: Text(
                              '${course.title} (${course.code})',
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: courseProvider.isLoading
                            ? null
                            : (value) {
                                setState(() {
                                  _selectedCourseId = value;
                                });
                              },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mata kuliah wajib dipilih';
                          }
                          return null;
                        },
                      ),

                      if (courseProvider.error != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          'Gagal memuat mata kuliah: '
                          '${courseProvider.error}',
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 12,
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),

                      _label('Deadline'),
                      InkWell(
                        onTap: _selectDate,
                        borderRadius: BorderRadius.circular(12),
                        child: InputDecorator(
                          decoration:
                              _decoration(icon: Icons.calendar_month_outlined)
                                  .copyWith(
                                    suffixIcon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Color(0xFF718075),
                                    ),
                                  ),
                          child: Text(_formatDate(_selectedDate)),
                        ),
                      ),

                      const SizedBox(height: 20),

                      _label('Prioritas'),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedPriority,
                        isExpanded: true,
                        decoration: _decoration(icon: Icons.flag_outlined),
                        items: Task.priorities.map((priority) {
                          return DropdownMenuItem<String>(
                            value: priority,
                            child: Text(priority),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedPriority = value;
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Prioritas wajib dipilih';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      _label('Status Tugas'),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedStatus,
                        isExpanded: true,
                        decoration: _decoration(
                          icon: Icons.pending_actions_outlined,
                        ),
                        items: Task.statuses.map((status) {
                          return DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedStatus = value;
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Status wajib dipilih';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed:
                              taskProvider.isUpdating ||
                                  courseProvider.isLoading
                              ? null
                              : _saveChanges,
                          style: FilledButton.styleFrom(
                            backgroundColor: _green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          icon: taskProvider.isUpdating
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.save_outlined),
                          label: Text(
                            taskProvider.isUpdating
                                ? 'Menyimpan Perubahan...'
                                : 'Simpan Perubahan',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
