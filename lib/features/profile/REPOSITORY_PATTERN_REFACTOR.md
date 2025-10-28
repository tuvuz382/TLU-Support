# Repository Pattern Refactor - Student Profile

## 📋 Tổng quan
Đã refactor code từ Service pattern sang **Repository pattern** để tuân thủ Clean Architecture và SOLID principles. Việc này giúp code dễ test, maintain và mở rộng.

## 🏗️ Cấu trúc mới theo Repository Pattern

### **Domain Layer** 
```
lib/features/profile/domain/
└── repositories/
    └── student_profile_repository.dart  (Interface)
```

### **Data Layer**
```
lib/features/profile/data/
├── datasources/
│   └── student_profile_remote_datasource.dart  (Firebase access)
└── repositories/
    └── student_profile_repository_impl.dart     (Implementation)
```

### **Presentation Layer**
```
lib/features/profile/presentation/
└── pages/
    ├── profile_page.dart           (Sử dụng Repository)
    └── personal_info_page.dart     (Sử dụng Repository)
```

---

## 🔄 So sánh Before vs After

### **BEFORE (Service Pattern)**
```dart
class StudentProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Logic trực tiếp gọi Firebase
  Future<SinhVienEntity?> getCurrentStudentProfile() async {
    // Direct Firebase calls
  }
}

// Usage in UI
class ProfilePage {
  final StudentProfileService _service = StudentProfileService();
}
```

**Vấn đề:**
- ❌ UI phụ thuộc trực tiếp vào Firebase (tight coupling)
- ❌ Khó test vì không thể mock Firebase
- ❌ Vi phạm Dependency Inversion Principle
- ❌ Khó thay đổi data source sau này

### **AFTER (Repository Pattern)**
```dart
// Domain Layer - Interface
abstract class StudentProfileRepository {
  Future<SinhVienEntity?> getCurrentStudentProfile();
  // ... other methods
}

// Data Layer - DataSource
class StudentProfileRemoteDataSource {
  // Pure Firebase operations, returns raw data
  Future<Map<String, dynamic>?> getCurrentStudentData() async {
    // Firebase calls
  }
}

// Data Layer - Repository Implementation
class StudentProfileRepositoryImpl implements StudentProfileRepository {
  final StudentProfileRemoteDataSource _dataSource;
  
  // Converts raw data to domain entities
  Future<SinhVienEntity?> getCurrentStudentProfile() async {
    final data = await _dataSource.getCurrentStudentData();
    return data != null ? SinhVienEntity.fromFirestore(data) : null;
  }
}

// Usage in UI
class ProfilePage {
  late final StudentProfileRepository _repository;
  
  void initState() {
    final dataSource = StudentProfileRemoteDataSource();
    _repository = StudentProfileRepositoryImpl(remoteDataSource: dataSource);
  }
}
```

**Ưu điểm:**
- ✅ UI chỉ phụ thuộc vào interface (loose coupling)
- ✅ Dễ test với mock repository
- ✅ Tuân thủ SOLID principles
- ✅ Dễ thay đổi data source (Local DB, API, etc.)

---

## 🏛️ Chi tiết các layer

### 1. **Domain Layer - Repository Interface**
```dart
abstract class StudentProfileRepository {
  // Contract cho business logic
  Future<SinhVienEntity?> getCurrentStudentProfile();
  Future<void> updateStudentProfile(SinhVienEntity student);
  // ... other business methods
}
```

**Đặc điểm:**
- **Pure abstraction** - không có implementation details
- **Business-focused** - methods phản ánh use cases
- **Framework agnostic** - không phụ thuộc Firebase/HTTP/etc.

### 2. **Data Layer - DataSource**
```dart
class StudentProfileRemoteDataSource {
  // Low-level Firebase operations
  Future<Map<String, dynamic>?> getCurrentStudentData();
  Future<void> createStudent(Map<String, dynamic> data);
  // ... pure Firebase methods
}
```

**Đặc điểm:**
- **Single responsibility** - chỉ lo Firebase operations
- **Raw data handling** - trả về Map, không biết gì về business entities
- **Reusable** - có thể dùng cho nhiều repositories khác

### 3. **Data Layer - Repository Implementation**
```dart
class StudentProfileRepositoryImpl implements StudentProfileRepository {
  final StudentProfileRemoteDataSource _dataSource;
  
  // Bridge between domain và data
  Future<SinhVienEntity?> getCurrentStudentProfile() async {
    final rawData = await _dataSource.getCurrentStudentData();
    return rawData != null ? SinhVienEntity.fromFirestore(rawData) : null;
  }
}
```

**Đặc điểm:**
- **Data transformation** - converts raw data ↔ domain entities
- **Error handling** - wraps data layer errors cho domain layer
- **Business logic coordination** - kết hợp multiple data sources nếu cần

---

## 🎯 Lợi ích của Repository Pattern

### **1. Testability** 🧪
```dart
// Before: Khó test vì phụ thuộc Firebase
void testService() {
  final service = StudentProfileService(); // Calls real Firebase!
}

// After: Dễ test với mock
void testRepository() {
  final mockDataSource = MockStudentProfileDataSource();
  final repository = StudentProfileRepositoryImpl(remoteDataSource: mockDataSource);
  // Test với fake data, không cần Firebase
}
```

### **2. Flexibility** 🔄
```dart
// Có thể dễ dàng switch data sources:
final repository = StudentProfileRepositoryImpl(
  remoteDataSource: useCache ? LocalDataSource() : RemoteDataSource(),
);
```

### **3. Separation of Concerns** 🎯
- **UI**: Chỉ lo presentation logic
- **Repository**: Chỉ lo business logic & data coordination  
- **DataSource**: Chỉ lo data access
- **Entity**: Chỉ lo data structure

### **4. SOLID Principles** ⭐
- **S** - Single Responsibility: Mỗi class có 1 nhiệm vụ rõ ràng
- **O** - Open/Closed: Dễ extend mà không modify existing code
- **L** - Liskov Substitution: Mock implementations hoạt động như real
- **I** - Interface Segregation: Repository interface focused và minimal
- **D** - Dependency Inversion: UI depends on abstraction, not concrete classes

---

## 🔧 Dependency Injection Setup

Hiện tại đang dùng **manual DI** trong initState:
```dart
void initState() {
  final dataSource = StudentProfileRemoteDataSource();
  _repository = StudentProfileRepositoryImpl(remoteDataSource: dataSource);
}
```

**Tương lai có thể upgrade lên:**
- **GetIt** - Service locator pattern
- **Provider** - Widget-based DI
- **Riverpod** - Modern state management + DI
- **Injectable** - Code generation DI

---

## 🚀 Cách sử dụng mới

### **1. Trong Presentation Layer:**
```dart
class ProfilePage {
  late final StudentProfileRepository _repository;
  
  void initState() {
    // Setup dependencies
    final dataSource = StudentProfileRemoteDataSource();
    _repository = StudentProfileRepositoryImpl(remoteDataSource: dataSource);
  }
  
  void loadProfile() async {
    // Use repository interface
    final profile = await _repository.getCurrentStudentProfile();
  }
}
```

### **2. Testing:**
```dart
void main() {
  group('StudentProfileRepository Tests', () {
    late StudentProfileRepository repository;
    late MockStudentProfileDataSource mockDataSource;
    
    setUp(() {
      mockDataSource = MockStudentProfileDataSource();
      repository = StudentProfileRepositoryImpl(remoteDataSource: mockDataSource);
    });
    
    test('should return student profile when data exists', () async {
      // Arrange
      mockDataSource.setMockData({'name': 'Test Student'});
      
      // Act
      final result = await repository.getCurrentStudentProfile();
      
      // Assert
      expect(result?.hoTen, 'Test Student');
    });
  });
}
```

---

## 📈 Kết luận

Repository pattern giúp codebase:
- **Cleaner** - Tách biệt concerns rõ ràng
- **Testable** - Dễ viết unit tests
- **Maintainable** - Dễ sửa đổi và mở rộng  
- **Scalable** - Dễ thêm features mới
- **Professional** - Tuân thủ industry best practices

Đây là foundation tốt để phát triển thêm các features khác trong ứng dụng! 🎉
