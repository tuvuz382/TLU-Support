# 🏗️ Clean Architecture - Documents Feature

## Tổng quan

Feature Documents được xây dựng theo mô hình **Clean Architecture** với 3 layers độc lập:

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│    (UI, State Management, Pages)        │
└──────────────┬──────────────────────────┘
               │
               ↓
┌─────────────────────────────────────────┐
│          Domain Layer                   │
│  (Business Logic, Entities, Repository) │
└──────────────┬──────────────────────────┘
               │
               ↓
┌─────────────────────────────────────────┐
│           Data Layer                    │
│   (DataSource, Repository Impl, API)    │
└─────────────────────────────────────────┘
```

## Nguyên tắc Clean Architecture

### 1. Dependency Rule
- **Inner layers không phụ thuộc vào outer layers**
- Domain layer không biết gì về Presentation hay Data
- Data layer chỉ biết về Domain (interface)
- Presentation layer chỉ biết về Domain (interface)

### 2. Separation of Concerns
- Mỗi layer có trách nhiệm riêng
- Dễ dàng test từng layer độc lập
- Thay đổi một layer không ảnh hưởng layers khác

### 3. Testability
- Domain logic dễ test (pure Dart)
- Data layer có thể mock
- Presentation có thể test UI riêng

## Chi tiết các Layers

### 🎯 Domain Layer (Business Logic)

**Vị trí**: `lib/features/documents/domain/`

**Thành phần**:
- **Entities**: Models thuần túy (sử dụng `TaiLieuEntity`)
- **Repositories**: Abstract interfaces định nghĩa operations

**Đặc điểm**:
- ✅ Không phụ thuộc Flutter SDK
- ✅ Không phụ thuộc external packages
- ✅ Pure Dart code
- ✅ Chỉ chứa business rules

**File**:
```dart
// domain/repositories/documents_repository.dart
abstract class DocumentsRepository {
  Future<List<TaiLieuEntity>> getAllDocuments();
  Future<List<TaiLieuEntity>> getFavoriteDocuments();
  Future<void> toggleFavorite(String documentId, bool isFavorite);
  Future<List<TaiLieuEntity>> searchDocuments(String query);
  Stream<List<TaiLieuEntity>> watchAllDocuments();
}
```

**Trách nhiệm**:
- Định nghĩa contract (interface)
- Không quan tâm implementation
- Business rules thuần túy

---

### 💾 Data Layer (Data Management)

**Vị trí**: `lib/features/documents/data/`

**Thành phần**:

#### A. DataSource
**File**: `data/datasources/firebase_documents_datasource.dart`

```dart
class FirebaseDocumentsDataSource {
  final FirebaseFirestore _firestore;
  
  // CRUD operations với Firestore
  Future<List<TaiLieuEntity>> getAllDocuments() { }
  Future<void> toggleFavorite(String id, bool status) { }
  // ...
}
```

**Trách nhiệm**:
- Giao tiếp trực tiếp với Firestore
- Parse data từ Firestore → Entity
- Error handling cấp thấp
- Query operations

#### B. Repository Implementation
**File**: `data/repositories/documents_repository_impl.dart`

```dart
class DocumentsRepositoryImpl implements DocumentsRepository {
  final FirebaseDocumentsDataSource _dataSource;
  
  DocumentsRepositoryImpl(this._dataSource);
  
  @override
  Future<List<TaiLieuEntity>> getAllDocuments() async {
    return await _dataSource.getAllDocuments();
  }
  
  // Implement tất cả methods từ interface
}
```

**Trách nhiệm**:
- Implement interface từ Domain
- Gọi DataSource
- Có thể thêm caching, mapping
- Bridge giữa Domain và external data

**Đặc điểm**:
- ✅ Depends on Domain (interface)
- ✅ Implements business rules
- ✅ Giao tiếp với external services
- ✅ Error transformation

---

### 🎨 Presentation Layer (UI)

**Vị trí**: `lib/features/documents/presentation/`

**Thành phần**:

#### A. Pages
**File**: `presentation/pages/documents_page.dart`

```dart
class DocumentsPage extends StatefulWidget {
  // UI Implementation
}

class _DocumentsPageState extends State<DocumentsPage> {
  late DocumentsRepository _repository;
  
  @override
  void initState() {
    _repository = DocumentsRepositoryImpl(
      FirebaseDocumentsDataSource()
    );
    _loadDocuments();
  }
  
  Future<void> _loadDocuments() async {
    final documents = await _repository.getAllDocuments();
    setState(() { /* update UI */ });
  }
}
```

**Trách nhiệm**:
- Render UI
- Handle user interactions
- State management (setState, Bloc, Riverpod, etc.)
- Call Repository methods
- Show loading/error states

**Đặc điểm**:
- ✅ Depends on Domain (interface)
- ✅ Không biết về Data layer implementation
- ✅ Flutter widgets
- ✅ User experience

---

## Data Flow Example

### 📥 Load Documents (Read Operation)

```
User Action: Open Documents Page
    ↓
┌────────────────────────────────────────────┐
│ 1. PRESENTATION                            │
│    _DocumentsPageState.initState()        │
│    → _loadDocuments()                     │
└────────────┬───────────────────────────────┘
             │
             ↓
┌────────────────────────────────────────────┐
│ 2. DOMAIN                                  │
│    DocumentsRepository.getAllDocuments()  │
│    (interface only)                       │
└────────────┬───────────────────────────────┘
             │
             ↓
┌────────────────────────────────────────────┐
│ 3. DATA                                    │
│    DocumentsRepositoryImpl                │
│    → FirebaseDocumentsDataSource          │
└────────────┬───────────────────────────────┘
             │
             ↓
┌────────────────────────────────────────────┐
│ 4. FIRESTORE                               │
│    Collection: taiLieu                     │
│    Query: get()                            │
└────────────┬───────────────────────────────┘
             │
             ↓ (Data returns)
┌────────────────────────────────────────────┐
│ 5. DATA                                    │
│    Parse: Firestore → TaiLieuEntity       │
│    Return: List<TaiLieuEntity>            │
└────────────┬───────────────────────────────┘
             │
             ↓
┌────────────────────────────────────────────┐
│ 6. PRESENTATION                            │
│    setState(() { _allDocuments = docs })  │
│    → UI rebuilds                          │
└────────────────────────────────────────────┘
```

### 📤 Toggle Favorite (Write Operation)

```
User Action: Tap favorite icon
    ↓
PRESENTATION: _toggleFavorite(id, status)
    ↓
    setState() → Optimistic UI update
    ↓
DOMAIN: repository.toggleFavorite(id, !status)
    ↓
DATA: FirebaseDocumentsDataSource
    ↓
FIRESTORE: Update document where maTL == id
    ↓
    Success → Done ✅
    ↓
    Error → Revert UI + Show error ❌
```

## Dependency Injection

### Current: Manual DI
```dart
// In _DocumentsPageState.initState()
_repository = DocumentsRepositoryImpl(
  FirebaseDocumentsDataSource()
);
```

### Future: với GetIt
```dart
// setup_dependencies.dart
final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<FirebaseDocumentsDataSource>(
    () => FirebaseDocumentsDataSource()
  );
  
  getIt.registerLazySingleton<DocumentsRepository>(
    () => DocumentsRepositoryImpl(getIt<FirebaseDocumentsDataSource>())
  );
}

// In DocumentsPage
final repository = getIt<DocumentsRepository>();
```

## Testing Strategy

### Unit Tests

#### Domain Layer
```dart
test('Repository interface methods are defined', () {
  // Test interface contracts
});
```

#### Data Layer
```dart
group('FirebaseDocumentsDataSource', () {
  test('getAllDocuments returns list of documents', () async {
    // Mock Firestore
    final dataSource = FirebaseDocumentsDataSource();
    final result = await dataSource.getAllDocuments();
    expect(result, isA<List<TaiLieuEntity>>());
  });
  
  test('toggleFavorite updates Firestore', () async {
    // Test update operation
  });
});
```

#### Presentation Layer
```dart
testWidgets('DocumentsPage shows loading indicator', (tester) async {
  await tester.pumpWidget(MaterialApp(home: DocumentsPage()));
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});

testWidgets('DocumentsPage shows documents after load', (tester) async {
  // Test UI after data loads
});
```

### Integration Tests
```dart
testWidgets('Full flow: Load documents and toggle favorite', (tester) async {
  // Test complete user flow
});
```

## Benefits of Clean Architecture

### ✅ Pros
1. **Testability**: Dễ dàng test từng layer
2. **Maintainability**: Code rõ ràng, dễ maintain
3. **Scalability**: Thêm features không ảnh hưởng code cũ
4. **Flexibility**: Đổi data source (Firestore → API) dễ dàng
5. **Reusability**: Repository có thể dùng cho nhiều UI
6. **Team collaboration**: Nhiều người làm song song

### ⚠️ Tradeoffs
1. **Boilerplate**: Nhiều file, nhiều code setup
2. **Learning curve**: Cần hiểu rõ architecture
3. **Overhead**: Có thể over-engineering cho app nhỏ

## Best Practices

### 1. Domain Layer
- ✅ Keep it pure Dart
- ✅ No Flutter dependencies
- ✅ Only business logic
- ❌ No UI code
- ❌ No implementation details

### 2. Data Layer
- ✅ Handle all external data sources
- ✅ Parse data to Domain entities
- ✅ Detailed error handling
- ❌ No UI logic
- ❌ No business rules

### 3. Presentation Layer
- ✅ Only call Domain interfaces
- ✅ Handle UI state
- ✅ User experience
- ❌ No direct Firestore calls
- ❌ No data parsing logic

## Migration Path

### Current State
```
DocumentsPage (UI + Logic + Data)
└─ Firestore directly
```

### After Clean Architecture
```
DocumentsPage (UI only)
└─ DocumentsRepository (Interface)
    └─ DocumentsRepositoryImpl
        └─ FirebaseDocumentsDataSource
            └─ Firestore
```

## Future Improvements

### 1. State Management
```dart
// With Bloc
class DocumentsBloc extends Bloc<DocumentsEvent, DocumentsState> {
  final DocumentsRepository repository;
  
  DocumentsBloc(this.repository);
}
```

### 2. Use Cases
```dart
// domain/usecases/get_all_documents.dart
class GetAllDocuments {
  final DocumentsRepository repository;
  
  Future<List<TaiLieuEntity>> call() {
    return repository.getAllDocuments();
  }
}
```

### 3. Result/Either pattern
```dart
// For better error handling
abstract class DocumentsRepository {
  Future<Either<Failure, List<TaiLieuEntity>>> getAllDocuments();
}
```

## Comparison with Other Features

### Auth Feature (có Clean Architecture)
```
auth/
├── domain/
│   ├── entities/user_entity.dart
│   └── repositories/auth_repository.dart
├── data/
│   └── datasources/firebase_auth_datasource.dart
└── presentation/
    └── pages/login_page.dart
```

### Documents Feature (Clean Architecture đầy đủ)
```
documents/
├── domain/
│   └── repositories/documents_repository.dart
├── data/
│   ├── datasources/firebase_documents_datasource.dart
│   └── repositories/documents_repository_impl.dart
└── presentation/
    └── pages/documents_page.dart
```

### Notes Feature (chưa có Clean Architecture)
```
notes/
└── presentation/
    └── pages/notes_page.dart
```

## Conclusion

Documents Feature là ví dụ hoàn chỉnh về Clean Architecture trong TLU Support app. Có thể áp dụng pattern tương tự cho các features khác như Schedule, Notes, Profile, etc.

**Key Takeaways**:
- Separation of concerns
- Testable code
- Maintainable và scalable
- Easy to extend
- Team-friendly

---

**Version**: 1.0  
**Last Updated**: 2024  
**Author**: TLU Support Team

