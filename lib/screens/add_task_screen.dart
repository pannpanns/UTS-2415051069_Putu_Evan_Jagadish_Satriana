
import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();
  final _deadlineController = TextEditingController();

  String? _selectedPriority;
  DateTime? _selectedDate;

  final List<String> _priorities = [
    'Tinggi',
    'Sedang',
    'Rendah',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
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

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, size: 20),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 17,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE2EBE4),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE2EBE4),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF2E8B57),
          width: 1.5,
        ),
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

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextFormField(
          controller: controller,
          decoration: _inputDecoration(
            hint: hint,
            icon: icon,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '$label wajib diisi';
            }
            return null;
          },
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
          decoration: _inputDecoration(
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
          items: _priorities.map((priority) {
            return DropdownMenuItem<String>(
              value: priority,
              child: Text(
                priority,
                style: const TextStyle(fontSize: 14),
              ),
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

  void _saveTask() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Form berhasil divalidasi. Penyimpanan akan diaktifkan pada tahap CRUD.',
        ),
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
            title: const Text('Tambah Tugas'),
            backgroundColor: background,
            surfaceTintColor: Colors.transparent,
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 600,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField(
                            label: 'Nama Tugas',
                            hint: 'Masukkan nama tugas',
                            icon: Icons.assignment_outlined,
                            controller: _titleController,
                          ),

                          const SizedBox(height: 20),

                          _buildTextField(
                            label: 'Mata Kuliah',
                            hint: 'Masukkan nama mata kuliah',
                            icon: Icons.menu_book_outlined,
                            controller: _subjectController,
                          ),

                          const SizedBox(height: 20),

                          _buildDeadlineField(),

                          const SizedBox(height: 20),

                          _buildPriorityField(),

                          const SizedBox(height: 28),

                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: _saveTask,
                              style: FilledButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF2E8B57),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(30),
                                ),
                              ),
                              icon: const Icon(Icons.save_outlined),
                              label: const Text(
                                'Simpan Tugas',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
