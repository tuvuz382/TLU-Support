import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../profile/data/repositories/student_profile_repository_impl.dart';
import '../../../profile/data/datasources/student_profile_remote_datasource.dart';
import '../../../profile/domain/usecases/get_current_student_profile_usecase.dart';
import '../../../data_generator/domain/entities/sinh_vien_entity.dart';
import '../../data/datasources/scholarship_remote_datasource.dart';
import '../../data/repositories/scholarship_repository_impl.dart';
import '../../domain/usecases/register_scholarship_usecase.dart';

class ScholarshipRegistrationPage extends StatefulWidget {
  final String? scholarshipId;
  final String? scholarshipTitle; // For backwards compatibility
  
  const ScholarshipRegistrationPage({
    super.key,
    this.scholarshipId,
    this.scholarshipTitle,
  });

  @override
  State<ScholarshipRegistrationPage> createState() => _ScholarshipRegistrationPageState();
}

class _ScholarshipRegistrationPageState extends State<ScholarshipRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _studentIdController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _classController = TextEditingController();
  final _majorController = TextEditingController();
  final _gpaController = TextEditingController();
  
  late final GetCurrentStudentProfileUseCase _getProfileUseCase;
  late final RegisterScholarshipUseCase _registerScholarshipUseCase;
  DateTime? _selectedDate;
  bool _isLoading = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Dependency Injection setup
    final dataSource = StudentProfileRemoteDataSource();
    final repository = StudentProfileRepositoryImpl(remoteDataSource: dataSource);
    _getProfileUseCase = GetCurrentStudentProfileUseCase(repository);

    // Scholarship DI
    final scholarshipRemote = ScholarshipRemoteDataSource();
    final scholarshipRepo = ScholarshipRepositoryImpl(remoteDataSource: scholarshipRemote);
    _registerScholarshipUseCase = RegisterScholarshipUseCase(scholarshipRepo);
    _loadStudentProfile();
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _classController.dispose();
    _majorController.dispose();
    _gpaController.dispose();
    super.dispose();
  }

  Future<void> _loadStudentProfile() async {
    try {
      final profile = await _getProfileUseCase();
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        if (profile != null) {
          _populateFields(profile);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi tải thông tin sinh viên: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _populateFields(SinhVienEntity student) {
    _studentIdController.text = student.maSV;
    _fullNameController.text = student.hoTen;
    _emailController.text = student.email;
    _classController.text = student.lop;
    _majorController.text = student.nganhHoc;
    _gpaController.text = student.diemGPA.toStringAsFixed(2);
    _selectedDate = student.ngaySinh;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.scholarshipList);
              }
            },
          ),
          title: const Text(
            'Học bổng',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.scholarshipList);
            }
          },
        ),
        title: const Text(
          'Học bổng',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Text(
                  'THÔNG TIN ĐĂNG KÝ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Student ID Field
                _buildTextField(
                  label: 'Mã sinh viên',
                  controller: _studentIdController,
                  enabled: true, // Cho phép chỉnh sửa
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập mã sinh viên';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Full Name Field
                _buildTextField(
                  label: 'Họ và tên',
                  controller: _fullNameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập họ và tên';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Email Field
                _buildTextField(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Email không đúng định dạng';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Date of Birth Field
                _buildDateField(),
                const SizedBox(height: 16),
                
                // Class Field
                _buildTextField(
                  label: 'Lớp',
                  controller: _classController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập lớp';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Major Field
                _buildTextField(
                  label: 'Ngành học',
                  controller: _majorController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập ngành học';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // GPA Field
                _buildTextField(
                  label: 'GPA',
                  controller: _gpaController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập GPA';
                    }
                    final gpa = double.tryParse(value);
                    if (gpa == null || gpa < 0 || gpa > 4.0) {
                      return 'GPA phải từ 0.0 đến 4.0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                
                // Register Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _handleRegistration,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Đăng ký',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: 'Nhập $label',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ngày sinh',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectDate,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _selectedDate != null
                  ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                  : 'Chọn ngày sinh',
              style: TextStyle(
                color: _selectedDate != null ? Colors.black : Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn ngày sinh'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Thực hiện đăng ký học bổng thực tế
      if (widget.scholarshipId == null || widget.scholarshipId!.isEmpty) {
        throw Exception('Thiếu mã học bổng');
      }

      final registrationId = await _registerScholarshipUseCase(widget.scholarshipId!);

      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });

        // Navigate to registration info page (giữ nguyên UX hiện tại)
        context.go(AppRoutes.scholarshipRegistrationInfo, extra: {
          'scholarshipId': widget.scholarshipId,
          'scholarshipTitle': widget.scholarshipTitle ?? 'Học bổng',
          'studentId': _studentIdController.text,
          'fullName': _fullNameController.text,
          'email': _emailController.text,
          'dateOfBirth': _selectedDate!,
          'class': _classController.text,
          'major': _majorController.text,
          'gpa': _gpaController.text,
          'registrationId': registrationId,
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi đăng ký: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
