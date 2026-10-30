import 'package:flutter/material.dart';

class EditTaskScreen extends StatefulWidget {
  final String title;
  final String subject;
  final String deadline;
  final String priority;

  const EditTaskScreen({
    super.key,
    required this.title,
    required this.subject,
    required this.deadline,
    required this.priority,
  });

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _subjectController;
  late final TextEditingController _deadlineController;

  String? _selectedPriority;
  DateTime? _selectedDate;

  final List<String> _priorities = ['Tinggi', 'Sedang', 'Rendah'];

  static const List<String> _months = [
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

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.title);

    _subjectController = TextEditingController(text: widget.subject);

    _deadlineController = TextEditingController(text: widget.deadline);

    _selectedPriority = _priorities.contains(widget.priority)
        ? widget.priority
        : null;

    _selectedDate = _parseDate(widget.deadline);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  DateTime _parseDate(String value) {
    final parts = value.trim().split(RegExp(r'\s+'));

    if (parts.length == 3) {
      final day = int.tryParse(parts[0]);

      final month =
          _months.indexWhere(
            (item) => item.toLowerCase() == parts[1].toLowerCase(),
          ) +
          1;

      final year = int.tryParse(parts[2]);

      if (day != null && month > 0 && year != null) {
        return DateTime(year, month, day);
      }
    }

    return DateTime.now();
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_months[date.month - 1]} ${date.year}';
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
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

  InputDecoration _inputDecoration({required IconData icon}) {
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextFormField(
          controller: controller,
          decoration: _inputDecoration(icon: icon),
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
          decoration: _inputDecoration(icon: Icons.calendar_month_outlined)
              .copyWith(
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
          decoration: _inputDecoration(icon: Icons.flag_outlined),
          items: _priorities.map((priority) {
            return DropdownMenuItem<String>(
              value: priority,
              child: Text(priority),
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

  void _saveChanges() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Form berhasil divalidasi. Pembaruan akan diaktifkan pada tahap CRUD.',
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
            title: const Text('Edit Tugas'),
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
                      _buildTextField(
                        label: 'Nama Tugas',
                        controller: _titleController,
                        icon: Icons.assignment_outlined,
                      ),

                      const SizedBox(height: 20),

                      _buildTextField(
                        label: 'Mata Kuliah',
                        controller: _subjectController,
                        icon: Icons.menu_book_outlined,
                      ),

                      const SizedBox(height: 20),

                      _buildDeadlineField(),

                      const SizedBox(height: 20),

                      _buildPriorityField(),

                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _saveChanges,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF2E8B57),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          icon: const Icon(Icons.save_outlined),
                          label: const Text(
                            'Simpan Perubahan',
                            style: TextStyle(fontWeight: FontWeight.w600),
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
