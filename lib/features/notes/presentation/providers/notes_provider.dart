import 'package:flutter/material.dart';
import '../../../data_generator/domain/entities/ghi_chu_entity.dart';
import '../../domain/usecases/get_all_notes_usecase.dart';
import '../../domain/usecases/add_note_usecase.dart';
import '../../domain/usecases/update_note_usecase.dart';
import '../../domain/usecases/delete_note_usecase.dart';

class NotesProvider extends ChangeNotifier {
  final GetAllNotesUseCase getAllNotesUseCase;
  final AddNoteUseCase addNoteUseCase;
  final UpdateNoteUseCase updateNoteUseCase;
  final DeleteNoteUseCase deleteNoteUseCase;

  NotesProvider({
    required this.getAllNotesUseCase,
    required this.addNoteUseCase,
    required this.updateNoteUseCase,
    required this.deleteNoteUseCase,
  });

  List<GhiChuEntity> _notes = [];
  bool _loading = false;
  List<GhiChuEntity> get notes => _notes;
  bool get loading => _loading;

  Future<void> fetchNotes() async {
    _loading = true;
    notifyListeners();
    _notes = await getAllNotesUseCase();
    _loading = false;
    notifyListeners();
  }

  Future<void> addNote(GhiChuEntity note) async {
    await addNoteUseCase(note);
    await fetchNotes();
  }

  Future<void> updateNote(GhiChuEntity note) async {
    await updateNoteUseCase(note);
    await fetchNotes();
  }

  Future<void> deleteNote(String maGhiChu) async {
    await deleteNoteUseCase(maGhiChu);
    await fetchNotes();
  }
}
