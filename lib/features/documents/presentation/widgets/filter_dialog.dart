import 'package:flutter/material.dart';
import '/core/presentation/theme/app_colors.dart';
import '../../../data_generator/domain/entities/tai_lieu_entity.dart';
import '../../domain/usecases/filter_documents_usecase.dart';
import '../../domain/usecases/get_available_subjects_usecase.dart';

class FilterDialog extends StatefulWidget {
  final List<TaiLieuEntity> allDocuments;
  final Function(List<TaiLieuEntity>) onFilterResults;

  const FilterDialog({
    super.key,
    required this.allDocuments,
    required this.onFilterResults,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String? _selectedSubject;
  String? _selectedSortBy;
  bool? _favoriteFilter;

  late FilterDocumentsUseCase _filterUseCase;
  late GetAvailableSubjectsUseCase _getSubjectsUseCase;

  @override
  void initState() {
    super.initState();
    _filterUseCase = FilterDocumentsUseCase();
    _getSubjectsUseCase = GetAvailableSubjectsUseCase();
  }

  // Get unique subjects from documents using UseCase
  List<String> get _availableSubjects {
    return _getSubjectsUseCase.call(widget.allDocuments);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Lọc tài liệu',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Subject Filter
            _buildFilterSection(
              title: 'Môn học',
              child: DropdownButtonFormField<String>(
                value: _selectedSubject,
                decoration: InputDecoration(
                  hintText: 'Chọn môn học',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('Tất cả môn học'),
                  ),
                  ..._availableSubjects.map(
                    (subject) => DropdownMenuItem<String>(
                      value: subject,
                      child: Text(subject),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedSubject = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 16),

            // Favorite Filter
            _buildFilterSection(
              title: 'Trạng thái yêu thích',
              child: Column(
                children: [
                  RadioListTile<bool?>(
                    title: const Text('Tất cả'),
                    value: null,
                    groupValue: _favoriteFilter,
                    onChanged: (value) {
                      setState(() {
                        _favoriteFilter = value;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                  RadioListTile<bool?>(
                    title: const Text('Yêu thích'),
                    value: true,
                    groupValue: _favoriteFilter,
                    onChanged: (value) {
                      setState(() {
                        _favoriteFilter = value;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                  RadioListTile<bool?>(
                    title: const Text('Không yêu thích'),
                    value: false,
                    groupValue: _favoriteFilter,
                    onChanged: (value) {
                      setState(() {
                        _favoriteFilter = value;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Sort Options
            _buildFilterSection(
              title: 'Sắp xếp theo',
              child: DropdownButtonFormField<String>(
                value: _selectedSortBy,
                decoration: InputDecoration(
                  hintText: 'Chọn cách sắp xếp',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                items: const [
                  DropdownMenuItem<String>(
                    value: null,
                    child: Text('Mặc định'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'name_asc',
                    child: Text('Tên A-Z'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'name_desc',
                    child: Text('Tên Z-A'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'subject_asc',
                    child: Text('Môn học A-Z'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'subject_desc',
                    child: Text('Môn học Z-A'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedSortBy = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _resetFilters,
                  child: const Text('Đặt lại'),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Hủy'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _applyFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Áp dụng'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedSubject = null;
      _selectedSortBy = null;
      _favoriteFilter = null;
    });
  }

  void _applyFilters() {
    // Use UseCase for filtering
    final filteredDocuments = _filterUseCase.call(
      documents: widget.allDocuments,
      subject: _selectedSubject,
      favoriteStatus: _favoriteFilter,
      sortBy: _selectedSortBy,
    );

    widget.onFilterResults(filteredDocuments);
    Navigator.of(context).pop();
  }
}
