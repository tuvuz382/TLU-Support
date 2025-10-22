import 'package:equatable/equatable.dart';

class DocumentEntity extends Equatable {
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

  const DocumentEntity({
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

  @override
  List<Object?> get props => [
    id,
    title,
    subject,
    author,
    thumbnailUrl,
    coverImageUrl,
    uploadDate,
    viewCount,
    isFavorite,
    documentType,
    language,
    department,
  ];

  DocumentEntity copyWith({
    String? id,
    String? title,
    String? subject,
    String? author,
    String? thumbnailUrl,
    String? coverImageUrl,
    DateTime? uploadDate,
    int? viewCount,
    bool? isFavorite,
    String? documentType,
    String? language,
    String? department,
  }) {
    return DocumentEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      author: author ?? this.author,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      uploadDate: uploadDate ?? this.uploadDate,
      viewCount: viewCount ?? this.viewCount,
      isFavorite: isFavorite ?? this.isFavorite,
      documentType: documentType ?? this.documentType,
      language: language ?? this.language,
      department: department ?? this.department,
    );
  }
}
