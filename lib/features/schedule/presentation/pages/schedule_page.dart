import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/core/presentation/theme/app_colors.dart';
import '../../../data_generator/domain/entities/lich_hoc_entity.dart';
import '../../../data_generator/domain/entities/mon_hoc_entity.dart';
import '../../../data_generator/domain/entities/sinh_vien_entity.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../../data/repositories/schedule_repository_impl.dart';
import '../../data/datasources/firebase_schedule_datasource.dart';
import '../../../profile/data/repositories/student_profile_repository_impl.dart';
import '../../../profile/data/datasources/student_profile_remote_datasource.dart';
import '../../../profile/domain/usecases/get_current_student_profile_usecase.dart';
import '../../../data_generator/domain/entities/giang_vien_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScheduleRepository _repository;
  late GetCurrentStudentProfileUseCase _getProfileUseCase;
  
  List<LichHocEntity> _allSchedules = [];
  List<LichHocEntity> _todaySchedules = [];
  List<MonHocEntity> _subjects = [];
  SinhVienEntity? _currentStudent;
  bool _isLoading = true;
  String? _errorMessage;
  List<GiangVienEntity> _lecturers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Dependency Injection setup
    _repository = ScheduleRepositoryImpl(FirebaseScheduleDataSource());
    final profileDataSource = StudentProfileRemoteDataSource();
    final profileRepository = StudentProfileRepositoryImpl(remoteDataSource: profileDataSource);
    _getProfileUseCase = GetCurrentStudentProfileUseCase(profileRepository);
    
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
          _errorMessage = 'Không tìm thấy thông tin sinh viên. Vui lòng cập nhật profile.';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _currentStudent = studentProfile;
      });

      // Lấy dữ liệu lịch học và môn học
      final futures = await Future.wait([
        _repository.getAllSchedules(),
        _repository.getAllSubjects(),
        FirebaseFirestore.instance.collection('giangVien').get(),
      ]);

      final allSchedules = futures[0] as List<LichHocEntity>;
      final subjects = futures[1] as List<MonHocEntity>;
      final lecturersSnap = futures[2] as QuerySnapshot;
      final lecturers = lecturersSnap.docs.map((doc) => GiangVienEntity.fromFirestore(doc.data() as Map<String, dynamic>)).toList();

      // Lọc lịch học theo lớp của sinh viên
      final filteredSchedules = allSchedules
          .where((schedule) => schedule.lop == studentProfile.lop)
          .toList();

      // Lấy lịch học hôm nay theo lớp
      final todaySchedules = await _repository.getTodaySchedulesByClass(studentProfile.lop);

      setState(() {
        _allSchedules = filteredSchedules;
        _todaySchedules = todaySchedules;
        _subjects = subjects;
        _lecturers = lecturers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi tải dữ liệu: $e';
        _isLoading = false;
      });
    }
  }

  String _getSubjectName(String maMon) {
    final subject = _subjects.firstWhere(
      (s) => s.maMon == maMon,
      orElse: () => MonHocEntity(
        maMon: maMon,
        maGV: '',
        tenMon: 'Môn học không xác định',
        soTinChi: 0,
        moTa: '',
        chuyenNganh: '',
      ),
    );
    return subject.tenMon;
  }

  String _getLecturerName(String maMon) {
    final subject = _subjects.firstWhere(
      (s) => s.maMon == maMon,
      orElse: () => MonHocEntity(
        maMon: maMon,
        maGV: '',
        tenMon: 'Môn học không xác định',
        soTinChi: 0,
        moTa: '',
        chuyenNganh: '',
      ),
    );
    if (subject.maGV.isEmpty) return '---';
    final lecturer = _lecturers.firstWhere(
      (g) => g.maGV == subject.maGV,
      orElse: () => GiangVienEntity(
        maGV: '',
        hoTen: 'Không xác định',
        email: '',
        chuyenNganh: '',
        hocVi: '',
        soDT: '',
      ),
    );
    return lecturer.hoTen;
  }

  String _getCurrentDateString() {
    final now = DateTime.now();
    final dayNames = [
      'Chủ nhật', 'Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7'
    ];
    final dayName = dayNames[now.weekday % 7];
    final dateFormat = DateFormat('dd/MM/yyyy');
    return '$dayName, Ngày ${dateFormat.format(now)}';
  }

  String _getDateString(DateTime date) {
    final dayNames = [
      'Chủ nhật', 'Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7'
    ];
    final dayName = dayNames[date.weekday % 7];
    final dateFormat = DateFormat('dd/MM/yyyy');
    return '$dayName, Ngày ${dateFormat.format(date)}';
  }

  String _getTimeFromPeriod(String period) {
    // Chuyển đổi tiết học thành giờ
    // Ví dụ: "Tiết 1-3" -> "07:00"
    final periodMap = {
      'Tiết 1-3': '07:00',
      'Tiết 4-6': '09:30',
      'Tiết 7-9': '12:55',
      'Tiết 10-12': '15:45',
    };
    return periodMap[period] ?? period;
  }

  Widget _buildScheduleCard(LichHocEntity schedule) {
    final subjectName = _getSubjectName(schedule.maMon);
    final time = _getTimeFromPeriod(schedule.tietHoc);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thời gian
            Text(
              time,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            
            // Thông tin môn học
            _buildInfoRow('Môn học:', subjectName),
            _buildInfoRow('Tiết:', schedule.tietHoc),
            _buildInfoRow('Phòng:', schedule.phongHoc),
            _buildInfoRow('Giảng viên:', _getLecturerName(schedule.maMon)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleList(List<LichHocEntity> schedules, {bool isTodayTab = false}) {
    if (schedules.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.event_available,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            const Text(
              'Không có lịch học',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isTodayTab 
                ? 'Hôm nay bạn không có lớp học nào'
                : 'Không có lịch học nào',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    // Nhóm lịch học theo ngày
    final groupedSchedules = <DateTime, List<LichHocEntity>>{};
    for (final schedule in schedules) {
      final date = DateTime(schedule.ngayHoc.year, schedule.ngayHoc.month, schedule.ngayHoc.day);
      groupedSchedules.putIfAbsent(date, () => []).add(schedule);
    }

    // Sắp xếp theo ngày
    final sortedDates = groupedSchedules.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final daySchedules = groupedSchedules[date]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header ngày (chỉ hiển thị nếu không phải tab hôm nay)
            if (!isTodayTab) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getDateString(date),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
            
            // Danh sách lịch học trong ngày
            ...daySchedules.map((schedule) => _buildScheduleCard(schedule)),
            
            // Khoảng cách giữa các ngày
            if (index < sortedDates.length - 1) const SizedBox(height: 16),
          ],
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
            const Text('Lịch học'),
            if (_currentStudent != null)
              Text(
                'Lớp: ${_currentStudent!.lop}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Hôm nay'),
            Tab(text: 'Lịch học'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Có lỗi xảy ra',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppColors.error,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      if (_errorMessage!.contains('Không tìm thấy thông tin sinh viên'))
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to profile page
                            Navigator.pushNamed(context, '/personal-info');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Cập nhật Profile'),
                        ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _loadData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    // Tab Hôm nay
                    Column(
                      children: [
                        // Ngày hiện tại
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          color: AppColors.surface,
                          child: Text(
                            _getCurrentDateString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        // Danh sách lịch học hôm nay
                        Expanded(
                          child: _buildScheduleList(_todaySchedules, isTodayTab: true),
                        ),
                      ],
                    ),
                    // Tab Lịch học
                    _buildScheduleList(_allSchedules),
                  ],
                ),
    );
  }
}
