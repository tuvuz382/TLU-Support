import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data_generator/domain/entities/mon_hoc_entity.dart';
import '../../../documents/data/datasources/firebase_documents_datasource.dart';
import '../../../data_generator/domain/entities/tai_lieu_entity.dart';

class SubjectDetailPage extends StatelessWidget {
  final MonHocEntity subject;
  const SubjectDetailPage({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(subject.tenMon, style: const TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${subject.tenMon} (${subject.maMon})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text('Số tín chỉ: ${subject.soTinChi}'),
            Text('Chuyên ngành: ${subject.chuyenNganh}'),
            const SizedBox(height: 16),
            const Text('Mục tiêu môn học', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(subject.moTa.isEmpty
                ? 'Nội dung sẽ được cập nhật.'
                : subject.moTa),
            const SizedBox(height: 16),
            const Text('Tài liệu tham khảo', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _SubjectDocuments(maMon: subject.maMon),
          ],
        ),
      ),
    );
  }
}

class _SubjectDocuments extends StatelessWidget {
  final String maMon;
  const _SubjectDocuments({required this.maMon});

  @override
  Widget build(BuildContext context) {
    final ds = FirebaseDocumentsDataSource();
    return FutureBuilder<List<TaiLieuEntity>>(
      future: ds.getAllDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data!
            .where((e) => e.maMon == maMon)
            .toList();
        if (docs.isEmpty) return const Text('Không có tài liệu.');
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const Divider(height: 16),
          itemBuilder: (context, index) {
            final d = docs[index];
            return ListTile(
              title: Text(d.tenTL),
              subtitle: Text(d.moTa),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            );
          },
        );
      },
    );
  }
}


