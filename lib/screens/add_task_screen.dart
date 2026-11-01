import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/course_provider.dart';
import '../providers/task_provider.dart';
import 'course_screen.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _deadlineController = TextEditingController();

  String? _selectedCourseId;
  String? _selectedPriority;
  DateTime? _selectedDate;

  @override
  void dispose() {
    _titleController.dispose();
    _deadlineController.dispose();
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

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2E8B57),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF25372B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _deadlineController.text = _formatDate(pickedDate);
      });
    }
  }

  Future<void> _openCourseManagement() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: const Color(0xFFF3F8F4),
          appBar: AppBar(
            title: const Text('Mata Kuliah'),
            backgroundColor: const Color(0xFFF3F8F4),
            surfaceTintColor: Colors.transparent,
          ),
          body: const SafeArea(child: CourseScreen()),
        ),
      ),
    );

    if (!mounted) return;

    await context.read<CourseProvider>().loadCourses();
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
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
        borderSide: const BorderSide(color: Color(0xFF2E8B57), width: 1.5),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: Color(0xFF25372B),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Nama Tugas'),
        TextFormField(
          controller: _titleController,
          textCapitalization: TextCapitalization.sentences,
          decoration: _inputDecoration(
            hint: 'Masukkan nama tugas',
            icon: Icons.assignment_outlined,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Nama tugas wajib diisi';
            }

            if (value.trim().length < 3) {
              return 'Nama tugas minimal 3 karakter';
            }

            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCourseField(CourseProvider provider) {
    final availableIds = provider.courses
        .map((course) => course.id.toString())
        .toSet();

    final selectedValue = availableIds.contains(_selectedCourseId)
        ? _selectedCourseId
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Mata Kuliah'),

        DropdownButtonFormField<String>(
          initialValue: selectedValue,
          isExpanded: true,
          decoration: _inputDecoration(
            hint: provider.isLoading
                ? 'Memuat mata kuliah...'
                : 'Pilih mata kuliah',
            icon: Icons.menu_book_outlined,
          ),
          items: provider.courses.map((course) {
            return DropdownMenuItem<String>(
              value: course.id.toString(),
              child: Text(
                '${course.code} - ${course.title}',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13),
              ),
            );
          }).toList(),
          onChanged: provider.isLoading || provider.courses.isEmpty
              ? null
              : (value) {
                  setState(() {
                    _selectedCourseId = value;
                  });
                },
          validator: (value) {
            if (provider.isLoading) {
              return 'Tunggu sampai mata kuliah selesai dimuat';
            }

            if (provider.courses.isEmpty) {
              return 'Tambahkan mata kuliah terlebih dahulu';
            }

            if (value == null) {
              return 'Mata kuliah wajib dipilih';
            }

            return null;
          },
        ),

        const SizedBox(height: 6),

        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: _openCourseManagement,
            icon: const Icon(Icons.add_circle_outline, size: 17),
            label: const Text('Kelola / Tambah Mata Kuliah'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF2E8B57),
              padding: const EdgeInsets.symmetric(horizontal: 4),
            ),
          ),
        ),

        if (provider.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Gagal memuat mata kuliah: ${provider.error}',
              style: const TextStyle(color: Colors.red, fontSize: 11),
            ),
          ),
      ],
    );
  }

  Widget _buildDeadlineField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Deadline'),
        TextFormField(
          controller: _deadlineController,
          readOnly: true,
          onTap: _selectDate,
          decoration:
              _inputDecoration(
                hint: 'Pilih tanggal deadline',
                icon: Icons.calendar_month_outlined,
              ).copyWith(
                suffixIcon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF718075),
                ),
              ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Deadline wajib dipilih';
            }

            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPriorityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Prioritas'),
        DropdownButtonFormField<String>(
          initialValue: _selectedPriority,
          isExpanded: true,
          decoration: _inputDecoration(
            hint: 'Pilih tingkat prioritas',
            icon: Icons.flag_outlined,
          ),
          items: Task.priorities.map((priority) {
            return DropdownMenuItem<String>(
              value: priority,
              child: Text(priority, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedPriority = value;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Prioritas wajib dipilih';
            }

            return null;
          },
        ),
      ],
    );
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate == null ||
        _selectedCourseId == null ||
        _selectedPriority == null) {
      return;
    }

    final task = Task(
      title: _titleController.text.trim(),
      courseId: _selectedCourseId!,
      deadline: DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
      ),
      priority: _selectedPriority!,
      status: Task.statusNotStarted,
    );

    final provider = context.read<TaskProvider>();

    final success = await provider.createTask(task);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tugas berhasil ditambahkan.'),
          backgroundColor: Color(0xFF2E8B57),
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.createError ?? 'Gagal menyimpan tugas.'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = context.watch<CourseProvider>();
    final taskProvider = context.watch<TaskProvider>();

    const background = Color(0xFFF3F8F4);

    return ColoredBox(
      color: background,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: background,
          appBar: AppBar(
            title: const Text('Tambah Tugas'),
            backgroundColor: background,
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
                      _buildTitleField(),

                      const SizedBox(height: 20),

                      _buildCourseField(courseProvider),

                      const SizedBox(height: 12),

                      _buildDeadlineField(),

                      const SizedBox(height: 20),

                      _buildPriorityField(),

                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: taskProvider.isCreating ? null : _saveTask,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF2E8B57),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          icon: taskProvider.isCreating
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
                            taskProvider.isCreating
                                ? 'Menyimpan...'
                                : 'Simpan Tugas',
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
