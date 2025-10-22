# TLU Support - Ứng dụng Đăng nhập

Ứng dụng Flutter đơn giản với chức năng đăng nhập sử dụng Firebase Authentication.

## Tính năng

- ✅ Giao diện đăng nhập đẹp mắt với Material Design 3
- ✅ Xác thực người dùng với Firebase Auth
- ✅ Xử lý lỗi đăng nhập thông minh
- ✅ Trang chủ đơn giản sau khi đăng nhập thành công
- ✅ Đăng xuất an toàn

## Cấu trúc dự án

```
lib/
├── core/
│   ├── config/
│   │   └── firebase_env.dart          # Cấu hình Firebase
│   ├── data/
│   │   └── firebase_remote_data_source.dart
│   ├── presentation/
│   │   └── theme/
│   │       ├── app_colors.dart        # Màu sắc ứng dụng
│   │       └── app_theme.dart         # Theme chính
│   └── routing/
│       ├── app_go_router.dart         # Cấu hình routing
│       ├── app_routes.dart            # Định nghĩa routes
│       └── go_router_refresh_change.dart
└── features/
    └── auth/
        ├── data/
        │   └── datasources/
        │       └── firebase_auth_datasource.dart
        ├── domain/
        │   ├── entities/
        │   │   └── user_entity.dart
        │   └── repositories/
        │       └── auth_repository.dart
        └── presentation/
            └── pages/
                ├── login_page.dart    # Trang đăng nhập
                └── home_page.dart     # Trang chủ
```

## Cài đặt

1. **Clone repository:**
   ```bash
   git clone <repository-url>
   cd TLU-Support
   ```

2. **Cài đặt dependencies:**
   ```bash
   flutter pub get
   ```

3. **Cấu hình Firebase:**
   - Tạo project Firebase mới
   - Bật Authentication với Email/Password
   - Tải file `google-services.json` (Android) hoặc `GoogleService-Info.plist` (iOS)
   - Cập nhật file `.env` với thông tin Firebase của bạn

4. **Chạy ứng dụng:**
   ```bash
   flutter run
   ```

## Cấu hình Firebase

Tạo file `.env` trong thư mục gốc với nội dung:

```env
FIREBASE_API_KEY=your_api_key
FIREBASE_APP_ID=your_app_id
FIREBASE_MESSAGING_SENDER_ID=your_sender_id
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_AUTH_DOMAIN=your_project_id.firebaseapp.com
FIREBASE_STORAGE_BUCKET=your_project_id.appspot.com
FIREBASE_MEASUREMENT_ID=your_measurement_id
```
FIREBASE_API_KEY="AIzaSyB12D-9YzKxyTGJkK1or9bA5FXRfinogjc"
FIREBASE_APP_ID="1:1043045561481:web:934deeaecf2e6eccde4258"
FIREBASE_MESSAGING_SENDER_ID="1043045561481"
FIREBASE_PROJECT_ID="myapp-81c15"
FIREBASE_AUTH_DOMAIN="myapp-81c15.firebaseapp.com"
FIREBASE_STORAGE_BUCKET="myapp-81c15.firebasestorage.app"
#FIREBASE_DATABASE_URL=https://my-flutter-app-default-rtdb.firebaseio.com/
FIREBASE_MEASUREMENT_ID="G-SNX5S30GBL"
## Sử dụng

1. **Đăng nhập:**
   - Nhập email và mật khẩu hợp lệ
   - Nhấn nút "Đăng nhập"
   - Ứng dụng sẽ tự động chuyển đến trang chủ nếu đăng nhập thành công

2. **Đăng xuất:**
   - Từ trang chủ, nhấn nút "Đăng xuất" hoặc icon logout
   - Ứng dụng sẽ quay về trang đăng nhập

## Công nghệ sử dụng

- **Flutter:** Framework UI
- **Firebase Auth:** Xác thực người dùng
- **Go Router:** Quản lý navigation
- **Material Design 3:** Thiết kế UI/UX

## Lưu ý

- Ứng dụng chỉ hỗ trợ đăng nhập, không có chức năng đăng ký
- Cần tạo tài khoản Firebase Console trước khi sử dụng
- Hỗ trợ cả Android và iOS
