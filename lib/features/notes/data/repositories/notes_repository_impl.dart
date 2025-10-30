import '../../../data_generator/domain/entities/ghi_chu_entity.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/firebase_notes_datasource.dart';

class NotesRepositoryImpl implements NotesRepository {
  final FirebaseNotesDatasource datasource;
  NotesRepositoryImpl(this.datasource);

  @override
  Future<List<GhiChuEntity>> getAllNotes() => datasource.getAllNotes();

  @override
  Future<void> addNote(GhiChuEntity note) => datasource.addNote(note);

  @override
  Future<void> updateNote(GhiChuEntity note) => datasource.updateNote(note);

  @override
  Future<void> deleteNote(String maGhiChu) => datasource.deleteNote(maGhiChu);
}
