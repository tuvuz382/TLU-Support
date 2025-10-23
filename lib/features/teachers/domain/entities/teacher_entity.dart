import 'package:equatable/equatable.dart';

class TeacherEntity extends Equatable {
  final String id;
  final String name;
  final String department;
  final String faculty;
  final String email;
  final String phone;
  final String degree; // Học vị: ThS., TS., PGS., GS.
  final List<String> specializations; // Lĩnh vực nghiên cứu
  final String? avatarUrl;
  final String? officeLocation;
  final Map<String, String>? officeHours; // Thời gian làm việc

  const TeacherEntity({
    required this.id,
    required this.name,
    required this.department,
    required this.faculty,
    required this.email,
    required this.phone,
    required this.degree,
    required this.specializations,
    this.avatarUrl,
    this.officeLocation,
    this.officeHours,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        department,
        faculty,
        email,
        phone,
        degree,
        specializations,
        avatarUrl,
        officeLocation,
        officeHours,
      ];

  // Tên đầy đủ với học vị
  String get fullName => '$degree.$name';

  factory TeacherEntity.fromJson(Map<String, dynamic> json, String id) {
    return TeacherEntity(
      id: id,
      name: json['name'] as String? ?? '',
      department: json['department'] as String? ?? '',
      faculty: json['faculty'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      degree: json['degree'] as String? ?? '',
      specializations: (json['specializations'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      avatarUrl: json['avatarUrl'] as String?,
      officeLocation: json['officeLocation'] as String?,
      officeHours: json['officeHours'] != null
          ? Map<String, String>.from(json['officeHours'] as Map)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'department': department,
      'faculty': faculty,
      'email': email,
      'phone': phone,
      'degree': degree,
      'specializations': specializations,
      'avatarUrl': avatarUrl,
      'officeLocation': officeLocation,
      'officeHours': officeHours,
    };
  }
}

