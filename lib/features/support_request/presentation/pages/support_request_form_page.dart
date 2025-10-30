import 'package:flutter/material.dart';
import '/core/presentation/theme/app_colors.dart';
import '../../../data_generator/domain/entities/lien_he_entity.dart';
import '../../data/datasources/firebase_support_request_datasource.dart';
import '../../data/repositories/support_request_repository_impl.dart';
import '../../domain/repositories/support_request_repository.dart';

class SupportRequestFormPage extends StatefulWidget {
  const SupportRequestFormPage({super.key});

  @override
  State<SupportRequestFormPage> createState() => _SupportRequestFormPageState();
}

class _SupportRequestFormPageState extends State<SupportRequestFormPage> {
  final _formKey = GlobalKey<FormState>();
  late SupportRequestRepository _repository;

  final _maSinhVienController = TextEditingController();
  final _tenSinhVienController = TextEditingController();
  final _lopController = TextEditingController();
  final _noiDungController = TextEditingController();

  String? _selectedRequestType;
  bool _isSubmitting = false;

  final List<String> _requestTypes = [
    'Làm lại thẻ sinh viên',
    'Mở tài khoản sinh viên',
    'Mở thêm lớp thể chất',
    'Hỗ trợ học tập',
    'Vấn đề kỹ thuật',
    'Khác',
  ];

  @override
  void initState() {
    super.initState();
    _repository = SupportRequestRepositoryImpl(
      FirebaseSupportRequestDataSource(),
    );
  }

  @override
  void dispose() {
    _maSinhVienController.dispose();
    _tenSinhVienController.dispose();
    _lopController.dispose();
    _noiDungController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedRequestType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn loại yêu cầu'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Gộp tất cả thông tin vào noiDung
      final noiDung = _buildNoiDung();

      // Tạo mã liên hệ tự động
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final maLienHe =
          'LH${timestamp.toString().substring(timestamp.toString().length - 6)}';

      // Tạo entity
      final request = LienHeEntity(
        maLienHe: maLienHe,
        noiDung: noiDung,
        ngayGui: DateTime.now(),
        trangThaiPhanHoi: 'Chưa phản hồi',
        maSV: _maSinhVienController.text,
      );

      // Gửi yêu cầu
      await _repository.submitSupportRequest(request);

      if (mounted) {
        // Reset form
        _formKey.currentState!.reset();
        _maSinhVienController.clear();
        _tenSinhVienController.clear();
        _lopController.clear();
        _noiDungController.clear();
        _selectedRequestType = null;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gửi yêu cầu thành công!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  String _buildNoiDung() {
    return '''Mã sinh viên: ${_maSinhVienController.text}
Tên: ${_tenSinhVienController.text}
Lớp: ${_lopController.text}
Loại yêu cầu: $_selectedRequestType
Nội dung: ${_noiDungController.text}''';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nhập thông tin cần hỗ trợ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),

            // Mã sinh viên
            TextFormField(
              controller: _maSinhVienController,
              decoration: InputDecoration(
                labelText: 'Mã sinh viên',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập mã sinh viên';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Tên sinh viên
            TextFormField(
              controller: _tenSinhVienController,
              decoration: InputDecoration(
                labelText: 'Tên sinh viên',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tên sinh viên';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Lớp
            TextFormField(
              controller: _lopController,
              decoration: InputDecoration(
                labelText: 'Lớp',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập lớp';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Loại yêu cầu
            DropdownButtonFormField<String>(
              value: _selectedRequestType,
              decoration: InputDecoration(
                labelText: 'Loại yêu cầu',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: const Icon(Icons.arrow_drop_down),
              ),
              items: _requestTypes.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRequestType = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng chọn loại yêu cầu';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Nội dung
            TextFormField(
              controller: _noiDungController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Nội dung',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập nội dung';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Nút gửi
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        'Gửi yêu cầu',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // Liên hệ
            Center(
              child: GestureDetector(
                onTap: () {
                  // TODO: Implement call functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Liên hệ: 0911111111')),
                  );
                },
                child: const Text(
                  'Liên hệ: 0911111111',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
