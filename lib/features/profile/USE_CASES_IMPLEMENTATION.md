# Profile Use Cases Implementation

## 📋 Tổng quan
Đã tạo các Use Case cho Profile feature theo pattern của project TLU Support. Mỗi Use Case chứa business logic cụ thể và có trách nhiệm rõ ràng.

## 🏗️ Cấu trúc Use Cases

### **Domain Layer - Use Cases**
```
lib/features/profile/domain/usecases/
├── get_current_student_profile_usecase.dart
├── update_student_profile_usecase.dart
├── create_basic_student_profile_usecase.dart
├── update_profile_image_usecase.dart
├── watch_student_profile_usecase.dart
├── get_all_sample_students_usecase.dart
├── select_existing_profile_usecase.dart
└── has_student_profile_usecase.dart
```

## 📝 Danh sách Use Cases

### 1. **GetCurrentStudentProfileUseCase**
- **Mục đích**: Lấy thông tin sinh viên hiện tại
- **Business Logic**: Error handling và exception wrapping
- **Input**: Không có
- **Output**: `SinhVienEntity?`

```dart
final profile = await _getProfileUseCase();
```

### 2. **UpdateStudentProfileUseCase**
- **Mục đích**: Cập nhật thông tin sinh viên
- **Business Logic**: 
  - Validation họ tên, mã SV, lớp, ngành học
  - Kiểm tra GPA từ 0.0 đến 4.0
  - Kiểm tra ngày sinh không phải tương lai
- **Input**: `SinhVienEntity`
- **Output**: `void`

```dart
await _updateProfileUseCase(updatedStudent);
```

### 3. **CreateBasicStudentProfileUseCase**
- **Mục đích**: Tạo profile sinh viên mới
- **Business Logic**: 
  - Validation email format
  - Validation họ tên (ít nhất 2 ký tự)
- **Input**: `email`, `hoTen`, `maSV?`, `lop?`, `nganhHoc?`
- **Output**: `void`

```dart
await _createProfileUseCase(
  email: email,
  hoTen: hoTen,
  maSV: maSV,
  lop: lop,
  nganhHoc: nganhHoc,
);
```

### 4. **UpdateProfileImageUseCase**
- **Mục đích**: Cập nhật ảnh đại diện
- **Business Logic**: 
  - Validation URL format
  - Kiểm tra extension ảnh (jpg, jpeg, png, gif, webp)
- **Input**: `String imageUrl`
- **Output**: `void`

```dart
await _updateImageUseCase(imageUrl);
```

### 5. **WatchStudentProfileUseCase**
- **Mục đích**: Theo dõi thay đổi profile real-time
- **Business Logic**: Error handling cho stream
- **Input**: Không có
- **Output**: `Stream<SinhVienEntity?>`

```dart
_stream = _watchProfileUseCase();
```

### 6. **GetAllSampleStudentsUseCase**
- **Mục đích**: Lấy danh sách sinh viên mẫu
- **Business Logic**: 
  - Filtering theo ngành học
  - Giới hạn số lượng trả về
- **Input**: `limit`, `nganhHoc?`
- **Output**: `List<SinhVienEntity>`

```dart
final students = await _getSampleUseCase(
  limit: 50,
  nganhHoc: 'CNTT',
);
```

### 7. **SelectExistingProfileUseCase**
- **Mục đích**: Chọn profile từ danh sách có sẵn
- **Business Logic**: 
  - Validation mã SV (ít nhất 3 ký tự)
  - Kiểm tra profile tồn tại
- **Input**: `String maSV`
- **Output**: `void`

```dart
await _selectProfileUseCase(maSV);
```

### 8. **HasStudentProfileUseCase**
- **Mục đích**: Kiểm tra sinh viên có profile chưa
- **Business Logic**: Error handling graceful
- **Input**: Không có
- **Output**: `bool`

```dart
final hasProfile = await _hasProfileUseCase();
```

## 🔧 Cách sử dụng trong Presentation Layer

### **Dependency Injection**
```dart
// Setup dependencies
final dataSource = StudentProfileRemoteDataSource();
final repository = StudentProfileRepositoryImpl(remoteDataSource: dataSource);

// Initialize use cases
final getProfileUseCase = GetCurrentStudentProfileUseCase(repository);
final updateProfileUseCase = UpdateStudentProfileUseCase(repository);
final updateImageUseCase = UpdateProfileImageUseCase(repository);
```

### **Sử dụng trong UI**
```dart
// ProfilePage
class _ProfilePageState extends State<ProfilePage> {
  late final GetCurrentStudentProfileUseCase _getProfileUseCase;
  
  Future<void> _loadStudentProfile() async {
    try {
      final profile = await _getProfileUseCase();
      // Handle profile data
    } catch (e) {
      // Handle error
    }
  }
}

// PersonalInfoPage
class _PersonalInfoPageState extends State<PersonalInfoPage> {
  late final GetCurrentStudentProfileUseCase _getProfileUseCase;
  late final UpdateStudentProfileUseCase _updateProfileUseCase;
  late final UpdateProfileImageUseCase _updateImageUseCase;
  
  Future<void> _saveProfile() async {
    try {
      await _updateProfileUseCase(updatedStudent);
      // Show success message
    } catch (e) {
      // Show error message
    }
  }
}
```

## 🎯 Lợi ích của Use Case Pattern

### **1. Separation of Concerns**
- **Repository**: Chỉ data access
- **UseCase**: Chỉ business logic
- **UI**: Chỉ presentation logic

### **2. Testability**
- Có thể test business logic độc lập
- Mock Repository dễ dàng
- Unit test cho từng UseCase

### **3. Maintainability**
- Business logic tập trung trong UseCase
- Dễ thay đổi business rules
- Code dễ đọc và hiểu

### **4. Reusability**
- UseCase có thể dùng ở nhiều nơi
- Không phụ thuộc vào UI
- Có thể dùng trong API hoặc CLI

### **5. Clean Architecture**
- Dependency Inversion: UI → UseCase → Repository
- Domain layer không phụ thuộc vào Data layer
- Tuân thủ SOLID principles

## 🔄 So sánh với các Feature khác

### **Documents Feature** (Simple Use Cases)
- Chủ yếu gọi repository
- Ít business logic
- Focus vào data access

### **Support Request Feature** (Complex Use Cases)
- Có validation phức tạp
- Business logic formatting
- Error handling chi tiết

### **Profile Feature** (Balanced Use Cases)
- Validation vừa phải
- Business rules rõ ràng
- Error handling tốt

## 📚 Tài liệu tham khảo

- [Clean Architecture - Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Use Case Pattern](https://martinfowler.com/bliki/UseCase.html)
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID)
