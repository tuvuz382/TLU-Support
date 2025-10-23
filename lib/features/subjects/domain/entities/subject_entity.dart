import 'package:equatable/equatable.dart';

class SubjectEntity extends Equatable {
  final String id;
  final String code; // Mã học phần (VD: CSE481)
  final String name; // Tên học phần
  final int credits; // Số tín chỉ
  final int practicalCredits; // Học kỳ thực hành
  final String major; // Ngành học (K64 - Kỹ thuật phần mềm)
  final int semester; // Học kỳ
  final List<String> objectives; // Mục tiêu môn học
  final List<String> content; // Nội dung chính
  final List<String> references; // Tài liệu tham khảo
  final Map<String, String> instructors; // Giảng viên giảng dạy

  const SubjectEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.credits,
    required this.practicalCredits,
    required this.major,
    required this.semester,
    this.objectives = const [],
    this.content = const [],
    this.references = const [],
    this.instructors = const {},
  });

  @override
  List<Object?> get props => [
        id,
        code,
        name,
        credits,
        practicalCredits,
        major,
        semester,
        objectives,
        content,
        references,
        instructors,
      ];

  factory SubjectEntity.fromJson(Map<String, dynamic> json, String id) {
    return SubjectEntity(
      id: id,
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      credits: json['credits'] as int? ?? 0,
      practicalCredits: json['practicalCredits'] as int? ?? 0,
      major: json['major'] as String? ?? '',
      semester: json['semester'] as int? ?? 1,
      objectives: (json['objectives'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      content: (json['content'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      references: (json['references'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      instructors: json['instructors'] != null
          ? Map<String, String>.from(json['instructors'] as Map)
          : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'credits': credits,
      'practicalCredits': practicalCredits,
      'major': major,
      'semester': semester,
      'objectives': objectives,
      'content': content,
      'references': references,
      'instructors': instructors,
    };
  }
}

