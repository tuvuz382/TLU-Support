import '../../domain/entities/scholarship_entity.dart';
import '../../domain/repositories/scholarship_repository.dart';
import '../datasources/scholarship_remote_datasource.dart';

/// Implementation của ScholarshipRepository
/// Kết nối Domain layer với Data layer thông qua DataSource
class ScholarshipRepositoryImpl implements ScholarshipRepository {
  final ScholarshipRemoteDataSource _remoteDataSource;

  ScholarshipRepositoryImpl({
    required ScholarshipRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<List<ScholarshipEntity>> getAllScholarships() async {
    try {
      final data = await _remoteDataSource.getAllScholarships();
      return data.map((item) => ScholarshipEntity.fromFirestore(item)).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách học bổng: $e');
    }
  }

  @override
  Future<ScholarshipEntity?> getScholarshipById(String maHB) async {
    try {
      final data = await _remoteDataSource.getScholarshipByMaHB(maHB);
      if (data == null) return null;
      return ScholarshipEntity.fromFirestore(data);
    } catch (e) {
      throw Exception('Lỗi khi lấy thông tin học bổng: $e');
    }
  }

  @override
  Stream<List<ScholarshipEntity>> watchScholarships() {
    return _remoteDataSource.watchScholarships().map((dataList) {
      return dataList
          .map((item) => ScholarshipEntity.fromFirestore(item))
          .toList();
    });
  }

  @override
  Future<String> registerScholarship(String maHB) async {
    try {
      final email = _remoteDataSource.getCurrentUserEmail();
      if (email == null) {
        throw Exception('Người dùng chưa đăng nhập');
      }

      // Kiểm tra đã đăng ký chưa
      final hasRegistered =
          await _remoteDataSource.hasRegisteredScholarship(email, maHB);
      if (hasRegistered) {
        throw Exception('Bạn đã đăng ký học bổng này rồi');
      }

      final registrationData = {
        'maHB': maHB,
        'email': email,
        'thoiGianDangKy': DateTime.now().toIso8601String(),
        'trangThai': 'pending',
      };

      return await _remoteDataSource.createRegistration(registrationData);
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Lỗi khi đăng ký học bổng: $e');
    }
  }

  @override
  Future<List<ScholarshipRegistrationEntity>>
      getRegisteredScholarships() async {
    try {
      final email = _remoteDataSource.getCurrentUserEmail();
      if (email == null) {
        return [];
      }

      final data =
          await _remoteDataSource.getRegistrationsByEmail(email);
      return data
          .map((item) => ScholarshipRegistrationEntity.fromFirestore(
              item['id'] as String, item))
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách đăng ký: $e');
    }
  }

  @override
  Stream<List<ScholarshipRegistrationEntity>>
      watchRegisteredScholarships() {
    final email = _remoteDataSource.getCurrentUserEmail();
    if (email == null) {
      return Stream.value([]);
    }

    return _remoteDataSource.watchRegistrationsByEmail(email).map((dataList) {
      return dataList
          .map((item) => ScholarshipRegistrationEntity.fromFirestore(
              item['id'] as String, item))
          .toList();
    });
  }

  @override
  Future<bool> hasRegisteredScholarship(String maHB) async {
    try {
      final email = _remoteDataSource.getCurrentUserEmail();
      if (email == null) return false;

      return await _remoteDataSource.hasRegisteredScholarship(email, maHB);
    } catch (e) {
      return false; // Graceful failure
    }
  }

  @override
  Future<ScholarshipRegistrationEntity?> getRegistrationById(
      String id) async {
    try {
      final data = await _remoteDataSource.getRegistrationById(id);
      if (data == null) return null;

      return ScholarshipRegistrationEntity.fromFirestore(
          data['id'] as String, data);
    } catch (e) {
      throw Exception('Lỗi khi lấy thông tin đăng ký: $e');
    }
  }

  @override
  Future<void> cancelRegistration(String registrationId) async {
    try {
      await _remoteDataSource.deleteRegistration(registrationId);
    } catch (e) {
      throw Exception('Lỗi khi hủy đăng ký: $e');
    }
  }

  @override
  Future<List<ScholarshipEntity>> getOpenScholarships() async {
    try {
      final data = await _remoteDataSource.getOpenScholarships();
      return data.map((item) => ScholarshipEntity.fromFirestore(item)).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách học bổng đang mở: $e');
    }
  }

  @override
  Future<List<ScholarshipEntity>> getExpiredScholarships() async {
    try {
      final data = await _remoteDataSource.getExpiredScholarships();
      return data.map((item) => ScholarshipEntity.fromFirestore(item)).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách học bổng đã hết hạn: $e');
    }
  }
}

