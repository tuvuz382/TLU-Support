# Tích hợp dữ liệu mẫu cho Profile

## 📋 Tổng quan
Đã tích hợp khả năng sử dụng dữ liệu sinh viên có sẵn từ `DataGeneratorService` cho chức năng profile. User giờ có thể chọn profile từ danh sách sinh viên mẫu thay vì phải tạo mới từ đầu.

## 🎯 Tính năng mới

### **1. Lấy dữ liệu sinh viên từ DataGeneratorService**
- Kết nối với dữ liệu sinh viên mẫu đã được tạo
- 5 sinh viên mẫu có sẵn với thông tin đầy đủ:
  - **SV001** - Nguyễn Văn An (CNTT01, GPA: 3.5)
  - **SV002** - Trần Thị Bình (CNTT02, GPA: 3.8)
  - **SV003** - Lê Văn Cường (KT01, GPA: 3.2)
  - **SV004** - Phạm Thị Dung (QTKD01, GPA: 3.6)
  - **SV005** - Hoàng Văn Em (CNTT01, GPA: 3.9)

### **2. Giao diện chọn profile**
- Trang `ProfileSelectorPage` hiển thị danh sách sinh viên
- UI card đẹp với thông tin đầy đủ
- Màu sắc GPA theo mức độ
- Một tap để chọn profile

### **3. Profile linking**
- Liên kết email hiện tại với profile sinh viên đã chọn
- Tự động thay thế email trong dữ liệu
- Xóa profile cũ (nếu có) trước khi tạo mới

---

## 🏗️ **Cấu trúc code mới**

### **Repository Interface** (Đã mở rộng)
```dart
abstract class StudentProfileRepository {
  // ... existing methods ...
  
  /// Lấy tất cả sinh viên mẫu từ hệ thống
  Future<List<SinhVienEntity>> getAllSampleStudents();
  
  /// Lấy sinh viên theo mã sinh viên
  Future<SinhVienEntity?> getStudentById(String maSV);
  
  /// Chọn profile sinh viên từ danh sách có sẵn
  Future<void> selectExistingProfile(String maSV);
  
  /// Kiểm tra xem có sinh viên nào trong hệ thống không
  Future<bool> hasSampleData();
}
```

### **DataSource** (Đã mở rộng)
```dart
class StudentProfileRemoteDataSource {
  // ... existing methods ...
  
  /// Lấy tất cả sinh viên từ Firestore
  Future<List<Map<String, dynamic>>> getAllStudents();
  
  /// Lấy sinh viên theo mã sinh viên
  Future<Map<String, dynamic>?> getStudentByMaSV(String maSV);
  
  /// Liên kết sinh viên có sẵn với user hiện tại
  Future<void> linkExistingStudentToCurrentUser(Map<String, dynamic> studentData);
  
  /// Kiểm tra có dữ liệu sinh viên nào không
  Future<bool> hasAnyStudentData();
}
```

### **New Page**
```dart
class ProfileSelectorPage extends StatefulWidget {
  // Hiển thị danh sách sinh viên có thể chọn
  // Beautiful card UI với thông tin đầy đủ
  // Tap để chọn profile
}
```

---

## 🚀 **Flow sử dụng**

### **Kịch bản 1: User chưa có profile**
1. Vào tab Profile → Hiển thị "Chưa có thông tin profile"
2. Có nút "Chọn profile có sẵn" nổi bật
3. Tap nút → Chuyển đến `ProfileSelectorPage`
4. Chọn sinh viên → Profile được liên kết với email hiện tại
5. Quay về Profile page → Hiển thị thông tin sinh viên đã chọn

### **Kịch bản 2: User muốn đổi profile**
1. Vào tab Profile → Menu "Chọn profile có sẵn"
2. Chọn sinh viên khác → Profile cũ bị thay thế
3. Hiển thị thông tin mới

### **Kịch bản 3: Chưa có dữ liệu mẫu**
1. Vào `ProfileSelectorPage` → Hiển thị "Chưa có dữ liệu sinh viên"
2. Hướng dẫn admin sinh dữ liệu mẫu
3. Nút "Quay lại" để return

---

## 📱 **UI/UX Features**

### **ProfilePage Updates**
- **Smart detection**: Tự động phát hiện có profile hay chưa
- **Dynamic UI**: Hiển thị khác nhau tùy trạng thái
- **Call-to-action**: Nút "Chọn profile có sẵn" khi chưa có data
- **Menu integration**: Thêm option vào menu chính

### **ProfileSelectorPage**
- **Beautiful cards**: Mỗi sinh viên một card đẹp
- **Comprehensive info**: Tên, mã SV, lớp, ngành, GPA, số học bổng
- **Color coding**: GPA có màu theo mức độ (xanh/xanh dương/cam/đỏ)
- **Loading states**: Smooth loading experience
- **Empty state**: Handle khi chưa có dữ liệu
- **Error handling**: User-friendly error messages

### **Data Linking Logic**
- **Email preservation**: Giữ nguyên email của user hiện tại
- **Clean replacement**: Xóa profile cũ trước khi tạo mới
- **Atomic operations**: Đảm bảo consistency

---

## 🔧 **Implementation Details**

### **Repository Pattern** 
```dart
// 1. DataSource lấy raw data từ Firestore
final studentsData = await _remoteDataSource.getAllStudents();

// 2. Repository convert thành entities
return studentsData
    .map((data) => SinhVienEntity.fromFirestore(data))
    .toList();

// 3. UI sử dụng entities
final students = await _repository.getAllSampleStudents();
```

### **Profile Linking Process**
```dart
// 1. Lấy dữ liệu sinh viên theo mã
final studentData = await _remoteDataSource.getStudentByMaSV(maSV);

// 2. Thay email thành email hiện tại
final newStudentData = Map<String, dynamic>.from(studentData);
newStudentData['email'] = currentUserEmail;

// 3. Xóa profile cũ và tạo mới
await deleteStudentByEmail(currentUserEmail);
await createStudent(newStudentData);
```

### **Routing Integration**
```dart
// Thêm route mới
static const String profileSelector = '/profile-selector';

// Route definition
GoRoute(
  path: AppRoutes.profileSelector,
  builder: (context, state) => const ProfileSelectorPage(),
)
```

---

## 📊 **Dữ liệu mẫu có sẵn**

Từ `DataGeneratorService`, có 5 sinh viên mẫu:

| Mã SV | Tên | Lớp | Ngành | GPA | Học bổng |
|-------|-----|-----|-------|-----|----------|
| SV001 | Nguyễn Văn An | CNTT01 | Công nghệ thông tin | 3.5 | 2 |
| SV002 | Trần Thị Bình | CNTT02 | Công nghệ thông tin | 3.8 | 1 |
| SV003 | Lê Văn Cường | KT01 | Kế toán | 3.2 | 1 |
| SV004 | Phạm Thị Dung | QTKD01 | Quản trị kinh doanh | 3.6 | 2 |
| SV005 | Hoàng Văn Em | CNTT01 | Công nghệ thông tin | 3.9 | 3 |

---

## ⚡ **Performance & Best Practices**

### **Efficient Data Loading**
- Chỉ load data khi cần thiết
- Cache-friendly với Firestore
- Graceful error handling

### **Memory Management**
- Proper widget disposal
- Controlled state updates
- Efficient list rendering

### **User Experience**
- Loading states everywhere
- Clear error messages
- Smooth transitions
- Intuitive navigation

---

## 🔄 **Integration với existing features**

### **Hoạt động với ProfilePage hiện tại**
- ✅ Tương thích hoàn toàn
- ✅ Không breaking changes
- ✅ Enhanced UX

### **Hoạt động với PersonalInfoPage**
- ✅ Load data từ profile đã chọn
- ✅ Edit/save functionality intact
- ✅ Validation vẫn hoạt động

### **Repository Pattern compliance**
- ✅ Clean Architecture
- ✅ SOLID principles
- ✅ Testable code

---

## 🎉 **Lợi ích**

### **Cho User**
- **Quick start**: Không cần nhập thông tin từ đầu
- **Realistic data**: Dữ liệu sinh viên thật với GPA, học bổng, etc.
- **Easy switching**: Đổi profile dễ dàng
- **Beautiful UI**: Giao diện đẹp và trực quan

### **Cho Developer**
- **Clean code**: Repository pattern chuẩn
- **Extensible**: Dễ thêm features
- **Maintainable**: Code dễ maintain
- **Testable**: Có thể test dễ dàng

### **Cho Testing**
- **Consistent data**: Dữ liệu test ổn định
- **Multiple personas**: 5 personas khác nhau để test
- **Realistic scenarios**: Test với dữ liệu thực tế

---

## 🔮 **Future Enhancements**

Có thể mở rộng:
- **Profile templates**: Tạo templates từ profiles có sẵn
- **Bulk import**: Import nhiều sinh viên từ CSV/Excel
- **Profile cloning**: Clone và customize profile
- **Advanced search**: Tìm kiếm sinh viên theo tiêu chí
- **Profile comparison**: So sánh profiles

---

Tính năng này làm cho việc sử dụng app TLU Support trở nên dễ dàng và thú vị hơn rất nhiều! 🚀
