import '../../../data_generator/domain/entities/ghi_chu_entity.dart';

abstract class NotesRepository {
  Future<List<GhiChuEntity>> getAllNotes();
  Future<void> addNote(GhiChuEntity note);
  Future<void> updateNote(GhiChuEntity note);
  Future<void> deleteNote(String maGhiChu);
}
