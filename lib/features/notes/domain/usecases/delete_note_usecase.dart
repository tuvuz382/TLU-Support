import '../repositories/notes_repository.dart';

class DeleteNoteUseCase {
  final NotesRepository repository;
  DeleteNoteUseCase(this.repository);

  Future<void> call(String maGhiChu) => repository.deleteNote(maGhiChu);
}
