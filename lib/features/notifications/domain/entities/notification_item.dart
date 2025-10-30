import 'package:equatable/equatable.dart';

class NotificationItem extends Equatable {
  final String id;
  final String title;
  final String time;
  final String description;
  final AttachmentItem? attachment;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.time,
    required this.description,
    this.attachment,
  });

  @override
  List<Object?> get props => [id, title, time, description, attachment];
}

class AttachmentItem extends Equatable {
  final String fileName;
  final String fileSize;

  const AttachmentItem({
    required this.fileName,
    required this.fileSize,
  });

  @override
  List<Object?> get props => [fileName, fileSize];
}
