# Tính năng Đội ngũ Giảng viên (Teachers)

## Tổng quan
Tính năng này cho phép người dùng xem danh sách giảng viên, tìm kiếm, lọc theo bộ môn và xem chi tiết thông tin từng giảng viên.

## Cấu trúc

```
teachers/
├── data/
│   ├── datasources/
│   │   └── firebase_teacher_datasource.dart  # Kết nối Firebase
│   └── seed_teachers_data.dart                # Dữ liệu mẫu
├── domain/
│   ├── entities/
│   │   └── teacher_entity.dart                # Model giảng viên
│   └── repositories/
│       └── teacher_repository.dart            # Interface repository
└── presentation/
    └── pages/
        ├── teachers_page.dart                 # Danh sách giảng viên
        ├── teacher_detail_page.dart           # Chi tiết giảng viên
        └── seed_data_page.dart                # Trang thêm dữ liệu mẫu
```

## Các tính năng

### 1. Danh sách giảng viên (`TeachersPage`)
- Hiển thị danh sách tất cả giảng viên
- Tìm kiếm theo tên
- Lọc theo bộ môn
- Pull-to-refresh
- Navigation đến trang chi tiết

### 2. Chi tiết giảng viên (`TeacherDetailPage`)
- Hiển thị thông tin đầy đủ của giảng viên
- Thông tin liên hệ (email, phone, office)
- Lĩnh vực nghiên cứu
- Nút gửi email và gọi điện (TODO)

### 3. Seed Data (`SeedDataPage`)
- Thêm dữ liệu mẫu vào Firebase
- Chỉ thêm nếu chưa có dữ liệu
- Có thể truy cập từ floating button trên `TeachersPage` khi danh sách trống

## Cách sử dụng

### Thêm dữ liệu mẫu vào Firebase

1. Chạy ứng dụng
2. Đăng nhập
3. Vào trang "Đội ngũ giảng viên" từ Home
4. Nếu danh sách trống, click vào nút "Thêm dữ liệu mẫu"
5. Hoặc truy cập trực tiếp: `/seed-data`

### Cấu trúc dữ liệu Firebase

Collection: `teachers`

```json
{
  "name": "Nguyễn Văn A",
  "department": "Công nghệ phần mềm",
  "faculty": "Công nghệ thông tin",
  "email": "nguyenvana@tlu.edu.vn",
  "phone": "0912345678",
  "degree": "ThS",
  "specializations": ["Xử lý ảnh", "Trí tuệ nhân tạo"],
  "officeLocation": "Phòng 301 - Nhà A"
}
```

## Navigation

- Từ Home → Click "Đội ngũ giảng viên" → `/teachers`
- Từ Teachers List → Click vào giảng viên → `/teachers/{id}`
- Từ Teachers List (khi trống) → Click FAB → `/seed-data`

## TODO / Cải tiến

- [ ] Thêm avatar thực từ URL hoặc upload
- [ ] Implement gửi email và gọi điện
- [ ] Thêm chức năng yêu thích giảng viên
- [ ] Lịch làm việc của giảng viên
- [ ] Đánh giá/review giảng viên
- [ ] Cache dữ liệu offline
- [ ] Pagination cho danh sách lớn
- [ ] Export danh sách giảng viên

