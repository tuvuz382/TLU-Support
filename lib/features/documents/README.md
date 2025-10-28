# 📚 Documents Feature - Tài liệu học tập

## Tổng quan
Tính năng quản lý và hiển thị danh sách tài liệu học tập của sinh viên TLU với kiến trúc Clean Architecture đầy đủ.

## 🏗️ Cấu trúc Clean Architecture

```
features/documents/
├── domain/                          # Business Logic Layer
│   └── repositories/
│       └── documents_repository.dart    # Abstract repository interface
├── data/                            # Data Layer
│   ├── datasources/
│   │   └── firebase_documents_datasource.dart  # Firebase implementation
│   └── repositories/
│       └── documents_repository_impl.dart      # Repository implementation
└── presentation/                    # Presentation Layer
    └── pages/
        └── documents_page.dart      # UI + State Management
```

## 📊 Data Flow

```
UI (DocumentsPage)
    ↓
Repository (DocumentsRepository)
    ↓
DataSource (FirebaseDocumentsDataSource)
    ↓
Firestore (Collection: taiLieu)
```

## 🔧 Các Layer

### 1. Domain Layer

**DocumentsRepository** (Abstract)
- `getAllDocuments()`: Lấy tất cả tài liệu
- `getFavoriteDocuments()`: Lấy tài liệu yêu thích
- `toggleFavorite()`: Bật/tắt yêu thích
- `searchDocuments()`: Tìm kiếm tài liệu
- `watchAllDocuments()`: Stream realtime updates

### 2. Data Layer

**FirebaseDocumentsDataSource**
- Xử lý tất cả operations với Firestore
- Collection: `taiLieu`
- CRUD operations cho documents
- Error handling

**DocumentsRepositoryImpl**
- Implement interface từ Domain layer
- Gọi DataSource để thực hiện operations
- Trung gian giữa Presentation và Data

### 3. Presentation Layer

**DocumentsPage**
- StatefulWidget với TabController
- State management: setState
- UI components: AppBar, TabBar, ListView
- Pull-to-refresh
- Loading states
- Error handling UI

## 📦 Entity

Sử dụng **TaiLieuEntity** từ Data Generator:

```dart
class TaiLieuEntity {
  final String maTL;        // Mã tài liệu (ID)
  final String tenTL;       // Tên tài liệu
  final String monHoc;      // Mã môn học
  final String duongDan;    // Đường dẫn file
  final String moTa;        // Mô tả
  final bool yeuThich;      // Trạng thái yêu thích
}
```

## 🔥 Firestore Integration

### Collection Structure
```
taiLieu/
├── document1/
│   ├── maTL: "TL001"
│   ├── tenTL: "Slide bài giảng OOP"
│   ├── monHoc: "MH001"
│   ├── duongDan: "/documents/oop_slides.pdf"
│   ├── moTa: "Slide bài giảng về lập trình hướng đối tượng"
│   └── yeuThich: true
└── ...
```

### Firestore Operations

**Read All**
```dart
final documents = await repository.getAllDocuments();
```

**Read Favorites**
```dart
final favorites = await repository.getFavoriteDocuments();
```

**Toggle Favorite**
```dart
await repository.toggleFavorite('TL001', true);
```

**Search**
```dart
final results = await repository.searchDocuments('OOP');
```

**Realtime Stream**
```dart
repository.watchAllDocuments().listen((documents) {
  // Update UI
});
```

## 🎨 Giao diện

### 1. Header
- **Nút Back**: Quay lại trang trước
- **Tiêu đề**: "Tài liệu học tập"
- **Icon Thông báo**: Truy cập trang thông báo

### 2. Tab Bar
- **Tất cả**: Hiển thị toàn bộ tài liệu từ Firestore
- **Yêu thích**: Hiển thị các tài liệu có `yeuThich = true`

### 3. Thanh công cụ
- **Số lượng**: Hiển thị tổng số tài liệu
- **Tìm kiếm**: Nút tìm kiếm tài liệu (đang phát triển)
- **Lọc**: Nút lọc tài liệu (đang phát triển)

### 4. Danh sách tài liệu

Mỗi item tài liệu bao gồm:
- ✅ **Thumbnail**: Icon màu theo môn học
- ✅ **Tiêu đề**: Tên tài liệu (tối đa 2 dòng)
- ✅ **Môn học**: Badge hiển thị mã môn học
- ✅ **Mô tả**: Mô tả ngắn (tối đa 2 dòng)
- ✅ **Nút Yêu thích**: Toggle trạng thái yêu thích

## ✅ Tính năng đã hoàn thành

### Core Features
1. **Clean Architecture**
   - Domain, Data, Presentation layers đầy đủ
   - Repository pattern
   - Dependency injection manual

2. **Firestore Integration**
   - Đọc dữ liệu từ collection `taiLieu`
   - Cập nhật trạng thái yêu thích
   - Lọc documents theo điều kiện

3. **UI Features**
   - Loading state với CircularProgressIndicator
   - Error state với retry button
   - Empty state cho cả 2 tabs
   - Pull-to-refresh
   - Responsive UI

4. **Tab Management**
   - Tab "Tất cả" với toàn bộ documents
   - Tab "Yêu thích" lọc documents có yeuThich = true
   - Real-time update giữa các tabs

5. **Favorite System**
   - Toggle favorite với optimistic UI update
   - Sync với Firestore
   - Revert nếu có lỗi

6. **Color-coded Thumbnails**
   - Mỗi môn học có màu riêng
   - Icon document placeholder

## 🚧 Đang phát triển

1. **Tìm kiếm nâng cao**: Full-text search
2. **Lọc**: Theo môn học, ngày đăng
3. **Chi tiết tài liệu**: Trang xem và tải file
4. **Download**: Tải file về thiết bị
5. **Stream**: Realtime updates với watchAllDocuments()
6. **State Management**: Bloc/Riverpod thay vì setState

## 🔄 Dữ liệu từ Data Generator

### Cách sinh dữ liệu

1. Đăng nhập với `admin123@gmail.com`
2. Vào **Profile** > **Sinh dữ liệu mẫu**
3. Chờ process hoàn tất
4. Dữ liệu sẽ được tạo trong Firestore collection `taiLieu`

### Dữ liệu mẫu (5 documents)

| ID | Tên | Môn học | Yêu thích |
|----|-----|---------|-----------|
| TL001 | Slide bài giảng OOP | MH001 | ✅ |
| TL002 | Bài tập SQL | MH002 | ❌ |
| TL003 | Tài liệu mạng máy tính | MH003 | ✅ |
| TL004 | UML Diagrams Guide | MH004 | ❌ |
| TL005 | Flutter Widgets Reference | MH005 | ✅ |

## 🎯 Cách sử dụng

### Từ Home Page
1. Nhấn vào ô **"Tài liệu"**
2. Trang Documents sẽ load dữ liệu từ Firestore
3. Xem loading indicator trong khi load

### Xem tất cả tài liệu
- Mặc định hiển thị tab **"Tất cả"**
- Pull-to-refresh để reload

### Xem tài liệu yêu thích
1. Chuyển sang tab **"Yêu thích"**
2. Chỉ hiển thị documents có `yeuThich = true`

### Thêm/Bỏ yêu thích
1. Nhấn icon **trái tim** 
2. UI update ngay lập tức (optimistic)
3. Firestore update ở background
4. Nếu lỗi sẽ revert và hiện thông báo

### Xử lý lỗi
- Hiển thị error screen nếu không load được
- Nút **"Thử lại"** để retry
- SnackBar thông báo lỗi khi toggle favorite fail

## 📱 States

### Loading State
```dart
_isLoading = true
→ Center(child: CircularProgressIndicator())
```

### Success State
```dart
_isLoading = false && _errorMessage == null
→ Show TabBarView with documents
```

### Error State
```dart
_isLoading = false && _errorMessage != null
→ Show error screen with retry button
```

### Empty State
```dart
documents.isEmpty
→ Show empty icon + message
```

## 🔐 Dependencies

```yaml
dependencies:
  cloud_firestore: ^6.0.2  # Firestore
  go_router: ^16.2.4       # Navigation
```

## 🎨 UI Colors

### Thumbnails by Subject
- **MH001**: Orange (#FF9800)
- **MH002**: Blue (#2196F3)
- **MH003**: Grey (#E0E0E0)
- **MH004**: Green (#4CAF50)
- **MH005**: Red (#D32F2F)
- **Default**: Purple (#9C27B0)

### Other Colors
- **Primary**: `AppColors.primary` (#2196F3)
- **Favorite**: Red
- **Border**: Grey300
- **Background**: White

## 🛠️ Error Handling

### Repository Level
```dart
try {
  return await dataSource.getAllDocuments();
} catch (e) {
  throw Exception('Lỗi khi lấy danh sách tài liệu: $e');
}
```

### UI Level
```dart
try {
  await repository.toggleFavorite(id, status);
} catch (e) {
  // Revert UI
  _loadDocuments();
  // Show error
  ScaffoldMessenger.of(context).showSnackBar(...);
}
```

## 📝 Code Examples

### Initialize Repository
```dart
late DocumentsRepository _repository;

@override
void initState() {
  _repository = DocumentsRepositoryImpl(
    FirebaseDocumentsDataSource()
  );
  _loadDocuments();
}
```

### Load Documents
```dart
Future<void> _loadDocuments() async {
  try {
    final documents = await _repository.getAllDocuments();
    setState(() {
      _allDocuments = documents;
      _favoriteDocuments = documents.where((d) => d.yeuThich).toList();
    });
  } catch (e) {
    setState(() => _errorMessage = e.toString());
  }
}
```

### Toggle Favorite
```dart
Future<void> _toggleFavorite(String id, bool status) async {
  // Optimistic update
  setState(() { /* update UI */ });
  
  try {
    await _repository.toggleFavorite(id, !status);
  } catch (e) {
    _loadDocuments(); // Revert
    showError(e);
  }
}
```

## 🚀 Future Enhancements

1. **Bloc/Cubit**: Thay thế setState
2. **Caching**: Lưu documents local
3. **Pagination**: Lazy load cho nhiều documents
4. **Sorting**: Sắp xếp theo tên, ngày, views
5. **Categories**: Nhóm theo môn học
6. **Download**: Tải file từ Storage
7. **Share**: Chia sẻ tài liệu
8. **Comments**: Bình luận và đánh giá

## 📄 License
Part of TLU Support Application
