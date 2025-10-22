import '../entities/document_entity.dart';
import '../entities/category_entity.dart';

abstract class DocumentRepository {
  Future<List<DocumentEntity>> getAllDocuments();
  Future<List<DocumentEntity>> getFavoriteDocuments();
  Future<DocumentEntity?> getDocumentById(String id);
  Future<List<CategoryEntity>> getCategories();
  Future<void> toggleFavorite(String documentId);
  Future<List<DocumentEntity>> searchDocuments(String keyword);
  Future<List<DocumentEntity>> filterDocuments(List<String> selectedCategories);
}
