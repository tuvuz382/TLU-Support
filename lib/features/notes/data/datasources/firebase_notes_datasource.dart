import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data_generator/domain/entities/ghi_chu_entity.dart';

class FirebaseNotesDatasource {
  final _col = FirebaseFirestore.instance.collection('ghiChu');

  Future<List<GhiChuEntity>> getAllNotes() async {
    final snap = await _col.get();
    return snap.docs.map((doc) => GhiChuEntity.fromFirestore(doc.data())).toList();
  }

  Future<void> addNote(GhiChuEntity note) async {
    await _col.add(note.toFirestore());
  }

  Future<void> updateNote(GhiChuEntity note) async {
    final q = await _col.where('maGhiChu', isEqualTo: note.maGhiChu).limit(1).get();
    if (q.docs.isNotEmpty) {
      await _col.doc(q.docs.first.id).update(note.toFirestore());
    }
  }

  Future<void> deleteNote(String maGhiChu) async {
    final q = await _col.where('maGhiChu', isEqualTo: maGhiChu).limit(1).get();
    if (q.docs.isNotEmpty) {
      await _col.doc(q.docs.first.id).delete();
    }
  }
}
