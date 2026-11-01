import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();

  final _codeController = TextEditingController();
  final _titleController = TextEditingController();
  final _creditsController = TextEditingController();

  String _selectedStatus = 'planned';

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _creditsController.dispose();
    super.dispose();
  }

  InputDecoration _decoration({required String hint, required IconData icon}) {
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

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF25372B),
        ),
      ),
    );
  }

  Future<void> _saveCourse() async {
    if (!_formKey.currentState!.validate()) return;

    final course = Course(
      code: _codeController.text.trim().toUpperCase(),
      title: _titleController.text.trim(),
      credits: int.parse(_creditsController.text.trim()),
      status: _selectedStatus,
    );

    final provider = context.read<CourseProvider>();
    final success = await provider.createCourse(course);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mata kuliah berhasil ditambahkan.'),
          backgroundColor: Color(0xFF2E8B57),
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.createError ?? 'Gagal menambahkan mata kuliah.',
          ),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    const background = Color(0xFFF3F8F4);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Tambah Mata Kuliah'),
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                        hint: 'Contoh: IF210',
                        icon: Icons.tag,
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
                      decoration: _decoration(
                        hint: 'Masukkan nama mata kuliah',
                        icon: Icons.menu_book_outlined,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nama mata kuliah wajib diisi';
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
                        hint: 'Contoh: 3',
                        icon: Icons.school_outlined,
                      ),
                      validator: (value) {
                        final credits = int.tryParse(value?.trim() ?? '');

                        if (credits == null || credits < 1 || credits > 10) {
                          return 'SKS harus berupa angka antara 1–10';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    _label('Status Mata Kuliah'),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedStatus,
                      isExpanded: true,
                      decoration: _decoration(
                        hint: 'Pilih status',
                        icon: Icons.flag_outlined,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'planned',
                          child: Text('Direncanakan'),
                        ),
                        DropdownMenuItem(value: 'active', child: Text('Aktif')),
                        DropdownMenuItem(value: 'done', child: Text('Selesai')),
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
                        onPressed: provider.isCreating ? null : _saveCourse,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF2E8B57),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        icon: provider.isCreating
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
                          provider.isCreating
                              ? 'Menyimpan...'
                              : 'Simpan Mata Kuliah',
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
    );
  }
}
