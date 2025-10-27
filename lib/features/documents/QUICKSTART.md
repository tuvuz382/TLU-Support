# 🚀 Quick Start - Documents Feature

## Bước 1: Sinh dữ liệu mẫu

### Đăng nhập Admin
```
Email: admin123@gmail.com
Password: [your admin password]
```

### Sinh dữ liệu
1. Vào **Profile** (tab cuối cùng)
2. Nhấn **"Sinh dữ liệu mẫu"**
3. Chờ thông báo thành công
4. 5 tài liệu sẽ được tạo trong Firestore

## Bước 2: Truy cập Documents

### Từ Home
1. Mở app → Trang chủ
2. Nhấn ô **"Tài liệu"**
3. Trang Documents sẽ load

### Trực tiếp (code)
```dart
context.go('/documents');
```

## Bước 3: Sử dụng

### Xem tất cả tài liệu
- Tab **"Tất cả"** mở mặc định
- Kéo xuống để refresh

### Xem yêu thích
- Chuyển sang tab **"Yêu thích"**
- Chỉ hiện documents có ❤️

### Toggle yêu thích
- Nhấn icon ❤️ trên mỗi document
- UI update ngay lập tức
- Firestore sync ở background

## Code để tích hợp

### Import Repository
```dart
import 'package:tlu_support/features/documents/domain/repositories/documents_repository.dart';
import 'package:tlu_support/features/documents/data/repositories/documents_repository_impl.dart';
import 'package:tlu_support/features/documents/data/datasources/firebase_documents_datasource.dart';
```

### Sử dụng trong Widget
```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late DocumentsRepository _repository;
  
  @override
  void initState() {
    super.initState();
    _repository = DocumentsRepositoryImpl(
      FirebaseDocumentsDataSource()
    );
    _loadData();
  }
  
  Future<void> _loadData() async {
    try {
      final docs = await _repository.getAllDocuments();
      // Use docs
    } catch (e) {
      // Handle error
    }
  }
}
```

## Kiểm tra Firestore

### Firebase Console
1. Mở Firebase Console
2. Vào **Firestore Database**
3. Collection: `taiLieu`
4. Kiểm tra 5 documents

### Cấu trúc document
```json
{
  "maTL": "TL001",
  "tenTL": "Slide bài giảng OOP",
  "monHoc": "MH001",
  "duongDan": "/documents/oop_slides.pdf",
  "moTa": "Slide bài giảng về lập trình hướng đối tượng",
  "yeuThich": true
}
```

## Troubleshooting

### Không có dữ liệu?
✅ Kiểm tra đã sinh dữ liệu chưa  
✅ Kiểm tra Firebase config  
✅ Kiểm tra internet connection  
✅ Xem console logs

### Lỗi khi toggle favorite?
✅ Kiểm tra Firestore rules  
✅ Kiểm tra user authentication  
✅ Xem error message

### UI không update?
✅ Pull-to-refresh  
✅ Restart app  
✅ Check setState được gọi

## File Structure

```
lib/features/documents/
├── domain/
│   └── repositories/
│       └── documents_repository.dart        ← Interface
├── data/
│   ├── datasources/
│   │   └── firebase_documents_datasource.dart  ← Firestore
│   └── repositories/
│       └── documents_repository_impl.dart   ← Implementation
└── presentation/
    └── pages/
        └── documents_page.dart              ← UI
```

## Next Steps

1. ✅ Đọc `README.md` để hiểu chi tiết features
2. ✅ Đọc `ARCHITECTURE.md` để hiểu Clean Architecture
3. ✅ Thử modify UI theo ý bạn
4. ✅ Thêm features mới (search, filter, etc.)

## Key Points

🎯 **Dữ liệu thật từ Firestore** - không phải mock  
🏗️ **Clean Architecture** - có thể test được  
♻️ **Reusable** - Repository dùng cho nhiều UI  
🔄 **Realtime-ready** - có sẵn `watchAllDocuments()`  
⚡ **Optimistic UI** - toggle favorite nhanh  

## API Quick Reference

### Repository Methods
```dart
// Get all
await repository.getAllDocuments();

// Get favorites only
await repository.getFavoriteDocuments();

// Toggle favorite
await repository.toggleFavorite('TL001', true);

// Search
await repository.searchDocuments('OOP');

// Watch (Stream)
repository.watchAllDocuments().listen((docs) {});
```

## Support

Có vấn đề? Xem:
- `README.md` - Chi tiết features
- `ARCHITECTURE.md` - Hiểu code structure
- Firebase Console - Check data
- Console logs - Debug errors

Happy coding! 🚀

