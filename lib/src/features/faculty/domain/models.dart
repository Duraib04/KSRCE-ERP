class Faculty {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String department;
  final String designation;
  final List<String> teachingCourses;
  final int yearsOfExperience;
  final String profileImageUrl;
  final DateTime joinDate;
  final String status;
  final double rating;

  Faculty({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.department,
    required this.designation,
    required this.teachingCourses,
    required this.yearsOfExperience,
    required this.profileImageUrl,
    required this.joinDate,
    required this.status,
    required this.rating,
  });

  /// Create a Faculty from JSON data
  factory Faculty.fromJson(Map<String, dynamic> json) {
    return Faculty(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      department: json['department'] as String? ?? '',
      designation: json['designation'] as String? ?? '',
      teachingCourses: List<String>.from(json['teachingCourses'] as List? ?? []),
      yearsOfExperience: json['yearsOfExperience'] as int? ?? 0,
      profileImageUrl: json['profileImageUrl'] as String? ?? '',
      joinDate: DateTime.tryParse(json['joinDate'] as String? ?? '') ?? DateTime.now(),
      status: json['status'] as String? ?? 'active',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Convert Faculty to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'department': department,
      'designation': designation,
      'teachingCourses': teachingCourses,
      'yearsOfExperience': yearsOfExperience,
      'profileImageUrl': profileImageUrl,
      'joinDate': joinDate.toIso8601String(),
      'status': status,
      'rating': rating,
    };
  }

  /// Create a copy with modified fields
  Faculty copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? department,
    String? designation,
    List<String>? teachingCourses,
    int? yearsOfExperience,
    String? profileImageUrl,
    DateTime? joinDate,
    String? status,
    double? rating,
  }) {
    return Faculty(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      designation: designation ?? this.designation,
      teachingCourses: teachingCourses ?? this.teachingCourses,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      joinDate: joinDate ?? this.joinDate,
      status: status ?? this.status,
      rating: rating ?? this.rating,
    );
  }

  @override
  String toString() => 'Faculty(id: $id, name: $name, designation: $designation, rating: $rating)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Faculty &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          department == other.department;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ department.hashCode;
}
