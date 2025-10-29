import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '/core/presentation/theme/app_colors.dart';
import '../../../data_generator/domain/entities/lien_he_entity.dart';

class SupportRequestDetailPage extends StatelessWidget {
  final LienHeEntity request;

  const SupportRequestDetailPage({super.key, required this.request});

  Map<String, String> _parseNoiDung(String noiDung) {
    final Map<String, String> info = {};
    final lines = noiDung.split('\n');

    for (var line in lines) {
      if (line.contains(':')) {
        final parts = line.split(':');
        if (parts.length >= 2) {
          final key = parts[0].trim();
          final value = parts.sublist(1).join(':').trim();
          info[key] = value;
        }
      }
    }

    return info;
  }

  @override
  Widget build(BuildContext context) {
    final infoMap = _parseNoiDung(request.noiDung);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Chi tiết yêu cầu hỗ trợ',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () => context.go('/notifications'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card thông tin chính
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thông tin Yêu cầu Hỗ trợ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow('Mã yêu cầu', request.maLienHe),
                  if (infoMap.containsKey('Mã sinh viên'))
                    _buildDetailRow('Mã sinh viên', infoMap['Mã sinh viên']!),
                  if (infoMap.containsKey('Tên'))
                    _buildDetailRow('Tên', infoMap['Tên']!),
                  if (infoMap.containsKey('Lớp'))
                    _buildDetailRow('Lớp', infoMap['Lớp']!),
                  if (infoMap.containsKey('Loại yêu cầu'))
                    _buildDetailRow('Loại yêu cầu', infoMap['Loại yêu cầu']!),
                  _buildDetailRow(
                    'Ngày gửi',
                    dateFormat.format(request.ngayGui),
                  ),
                  _buildDetailRow('Trạng thái', request.trangThaiPhanHoi),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Nội dung chi tiết
            if (infoMap.containsKey('Nội dung')) ...[
              const Text(
                'Nội dung',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Text(
                  infoMap['Nội dung']!,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[800],
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Nội dung đầy đủ (raw)
            const Text(
              'Thông tin đầy đủ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Text(
                request.noiDung,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
