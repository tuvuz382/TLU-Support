import '../../../data_generator/domain/entities/ghi_chu_entity.dart';
import '../repositories/notes_repository.dart';

class UpdateNoteUseCase {
  final NotesRepository repository;
  UpdateNoteUseCase(this.repository);

  Future<void> call(GhiChuEntity note) => repository.updateNote(note);
}
