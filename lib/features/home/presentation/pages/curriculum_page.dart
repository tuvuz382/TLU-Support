import 'package:flutter/material.dart';
import '../../../data_generator/domain/entities/mon_hoc_entity.dart';
import '../../../documents/data/datasources/firebase_documents_datasource.dart';
import '../../../documents/data/repositories/documents_repository_impl.dart';

class CurriculumPage extends StatefulWidget {
  const CurriculumPage({super.key});

  @override
  State<CurriculumPage> createState() => _CurriculumPageState();
}

class _CurriculumPageState extends State<CurriculumPage> {
  List<MonHocEntity> _subjects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSubjects();
  }

  Future<void> _fetchSubjects() async {
    // TODO: Replace by repo/service, dùng tạm dữ liệu mẫu cho dev
    // Thực tế bạn nên inject hoặc lấy từ Firestore/service
    setState(() {
      _subjects = [
        MonHocEntity(maMon: 'CSE481', maGV: 'GV001', tenMon: 'Công nghệ phần mềm', soTinChi: 3, moTa: 'Kỹ thuật phần mềm cơ bản', chuyenNganh: 'Công nghệ phần mềm'),
        MonHocEntity(maMon: 'CSE482', maGV: 'GV001', tenMon: 'Lập trình nâng cao', soTinChi: 3, moTa: '', chuyenNganh: ''),
        MonHocEntity(maMon: 'CSE483', maGV: 'GV001', tenMon: 'Khai thác dữ liệu', soTinChi: 3, moTa: '', chuyenNganh: ''),
        MonHocEntity(maMon: 'CSE484', maGV: 'GV001', tenMon: 'Lập trình mạng', soTinChi: 3, moTa: '', chuyenNganh: ''),
        MonHocEntity(maMon: 'CSE485', maGV: 'GV001', tenMon: 'Kiểm thử phần mềm', soTinChi: 3, moTa: '', chuyenNganh: ''),
        MonHocEntity(maMon: 'CSE486', maGV: 'GV001', tenMon: 'Lập trình di động', soTinChi: 3, moTa: '', chuyenNganh: ''),
        MonHocEntity(maMon: 'CSE487', maGV: 'GV001', tenMon: 'Quản lý dự án', soTinChi: 3, moTa: '', chuyenNganh: ''),
        MonHocEntity(maMon: 'CSE488', maGV: 'GV001', tenMon: 'Phân tích thiết kế hệ thống', soTinChi: 3, moTa: '', chuyenNganh: ''),
        MonHocEntity(maMon: 'CSE491', maGV: 'GV001', tenMon: 'Đồ án phần mềm', soTinChi: 3, moTa: '', chuyenNganh: ''),
        MonHocEntity(maMon: 'CSE492', maGV: 'GV001', tenMon: 'Công nghệ phần mềm nâng cao', soTinChi: 3, moTa: '', chuyenNganh: ''),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chương trình đào tạo'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('STT')),
                  DataColumn(label: Text('Mã học phần')),
                  DataColumn(label: Text('Tên học phần')),
                  DataColumn(label: Text('Số TC')),
                ],
                rows: List<DataRow>.generate(
                  _subjects.length,
                  (index) => DataRow(
                    cells: [
                      DataCell(Text('${index + 1}')),
                      DataCell(Text(_subjects[index].maMon)),
                      DataCell(
                        InkWell(
                          child: Text(
                            _subjects[index].tenMon,
                            style: const TextStyle(
                                color: Colors.blue, decoration: TextDecoration.underline),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SubjectDetailPage(subject: _subjects[index]),
                                ));
                          },
                        ),
                      ),
                      DataCell(Text(_subjects[index].soTinChi.toString())),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class SubjectDetailPage extends StatelessWidget {
  final MonHocEntity subject;
  const SubjectDetailPage({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(subject.tenMon)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Mã học phần: ${subject.maMon}\nSố tín chỉ: ${subject.soTinChi}\nChuyên ngành: ${subject.chuyenNganh}'),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Tài liệu tham khảo:', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          // Tài liệu sẽ được fetch hoặc lọc ở dưới
          Expanded(
            child: _SubjectDocumentsWidget(maMon: subject.maMon),
          )
        ],
      ),
    );
  }
}

class _SubjectDocumentsWidget extends StatelessWidget {
  final String maMon;
  const _SubjectDocumentsWidget({required this.maMon});

  @override
  Widget build(BuildContext context) {
    final repo = DocumentsRepositoryImpl(FirebaseDocumentsDataSource());
    return FutureBuilder(
      future: repo.getAllDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final docs = snapshot.data!
            .where((doc) => doc.maMon == maMon)
            .toList();
        if (docs.isEmpty) return const Text('Không có tài liệu tham khảo.');
        return ListView.separated(
          itemCount: docs.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final doc = docs[index];
            return ListTile(
              title: Text(doc.tenTL),
              subtitle: Text(doc.moTa),
              onTap: () {
                // TODO: Chuyển tới trang chi tiết tài liệu nếu cần
              },
            );
          },
        );
      },
    );
  }
}
