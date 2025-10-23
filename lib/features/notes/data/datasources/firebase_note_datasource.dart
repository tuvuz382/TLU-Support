import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/note_repository.dart';

class FirebaseNoteDatasource implements NoteRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final String _collectionName = 'notes';

  FirebaseNoteDatasource({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  @override
  Future<List<NoteEntity>> getAllNotes() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: _userId)
          .get();

      // Sort client-side để tránh cần composite index
      final notes = querySnapshot.docs
          .map((doc) => NoteEntity.fromJson(doc.data(), doc.id))
          .toList();
      
      notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      
      return notes;
    } catch (e) {
      throw Exception('Không thể tải danh sách ghi chú: $e');
    }
  }

  @override
  Future<NoteEntity?> getNoteById(String id) async {
    try {
      final docSnapshot =
          await _firestore.collection(_collectionName).doc(id).get();

      if (!docSnapshot.exists) {
        return null;
      }

      final data = docSnapshot.data()!;
      if (data['userId'] != _userId) {
        return null; // Không có quyền truy cập
      }

      return NoteEntity.fromJson(data, docSnapshot.id);
    } catch (e) {
      throw Exception('Không thể tải ghi chú: $e');
    }
  }

  @override
  Future<String> addNote(Map<String, dynamic> noteData) async {
    try {
      final data = {
        ...noteData,
        'userId': _userId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      final docRef = await _firestore.collection(_collectionName).add(data);
      return docRef.id;
    } catch (e) {
      throw Exception('Không thể thêm ghi chú: $e');
    }
  }

  @override
  Future<void> updateNote(String id, Map<String, dynamic> noteData) async {
    try {
      final data = {
        ...noteData,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection(_collectionName).doc(id).update(data);
    } catch (e) {
      throw Exception('Không thể cập nhật ghi chú: $e');
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    try {
      await _firestore.collection(_collectionName).doc(id).delete();
    } catch (e) {
      throw Exception('Không thể xóa ghi chú: $e');
    }
  }

  @override
  Future<List<NoteEntity>> getNotesBySubject(String subject) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: _userId)
          .where('subject', isEqualTo: subject)
          .get();

      // Sort client-side
      final notes = querySnapshot.docs
          .map((doc) => NoteEntity.fromJson(doc.data(), doc.id))
          .toList();
      
      notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      
      return notes;
    } catch (e) {
      throw Exception('Không thể tải ghi chú theo môn học: $e');
    }
  }

  @override
  Future<List<NoteEntity>> searchNotes(String query) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: _userId)
          .get();

      final allNotes = querySnapshot.docs
          .map((doc) => NoteEntity.fromJson(doc.data(), doc.id))
          .toList();

      // Tìm kiếm và sort client-side
      final filteredNotes = allNotes
          .where((note) =>
              note.title.toLowerCase().contains(query.toLowerCase()) ||
              note.content.toLowerCase().contains(query.toLowerCase()) ||
              note.subject.toLowerCase().contains(query.toLowerCase()))
          .toList();
      
      filteredNotes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      
      return filteredNotes;
    } catch (e) {
      throw Exception('Không thể tìm kiếm ghi chú: $e');
    }
  }
}

