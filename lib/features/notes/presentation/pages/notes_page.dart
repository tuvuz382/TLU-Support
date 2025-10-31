import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/datasources/firebase_notes_datasource.dart';
import '../../data/repositories/notes_repository_impl.dart';
import '../../domain/usecases/get_all_notes_usecase.dart';
import '../../domain/usecases/add_note_usecase.dart';
import '../../domain/usecases/update_note_usecase.dart';
import '../../domain/usecases/delete_note_usecase.dart';
import '../../../data_generator/domain/entities/ghi_chu_entity.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late final GetAllNotesUseCase _getAllUC;
  late final AddNoteUseCase _addUC;
  late final UpdateNoteUseCase _updateUC;
  late final DeleteNoteUseCase _deleteUC;

  final TextEditingController _searchController = TextEditingController();
  List<GhiChuEntity> _notes = [];
  List<GhiChuEntity> _filtered = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final ds = FirebaseNotesDatasource();
    final repo = NotesRepositoryImpl(ds);
    _getAllUC = GetAllNotesUseCase(repo);
    _addUC = AddNoteUseCase(repo);
    _updateUC = UpdateNoteUseCase(repo);
    _deleteUC = DeleteNoteUseCase(repo);

    _searchController.addListener(_applyFilter);
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    final data = await _getAllUC();
    data.sort((a, b) => b.ngayTao.compareTo(a.ngayTao));
    setState(() {
      _notes = data;
      _filtered = data;
      _loading = false;
    });
  }

  void _applyFilter() {
    final q = _searchController.text.trim().toLowerCase();
    setState(() {
      _filtered = _notes
          .where((n) => n.noiDung.toLowerCase().contains(q) || n.tieuDe.toLowerCase().contains(q))
          .toList();
    });
  }

  Color _tagColor(String tag) {
    if (tag == 'CNTT') return Colors.yellow;
    if (tag == 'Đại Cương') return Colors.red;
    return Colors.grey.shade300;
  }

  Future<void> _openForm({GhiChuEntity? note}) async {
    final titleCtrl = TextEditingController(text: note?.tieuDe ?? 'CNTT');
    final contentCtrl = TextEditingController(text: note?.noiDung ?? '');
    bool saving = false;
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Ghi chú', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleCtrl,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              decoration: const InputDecoration(labelText: 'Tiêu đề'),
            ),
            const SizedBox(height: 16),
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: contentCtrl,
                maxLines: null,
                expands: true,
                style: const TextStyle(fontSize: 15),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(12),
                  border: InputBorder.none,
                  hintText: 'Nội dung ghi chú...',
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: saving
                ? null
                : () async {
                    final title = titleCtrl.text.trim();
                    final content = contentCtrl.text.trim();
                    if (title.isEmpty || content.isEmpty) return;
                    saving = true;
                    final now = DateTime.now();
                    final edited = GhiChuEntity(
                      maGhiChu: note?.maGhiChu ?? 'GC${now.millisecondsSinceEpoch}',
                      noiDung: content,
                      ngayTao: note?.ngayTao ?? now,
                      tieuDe: title,
                    );
                    if (note == null) {
                      await _addUC(edited);
                    } else {
                      await _updateUC(edited);
                    }
                    if (mounted) Navigator.pop(context, true);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow.shade400,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );

    if (saved == true) {
      await _fetch();
      await _showSuccessDialog();
    }
  }

  Future<void> _showSuccessDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 36),
              SizedBox(height: 8),
              Text('Lưu thành công'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDelete(GhiChuEntity note) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa ghi chú'),
        content: const Text('Bạn chắc chắn muốn xóa ghi chú này?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xóa')),
        ],
      ),
    );
    if (ok == true) {
      await _deleteUC(note.maGhiChu);
      await _fetch();
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = _searchController.text.isEmpty ? _notes : _filtered;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
           onPressed: () => context.go('/'),
        ),
        title: const Text('Ghi chú', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () => context.go('/notifications'),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Tìm kiếm ghi chú...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final note = list[index];
                      return Dismissible(
                        key: ValueKey(note.maGhiChu),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (_) async {
                          await _confirmDelete(note);
                          return false; // list sẽ refresh thủ công
                        },
                        child: Card(
                          color: Colors.grey.shade100,
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: ListTile(
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    note.noiDung,
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                                if (note.tieuDe.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    margin: const EdgeInsets.only(left: 6),
                                    decoration: BoxDecoration(
                                      color: _tagColor(note.tieuDe),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      note.tieuDe,
                                      style: TextStyle(
                                        color: _tagColor(note.tieuDe) == Colors.yellow ? Colors.black : Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            subtitle: Text('Ngày: ${note.ngayTao.day}/${note.ngayTao.month}'),
                            onTap: () => _openForm(note: note),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
        tooltip: 'Thêm ghi chú',
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
