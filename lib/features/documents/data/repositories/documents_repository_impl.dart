import '../../../data_generator/domain/entities/tai_lieu_entity.dart';
import '../../domain/repositories/documents_repository.dart';
import '../datasources/firebase_documents_datasource.dart';

/// Implementation of DocumentsRepository
class DocumentsRepositoryImpl implements DocumentsRepository {
  final FirebaseDocumentsDataSource _dataSource;

  DocumentsRepositoryImpl(this._dataSource);

  @override
  Future<List<TaiLieuEntity>> getAllDocuments() async {
    return await _dataSource.getAllDocuments();
  }

  @override
  Future<List<TaiLieuEntity>> getFavoriteDocuments() async {
    return await _dataSource.getFavoriteDocuments();
  }

  @override
  Future<void> toggleFavorite(String documentId, bool isFavorite) async {
    return await _dataSource.toggleFavorite(documentId, isFavorite);
  }

  @override
  Future<List<TaiLieuEntity>> searchDocuments(String query) async {
    return await _dataSource.searchDocuments(query);
  }

  @override
  Stream<List<TaiLieuEntity>> watchAllDocuments() {
    return _dataSource.watchAllDocuments();
  }
}
