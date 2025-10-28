import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/core/presentation/theme/app_colors.dart';
import '/features/data_generator/data/services/data_generator_service.dart';
import '/features/data_generator/domain/entities/sinh_vien_entity.dart';
import '../../domain/repositories/student_profile_repository.dart';
import '../../data/repositories/student_profile_repository_impl.dart';
import '../../data/datasources/student_profile_remote_datasource.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final StudentProfileRepository _studentRepository;
  SinhVienEntity? _studentProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Dependency Injection setup
    final dataSource = StudentProfileRemoteDataSource();
    _studentRepository = StudentProfileRepositoryImpl(remoteDataSource: dataSource);
    _loadStudentProfile();
  }

  Future<void> _loadStudentProfile() async {
    try {
      final profile = await _studentRepository.getCurrentStudentProfile();
      if (mounted) {
        setState(() {
          _studentProfile = profile;
          _isLoading = false;
        });
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

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        context.go('/login_page');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi đăng xuất: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _generateSampleData(BuildContext context) async {
    try {
      // Hiển thị dialog loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final dataGeneratorService = DataGeneratorService();
      await dataGeneratorService.generateSampleData();

      // Đóng dialog loading
      if (context.mounted) {
        Navigator.of(context).pop();
        
        // Hiển thị thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sinh dữ liệu mẫu thành công!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Đóng dialog loading nếu có lỗi
      if (context.mounted) {
        Navigator.of(context).pop();
        
        // Hiển thị thông báo lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi sinh dữ liệu: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa dữ liệu'),
          content: const Text(
            'Bạn có chắc chắn muốn xóa toàn bộ dữ liệu mẫu đã sinh?\n\n'
            'Hành động này không thể hoàn tác!',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Xóa',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAllSampleData(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAllSampleData(BuildContext context) async {
    try {
      // Hiển thị dialog loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final dataGeneratorService = DataGeneratorService();
      await dataGeneratorService.deleteAllSampleData();

      // Đóng dialog loading
      if (context.mounted) {
        Navigator.of(context).pop();
        
        // Hiển thị thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Xóa dữ liệu mẫu thành công!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Đóng dialog loading nếu có lỗi
      if (context.mounted) {
        Navigator.of(context).pop();
        
        // Hiển thị thông báo lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi xóa dữ liệu: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang cá nhân'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Thông tin người dùng
            _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : _studentProfile == null
                    ? _buildNoProfileView(user)
                    : _buildProfileView(),
            
            const SizedBox(height: 24),
            
            // Menu options
            Expanded(
              child: ListView(
                children: [
                  _buildMenuItem(
                    icon: Icons.person,
                    title: 'Thông tin cá nhân',
                    onTap: () => context.go('/personal-info'),
                  ),
                  _buildMenuItem(
                    icon: Icons.school,
                    title: 'Chọn profile có sẵn',
                    onTap: () => context.go('/profile-selector'),
                  ),
                  // Chỉ hiển thị các nút quản lý dữ liệu cho admin123@gmail.com
                  if (user?.email == 'admin123@gmail.com') ...[
                    _buildMenuItem(
                      icon: Icons.data_object,
                      title: 'Sinh dữ liệu mẫu',
                      onTap: () => _generateSampleData(context),
                    ),
                    _buildMenuItem(
                      icon: Icons.delete_forever,
                      title: 'Xóa dữ liệu mẫu',
                      onTap: () => _showDeleteConfirmationDialog(context),
                      isDestructive: true,
                    ),
                    const Divider(),
                  ],
                  _buildMenuItem(
                    icon: Icons.settings,
                    title: 'Cài đặt',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.help,
                    title: 'Trợ giúp',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.info,
                    title: 'Về ứng dụng',
                    onTap: () {},
                  ),
                  const Divider(),
                  _buildMenuItem(
                    icon: Icons.logout,
                    title: 'Đăng xuất',
                    onTap: () => _signOut(context),
                    isDestructive: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoProfileView(User? user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Icon(
              Icons.person,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user?.email ?? 'Người dùng',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.orange, width: 1),
            ),
            child: const Text(
              'Chưa có thông tin profile',
              style: TextStyle(
                fontSize: 12,
                color: Colors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => context.go('/profile-selector'),
            icon: const Icon(Icons.school),
            label: const Text('Chọn profile có sẵn'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileView() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            backgroundImage: _studentProfile?.anhDaiDien != null
                ? NetworkImage(_studentProfile!.anhDaiDien!)
                : null,
            child: _studentProfile?.anhDaiDien == null
                ? Icon(
                    Icons.person,
                    size: 40,
                    color: AppColors.primary,
                  )
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            _studentProfile?.hoTen ?? 'Người dùng',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          if (_studentProfile?.maSV != null) ...[
            const SizedBox(height: 4),
            Text(
              _studentProfile!.maSV,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            _studentProfile?.lop != null && _studentProfile!.lop.isNotEmpty
                ? 'Lớp ${_studentProfile!.lop}'
                : 'Sinh viên TLU',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          if (_studentProfile?.nganhHoc != null && 
              _studentProfile!.nganhHoc.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              _studentProfile!.nganhHoc,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }


  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.error : AppColors.primary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? AppColors.error : AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
