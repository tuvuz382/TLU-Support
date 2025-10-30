import '../../../data_generator/domain/entities/ghi_chu_entity.dart';
import '../repositories/notes_repository.dart';

class AddNoteUseCase {
  final NotesRepository repository;
  AddNoteUseCase(this.repository);

  Future<void> call(GhiChuEntity note) => repository.addNote(note);
}
