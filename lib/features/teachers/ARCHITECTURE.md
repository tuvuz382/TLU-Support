# Architecture - Teachers Feature

## 📐 Clean Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  ┌────────────────┐  ┌────────────────┐  ┌──────────────┐  │
│  │ TeachersPage   │  │TeacherDetail   │  │ SeedDataPage │  │
│  │                │  │Page            │  │              │  │
│  │ - List view    │  │ - Detail view  │  │ - Seed data  │  │
│  │ - Search       │  │ - Contact info │  │              │  │
│  │ - Filter       │  │ - Specializ.   │  │              │  │
│  └────────────────┘  └────────────────┘  └──────────────┘  │
└─────────────────────────────────────────────────────────────┘
                             ↓
┌─────────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                            │
│  ┌─────────────────────────────────────────────────────┐    │
│  │              TeacherEntity                          │    │
│  │  - id, name, department, faculty                   │    │
│  │  - email, phone, degree                            │    │
│  │  - specializations, officeLocation                 │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐    │
│  │         TeacherRepository (Interface)               │    │
│  │  - getAllTeachers()                                │    │
│  │  - getTeacherById(id)                              │    │
│  │  - searchTeachers(query)                           │    │
│  │  - getTeachersByFaculty(faculty)                   │    │
│  │  - getTeachersByDepartment(department)             │    │
│  └─────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
                             ↓
┌─────────────────────────────────────────────────────────────┐
│                       DATA LAYER                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │      FirebaseTeacherDatasource                      │    │
│  │      (implements TeacherRepository)                 │    │
│  │                                                      │    │
│  │  - Firestore queries                               │    │
│  │  - Data transformation                             │    │
│  │  - Error handling                                  │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐    │
│  │         seedTeachersData()                          │    │
│  │  - Sample data insertion                           │    │
│  └─────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
                             ↓
                    ┌─────────────────┐
                    │   FIREBASE      │
                    │   Firestore     │
                    │  Collection:    │
                    │   'teachers'    │
                    └─────────────────┘
```

## 🔄 Data Flow

### 1. Hiển thị danh sách giảng viên

```
User opens TeachersPage
         ↓
TeachersPage.initState()
         ↓
_loadTeachers()
         ↓
FirebaseTeacherDatasource.getAllTeachers()
         ↓
Firestore.collection('teachers').orderBy('name').get()
         ↓
Convert QuerySnapshot → List<TeacherEntity>
         ↓
setState() → Update UI
         ↓
Display list of teachers
```

### 2. Tìm kiếm giảng viên

```
User types in search field
         ↓
onChanged callback
         ↓
_filterTeachers()
         ↓
Filter _teachers by name (client-side)
         ↓
Update _filteredTeachers
         ↓
setState() → Update UI
```

### 3. Xem chi tiết giảng viên

```
User clicks on teacher card
         ↓
context.push('/teachers/{id}')
         ↓
TeacherDetailPage(teacherId: id)
         ↓
_loadTeacherDetail()
         ↓
FirebaseTeacherDatasource.getTeacherById(id)
         ↓
Firestore.collection('teachers').doc(id).get()
         ↓
Convert DocumentSnapshot → TeacherEntity
         ↓
setState() → Display teacher details
```

### 4. Seed dữ liệu mẫu

```
User clicks "Thêm dữ liệu mẫu"
         ↓
context.push('/seed-data')
         ↓
SeedDataPage → User clicks button
         ↓
seedTeachersData()
         ↓
Check if data exists
         ↓
If not exists: Add sample teachers to Firestore
         ↓
Show success message
         ↓
User navigates back → Refresh data
```

## 🗂️ File Structure

```
teachers/
│
├── data/                           # Data Layer
│   ├── datasources/
│   │   └── firebase_teacher_datasource.dart
│   │       ├── getAllTeachers()
│   │       ├── getTeacherById()
│   │       ├── searchTeachers()
│   │       ├── getTeachersByFaculty()
│   │       └── getTeachersByDepartment()
│   │
│   └── seed_teachers_data.dart
│       └── seedTeachersData()      # Populate sample data
│
├── domain/                         # Domain Layer
│   ├── entities/
│   │   └── teacher_entity.dart
│   │       ├── TeacherEntity class
│   │       ├── fromJson()
│   │       └── toJson()
│   │
│   └── repositories/
│       └── teacher_repository.dart # Interface
│
└── presentation/                   # Presentation Layer
    └── pages/
        ├── teachers_page.dart
        │   ├── State management
        │   ├── Search & Filter UI
        │   └── Teacher cards
        │
        ├── teacher_detail_page.dart
        │   ├── SliverAppBar
        │   ├── Teacher info sections
        │   └── Action buttons
        │
        └── seed_data_page.dart
            └── Seed data UI
```

## 🎯 Design Patterns

### 1. Repository Pattern
- `TeacherRepository` interface defines contract
- `FirebaseTeacherDatasource` implements the contract
- Easy to swap datasource (local, API, etc.)

### 2. Entity Pattern
- `TeacherEntity` is domain model
- Immutable (uses `const`)
- Extends `Equatable` for value comparison

### 3. Clean Architecture
- Clear separation of concerns
- Presentation → Domain → Data
- Domain layer is independent of frameworks

## 🔐 Security Considerations

### Firestore Rules
```javascript
// Read: Authenticated users only
allow read: if request.auth != null;

// Write: Admin only (implement admin check)
allow write: if request.auth != null 
          && request.auth.token.admin == true;
```

### Data Validation
- Email format validation (optional)
- Phone format validation (optional)
- Required fields check in entity

## ⚡ Performance

### Optimization Strategies
1. **Firestore Indexing**: Auto-indexed by `name` field
2. **Client-side Filtering**: Search/filter on local data
3. **Pull-to-refresh**: Manual refresh instead of realtime
4. **Lazy Loading**: Only load detail when needed

### Future Improvements
- [ ] Pagination for large datasets
- [ ] Caching with Hive/SharedPreferences
- [ ] Realtime updates with StreamBuilder
- [ ] Image lazy loading
- [ ] Offline support

## 🧪 Testing Strategy

### Unit Tests
```dart
// Test entity
test('TeacherEntity fromJson', () { ... });

// Test repository
test('getAllTeachers returns list', () { ... });
```

### Widget Tests
```dart
testWidgets('TeachersPage displays list', (tester) async { ... });
```

### Integration Tests
```dart
// Test full flow from UI to Firebase
```

## 📱 Responsive Design

- Mobile: Single column list
- Tablet: Grid view (2 columns)
- Desktop: Grid view (3-4 columns)

(Currently optimized for mobile)

## 🌐 Localization (Future)

Support for multiple languages:
- Vietnamese (default)
- English
- Others...

## 🎨 Theme Integration

Uses app-wide theme:
- `AppColors.primary`
- `AppColors.primaryDark`
- `AppColors.textPrimary`
- `AppColors.textSecondary`
- `AppColors.divider`

## 🔗 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cloud_firestore: ^6.0.2    # Firebase Firestore
  go_router: ^16.2.4         # Navigation
  equatable: ^2.0.7          # Value equality
```

---

**Architecture follows Clean Architecture principles with clear separation of concerns.**

