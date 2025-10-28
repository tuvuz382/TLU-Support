# Profile Integration với SinhVienEntity

## Tổng quan
Đã hoàn thiện việc tích hợp `SinhVienEntity` vào chức năng profile của ứng dụng TLU Support. Profile hiện có thể hiển thị và quản lý đầy đủ thông tin sinh viên.

## Các tính năng đã hoàn thành

### 1. StudentProfileService
**File**: `lib/features/profile/data/services/student_profile_service.dart`

**Chức năng**:
- Lấy thông tin sinh viên theo email của user hiện tại
- Cập nhật thông tin sinh viên
- Tạo profile sinh viên mới với thông tin cơ bản
- Cập nhật ảnh đại diện
- Kiểm tra xem sinh viên có profile không
- Theo dõi thay đổi profile sinh viên (Stream)

### 2. ProfilePage (Cập nhật)
**File**: `lib/features/profile/presentation/pages/profile_page.dart`

**Tính năng mới**:
- Hiển thị thông tin sinh viên từ `SinhVienEntity` thay vì chỉ email
- Hiển thị ảnh đại diện (nếu có)
- Hiển thị mã sinh viên, tên, lớp, ngành học
- Hiển thị điểm GPA với màu sắc phù hợp:
  - Xanh lá: GPA ≥ 3.5
  - Xanh dương: GPA ≥ 3.0
  - Cam: GPA ≥ 2.5
  - Đỏ: GPA < 2.5
- Loading state khi tải dữ liệu
- Xử lý lỗi khi không tải được thông tin

### 3. PersonalInfoPage (Hoàn toàn mới)
**File**: `lib/features/profile/presentation/pages/personal_info_page.dart`

**Tính năng**:
- Form đầy đủ cho thông tin sinh viên:
  - Mã sinh viên
  - Họ và tên
  - Email (không thể chỉnh sửa)
  - Ngày sinh (date picker)
  - Lớp
  - Ngành học
  - Điểm GPA
- Tự động load thông tin từ Firestore
- Lưu/cập nhật thông tin vào Firestore
- Validation đầy đủ cho tất cả trường
- Hiển thị ảnh đại diện với khả năng cập nhật
- Loading states và error handling

### 4. Quản lý ảnh đại diện
- Hiển thị ảnh đại diện từ URL
- Dialog để cập nhật ảnh đại diện mới
- Fallback về icon mặc định nếu không có ảnh
- Error handling khi load ảnh thất bại

## Cấu trúc dữ liệu

### SinhVienEntity
```dart
class SinhVienEntity {
  final String maSV;          // Mã sinh viên
  final String hoTen;         // Họ và tên
  final String email;         // Email
  final String matKhau;       // Mật khẩu (quản lý bởi Firebase Auth)
  final DateTime ngaySinh;    // Ngày sinh
  final String lop;           // Lớp
  final String nganhHoc;      // Ngành học
  final double diemGPA;       // Điểm GPA
  final List<String> hocBongDangKy; // Danh sách học bổng đã đăng ký
  final String? anhDaiDien;   // URL ảnh đại diện
}
```

## Cách sử dụng

### 1. Xem thông tin sinh viên
- Vào tab "Profile" trong bottom navigation
- Thông tin sinh viên sẽ được tự động tải và hiển thị

### 2. Chỉnh sửa thông tin
- Tap vào "Thông tin cá nhân" trong ProfilePage
- Điền/chỉnh sửa thông tin trong form
- Tap "Lưu Thông tin" để lưu

### 3. Cập nhật ảnh đại diện
- Trong PersonalInfoPage, tap vào icon edit trên ảnh đại diện
- Nhập URL ảnh mới
- Tap "Lưu" để cập nhật

## Lưu ý kỹ thuật

### Firebase Firestore
- Collection: `sinhVien`
- Query theo field `email` để liên kết với Firebase Auth
- Tự động tạo document mới nếu chưa có
- Cập nhật document existing nếu đã có

### Error Handling
- Tất cả các thao tác đều có error handling
- Hiển thị SnackBar với thông báo lỗi/thành công
- Loading states để cải thiện UX

### Validation
- Required fields: Mã SV, Họ tên, Email, Lớp, Ngành học
- GPA: Số từ 0 đến 4.0
- Email: Không thể chỉnh sửa (quản lý bởi Firebase Auth)

### Performance
- Lazy loading: Chỉ tải khi cần thiết
- Efficient updates: Chỉ update field thay đổi
- Stream support: Theo dõi thay đổi real-time (đã chuẩn bị)

## Tương lai

### Có thể mở rộng thêm:
- Upload ảnh từ device thay vì chỉ URL
- Quản lý học bổng đã đăng ký
- Lịch sử thay đổi thông tin
- Backup/sync với hệ thống trường
- Push notification khi có thay đổi quan trọng
