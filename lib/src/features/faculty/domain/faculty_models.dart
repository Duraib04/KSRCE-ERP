import 'package:flutter/foundation.dart';

// ==================== Enums ====================

enum ClassType { lecture, lab, tutorial }

enum GradeStatus { submitted, pending, locked }

// ==================== Faculty Profile ====================

@immutable
class FacultyProfile {
  final String facultyId;
  final String name;
  final String email;
  final String phone;
  final String department;
  final String qualification;
  final int yearsOfExperience;
  final String officeLocation;
  final String officeHours;
  final String? profileImageUrl;

  const FacultyProfile({
    required this.facultyId,
    required this.name,
    required this.email,
    required this.phone,
    required this.department,
    required this.qualification,
    required this.yearsOfExperience,
    required this.officeLocation,
    required this.officeHours,
    this.profileImageUrl,
  });

  factory FacultyProfile.fromJson(Map<String, dynamic> json) {
    return FacultyProfile(
      facultyId: json['facultyId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      department: json['department'] as String? ?? '',
      qualification: json['qualification'] as String? ?? '',
      yearsOfExperience: json['yearsOfExperience'] as int? ?? 0,
      officeLocation: json['officeLocation'] as String? ?? '',
      officeHours: json['officeHours'] as String? ?? '',
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'facultyId': facultyId,
      'name': name,
      'email': email,
      'phone': phone,
      'department': department,
      'qualification': qualification,
      'yearsOfExperience': yearsOfExperience,
      'officeLocation': officeLocation,
      'officeHours': officeHours,
      'profileImageUrl': profileImageUrl,
    };
  }

  FacultyProfile copyWith({
    String? facultyId,
    String? name,
    String? email,
    String? phone,
    String? department,
    String? qualification,
    int? yearsOfExperience,
    String? officeLocation,
    String? officeHours,
    String? profileImageUrl,
  }) {
    return FacultyProfile(
      facultyId: facultyId ?? this.facultyId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      qualification: qualification ?? this.qualification,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      officeLocation: officeLocation ?? this.officeLocation,
      officeHours: officeHours ?? this.officeHours,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}

// ==================== Class Assignment ====================

@immutable
class ClassAssignment {
  final String courseId;
  final String courseCode;
  final String courseName;
  final String section;
  final int totalStudents;
  final int? enrolledStudents;
  final String semester;
  final int credits;
  final String? schedule;
  final String? room;
  final ClassType classType;

  const ClassAssignment({
    required this.courseId,
    required this.courseCode,
    required this.courseName,
    required this.section,
    required this.totalStudents,
    this.enrolledStudents,
    required this.semester,
    required this.credits,
    this.schedule,
    this.room,
    required this.classType,
  });

  factory ClassAssignment.fromJson(Map<String, dynamic> json) {
    return ClassAssignment(
      courseId: json['courseId'] as String? ?? '',
      courseCode: json['courseCode'] as String? ?? '',
      courseName: json['courseName'] as String? ?? '',
      section: json['section'] as String? ?? '',
      totalStudents: json['totalStudents'] as int? ?? 0,
      enrolledStudents: json['enrolledStudents'] as int?,
      semester: json['semester'] as String? ?? '',
      credits: json['credits'] as int? ?? 0,
      schedule: json['schedule'] as String?,
      room: json['room'] as String?,
      classType: ClassType.values[json['classType'] as int? ?? 0],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'courseCode': courseCode,
      'courseName': courseName,
      'section': section,
      'totalStudents': totalStudents,
      'enrolledStudents': enrolledStudents,
      'semester': semester,
      'credits': credits,
      'schedule': schedule,
      'room': room,
      'classType': classType.index,
    };
  }

  ClassAssignment copyWith({
    String? courseId,
    String? courseCode,
    String? courseName,
    String? section,
    int? totalStudents,
    int? enrolledStudents,
    String? semester,
    int? credits,
    String? schedule,
    String? room,
    ClassType? classType,
  }) {
    return ClassAssignment(
      courseId: courseId ?? this.courseId,
      courseCode: courseCode ?? this.courseCode,
      courseName: courseName ?? this.courseName,
      section: section ?? this.section,
      totalStudents: totalStudents ?? this.totalStudents,
      enrolledStudents: enrolledStudents ?? this.enrolledStudents,
      semester: semester ?? this.semester,
      credits: credits ?? this.credits,
      schedule: schedule ?? this.schedule,
      room: room ?? this.room,
      classType: classType ?? this.classType,
    );
  }
}

// ==================== Class Attendance ====================

@immutable
class ClassAttendance {
  final String attendanceId;
  final String courseId;
  final String courseCode;
  final DateTime sessionDate;
  final List<StudentAttendanceEntry> students;

  const ClassAttendance({
    required this.attendanceId,
    required this.courseId,
    required this.courseCode,
    required this.sessionDate,
    required this.students,
  });

  int get presentCount => students.where((s) => s.isPresent).length;
  int get absentCount => students.where((s) => !s.isPresent).length;
  double get attendancePercentage =>
      students.isEmpty ? 0 : (presentCount / students.length) * 100;

  factory ClassAttendance.fromJson(Map<String, dynamic> json) {
    return ClassAttendance(
      attendanceId: json['attendanceId'] as String? ?? '',
      courseId: json['courseId'] as String? ?? '',
      courseCode: json['courseCode'] as String? ?? '',
      sessionDate:
          DateTime.parse(json['sessionDate'] as String? ?? DateTime.now().toString()),
      students: (json['students'] as List<dynamic>?)
              ?.map((e) => StudentAttendanceEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attendanceId': attendanceId,
      'courseId': courseId,
      'courseCode': courseCode,
      'sessionDate': sessionDate.toIso8601String(),
      'students': students.map((s) => s.toJson()).toList(),
    };
  }

  ClassAttendance copyWith({
    String? attendanceId,
    String? courseId,
    String? courseCode,
    DateTime? sessionDate,
    List<StudentAttendanceEntry>? students,
  }) {
    return ClassAttendance(
      attendanceId: attendanceId ?? this.attendanceId,
      courseId: courseId ?? this.courseId,
      courseCode: courseCode ?? this.courseCode,
      sessionDate: sessionDate ?? this.sessionDate,
      students: students ?? this.students,
    );
  }
}

@immutable
class StudentAttendanceEntry {
  final String studentId;
  final String studentName;
  final String rollNumber;
  final bool isPresent;

  const StudentAttendanceEntry({
    required this.studentId,
    required this.studentName,
    required this.rollNumber,
    required this.isPresent,
  });

  factory StudentAttendanceEntry.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceEntry(
      studentId: json['studentId'] as String? ?? '',
      studentName: json['studentName'] as String? ?? '',
      rollNumber: json['rollNumber'] as String? ?? '',
      isPresent: json['isPresent'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'rollNumber': rollNumber,
      'isPresent': isPresent,
    };
  }

  StudentAttendanceEntry copyWith({
    String? studentId,
    String? studentName,
    String? rollNumber,
    bool? isPresent,
  }) {
    return StudentAttendanceEntry(
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      rollNumber: rollNumber ?? this.rollNumber,
      isPresent: isPresent ?? this.isPresent,
    );
  }
}

// ==================== Grade Entry ====================

@immutable
class GradeEntry {
  final String gradeId;
  final String studentId;
  final String studentName;
  final String rollNumber;
  final String courseId;
  final String courseCode;
  final int maxMarks;
  final int? obtainedMarks;
  final String? grade;
  final GradeStatus status;
  final DateTime? submittedDate;

  const GradeEntry({
    required this.gradeId,
    required this.studentId,
    required this.studentName,
    required this.rollNumber,
    required this.courseId,
    required this.courseCode,
    required this.maxMarks,
    this.obtainedMarks,
    this.grade,
    required this.status,
    this.submittedDate,
  });

  String? calculateGrade() {
    if (obtainedMarks == null) return null;
    final percentage = (obtainedMarks! / maxMarks) * 100;
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B+';
    if (percentage >= 60) return 'B';
    if (percentage >= 50) return 'C';
    return 'F';
  }

  double? getPercentage() {
    if (obtainedMarks == null) return null;
    return (obtainedMarks! / maxMarks) * 100;
  }

  factory GradeEntry.fromJson(Map<String, dynamic> json) {
    return GradeEntry(
      gradeId: json['gradeId'] as String? ?? '',
      studentId: json['studentId'] as String? ?? '',
      studentName: json['studentName'] as String? ?? '',
      rollNumber: json['rollNumber'] as String? ?? '',
      courseId: json['courseId'] as String? ?? '',
      courseCode: json['courseCode'] as String? ?? '',
      maxMarks: json['maxMarks'] as int? ?? 100,
      obtainedMarks: json['obtainedMarks'] as int?,
      grade: json['grade'] as String?,
      status: GradeStatus.values[json['status'] as int? ?? 1],
      submittedDate: json['submittedDate'] != null
          ? DateTime.parse(json['submittedDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gradeId': gradeId,
      'studentId': studentId,
      'studentName': studentName,
      'rollNumber': rollNumber,
      'courseId': courseId,
      'courseCode': courseCode,
      'maxMarks': maxMarks,
      'obtainedMarks': obtainedMarks,
      'grade': grade,
      'status': status.index,
      'submittedDate': submittedDate?.toIso8601String(),
    };
  }

  GradeEntry copyWith({
    String? gradeId,
    String? studentId,
    String? studentName,
    String? rollNumber,
    String? courseId,
    String? courseCode,
    int? maxMarks,
    int? obtainedMarks,
    String? grade,
    GradeStatus? status,
    DateTime? submittedDate,
  }) {
    return GradeEntry(
      gradeId: gradeId ?? this.gradeId,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      rollNumber: rollNumber ?? this.rollNumber,
      courseId: courseId ?? this.courseId,
      courseCode: courseCode ?? this.courseCode,
      maxMarks: maxMarks ?? this.maxMarks,
      obtainedMarks: obtainedMarks ?? this.obtainedMarks,
      grade: grade ?? this.grade,
      status: status ?? this.status,
      submittedDate: submittedDate ?? this.submittedDate,
    );
  }
}

// ==================== Schedule Entry ====================

@immutable
class ScheduleEntry {
  final String scheduleId;
  final String courseId;
  final String courseCode;
  final String courseName;
  final String dayOfWeek; // Monday, Tuesday, etc.
  final String startTime; // HH:mm format
  final String endTime; // HH:mm format
  final String room;
  final ClassType classType;

  const ScheduleEntry({
    required this.scheduleId,
    required this.courseId,
    required this.courseCode,
    required this.courseName,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.classType,
  });

  factory ScheduleEntry.fromJson(Map<String, dynamic> json) {
    return ScheduleEntry(
      scheduleId: json['scheduleId'] as String? ?? '',
      courseId: json['courseId'] as String? ?? '',
      courseCode: json['courseCode'] as String? ?? '',
      courseName: json['courseName'] as String? ?? '',
      dayOfWeek: json['dayOfWeek'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      room: json['room'] as String? ?? '',
      classType: ClassType.values[json['classType'] as int? ?? 0],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scheduleId': scheduleId,
      'courseId': courseId,
      'courseCode': courseCode,
      'courseName': courseName,
      'dayOfWeek': dayOfWeek,
      'startTime': startTime,
      'endTime': endTime,
      'room': room,
      'classType': classType.index,
    };
  }

  ScheduleEntry copyWith({
    String? scheduleId,
    String? courseId,
    String? courseCode,
    String? courseName,
    String? dayOfWeek,
    String? startTime,
    String? endTime,
    String? room,
    ClassType? classType,
  }) {
    return ScheduleEntry(
      scheduleId: scheduleId ?? this.scheduleId,
      courseId: courseId ?? this.courseId,
      courseCode: courseCode ?? this.courseCode,
      courseName: courseName ?? this.courseName,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      room: room ?? this.room,
      classType: classType ?? this.classType,
    );
  }
}

// ==================== Notice ====================

@immutable
class Notice {
  final String noticeId;
  final String title;
  final String content;
  final DateTime postedDate;
  final String? attachmentUrl;
  final String audience; // "All Students" or specific class/section
  final String? category; // Academic, Administrative, etc.
  final bool isDraft;

  const Notice({
    required this.noticeId,
    required this.title,
    required this.content,
    required this.postedDate,
    this.attachmentUrl,
    required this.audience,
    this.category,
    this.isDraft = false,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      noticeId: json['noticeId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      postedDate: DateTime.parse(json['postedDate'] as String? ?? DateTime.now().toString()),
      attachmentUrl: json['attachmentUrl'] as String?,
      audience: json['audience'] as String? ?? '',
      category: json['category'] as String?,
      isDraft: json['isDraft'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'noticeId': noticeId,
      'title': title,
      'content': content,
      'postedDate': postedDate.toIso8601String(),
      'attachmentUrl': attachmentUrl,
      'audience': audience,
      'category': category,
      'isDraft': isDraft,
    };
  }

  Notice copyWith({
    String? noticeId,
    String? title,
    String? content,
    DateTime? postedDate,
    String? attachmentUrl,
    String? audience,
    String? category,
    bool? isDraft,
  }) {
    return Notice(
      noticeId: noticeId ?? this.noticeId,
      title: title ?? this.title,
      content: content ?? this.content,
      postedDate: postedDate ?? this.postedDate,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      audience: audience ?? this.audience,
      category: category ?? this.category,
      isDraft: isDraft ?? this.isDraft,
    );
  }
}
