import 'package:flutter/material.dart';
import '/core/presentation/theme/app_colors.dart';
import '../../../data_generator/domain/entities/bang_diem_entity.dart';
import '../../../data_generator/domain/entities/mon_hoc_entity.dart';
import '../../../data_generator/domain/entities/sinh_vien_entity.dart';
import '../../../profile/data/repositories/student_profile_repository_impl.dart';
import '../../../profile/data/datasources/student_profile_remote_datasource.dart';
import '../../../profile/domain/usecases/get_current_student_profile_usecase.dart';
import '../../domain/repositories/gpa_repository.dart';
import '../../data/repositories/gpa_repository_impl.dart';
import '../../data/datasources/firebase_gpa_datasource.dart';
import '../../domain/usecases/calculate_gpa_usecase.dart';
import '../../domain/usecases/calculate_gpa_summary_usecase.dart';
import '../../domain/entities/gpa_summary_entity.dart';

class GPAPage extends StatefulWidget {
  const GPAPage({super.key});

  @override
  State<GPAPage> createState() => _GPAPageState();
}

class _GPAPageState extends State<GPAPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late GPARepository _repository;
  late GetCurrentStudentProfileUseCase _getProfileUseCase;
  late CalculateGPAUseCase _calculateGPAUseCase;
  late CalculateGPASummaryUseCase _calculateGPASummaryUseCase;

  SinhVienEntity? _currentStudent;
  List<BangDiemEntity> _allGrades = [];
  List<MonHocEntity> _subjects = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Filter states
  String? _selectedNamHoc;
  String? _selectedHocKy;
  List<int> _availableYears = [];
  List<String> _availableSemesters = ['HK1', 'HK2'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Dependency Injection setup
    _repository = GPARepositoryImpl(FirebaseGPADataSource());
    final profileDataSource = StudentProfileRemoteDataSource();
    final profileRepository =
        StudentProfileRepositoryImpl(remoteDataSource: profileDataSource);
    _getProfileUseCase = GetCurrentStudentProfileUseCase(profileRepository);
    
    // Initialize Use Cases
    _calculateGPAUseCase = CalculateGPAUseCase();
    _calculateGPASummaryUseCase = CalculateGPASummaryUseCase(
      calculateGPAUseCase: _calculateGPAUseCase,
    );

    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Lấy thông tin sinh viên hiện tại
      final studentProfile = await _getProfileUseCase();

      if (studentProfile == null) {
        setState(() {
          _errorMessage =
              'Không tìm thấy thông tin sinh viên. Vui lòng cập nhật profile.';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _currentStudent = studentProfile;
      });

      // Lấy dữ liệu bảng điểm và môn học
      final futures = await Future.wait([
        _repository.getGradesByStudent(studentProfile.maSV),
        _repository.getAllSubjects(),
      ]);

      final allGrades = futures[0] as List<BangDiemEntity>;
      final subjects = futures[1] as List<MonHocEntity>;

      // Lấy danh sách năm học có dữ liệu
      final years = allGrades.map((g) => g.namHoc).toSet().toList()..sort();
      if (years.isNotEmpty && _selectedNamHoc == null) {
        _selectedNamHoc = years.last.toString();
      }

      setState(() {
        _allGrades = allGrades;
        _subjects = subjects;
        _availableYears = years;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi tải dữ liệu: $e';
        _isLoading = false;
      });
    }
  }

  List<BangDiemEntity> _getFilteredGrades() {
    var filtered = _allGrades;

    if (_selectedNamHoc != null) {
      final namHoc = int.tryParse(_selectedNamHoc!) ?? 0;
      filtered = filtered.where((g) => g.namHoc == namHoc).toList();

      if (_selectedHocKy != null) {
        filtered =
            filtered.where((g) => g.hocky == _selectedHocKy).toList();
      }
    }

    return filtered;
  }


  /// Tính tổng hợp GPA sử dụng Use Case
  List<GPASummaryEntity> _calculateGPASummary() {
    return _calculateGPASummaryUseCase(
      allGrades: _allGrades,
      subjects: _subjects,
    );
  }

  String _getSubjectName(String maMon) {
    final subject = _subjects.firstWhere(
      (s) => s.maMon == maMon,
      orElse: () => MonHocEntity(
        maMon: maMon,
        maGV: '',
        tenMon: 'Không xác định',
        soTinChi: 3,
        moTa: '',
      ),
    );
    return subject.tenMon;
  }

  int _getSubjectCredits(String maMon) {
    final subject = _subjects.firstWhere(
      (s) => s.maMon == maMon,
      orElse: () => MonHocEntity(
        maMon: maMon,
        maGV: '',
        tenMon: 'Không xác định',
        soTinChi: 3,
        moTa: '',
      ),
    );
    return subject.soTinChi;
  }

  Widget _buildGradeTable() {
    final filteredGrades = _getFilteredGrades();

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      children: [
        // Filter section
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String?>(
                  value: _selectedNamHoc,
                  decoration: const InputDecoration(
                    labelText: 'Năm học',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                  ),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Tất cả'),
                    ),
                    ..._availableYears.map((year) => DropdownMenuItem(
                          value: year.toString(),
                          child: Text('$year-${year + 1}'),
                        )),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedNamHoc = value;
                      _selectedHocKy = null;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String?>(
                  value: _selectedHocKy,
                  decoration: const InputDecoration(
                    labelText: 'Kỳ học',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                  ),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Tất cả'),
                    ),
                    ..._availableSemesters.map((sem) => DropdownMenuItem(
                          value: sem,
                          child: Text(sem),
                        )),
                  ],
                  onChanged: _selectedNamHoc == null
                      ? null
                      : (value) {
                          setState(() {
                            _selectedHocKy = value;
                          });
                        },
                ),
              ),
            ],
          ),
        ),
        // Table đơn giản responsive
        Expanded(
          child: filteredGrades.isEmpty
              ? const Center(
                  child: Text('Không có dữ liệu điểm'),
                )
              : _buildSimpleGradeTable(filteredGrades),
        ),
      ],
    );
  }

  Widget _buildGPASummary() {
    final summary = _calculateGPASummary();

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return summary.isEmpty
        ? const Center(
            child: Text('Không có dữ liệu điểm'),
          )
        : _buildSimpleGPASummary(summary);
  }

  // Bảng điểm đơn giản không màu mè
  Widget _buildSimpleGradeTable(List<BangDiemEntity> grades) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive: điều chỉnh width của các cột dựa vào màn hình
        final screenWidth = constraints.maxWidth;
        final isSmallScreen = screenWidth < 600;
        
        // Tính toán width động cho từng cột
        final sttWidth = isSmallScreen ? 40.0 : 50.0;
        final maMonWidth = isSmallScreen ? 100.0 : 120.0;
        final tenMonWidth = screenWidth * 0.25;
        final soTinChiWidth = isSmallScreen ? 70.0 : 90.0;
        final diem10Width = isSmallScreen ? 80.0 : 100.0;
        final diem4Width = isSmallScreen ? 70.0 : 90.0;
        final diemChuWidth = isSmallScreen ? 70.0 : 90.0;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Row(
                      children: [
                        _buildSimpleTableCell('STT', sttWidth, isHeader: true),
                        _buildSimpleTableCell('Mã học phần', maMonWidth, isHeader: true),
                        _buildSimpleTableCell('Tên học phần', tenMonWidth, isHeader: true),
                        _buildSimpleTableCell('Số tín chỉ', soTinChiWidth, isHeader: true),
                        _buildSimpleTableCell('Thang điểm 10', diem10Width, isHeader: true),
                        _buildSimpleTableCell('Thang điểm 4', diem4Width, isHeader: true),
                        _buildSimpleTableCell('Thang điểm chữ', diemChuWidth, isHeader: true),
                      ],
                    ),
                  ),
                  // Rows
                  ...grades.asMap().entries.map((entry) {
                    final index = entry.key;
                    final grade = entry.value;
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildSimpleTableCell('${index + 1}', sttWidth),
                          _buildSimpleTableCell(grade.maMon, maMonWidth),
                          _buildSimpleTableCell(_getSubjectName(grade.maMon), tenMonWidth),
                          _buildSimpleTableCell(_getSubjectCredits(grade.maMon).toString(), soTinChiWidth),
                          _buildSimpleTableCell(grade.diem.toStringAsFixed(1), diem10Width),
                          _buildSimpleTableCell(grade.diemHe4.toStringAsFixed(1), diem4Width),
                          _buildSimpleTableCell(grade.diemChu, diemChuWidth),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSimpleTableCell(String text, double width, {bool isHeader = false}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isHeader ? 14 : 14,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: Colors.black87,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  // Bảng điểm tổng hợp đơn giản
  Widget _buildSimpleGPASummary(List<GPASummaryEntity> summary) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isSmallScreen = screenWidth < 600;
        
        final namHocWidth = isSmallScreen ? 120.0 : 150.0;
        final hocKyWidth = isSmallScreen ? 90.0 : 120.0;
        final gpaWidth = isSmallScreen ? 100.0 : 120.0;
        final tinChiWidth = isSmallScreen ? 90.0 : 120.0;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Row(
                      children: [
                        _buildSimpleTableCell('Năm học', namHocWidth, isHeader: true),
                        _buildSimpleTableCell('Học kỳ', hocKyWidth, isHeader: true),
                        _buildSimpleTableCell('TBTL Hệ 10', gpaWidth, isHeader: true),
                        _buildSimpleTableCell('TBTL Hệ 4', gpaWidth, isHeader: true),
                        _buildSimpleTableCell('Số tín chỉ', tinChiWidth, isHeader: true),
                      ],
                    ),
                  ),
                  // Rows
                  ...summary.map((item) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildSimpleTableCell(item.namHoc, namHocWidth),
                          _buildSimpleTableCell(item.hocKy, hocKyWidth),
                          _buildSimpleTableCell(
                            item.gpaResult.gpaHe10.toStringAsFixed(1),
                            gpaWidth,
                          ),
                          _buildSimpleTableCell(
                            item.gpaResult.gpaHe4.toStringAsFixed(1),
                            gpaWidth,
                          ),
                          _buildSimpleTableCell(item.gpaResult.tongTinChi.toString(), tinChiWidth),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tra cứu GPA'),
            if (_currentStudent != null)
              Text(
                'Mã SV: ${_currentStudent!.maSV}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Bảng điểm'),
            Tab(text: 'Điểm tổng hợp'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGradeTable(),
          _buildGPASummary(),
        ],
      ),
    );
  }
}

