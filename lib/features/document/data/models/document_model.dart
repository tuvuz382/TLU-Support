import '../../domain/entities/document_entity.dart';

class DocumentModel {
  final String id;
  final String title;
  final String subject;
  final String author;
  final String thumbnailUrl;
  final String coverImageUrl;
  final DateTime uploadDate;
  final int viewCount;
  final bool isFavorite;
  final String documentType;
  final String language;
  final String department;

  const DocumentModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.author,
    required this.thumbnailUrl,
    required this.coverImageUrl,
    required this.uploadDate,
    required this.viewCount,
    required this.isFavorite,
    required this.documentType,
    required this.language,
    required this.department,
  });

  factory DocumentModel.fromEntity(DocumentEntity entity) {
    return DocumentModel(
      id: entity.id,
      title: entity.title,
      subject: entity.subject,
      author: entity.author,
      thumbnailUrl: entity.thumbnailUrl,
      coverImageUrl: entity.coverImageUrl,
      uploadDate: entity.uploadDate,
      viewCount: entity.viewCount,
      isFavorite: entity.isFavorite,
      documentType: entity.documentType,
      language: entity.language,
      department: entity.department,
    );
  }

  DocumentEntity toEntity() {
    return DocumentEntity(
      id: id,
      title: title,
      subject: subject,
      author: author,
      thumbnailUrl: thumbnailUrl,
      coverImageUrl: coverImageUrl,
      uploadDate: uploadDate,
      viewCount: viewCount,
      isFavorite: isFavorite,
      documentType: documentType,
      language: language,
      department: department,
    );
  }
}
