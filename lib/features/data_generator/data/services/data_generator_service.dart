import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/sinh_vien_entity.dart';
import '../../domain/entities/hoc_bong_entity.dart';
import '../../domain/entities/mon_hoc_entity.dart';
import '../../domain/entities/danh_gia_entity.dart';
import '../../domain/entities/ghi_chu_entity.dart';
import '../../domain/entities/lien_he_entity.dart';
import '../../domain/entities/thong_bao_entity.dart';
import '../../domain/entities/lich_hoc_entity.dart';
import '../../domain/entities/tai_lieu_entity.dart';

class DataGeneratorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> generateSampleData() async {
    try {
      // Tạo dữ liệu mẫu cho tất cả các collection
      await _generateSinhVienData();
      await _generateHocBongData();
      await _generateMonHocData();
      await _generateDanhGiaData();
      await _generateGhiChuData();
      await _generateLienHeData();
      await _generateThongBaoData();
      await _generateLichHocData();
      await _generateTaiLieuData();
    } catch (e) {
      throw Exception('Lỗi khi sinh dữ liệu: $e');
    }
  }

  Future<void> deleteAllSampleData() async {
    try {
      // Xóa dữ liệu từ tất cả các collection
      await _deleteCollectionData('sinhVien');
      await _deleteCollectionData('hocBong');
      await _deleteCollectionData('monHoc');
      await _deleteCollectionData('danhGia');
      await _deleteCollectionData('ghiChu');
      await _deleteCollectionData('lienHe');
      await _deleteCollectionData('thongBao');
      await _deleteCollectionData('lichHoc');
      await _deleteCollectionData('taiLieu');
    } catch (e) {
      throw Exception('Lỗi khi xóa dữ liệu: $e');
    }
  }

  Future<void> _deleteCollectionData(String collectionName) async {
    final collection = _firestore.collection(collectionName);
    final snapshot = await collection.get();
    
    // Xóa từng document trong batch để tối ưu hiệu suất
    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    
    if (snapshot.docs.isNotEmpty) {
      await batch.commit();
    }
  }

  Future<void> _generateSinhVienData() async {
    final sinhVienList = [
      SinhVienEntity(
        maSV: 'SV001',
        hoTen: 'Nguyễn Văn An',
        email: 'an.nguyen@student.tlu.edu.vn',
        matKhau: 'password123',
        ngaySinh: DateTime(2000, 5, 15),
        lop: 'CNTT01',
        nganhHoc: 'Công nghệ thông tin',
        diemGPA: 3.5,
        hocBongDangKy: ['HB001', 'HB002'],
        anhDaiDien: null,
      ),
      SinhVienEntity(
        maSV: 'SV002',
        hoTen: 'Trần Thị Bình',
        email: 'binh.tran@student.tlu.edu.vn',
        matKhau: 'password123',
        ngaySinh: DateTime(2001, 8, 22),
        lop: 'CNTT02',
        nganhHoc: 'Công nghệ thông tin',
        diemGPA: 3.8,
        hocBongDangKy: ['HB001'],
        anhDaiDien: null,
      ),
      SinhVienEntity(
        maSV: 'SV003',
        hoTen: 'Lê Văn Cường',
        email: 'cuong.le@student.tlu.edu.vn',
        matKhau: 'password123',
        ngaySinh: DateTime(1999, 12, 10),
        lop: 'KT01',
        nganhHoc: 'Kế toán',
        diemGPA: 3.2,
        hocBongDangKy: ['HB003'],
        anhDaiDien: null,
      ),
      SinhVienEntity(
        maSV: 'SV004',
        hoTen: 'Phạm Thị Dung',
        email: 'dung.pham@student.tlu.edu.vn',
        matKhau: 'password123',
        ngaySinh: DateTime(2000, 3, 18),
        lop: 'QTKD01',
        nganhHoc: 'Quản trị kinh doanh',
        diemGPA: 3.6,
        hocBongDangKy: ['HB002', 'HB004'],
        anhDaiDien: null,
      ),
      SinhVienEntity(
        maSV: 'SV005',
        hoTen: 'Hoàng Văn Em',
        email: 'em.hoang@student.tlu.edu.vn',
        matKhau: 'password123',
        ngaySinh: DateTime(2001, 7, 5),
        lop: 'CNTT01',
        nganhHoc: 'Công nghệ thông tin',
        diemGPA: 3.9,
        hocBongDangKy: ['HB001', 'HB003', 'HB005'],
        anhDaiDien: null,
      ),
    ];

    for (final sinhVien in sinhVienList) {
      await _firestore.collection('sinhVien').add(sinhVien.toFirestore());
    }
  }

  Future<void> _generateHocBongData() async {
    final hocBongList = [
      HocBongEntity(
        maHB: 'HB001',
        tenHB: 'Học bổng khuyến khích học tập',
        moTa: 'Học bổng dành cho sinh viên có thành tích học tập xuất sắc',
        giaTri: 5000000,
        thoiHanDangKy: DateTime(2024, 12, 31),
        trangThaiDangKy: 'Mở',
      ),
      HocBongEntity(
        maHB: 'HB002',
        tenHB: 'Học bổng hỗ trợ sinh viên nghèo',
        moTa: 'Học bổng hỗ trợ sinh viên có hoàn cảnh khó khăn',
        giaTri: 3000000,
        thoiHanDangKy: DateTime(2024, 11, 30),
        trangThaiDangKy: 'Mở',
      ),
      HocBongEntity(
        maHB: 'HB003',
        tenHB: 'Học bổng nghiên cứu khoa học',
        moTa: 'Học bổng dành cho sinh viên tham gia nghiên cứu khoa học',
        giaTri: 7000000,
        thoiHanDangKy: DateTime(2024, 10, 15),
        trangThaiDangKy: 'Mở',
      ),
      HocBongEntity(
        maHB: 'HB004',
        tenHB: 'Học bổng tài năng',
        moTa: 'Học bổng dành cho sinh viên có tài năng đặc biệt',
        giaTri: 10000000,
        thoiHanDangKy: DateTime(2024, 9, 30),
        trangThaiDangKy: 'Mở',
      ),
      HocBongEntity(
        maHB: 'HB005',
        tenHB: 'Học bổng thực tập tốt',
        moTa: 'Học bổng dành cho sinh viên có thành tích thực tập xuất sắc',
        giaTri: 4000000,
        thoiHanDangKy: DateTime(2024, 8, 31),
        trangThaiDangKy: 'Mở',
      ),
    ];

    for (final hocBong in hocBongList) {
      await _firestore.collection('hocBong').add(hocBong.toFirestore());
    }
  }

  Future<void> _generateMonHocData() async {
    final monHocList = [
      MonHocEntity(
        maMon: 'MH001',
        tenMon: 'Lập trình hướng đối tượng',
        soTinChi: 3,
        moTa: 'Môn học về lập trình hướng đối tượng sử dụng Java',
        danhGiaTB: 4.2,
      ),
      MonHocEntity(
        maMon: 'MH002',
        tenMon: 'Cơ sở dữ liệu',
        soTinChi: 3,
        moTa: 'Môn học về thiết kế và quản lý cơ sở dữ liệu',
        danhGiaTB: 4.0,
      ),
      MonHocEntity(
        maMon: 'MH003',
        tenMon: 'Mạng máy tính',
        soTinChi: 3,
        moTa: 'Môn học về nguyên lý và ứng dụng mạng máy tính',
        danhGiaTB: 3.8,
      ),
      MonHocEntity(
        maMon: 'MH004',
        tenMon: 'Phân tích thiết kế hệ thống',
        soTinChi: 3,
        moTa: 'Môn học về phân tích và thiết kế hệ thống thông tin',
        danhGiaTB: 4.1,
      ),
      MonHocEntity(
        maMon: 'MH005',
        tenMon: 'Phát triển ứng dụng di động',
        soTinChi: 3,
        moTa: 'Môn học về phát triển ứng dụng trên nền tảng di động',
        danhGiaTB: 4.3,
      ),
    ];

    for (final monHoc in monHocList) {
      await _firestore.collection('monHoc').add(monHoc.toFirestore());
    }
  }

  Future<void> _generateDanhGiaData() async {
    final danhGiaList = [
      DanhGiaEntity(
        maDanhGia: 'DG001',
        maMon: 'MH001',
        maSV: 'SV001',
        noiDung: 'Môn học rất hay và bổ ích, giảng viên nhiệt tình',
        diemDanhGia: 4.5,
        ngayDanhGia: DateTime(2024, 1, 15),
      ),
      DanhGiaEntity(
        maDanhGia: 'DG002',
        maMon: 'MH001',
        maSV: 'SV002',
        noiDung: 'Nội dung môn học phù hợp với thực tế',
        diemDanhGia: 4.0,
        ngayDanhGia: DateTime(2024, 1, 16),
      ),
      DanhGiaEntity(
        maDanhGia: 'DG003',
        maMon: 'MH002',
        maSV: 'SV001',
        noiDung: 'Môn học khó nhưng rất quan trọng',
        diemDanhGia: 3.8,
        ngayDanhGia: DateTime(2024, 1, 20),
      ),
      DanhGiaEntity(
        maDanhGia: 'DG004',
        maMon: 'MH003',
        maSV: 'SV003',
        noiDung: 'Giảng viên giảng dạy rất dễ hiểu',
        diemDanhGia: 4.2,
        ngayDanhGia: DateTime(2024, 1, 25),
      ),
      DanhGiaEntity(
        maDanhGia: 'DG005',
        maMon: 'MH005',
        maSV: 'SV005',
        noiDung: 'Môn học thú vị và có tính ứng dụng cao',
        diemDanhGia: 4.7,
        ngayDanhGia: DateTime(2024, 2, 1),
      ),
    ];

    for (final danhGia in danhGiaList) {
      await _firestore.collection('danhGia').add(danhGia.toFirestore());
    }
  }

  Future<void> _generateGhiChuData() async {
    final ghiChuList = [
      GhiChuEntity(
        maGhiChu: 'GC001',
        noiDung: 'Cần ôn tập lại phần inheritance trong OOP',
        ngayTao: DateTime(2024, 1, 10),
        monHoc: 'MH001',
      ),
      GhiChuEntity(
        maGhiChu: 'GC002',
        noiDung: 'Làm bài tập về SQL queries',
        ngayTao: DateTime(2024, 1, 12),
        monHoc: 'MH002',
      ),
      GhiChuEntity(
        maGhiChu: 'GC003',
        noiDung: 'Tìm hiểu về TCP/IP protocol',
        ngayTao: DateTime(2024, 1, 15),
        monHoc: 'MH003',
      ),
      GhiChuEntity(
        maGhiChu: 'GC004',
        noiDung: 'Chuẩn bị presentation về UML diagrams',
        ngayTao: DateTime(2024, 1, 18),
        monHoc: 'MH004',
      ),
      GhiChuEntity(
        maGhiChu: 'GC005',
        noiDung: 'Thực hành Flutter widgets',
        ngayTao: DateTime(2024, 1, 20),
        monHoc: 'MH005',
      ),
    ];

    for (final ghiChu in ghiChuList) {
      await _firestore.collection('ghiChu').add(ghiChu.toFirestore());
    }
  }

  Future<void> _generateLienHeData() async {
    final lienHeList = [
      LienHeEntity(
        maLienHe: 'LH001',
        noiDung: '''Mã sinh viên: SV001
Tên: Nguyễn Văn An
Lớp: CNTT01
Loại yêu cầu: Hỗ trợ học tập
Nội dung: Tôi muốn hỏi về thủ tục đăng ký học bổng''',
        ngayGui: DateTime(2024, 1, 5),
        trangThaiPhanHoi: 'Đã phản hồi',
      ),
      LienHeEntity(
        maLienHe: 'LH002',
        noiDung: '''Mã sinh viên: SV002
Tên: Trần Thị Bình
Lớp: CNTT02
Loại yêu cầu: Hỗ trợ học tập
Nội dung: Cần hỗ trợ về việc đăng ký môn học''',
        ngayGui: DateTime(2024, 1, 8),
        trangThaiPhanHoi: 'Đang xử lý',
      ),
      LienHeEntity(
        maLienHe: 'LH003',
        noiDung: '''Mã sinh viên: SV003
Tên: Lê Văn Cường
Lớp: KT01
Loại yêu cầu: Vấn đề kỹ thuật
Nội dung: Báo cáo lỗi hệ thống đăng nhập''',
        ngayGui: DateTime(2024, 1, 10),
        trangThaiPhanHoi: 'Đã phản hồi',
      ),
      LienHeEntity(
        maLienHe: 'LH004',
        noiDung: '''Mã sinh viên: SV004
Tên: Phạm Thị Dung
Lớp: QTKD01
Loại yêu cầu: Làm lại thẻ sinh viên
Nội dung: Yêu cầu cấp lại thẻ sinh viên''',
        ngayGui: DateTime(2024, 1, 12),
        trangThaiPhanHoi: 'Đang xử lý',
      ),
      LienHeEntity(
        maLienHe: 'LH005',
        noiDung: '''Mã sinh viên: SV005
Tên: Hoàng Văn Em
Lớp: CNTT01
Loại yêu cầu: Hỗ trợ học tập
Nội dung: Hỏi về lịch thi cuối kỳ''',
        ngayGui: DateTime(2024, 1, 15),
        trangThaiPhanHoi: 'Chưa phản hồi',
      ),
    ];

    for (final lienHe in lienHeList) {
      await _firestore.collection('lienHe').add(lienHe.toFirestore());
    }
  }

  Future<void> _generateThongBaoData() async {
    final thongBaoList = [
      ThongBaoEntity(
        maTB: 'TB001',
        tieuDe: 'Thông báo về lịch thi cuối kỳ',
        noiDung: 'Lịch thi cuối kỳ sẽ được công bố vào tuần tới. Sinh viên vui lòng theo dõi.',
        ngayDang: DateTime(2024, 1, 1),
      ),
      ThongBaoEntity(
        maTB: 'TB002',
        tieuDe: 'Thông báo về học bổng học kỳ mới',
        noiDung: 'Đăng ký học bổng học kỳ mới bắt đầu từ ngày 15/1/2024.',
        ngayDang: DateTime(2024, 1, 3),
      ),
      ThongBaoEntity(
        maTB: 'TB003',
        tieuDe: 'Thông báo về việc đăng ký môn học',
        noiDung: 'Thời gian đăng ký môn học học kỳ mới từ 20/1 đến 25/1/2024.',
        ngayDang: DateTime(2024, 1, 5),
      ),
      ThongBaoEntity(
        maTB: 'TB004',
        tieuDe: 'Thông báo về hoạt động ngoại khóa',
        noiDung: 'Chương trình hoạt động ngoại khóa sẽ được tổ chức vào cuối tháng.',
        ngayDang: DateTime(2024, 1, 8),
      ),
      ThongBaoEntity(
        maTB: 'TB005',
        tieuDe: 'Thông báo về bảo trì hệ thống',
        noiDung: 'Hệ thống sẽ được bảo trì vào chủ nhật tuần này từ 2h-6h sáng.',
        ngayDang: DateTime(2024, 1, 10),
      ),
    ];

    for (final thongBao in thongBaoList) {
      await _firestore.collection('thongBao').add(thongBao.toFirestore());
    }
  }

  Future<void> _generateLichHocData() async {
    final lichHocList = [
      LichHocEntity(
        maLich: 'LH001',
        maMon: 'MH001',
        ngayHoc: 'Thứ 2',
        tietHoc: 'Tiết 1-3',
        phongHoc: 'A101',
        giangVienPhuTrach: 'ThS. Nguyễn Văn A',
      ),
      LichHocEntity(
        maLich: 'LH002',
        maMon: 'MH002',
        ngayHoc: 'Thứ 3',
        tietHoc: 'Tiết 4-6',
        phongHoc: 'A102',
        giangVienPhuTrach: 'TS. Trần Thị B',
      ),
      LichHocEntity(
        maLich: 'LH003',
        maMon: 'MH003',
        ngayHoc: 'Thứ 4',
        tietHoc: 'Tiết 1-3',
        phongHoc: 'A103',
        giangVienPhuTrach: 'ThS. Lê Văn C',
      ),
      LichHocEntity(
        maLich: 'LH004',
        maMon: 'MH004',
        ngayHoc: 'Thứ 5',
        tietHoc: 'Tiết 4-6',
        phongHoc: 'A104',
        giangVienPhuTrach: 'TS. Phạm Thị D',
      ),
      LichHocEntity(
        maLich: 'LH005',
        maMon: 'MH005',
        ngayHoc: 'Thứ 6',
        tietHoc: 'Tiết 1-3',
        phongHoc: 'A105',
        giangVienPhuTrach: 'ThS. Hoàng Văn E',
      ),
    ];

    for (final lichHoc in lichHocList) {
      await _firestore.collection('lichHoc').add(lichHoc.toFirestore());
    }
  }

  Future<void> _generateTaiLieuData() async {
    final taiLieuList = [
      TaiLieuEntity(
        maTL: 'TL001',
        tenTL: 'Slide bài giảng OOP',
        monHoc: 'MH001',
        duongDan: '/documents/oop_slides.pdf',
        moTa: 'Slide bài giảng về lập trình hướng đối tượng',
        yeuThich: true,
      ),
      TaiLieuEntity(
        maTL: 'TL002',
        tenTL: 'Bài tập SQL',
        monHoc: 'MH002',
        duongDan: '/documents/sql_exercises.pdf',
        moTa: 'Tập hợp các bài tập về SQL',
        yeuThich: false,
      ),
      TaiLieuEntity(
        maTL: 'TL003',
        tenTL: 'Tài liệu mạng máy tính',
        monHoc: 'MH003',
        duongDan: '/documents/network_basics.pdf',
        moTa: 'Tài liệu cơ bản về mạng máy tính',
        yeuThich: true,
      ),
      TaiLieuEntity(
        maTL: 'TL004',
        tenTL: 'UML Diagrams Guide',
        monHoc: 'MH004',
        duongDan: '/documents/uml_guide.pdf',
        moTa: 'Hướng dẫn vẽ các loại biểu đồ UML',
        yeuThich: false,
      ),
      TaiLieuEntity(
        maTL: 'TL005',
        tenTL: 'Flutter Widgets Reference',
        monHoc: 'MH005',
        duongDan: '/documents/flutter_widgets.pdf',
        moTa: 'Tài liệu tham khảo về Flutter widgets',
        yeuThich: true,
      ),
    ];

    for (final taiLieu in taiLieuList) {
      await _firestore.collection('taiLieu').add(taiLieu.toFirestore());
    }
  }
}
