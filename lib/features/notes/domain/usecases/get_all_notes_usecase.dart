import '../../../data_generator/domain/entities/ghi_chu_entity.dart';
import '../repositories/notes_repository.dart';

class GetAllNotesUseCase {
  final NotesRepository repository;
  GetAllNotesUseCase(this.repository);

  Future<List<GhiChuEntity>> call() => repository.getAllNotes();
}
