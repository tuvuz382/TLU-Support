import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../data_generator/domain/entities/mon_hoc_entity.dart';
import '../../../data_generator/data/services/data_generator_service.dart';
import '../../data/datasources/firebase_subjects_datasource.dart';
import '../../data/repositories/subjects_repository_impl.dart';
import '../../domain/usecases/get_all_subjects_usecase.dart';

class CurriculumPage extends StatefulWidget {
  const CurriculumPage({super.key});

  @override
  State<CurriculumPage> createState() => _CurriculumPageState();
}

class _CurriculumPageState extends State<CurriculumPage> {
  late final GetAllSubjectsUseCase _getAllSubjectsUC;
  final TextEditingController _searchController = TextEditingController();

  List<MonHocEntity> _allSubjects = [];
  List<MonHocEntity> _filtered = [];
  bool _loading = true;
  String? _selectedMajor; // null => tất cả

  @override
  void initState() {
    super.initState();
    final repo = SubjectsRepositoryImpl(FirebaseSubjectsDataSource());
    _getAllSubjectsUC = GetAllSubjectsUseCase(repo);
    _load();
    _searchController.addListener(_applyFilters);
  }

  Future<void> _load() async {
    try {
      final subjects = await _getAllSubjectsUC();
      setState(() {
        _allSubjects = subjects;
        _filtered = subjects;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi tải dữ liệu: $e'),
            action: SnackBarAction(
              label: 'Sinh dữ liệu mẫu',
              onPressed: _generateSampleData,
            ),
          ),
        );
      }
    }
  }

  Future<void> _generateSampleData() async {
    try {
      setState(() => _loading = true);
      final dataGeneratorService = DataGeneratorService();
      await dataGeneratorService.generateSampleData();
      await _load(); // Reload data after generation
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi sinh dữ liệu: $e')),
        );
      }
    }
  }

  void _applyFilters() {
    final q = _searchController.text.trim().toLowerCase();
    setState(() {
      _filtered = _allSubjects.where((s) {
        final matchMajor = _selectedMajor == null || _selectedMajor!.isEmpty
            ? true
            : s.chuyenNganh == _selectedMajor;
        final matchQuery = q.isEmpty ||
            s.tenMon.toLowerCase().contains(q) ||
            s.maMon.toLowerCase().contains(q);
        return matchMajor && matchQuery;
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
           onPressed: () => context.go('/'),
        ),
        title: const Text('Chương trình đào tạo', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () => context.go('/notifications'),
          ),
        ],
      ),
      floatingActionButton: _allSubjects.isEmpty && !_loading
          ? FloatingActionButton(
              onPressed: _generateSampleData,
              child: const Icon(Icons.add),
              tooltip: 'Sinh dữ liệu mẫu',
            )
          : null,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: _MajorDropdown(
                          majors: [
                            ...{for (final s in _allSubjects) s.chuyenNganh}
                          ],
                          selected: _selectedMajor,
                          onChanged: (val) {
                            _selectedMajor = val?.isEmpty == true ? null : val;
                            _applyFilters();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: 'Tìm kiếm học phần...',
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: _allSubjects.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.school, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'Chưa có dữ liệu môn học',
                                style: TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Nhấn nút + để sinh dữ liệu mẫu',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                              child: DataTable(
                                headingRowHeight: 56,
                                dataRowMinHeight: 52,
                                dataRowMaxHeight: 72,
                                headingRowColor: WidgetStateProperty.all(
                                  AppColors.primary.withValues(alpha: 0.1),
                                ),
                                columns: const [
                                  DataColumn(
                                    label: Text(
                                      'STT',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Mã học phần',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Tên học phần',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Số tín chỉ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: List<DataRow>.generate(
                                  _filtered.length,
                                  (index) {
                                    final subject = _filtered[index];
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          Center(
                                            child: Text(
                                              '${index + 1}',
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            subject.maMon,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          InkWell(
                                            child: Text(
                                              subject.tenMon,
                                              style: const TextStyle(
                                                color: AppColors.primary,
                                                decoration: TextDecoration.underline,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            onTap: () => context.push(
                                              AppRoutes.subjectDetail,
                                              extra: subject,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              subject.soTinChi.toString(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}

class _MajorDropdown extends StatelessWidget {
  final List<String> majors;
  final String? selected;
  final ValueChanged<String?> onChanged;
  const _MajorDropdown({
    required this.majors,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final items = ['Tất cả', ...majors.toSet()];
    return DropdownButtonFormField<String>(
      value: selected ?? 'Tất cả',
      items: items
          .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
          .toList(),
      onChanged: (val) => onChanged(val == 'Tất cả' ? '' : val),
      decoration: const InputDecoration(
        isDense: true,
        border: OutlineInputBorder(),
      ),
    );
  }
}