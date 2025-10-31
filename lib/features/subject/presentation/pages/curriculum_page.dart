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
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: double.infinity,
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
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: double.infinity,
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.search, size: 20),
                              hintText: 'Tìm kiếm...',
                              isDense: true,
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                            ),
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
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            final screenWidth = constraints.maxWidth;
                            final isSmallScreen = screenWidth < 400;
                            
                            // Tính toán font size và spacing dựa trên màn hình
                            final fontSize = isSmallScreen ? 11.0 : 13.0;
                            final columnSpacing = isSmallScreen ? 8.0 : 12.0;
                            final horizontalMargin = isSmallScreen ? 8.0 : 16.0;
                            
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
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
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: screenWidth - (horizontalMargin * 2),
                                    ),
                                    child: DataTable(
                                      headingRowHeight: isSmallScreen ? 48 : 56,
                                      dataRowMinHeight: isSmallScreen ? 48 : 56,
                                      dataRowMaxHeight: isSmallScreen ? 64 : 72,
                                      columnSpacing: columnSpacing,
                                      horizontalMargin: horizontalMargin,
                                      headingRowColor: WidgetStateProperty.all(
                                        AppColors.primary.withValues(alpha: 0.1),
                                      ),
                                      columns: [
                                        DataColumn(
                                          label: SizedBox(
                                            width: isSmallScreen ? 35 : 50,
                                            child: Text(
                                              'STT',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: fontSize,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width: isSmallScreen ? 80 : 100,
                                            child: Text(
                                              isSmallScreen ? 'Mã HP' : 'Mã học phần',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: fontSize,
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Tên học phần',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: fontSize,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width: isSmallScreen ? 50 : 70,
                                            child: Text(
                                              isSmallScreen ? 'TC' : 'Số tín chỉ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: fontSize,
                                              ),
                                              textAlign: TextAlign.center,
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
                                                SizedBox(
                                                  width: isSmallScreen ? 35 : 50,
                                                  child: Center(
                                                    child: Text(
                                                      '${index + 1}',
                                                      style: TextStyle(fontSize: fontSize),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                SizedBox(
                                                  width: isSmallScreen ? 80 : 100,
                                                  child: Text(
                                                    subject.maMon,
                                                    style: TextStyle(
                                                      fontSize: fontSize,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                InkWell(
                                                  child: Text(
                                                    subject.tenMon,
                                                    style: TextStyle(
                                                      color: AppColors.primary,
                                                      fontSize: fontSize,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                  onTap: () => context.push(
                                                    AppRoutes.subjectDetail,
                                                    extra: subject,
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                SizedBox(
                                                  width: isSmallScreen ? 50 : 70,
                                                  child: Center(
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(
                                                        horizontal: isSmallScreen ? 6 : 10,
                                                        vertical: isSmallScreen ? 3 : 5,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: AppColors.primary.withValues(alpha: 0.1),
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: Text(
                                                        subject.soTinChi.toString(),
                                                        style: TextStyle(
                                                          fontSize: fontSize,
                                                          fontWeight: FontWeight.bold,
                                                          color: AppColors.primary,
                                                        ),
                                                      ),
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
                            );
                          },
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return DropdownButtonFormField<String>(
          value: selected ?? 'Tất cả',
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, size: 20),
          iconSize: 20,
          items: items
              .map((e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(
                      e,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ))
              .toList(),
          onChanged: (val) => onChanged(val == 'Tất cả' ? '' : val),
          decoration: InputDecoration(
            isDense: true,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            hintText: constraints.maxWidth < 150 ? null : 'Tất cả',
            hintStyle: const TextStyle(fontSize: 13),
          ),
          selectedItemBuilder: (context) {
            return items.map((e) {
              return SizedBox(
                width: constraints.maxWidth - 40, // Trừ không gian cho icon
                child: Text(
                  e,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 13),
                ),
              );
            }).toList();
          },
        );
      },
    );
  }
}