import '../../../data_generator/domain/entities/tai_lieu_entity.dart';

/// Abstract repository for Documents operations
abstract class DocumentsRepository {
  /// Get all documents from Firestore
  Future<List<TaiLieuEntity>> getAllDocuments();

  /// Get favorite documents
  Future<List<TaiLieuEntity>> getFavoriteDocuments();

  /// Toggle favorite status of a document
  Future<void> toggleFavorite(String documentId, bool isFavorite);

  /// Search documents by title
  Future<List<TaiLieuEntity>> searchDocuments(String query);

  /// Watch all documents (Stream for realtime updates)
  Stream<List<TaiLieuEntity>> watchAllDocuments();
}
