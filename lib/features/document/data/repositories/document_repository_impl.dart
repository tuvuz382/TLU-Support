import '../../domain/entities/document_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/document_repository.dart';
import '../datasources/mock_document_datasource.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  final MockDocumentDataSource _dataSource;

  DocumentRepositoryImpl(this._dataSource);

  @override
  Future<List<DocumentEntity>> getAllDocuments() async {
    return await _dataSource.getAllDocuments();
  }

  @override
  Future<List<DocumentEntity>> getFavoriteDocuments() async {
    return await _dataSource.getFavoriteDocuments();
  }

  @override
  Future<DocumentEntity?> getDocumentById(String id) async {
    return await _dataSource.getDocumentById(id);
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    return await _dataSource.getCategories();
  }

  @override
  Future<void> toggleFavorite(String documentId) async {
    await _dataSource.toggleFavorite(documentId);
  }

  @override
  Future<List<DocumentEntity>> searchDocuments(String keyword) async {
    return await _dataSource.searchDocuments(keyword);
  }

  @override
  Future<List<DocumentEntity>> filterDocuments(
    List<String> selectedCategories,
  ) async {
    return await _dataSource.filterDocuments(selectedCategories);
  }
}
