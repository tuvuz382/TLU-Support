# Hướng dẫn sử dụng chức năng sinh dữ liệu mẫu

## Tổng quan
Chức năng sinh dữ liệu mẫu cho phép tạo ra 5 bản ghi mẫu cho tất cả các lớp trong hệ thống quản lý sinh viên TLU.

## Cách sử dụng

### 1. Đăng nhập với tài khoản admin
- Chỉ tài khoản `admin123@gmail.com` mới có thể sử dụng chức năng này
- Đăng nhập vào ứng dụng với email `admin123@gmail.com`

### 2. Truy cập chức năng sinh dữ liệu
- Vào trang **Profile** (Trang cá nhân)
- Tìm và nhấn vào mục **"Sinh dữ liệu mẫu"** (chỉ hiển thị cho admin)
- Chờ quá trình sinh dữ liệu hoàn tất

### 3. Xóa dữ liệu mẫu (nếu cần)
- Vào trang **Profile** (Trang cá nhân)
- Tìm và nhấn vào mục **"Xóa dữ liệu mẫu"** (chỉ hiển thị cho admin)
- Xác nhận việc xóa trong dialog hiện ra
- Chờ quá trình xóa hoàn tất

### 4. Dữ liệu được tạo
Chức năng sẽ tạo ra 5 bản ghi cho mỗi collection sau:

#### SinhVien (Sinh viên)
- SV001: Nguyễn Văn An - CNTT01
- SV002: Trần Thị Bình - CNTT02  
- SV003: Lê Văn Cường - KT01
- SV004: Phạm Thị Dung - QTKD01
- SV005: Hoàng Văn Em - CNTT01

#### HocBong (Học bổng)
- HB001: Học bổng khuyến khích học tập (5,000,000 VNĐ)
- HB002: Học bổng hỗ trợ sinh viên nghèo (3,000,000 VNĐ)
- HB003: Học bổng nghiên cứu khoa học (7,000,000 VNĐ)
- HB004: Học bổng tài năng (10,000,000 VNĐ)
- HB005: Học bổng thực tập tốt (4,000,000 VNĐ)

#### MonHoc (Môn học)
- MH001: Lập trình hướng đối tượng (3 tín chỉ)
- MH002: Cơ sở dữ liệu (3 tín chỉ)
- MH003: Mạng máy tính (3 tín chỉ)
- MH004: Phân tích thiết kế hệ thống (3 tín chỉ)
- MH005: Phát triển ứng dụng di động (3 tín chỉ)

#### DanhGia (Đánh giá)
- 5 đánh giá mẫu từ các sinh viên về các môn học

#### GhiChu (Ghi chú)
- 5 ghi chú mẫu liên quan đến các môn học

#### LienHe (Liên hệ)
- 5 yêu cầu liên hệ mẫu với các trạng thái khác nhau

#### ThongBao (Thông báo)
- 5 thông báo mẫu về các hoạt động của trường

#### LichHoc (Lịch học)
- 5 lịch học mẫu cho các môn học

#### TaiLieu (Tài liệu)
- 5 tài liệu mẫu cho các môn học

## Lưu ý quan trọng
- **Chỉ admin mới có quyền**: Các chức năng này chỉ hiển thị cho tài khoản `admin123@gmail.com`
- **Dữ liệu được lưu vào Firestore**: Tất cả dữ liệu sẽ được lưu vào các collection tương ứng trong Firestore
- **Không ghi đè**: Nếu đã có dữ liệu trong Firestore, chức năng sinh dữ liệu sẽ thêm dữ liệu mới vào
- **Xóa toàn bộ**: Chức năng xóa sẽ xóa tất cả dữ liệu trong các collection, không chỉ dữ liệu mẫu
- **Xác nhận trước khi xóa**: Hệ thống sẽ hiển thị dialog xác nhận trước khi thực hiện việc xóa
- **Thông báo kết quả**: Sau khi hoàn tất, ứng dụng sẽ hiển thị thông báo thành công hoặc lỗi

## Xử lý lỗi
Nếu gặp lỗi trong quá trình sinh hoặc xóa dữ liệu:
1. Kiểm tra kết nối internet
2. Kiểm tra cấu hình Firebase
3. Thử lại sau vài phút
4. Liên hệ quản trị viên nếu lỗi vẫn tiếp tục

## Cảnh báo bảo mật
- **Chức năng xóa dữ liệu rất nguy hiểm**: Sẽ xóa toàn bộ dữ liệu trong các collection
- **Không thể hoàn tác**: Một khi đã xóa, dữ liệu sẽ không thể khôi phục
- **Chỉ dành cho admin**: Đảm bảo chỉ người có quyền mới có thể truy cập
- **Kiểm tra kỹ trước khi xóa**: Luôn xác nhận lại trước khi thực hiện
