import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';

class EditCourseScreen extends StatefulWidget {
  final Course course;

  const EditCourseScreen({super.key, required this.course});

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _codeController;
  late final TextEditingController _titleController;
  late final TextEditingController _creditsController;

  late String _selectedStatus;

  static const Color _green = Color(0xFF2E8B57);
  static const Color _darkGreen = Color(0xFF25372B);
  static const Color _background = Color(0xFFF3F8F4);

  @override
  void initState() {
    super.initState();

    _codeController = TextEditingController(text: widget.course.code);

    _titleController = TextEditingController(text: widget.course.title);

    _creditsController = TextEditingController(
      text: widget.course.credits.toString(),
    );

    _selectedStatus =
        ['planned', 'active', 'done'].contains(widget.course.status)
        ? widget.course.status
        : 'planned';
  }

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _creditsController.dispose();
    super.dispose();
  }

  InputDecoration _decoration({required IconData icon, String? hint}) {
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

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final updatedCourse = widget.course.copyWith(
      code: _codeController.text.trim().toUpperCase(),
      title: _titleController.text.trim(),
      credits: int.parse(_creditsController.text.trim()),
      status: _selectedStatus,
    );

    final provider = context.read<CourseProvider>();

    final success = await provider.updateCourse(updatedCourse);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.updateError ?? 'Gagal memperbarui mata kuliah.',
          ),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return ColoredBox(
      color: _background,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: _background,
          appBar: AppBar(
            title: const Text('Edit Mata Kuliah'),
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
                      _label('Kode Mata Kuliah'),
                      TextFormField(
                        controller: _codeController,
                        textCapitalization: TextCapitalization.characters,
                        decoration: _decoration(
                          icon: Icons.tag,
                          hint: 'Contoh: IF204',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Kode mata kuliah wajib diisi';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      _label('Nama Mata Kuliah'),
                      TextFormField(
                        controller: _titleController,
                        textCapitalization: TextCapitalization.words,
                        decoration: _decoration(
                          icon: Icons.menu_book_outlined,
                          hint: 'Masukkan nama mata kuliah',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama mata kuliah wajib diisi';
                          }

                          if (value.trim().length < 3) {
                            return 'Nama minimal 3 karakter';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      _label('Jumlah SKS'),
                      TextFormField(
                        controller: _creditsController,
                        keyboardType: TextInputType.number,
                        decoration: _decoration(
                          icon: Icons.school_outlined,
                          hint: 'Contoh: 3',
                        ),
                        validator: (value) {
                          final credits = int.tryParse(value?.trim() ?? '');

                          if (credits == null || credits < 1 || credits > 10) {
                            return 'SKS harus antara 1–10';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      _label('Status Mata Kuliah'),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedStatus,
                        isExpanded: true,
                        decoration: _decoration(icon: Icons.flag_outlined),
                        items: const [
                          DropdownMenuItem(
                            value: 'planned',
                            child: Text('Direncanakan'),
                          ),
                          DropdownMenuItem(
                            value: 'active',
                            child: Text('Aktif'),
                          ),
                          DropdownMenuItem(
                            value: 'done',
                            child: Text('Selesai'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedStatus = value;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: provider.isUpdating ? null : _saveChanges,
                          style: FilledButton.styleFrom(
                            backgroundColor: _green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          icon: provider.isUpdating
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
                            provider.isUpdating
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
