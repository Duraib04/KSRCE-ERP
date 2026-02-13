class Student {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String department;
  final String semester;
  final double gpa;
  final int attendancePercentage;
  final List<String> enrolledCourses;
  final String profileImageUrl;
  final DateTime enrollmentDate;
  final String status;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.department,
    required this.semester,
    required this.gpa,
    required this.attendancePercentage,
    required this.enrolledCourses,
    required this.profileImageUrl,
    required this.enrollmentDate,
    required this.status,
  });

  /// Create a Student from JSON data (typically from API response)
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      department: json['department'] as String? ?? '',
      semester: json['semester'] as String? ?? '',
      gpa: (json['gpa'] as num?)?.toDouble() ?? 0.0,
      attendancePercentage: json['attendancePercentage'] as int? ?? 0,
      enrolledCourses: List<String>.from(json['enrolledCourses'] as List? ?? []),
      profileImageUrl: json['profileImageUrl'] as String? ?? '',
      enrollmentDate: DateTime.tryParse(json['enrollmentDate'] as String? ?? '') ?? DateTime.now(),
      status: json['status'] as String? ?? 'active',
    );
  }

  /// Convert Student to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'department': department,
      'semester': semester,
      'gpa': gpa,
      'attendancePercentage': attendancePercentage,
      'enrolledCourses': enrolledCourses,
      'profileImageUrl': profileImageUrl,
      'enrollmentDate': enrollmentDate.toIso8601String(),
      'status': status,
    };
  }

  /// Create a copy of Student with modified fields
  Student copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? department,
    String? semester,
    double? gpa,
    int? attendancePercentage,
    List<String>? enrolledCourses,
    String? profileImageUrl,
    DateTime? enrollmentDate,
    String? status,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      semester: semester ?? this.semester,
      gpa: gpa ?? this.gpa,
      attendancePercentage: attendancePercentage ?? this.attendancePercentage,
      enrolledCourses: enrolledCourses ?? this.enrolledCourses,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      enrollmentDate: enrollmentDate ?? this.enrollmentDate,
      status: status ?? this.status,
    );
  }

  @override
  String toString() => 'Student(id: $id, name: $name, gpa: $gpa, status: $status)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Student &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          gpa == other.gpa;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ gpa.hashCode;
}
