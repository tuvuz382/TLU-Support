import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/core/presentation/theme/app_colors.dart';
import '../../../data_generator/domain/entities/lien_he_entity.dart';

class SupportRequestCard extends StatelessWidget {
  final LienHeEntity request;
  final VoidCallback? onTap;

  const SupportRequestCard({super.key, required this.request, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Parse thông tin từ noiDung
    final infoMap = _parseNoiDung(request.noiDung);

    // Lấy tên, MSV, yêu cầu từ noiDung
    final ten = infoMap['Tên'] ?? 'N/A';
    final msv = infoMap['Mã sinh viên'] ?? infoMap['MSV'] ?? 'N/A';
    final yeuCau = infoMap['Loại yêu cầu'] ?? infoMap['Yêu cầu'] ?? 'N/A';

    return GestureDetector(
      onTap:
          onTap ??
          () {
            context.push('/support-request-detail', extra: request);
          },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Thông tin Yêu cầu Hỗ trợ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Thông tin
            _buildInfoRow('Tên', ten),
            _buildInfoRow('MSV', msv),
            _buildInfoRow('Yêu cầu', yeuCau),

            // Thời gian xử lý (chỉ hiện khi chờ xác nhận)
            if (request.trangThaiPhanHoi == 'Chưa phản hồi' ||
                request.trangThaiPhanHoi == 'Đang xử lý') ...[
              const SizedBox(height: 4),
              _buildInfoRow(
                'Thời gian xử lý',
                _formatProcessingTime(request.ngayGui),
              ),
            ],

            // Trạng thái (chỉ hiện khi đã xử lý)
            if (request.trangThaiPhanHoi == 'Đã phản hồi') ...[
              const SizedBox(height: 4),
              _buildInfoRow('Trạng thái', request.trangThaiPhanHoi),
            ],

            const SizedBox(height: 8),

            // Link xem chi tiết
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap:
                    onTap ??
                    () {
                      context.push('/support-request-detail', extra: request);
                    },
                child: const Text(
                  'xem chi tiết',
                  style: TextStyle(
                    color: Colors.white,
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        '$label: $value',
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

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

  String _formatProcessingTime(DateTime ngayGui) {
    // Tính toán thời gian xử lý (ví dụ: 7 ngày)
    final endDate = ngayGui.add(const Duration(days: 7));
    return '${ngayGui.day.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}/${ngayGui.month.toString().padLeft(2, '0')}/${endDate.year}';
  }
}
