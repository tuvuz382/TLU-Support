import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/core/presentation/theme/app_colors.dart';
import '/features/data_generator/domain/entities/sinh_vien_entity.dart';
import '../../data/repositories/student_profile_repository_impl.dart';
import '../../data/datasources/student_profile_remote_datasource.dart';
import '../../domain/usecases/get_current_student_profile_usecase.dart';
import '../../domain/usecases/update_profile_image_usecase.dart';
import '../../domain/usecases/update_student_profile_usecase.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _studentIdController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _classController = TextEditingController();
  final _majorController = TextEditingController();
  
  late final GetCurrentStudentProfileUseCase _getProfileUseCase;
  late final UpdateProfileImageUseCase _updateImageUseCase;
  late final UpdateStudentProfileUseCase _updateProfileUseCase;
  SinhVienEntity? _studentProfile;
  bool _isLoading = false;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // Dependency Injection setup
    final dataSource = StudentProfileRemoteDataSource();
    final repository = StudentProfileRepositoryImpl(remoteDataSource: dataSource);
    _getProfileUseCase = GetCurrentStudentProfileUseCase(repository);
    _updateImageUseCase = UpdateProfileImageUseCase(repository);
    _updateProfileUseCase = UpdateStudentProfileUseCase(repository);
    _loadStudentProfile();
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _classController.dispose();
    _majorController.dispose();
    super.dispose();
  }

  Future<void> _loadStudentProfile() async {
    try {
      final profile = await _getProfileUseCase();
      if (mounted) {
        setState(() {
          _studentProfile = profile;
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
            content: Text('Lỗi khi tải thông tin: $e'),
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
    _selectedDate = student.ngaySinh;
  }


  Future<void> _saveInfo() async {
    if (!_formKey.currentState!.validate()) return;
    if (_studentProfile == null) {
      debugPrint('Không có dữ liệu profile!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không có dữ liệu profile để lưu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() { _isLoading = true; });
    try {
      final updated = SinhVienEntity(
        maSV: _studentProfile!.maSV,
        hoTen: _fullNameController.text.trim(),
        email: _studentProfile!.email,
        matKhau: _studentProfile!.matKhau,
        ngaySinh: _studentProfile!.ngaySinh,
        lop: _classController.text.trim(),
        nganhHoc: _majorController.text.trim(),
        diemGPA: _studentProfile!.diemGPA,
        hocBongDangKy: _studentProfile!.hocBongDangKy,
        anhDaiDien: _studentProfile!.anhDaiDien,
      );
      await _updateProfileUseCase(updated);
      if (!mounted) return;
      setState(() {
        _studentProfile = updated;
        _isLoading = false;
        _populateFields(updated);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã lưu thông tin thành công!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e, st) {
      debugPrint('Lỗi khi lưu thông tin: $e');
      debugPrintStack(label: 'STACKTRACE Lỗi cập nhật thông tin', stackTrace: st);
      if (mounted) {
        setState(() { _isLoading = false; });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lưu thông tin thất bại: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }




  Future<void> _showUpdateAvatarDialog() async {
    final controller = TextEditingController();
    final url = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cập nhật ảnh đại diện'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Nhập URL ảnh đại diện:'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'https://example.com/image.jpg',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Cập nhật'),
          ),
        ],
      ),
    );
    if (url != null && url.isNotEmpty && _studentProfile != null) {
      setState(() { _isLoading = true; });
      try {
        await _updateImageUseCase(url);
        if (!mounted) return;
        setState(() {
          _studentProfile = SinhVienEntity(
            maSV: _studentProfile!.maSV,
            hoTen: _studentProfile!.hoTen,
            email: _studentProfile!.email,
            matKhau: _studentProfile!.matKhau,
            ngaySinh: _studentProfile!.ngaySinh,
            lop: _studentProfile!.lop,
            nganhHoc: _studentProfile!.nganhHoc,
            diemGPA: _studentProfile!.diemGPA,
            hocBongDangKy: _studentProfile!.hocBongDangKy,
            anhDaiDien: url, // cập nhật ngay
          );
          _populateFields(_studentProfile!);
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã cập nhật ảnh đại diện!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        if (mounted) {
          setState(() { _isLoading = false; });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi khi cập nhật ảnh: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () {
            context.go('/profile');
          },
        ),
        title: const Text(
          'Thông tin cá nhân',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                    // Profile Section
                    Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                          child: (_studentProfile?.anhDaiDien != null && _studentProfile!.anhDaiDien!.isNotEmpty)
                              ? ClipOval(
                                  child: Image.network(
                                    _studentProfile!.anhDaiDien!,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: 60,
                                        ),
                                  ),
                                )
                              : const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 60,
                                ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _showUpdateAvatarDialog,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: AppColors.textPrimary,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Form Fields
                    _buildTextField(
                      label: 'Mã sinh viên',
                      controller: _studentIdController,
                      enabled: false,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    _buildTextField(
                      label: 'Họ và Tên',
                      controller: _fullNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập họ và tên';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    _buildTextField(
                      label: 'Email',
                      controller: _emailController,
                      enabled: false, // Email không được chỉnh sửa
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập email';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Date picker field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ngày sinh',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedDate != null
                                    ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                    : 'Chưa có thông tin',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _selectedDate != null
                                      ? AppColors.textPrimary
                                      : AppColors.textSecondary,
                                ),
                              ),
                              const Icon(
                                Icons.calendar_today,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    _buildTextField(
                      label: 'Lớp',
                      controller: _classController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập lớp';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    _buildTextField(
                      label: 'Ngành học',
                      controller: _majorController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập ngành học';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Action Buttons
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: _saveInfo,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Lưu Thông tin',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.2),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
    Widget? suffixIcon,
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
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          enabled: enabled,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
