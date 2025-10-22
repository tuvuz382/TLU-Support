import '../../domain/entities/document_entity.dart';
import '../../domain/entities/category_entity.dart';

class MockDocumentDataSource {
  // Mock data cho documents
  static final List<DocumentEntity> _mockDocuments = [
    DocumentEntity(
      id: '1',
      title: 'Giáo Trình Tư Tưởng Hồ Chí Minh',
      subject: 'Tư Tưởng Hồ Chí Minh (TTHCM)',
      author: 'Nguyễn Văn A',
      thumbnailUrl: 'assets/images/doc1_thumb.jpg',
      coverImageUrl: 'assets/images/doc1_cover.jpg',
      uploadDate: DateTime(2025, 9, 20),
      viewCount: 1130,
      isFavorite: true,
      documentType: 'Giáo trình',
      language: 'Tiếng Việt',
      department: 'Công nghệ thông tin',
    ),
    DocumentEntity(
      id: '2',
      title: 'Slide Bài Giảng Lập Trình Flutter',
      subject: 'Lập Trình Di Động',
      author: 'Trần Thị B',
      thumbnailUrl: 'assets/images/doc2_thumb.jpg',
      coverImageUrl: 'assets/images/doc2_cover.jpg',
      uploadDate: DateTime(2025, 9, 18),
      viewCount: 856,
      isFavorite: false,
      documentType: 'Slide bài giảng',
      language: 'Tiếng Việt',
      department: 'Công nghệ thông tin',
    ),
    DocumentEntity(
      id: '3',
      title: 'Đề Thi Ôn Tập Toán Cao Cấp',
      subject: 'Toán Cao Cấp',
      author: 'Lê Văn C',
      thumbnailUrl: 'assets/images/doc3_thumb.jpg',
      coverImageUrl: 'assets/images/doc3_cover.jpg',
      uploadDate: DateTime(2025, 9, 15),
      viewCount: 2341,
      isFavorite: true,
      documentType: 'Đề thi ôn tập',
      language: 'Tiếng Việt',
      department: 'Kinh tế',
    ),
  ];

  // Mock data cho categories
  static final List<CategoryEntity> _mockCategories = [
    // Departments
    CategoryEntity(
      id: 'dept_1',
      name: 'Công nghệ thông tin',
      type: 'department',
      isSelected: false,
    ),
    CategoryEntity(
      id: 'dept_2',
      name: 'Kinh Tế',
      type: 'department',
      isSelected: false,
    ),
    CategoryEntity(
      id: 'dept_3',
      name: 'Điện/Điện tử',
      type: 'department',
      isSelected: false,
    ),
    CategoryEntity(
      id: 'dept_4',
      name: 'Cơ Khí',
      type: 'department',
      isSelected: false,
    ),
    CategoryEntity(
      id: 'dept_5',
      name: 'Ngoại ngữ',
      type: 'department',
      isSelected: false,
    ),
    CategoryEntity(
      id: 'dept_6',
      name: 'Tài nguyên nước',
      type: 'department',
      isSelected: false,
    ),

    // Document Types
    CategoryEntity(
      id: 'type_1',
      name: 'Giáo trình',
      type: 'document_type',
      isSelected: false,
    ),
    CategoryEntity(
      id: 'type_2',
      name: 'Slide bài giảng',
      type: 'document_type',
      isSelected: false,
    ),
    CategoryEntity(
      id: 'type_3',
      name: 'Đề thi ôn tập',
      type: 'document_type',
      isSelected: false,
    ),
    CategoryEntity(
      id: 'type_4',
      name: 'Bài tập lớn',
      type: 'document_type',
      isSelected: false,
    ),
    CategoryEntity(
      id: 'type_5',
      name: 'Sách tham khảo',
      type: 'document_type',
      isSelected: false,
    ),

    // Languages
    CategoryEntity(
      id: 'lang_1',
      name: 'Tiếng Anh',
      type: 'language',
      isSelected: false,
    ),
    CategoryEntity(
      id: 'lang_2',
      name: 'Tiếng Việt',
      type: 'language',
      isSelected: false,
    ),
    CategoryEntity(
      id: 'lang_3',
      name: 'Tiếng nước khác(trung, hàn,..v.v..)',
      type: 'language',
      isSelected: false,
    ),
  ];

  Future<List<DocumentEntity>> getAllDocuments() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network delay
    return _mockDocuments;
  }

  Future<List<DocumentEntity>> getFavoriteDocuments() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockDocuments.where((doc) => doc.isFavorite).toList();
  }

  Future<DocumentEntity?> getDocumentById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockDocuments.firstWhere((doc) => doc.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<CategoryEntity>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockCategories;
  }

  Future<void> toggleFavorite(String documentId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // Mock implementation - in real app this would update database
  }

  Future<List<DocumentEntity>> searchDocuments(String keyword) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (keyword.isEmpty) return _mockDocuments;

    return _mockDocuments
        .where(
          (doc) =>
              doc.title.toLowerCase().contains(keyword.toLowerCase()) ||
              doc.subject.toLowerCase().contains(keyword.toLowerCase()) ||
              doc.author.toLowerCase().contains(keyword.toLowerCase()),
        )
        .toList();
  }

  Future<List<DocumentEntity>> filterDocuments(
    List<String> selectedCategories,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (selectedCategories.isEmpty) return _mockDocuments;

    return _mockDocuments.where((doc) {
      return selectedCategories.any((categoryId) {
        final category = _mockCategories.firstWhere(
          (cat) => cat.id == categoryId,
        );
        switch (category.type) {
          case 'department':
            return doc.department == category.name;
          case 'document_type':
            return doc.documentType == category.name;
          case 'language':
            return doc.language == category.name;
          default:
            return false;
        }
      });
    }).toList();
  }
}
