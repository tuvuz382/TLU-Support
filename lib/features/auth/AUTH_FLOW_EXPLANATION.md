# 📚 GIẢI THÍCH LUỒNG HOẠT ĐỘNG ĐĂNG NHẬP THEO CLEAN ARCHITECTURE

## 🏗️ TỔNG QUAN CẤU TRÚC

```
lib/features/auth/
├── presentation/          # Lớp UI - Tương tác với người dùng
│   └── pages/
│       └── login_page.dart
├── domain/               # Lớp Business Logic - Core của ứng dụng
│   ├── entities/         # Domain Models
│   │   └── user_entity.dart
│   └── repositories/     # Interface định nghĩa contract
│       └── auth_repository.dart
└── data/                 # Lớp Data - Truy cập dữ liệu
    ├── datasources/      # Firebase Authentication
    │   └── firebase_auth_datasource.dart
    └── repositories/      # Implementation của repository
        └── auth_repository_impl.dart
```

---

## 🔄 LUỒNG HOẠT ĐỘNG TỪNG BƯỚC

### **1. PRESENTATION LAYER** (UI Layer - `login_page.dart`)

#### 1.1. Khởi tạo (initState)
```dart
@override
void initState() {
  super.initState();
  _authRepository = AuthRepositoryImpl();
}
```
**Giải thích:**
- Đơn giản hơn GPA/Schedule (không có Dependency Injection phức tạp)
- Chỉ tạo `AuthRepositoryImpl` trực tiếp
- `AuthRepositoryImpl` tự tạo `FirebaseAuthDataSource` bên trong

#### 1.2. User Tương Tác - Nhập Liệu
```dart
TextFormField(
  controller: _emailController,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  },
)
```
**Chức năng:**
- User nhập email
- Validate real-time (khi submit form)
- Regex check format email

#### 1.3. User Nhấn "Đăng nhập" (_login)
```dart
Future<void> _login() async {
  if (!_formKey.currentState!.validate()) return;
  
  setState(() {
    _isLoading = true;
    _errorMessage = null;
  });

  try {
    await _authRepository.signIn(
      _emailController.text.trim(),
      _passwordController.text,
    );
    // Navigation tự động bởi GoRouter
  } catch (e) {
    // Xử lý lỗi
  }
}
```

**Luồng dữ liệu:**
```
UI (_login)
  ↓ validate form
  ↓ setState loading
  ↓
Domain (AuthRepository.signIn)
  ↓
Data (AuthRepositoryImpl)
  ↓
Data (FirebaseAuthDataSource)
  ↓
Firebase Authentication
```

---

### **2. DOMAIN LAYER** (Business Logic)

#### 2.1. Repository Interface (`auth_repository.dart`)
```dart
abstract class AuthRepository {
  Future<UserEntity?> signIn(String email, String password);
  Future<UserEntity?> signUp(String email, String password);
  Future<void> signOut();
  Stream<UserEntity?> get user;
  UserEntity? getCurrentUser();
}
```

**Vai trò:**
- ✅ Định nghĩa contract (interface) cho authentication
- ✅ Domain layer KHÔNG phụ thuộc vào Data layer
- ✅ Data layer implement interface này

#### 2.2. User Entity (`user_entity.dart`)
```dart
class UserEntity {
  final String uid;
  final String? email;
  
  // Pure data class
}
```

**Vai trò:**
- Domain model cho User
- Không phụ thuộc Firebase

---

### **3. DATA LAYER** (Data Access)

#### 3.1. Repository Implementation (`auth_repository_impl.dart`)
```dart
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _dataSource;
  
  AuthRepositoryImpl({
    FirebaseAuthDataSource? dataSource,
  }) : _dataSource = dataSource ?? 
      FirebaseAuthDataSource(FirebaseAuth.instance);

  @override
  Future<UserEntity?> signIn(String email, String password) async {
    try {
      return await _dataSource.signIn(email, password);
    } catch (e) {
      rethrow;  // Re-throw để UI xử lý
    }
  }
}
```

**Vai trò:**
- ✅ Implement interface từ Domain layer
- ✅ Ủy thác cho DataSource
- ✅ Re-throw exception để UI xử lý

#### 3.2. DataSource (`firebase_auth_datasource.dart`)
```dart
class FirebaseAuthDataSource {
  final FirebaseAuth _firebaseAuth;
  
  FirebaseAuthDataSource([FirebaseAuth? firebaseAuth])
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<UserEntity?> signIn(String email, String password) async {
    final cred = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _userFromFirebase(cred.user);
  }
  
  UserEntity? _userFromFirebase(User? user) {
    if (user == null) return null;
    return UserEntity(uid: user.uid, email: user.email);
  }
}
```

**Vai trò:**
- ✅ Trực tiếp tương tác với Firebase Authentication
- ✅ Transform: Firebase User → Domain UserEntity
- ✅ Xử lý lỗi và throw exception

---

## 📊 SƠ ĐỒ LUỒNG DỮ LIỆU HOÀN CHỈNH

```
┌─────────────────────────────────────────────────────────┐
│         PRESENTATION LAYER (UI)                        │
│  ┌──────────────────────────────────────────────────┐  │
│  │  LoginPage.initState()                           │  │
│  │    ↓ _authRepository = AuthRepositoryImpl()     │  │
│  └──────────────────────────────────────────────────┘  │
│                        ↓                                │
│  ┌──────────────────────────────────────────────────┐  │
│  │  User nhập email & password                      │  │
│  │    ↓ Validate form                               │  │
│  │    ↓ User nhấn "Đăng nhập"                       │  │
│  └──────────────────────────────────────────────────┘  │
│                        ↓                                │
│  ┌──────────────────────────────────────────────────┐  │
│  │  LoginPage._login()                              │  │
│  │    ↓ setState(_isLoading = true)                 │  │
│  │    ↓ _authRepository.signIn()                   │  │
│  └──────────────────────────────────────────────────┘  │
└────────────────────┬────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────────────┐
│         DOMAIN LAYER (Business Logic)                    │
│  ┌──────────────────────────────────────────────────┐  │
│  │  AuthRepository (Interface)                     │  │
│  │    signIn(String email, String password)        │  │
│  └──────────────────────────────────────────────────┘  │
└────────────────────┬────────────────────────────────────┘
                     ↓ (implement)
┌─────────────────────────────────────────────────────────┐
│         DATA LAYER (Data Access)                          │
│  ┌──────────────────────────────────────────────────┐  │
│  │  AuthRepositoryImpl                              │  │
│  │    ↓ _dataSource.signIn()                       │  │
│  └──────────────────────────────────────────────────┘  │
│                        ↓                                │
│  ┌──────────────────────────────────────────────────┐  │
│  │  FirebaseAuthDataSource                          │  │
│  │    ↓ signInWithEmailAndPassword()                │  │
│  │    ↓ Transform: Firebase User → UserEntity       │  │
│  └──────────────────────────────────────────────────┘  │
└────────────────────┬────────────────────────────────────┘
                     ↓
            ┌────────────────┐
            │ Firebase        │
            │ Authentication │
            └────────────────┘
                     ↓ (thành công hoặc lỗi)
            Quay lại UI layer
```

---

## 🔍 LUỒNG XỬ LÝ LỖI

### Khi Đăng Nhập Thất Bại

```
Firebase Authentication
    ↓ (lỗi)
FirebaseException thrown
    ↓
FirebaseAuthDataSource
    ↓ (rethrow)
AuthRepositoryImpl
    ↓ (rethrow)
LoginPage._login()
    ↓
catch (e)
    ↓
Parse error message
    ↓
if (user-not-found) → "Không tìm thấy tài khoản"
if (wrong-password) → "Mật khẩu không đúng"
if (invalid-email) → "Email không hợp lệ"
...
    ↓
setState(_errorMessage)
    ↓
Hiển thị error trên UI
```

---

## 🔍 VÍ DỤ CỤ THỂ: ĐĂNG NHẬP THÀNH CÔNG

### Bước 1: User nhập email và password
```
Email: "student@tlu.edu.vn"
Password: "123456"
```

### Bước 2: User nhấn "Đăng nhập"
```dart
// LoginPage
_login() {
  validate() → OK
  setState(_isLoading = true)
  _authRepository.signIn("student@tlu.edu.vn", "123456")
}
```

### Bước 3: Domain Layer
```dart
// AuthRepository (interface)
signIn("student@tlu.edu.vn", "123456")
  ↓ (implementation)
```

### Bước 4: Data Layer
```dart
// AuthRepositoryImpl
_dataSource.signIn("student@tlu.edu.vn", "123456")
  ↓
// FirebaseAuthDataSource
_firebaseAuth.signInWithEmailAndPassword(
  email: "student@tlu.edu.vn",
  password: "123456"
)
```

### Bước 5: Firebase Authentication
```
Firebase kiểm tra:
- Email có tồn tại không?
- Password có đúng không?
- Tài khoản có bị disable không?
  ↓
Thành công → Trả về Firebase User
```

### Bước 6: Transform Data
```dart
// FirebaseAuthDataSource
_userFromFirebase(firebaseUser)
  ↓
return UserEntity(
  uid: firebaseUser.uid,
  email: firebaseUser.email
)
```

### Bước 7: Auth State Change
```
Firebase Auth state thay đổi
  ↓
GoRouter detect auth state change
  ↓
Tự động navigate về Home
```

### Bước 8: UI Update
```
LoginPage không cần navigate thủ công
GoRouter tự động chuyển trang
```

---

## 🔍 VÍ DỤ CỤ THỂ: ĐĂNG NHẬP THẤT BẠI

### Scenario: Password sai

### Bước 1-4: Giống như trên

### Bước 5: Firebase Authentication
```
Firebase kiểm tra password → SAI
  ↓
Throw FirebaseAuthException với code: "wrong-password"
```

### Bước 6: Exception Propagation
```
FirebaseAuthDataSource
  ↓ (exception không được catch)
AuthRepositoryImpl
  ↓ (rethrow)
LoginPage._login()
  ↓
catch (e)
```

### Bước 7: Parse Error
```dart
errorString = e.toString().toLowerCase()
// "firebaseauthException: wrong-password"

if (errorString.contains('wrong-password')) {
  errorMessage = 'Mật khẩu không đúng.';
}
```

### Bước 8: Display Error
```dart
setState(() {
  _errorMessage = 'Mật khẩu không đúng.';
  _isLoading = false;
})
  ↓
UI hiển thị error message
```

---

## 🎯 CÁC NGUYÊN TẮC CLEAN ARCHITECTURE ÁP DỤNG

### 1. **Dependency Rule (Quy tắc phụ thuộc)**
```
Presentation → Domain ← Data
     ↓           ↑        ↓
     └───────────┴────────┘
```
- ✅ Domain layer KHÔNG phụ thuộc vào Presentation và Data
- ✅ Presentation và Data phụ thuộc vào Domain (interface)

### 2. **Separation of Concerns**
- **Presentation**: UI, Form validation, User interaction
- **Domain**: Business logic (interface definition)
- **Data**: Data access, Firebase integration

### 3. **Dependency Inversion Principle (DIP)**
- Domain định nghĩa `AuthRepository` (interface)
- Data implement `AuthRepositoryImpl` (implementation)
- UI depend on interface, không depend on implementation

### 4. **Error Handling Strategy**
- DataSource throw exception
- Repository rethrow exception
- UI catch và parse error message (user-friendly)

---

## ✅ LỢI ÍCH CỦA CẤU TRÚC NÀY

1. **Testability**: Có thể mock AuthRepository để test UI
2. **Flexibility**: Dễ thay đổi Firebase → Auth0, Supabase...
3. **Maintainability**: Dễ bảo trì, sửa đổi
4. **Separation**: UI không biết về Firebase
5. **Error Handling**: Centralized error parsing ở UI layer

---

## 📝 TÓM TẮT

**Luồng dữ liệu:**
1. **UI** validate form
2. **UI** gọi **Repository Interface**
3. **Repository Implementation** gọi **DataSource**
4. **DataSource** tương tác **Firebase Authentication**
5. **Kết quả quay lại** theo chiều ngược lại
6. **UI** xử lý error hoặc navigation tự động

**Đặc điểm:**
- 🔽 **Đi xuống**: UI → Domain → Data → Firebase
- 🔼 **Đi lên**: Firebase → Data → Domain → UI
- 🎯 **Navigation**: Tự động bởi GoRouter (auth state stream)
- ❌ **Error Handling**: Parse ở UI layer với message tiếng Việt

---

## 🔄 SO SÁNH VỚI GPA/SCHEDULE

| Đặc điểm | Auth Module | GPA/Schedule Module |
|----------|-------------|---------------------|
| **Use Cases** | Không có (đơn giản) | Có (tính toán phức tạp) |
| **Dependency Injection** | Đơn giản (1 repository) | Phức tạp (nhiều use cases) |
| **Data Loading** | Không có | Load nhiều dữ liệu |
| **Navigation** | Tự động (auth stream) | Thủ công (context.go) |
| **Error Handling** | Parse ở UI | Parse ở UI |
| **Stream** | Có (auth state stream) | Không có |

---

## 🔑 ĐIỂM QUAN TRỌNG

### 1. Auth State Stream
```dart
Stream<UserEntity?> get user =>
    _firebaseAuth.authStateChanges().map(_userFromFirebase);
```
- Stream theo dõi auth state changes
- GoRouter listen stream này để tự động navigate

### 2. Form Validation
- Validate trước khi submit
- Real-time validation trong TextFormField
- Regex cho email, length check cho password

### 3. Error Parsing
- Parse lỗi Firebase thành message tiếng Việt
- Xử lý các loại lỗi cụ thể
- User-friendly error messages

### 4. Loading State
- Disable nút khi loading
- Hiện spinner trong nút
- Prevent multiple submissions


