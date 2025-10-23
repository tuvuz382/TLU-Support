import '../entities/note_entity.dart';

abstract class NoteRepository {
  /// Lấy danh sách tất cả ghi chú
  Future<List<NoteEntity>> getAllNotes();

  /// Lấy ghi chú theo ID
  Future<NoteEntity?> getNoteById(String id);

  /// Thêm ghi chú mới
  Future<String> addNote(Map<String, dynamic> noteData);

  /// Cập nhật ghi chú
  Future<void> updateNote(String id, Map<String, dynamic> noteData);

  /// Xóa ghi chú
  Future<void> deleteNote(String id);

  /// Lọc ghi chú theo môn học
  Future<List<NoteEntity>> getNotesBySubject(String subject);

  /// Tìm kiếm ghi chú
  Future<List<NoteEntity>> searchNotes(String query);
}

