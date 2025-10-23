import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/core/presentation/theme/app_colors.dart';
import '../../data/datasources/firebase_teacher_datasource.dart';

class AddTeacherPage extends StatefulWidget {
  const AddTeacherPage({super.key});

  @override
  State<AddTeacherPage> createState() => _AddTeacherPageState();
}

class _AddTeacherPageState extends State<AddTeacherPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseTeacherDatasource _datasource = FirebaseTeacherDatasource();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _officeLocationController = TextEditingController();
  final _specializationController = TextEditingController();

  // Dropdowns
  String _selectedDegree = 'ThS';
  String _selectedDepartment = 'Công nghệ phần mềm';
  String _selectedFaculty = 'Công nghệ thông tin';

  // Specializations
  final List<String> _specializations = [];

  bool _isLoading = false;

  final List<String> _degrees = ['ThS', 'TS', 'PGS.TS', 'GS.TS'];
  final List<String> _departments = [
    'Công nghệ phần mềm',
    'Khoa học máy tính',
    'Hệ thống thông tin',
    'Kỹ thuật máy tính',
    'Mạng máy tính và truyền thông',
  ];
  final List<String> _faculties = [
    'Công nghệ thông tin',
    'Khoa học tự nhiên',
    'Kinh tế',
    'Ngoại ngữ',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _officeLocationController.dispose();
    _specializationController.dispose();
    super.dispose();
  }

  void _addSpecialization() {
    final spec = _specializationController.text.trim();
    if (spec.isNotEmpty && !_specializations.contains(spec)) {
      setState(() {
        _specializations.add(spec);
        _specializationController.clear();
      });
    }
  }

  void _removeSpecialization(String spec) {
    setState(() {
      _specializations.remove(spec);
    });
  }

  Future<void> _saveTeacher() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_specializations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng thêm ít nhất một lĩnh vực nghiên cứu'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final teacherData = {
        'name': _nameController.text.trim(),
        'department': _selectedDepartment,
        'faculty': _selectedFaculty,
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'degree': _selectedDegree,
        'specializations': _specializations,
        'officeLocation': _officeLocationController.text.trim(),
      };

      await _datasource.addTeacher(teacherData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Đã thêm giảng viên thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop(true); // Return true để refresh danh sách
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Thêm giảng viên',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Thông tin cơ bản
            _buildSectionTitle('Thông tin cơ bản'),
            _buildCard([
              // Học vị
              DropdownButtonFormField<String>(
                value: _selectedDegree,
                decoration: const InputDecoration(
                  labelText: 'Học vị *',
                  prefixIcon: Icon(Icons.school, color: AppColors.primary),
                ),
                items: _degrees.map((degree) {
                  return DropdownMenuItem(
                    value: degree,
                    child: Text(degree),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedDegree = value!);
                },
              ),
              const SizedBox(height: 16),

              // Họ tên
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Họ và tên *',
                  hintText: 'VD: Nguyễn Văn A',
                  prefixIcon: Icon(Icons.person, color: AppColors.primary),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập họ tên';
                  }
                  return null;
                },
              ),
            ]),

            const SizedBox(height: 24),

            // Đơn vị
            _buildSectionTitle('Đơn vị công tác'),
            _buildCard([
              // Khoa
              DropdownButtonFormField<String>(
                value: _selectedFaculty,
                decoration: const InputDecoration(
                  labelText: 'Khoa *',
                  prefixIcon: Icon(Icons.business, color: AppColors.primary),
                ),
                items: _faculties.map((faculty) {
                  return DropdownMenuItem(
                    value: faculty,
                    child: Text(faculty),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedFaculty = value!);
                },
              ),
              const SizedBox(height: 16),

              // Bộ môn
              DropdownButtonFormField<String>(
                value: _selectedDepartment,
                decoration: const InputDecoration(
                  labelText: 'Bộ môn *',
                  prefixIcon: Icon(Icons.category, color: AppColors.primary),
                ),
                items: _departments.map((dept) {
                  return DropdownMenuItem(
                    value: dept,
                    child: Text(dept),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedDepartment = value!);
                },
              ),
              const SizedBox(height: 16),

              // Phòng làm việc
              TextFormField(
                controller: _officeLocationController,
                decoration: const InputDecoration(
                  labelText: 'Phòng làm việc',
                  hintText: 'VD: Phòng 301 - Nhà A',
                  prefixIcon: Icon(Icons.location_on, color: AppColors.primary),
                ),
              ),
            ]),

            const SizedBox(height: 24),

            // Thông tin liên hệ
            _buildSectionTitle('Thông tin liên hệ'),
            _buildCard([
              // Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email *',
                  hintText: 'VD: nguyenvana@tlu.edu.vn',
                  prefixIcon: Icon(Icons.email, color: AppColors.primary),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập email';
                  }
                  if (!value.contains('@')) {
                    return 'Email không hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Số điện thoại
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại *',
                  hintText: 'VD: 0912345678',
                  prefixIcon: Icon(Icons.phone, color: AppColors.primary),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  }
                  if (value.length < 10) {
                    return 'Số điện thoại không hợp lệ';
                  }
                  return null;
                },
              ),
            ]),

            const SizedBox(height: 24),

            // Lĩnh vực nghiên cứu
            _buildSectionTitle('Lĩnh vực nghiên cứu'),
            _buildCard([
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _specializationController,
                      decoration: const InputDecoration(
                        labelText: 'Thêm lĩnh vực',
                        hintText: 'VD: Trí tuệ nhân tạo',
                        prefixIcon: Icon(Icons.lightbulb, color: AppColors.primary),
                      ),
                      onSubmitted: (_) => _addSpecialization(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addSpecialization,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Danh sách lĩnh vực đã thêm
              if (_specializations.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _specializations.map((spec) {
                    return Chip(
                      label: Text(spec),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () => _removeSpecialization(spec),
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      labelStyle: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }).toList(),
                )
              else
                Text(
                  'Chưa có lĩnh vực nghiên cứu nào',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ]),

            const SizedBox(height: 32),

            // Nút lưu
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _saveTeacher,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(
                  _isLoading ? 'Đang lưu...' : 'Lưu giảng viên',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

