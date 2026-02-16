import 'package:flutter/foundation.dart';

/// Student profile information
@immutable
class StudentProfile {
  final String studentId;
  final String name;
  final String email;
  final String phone;
  final String department;
  final String year;
  final String section;
  final String dateOfBirth;
  final String bloodGroup;
  final String address;
  final String parentName;
  final String parentPhone;
  final String admissionDate;
  final double cgpa;

  const StudentProfile({
    required this.studentId,
    required this.name,
    required this.email,
    required this.phone,
    required this.department,
    required this.year,
    required this.section,
    required this.dateOfBirth,
    required this.bloodGroup,
    required this.address,
    required this.parentName,
    required this.parentPhone,
    required this.admissionDate,
    required this.cgpa,
  });
}

/// Course enrollment information
@immutable
class Course {
  final String courseId;
  final String courseCode;
  final String courseName;
  final String facultyName;
  final String facultyId;
  final int credits;
  final String department;
  final String semester;
  final String schedule; // e.g., "Mon, Wed, Fri 10:00-11:00"
  final String room;
  final int totalClasses;
  final int attendedClasses;

  const Course({
    required this.courseId,
    required this.courseCode,
    required this.courseName,
    required this.facultyName,
    required this.facultyId,
    required this.credits,
    required this.department,
    required this.semester,
    required this.schedule,
    required this.room,
    required this.totalClasses,
    required this.attendedClasses,
  });

  double get attendancePercentage =>
      totalClasses > 0 ? (attendedClasses / totalClasses) * 100 : 0.0;
}

/// Assignment information
@immutable
class Assignment {
  final String assignmentId;
  final String courseId;
  final String courseCode;
  final String courseName;
  final String title;
  final String description;
  final DateTime dueDate;
  final DateTime assignedDate;
  final int maxMarks;
  final AssignmentStatus status;
  final int? obtainedMarks;
  final DateTime? submittedDate;
  final String? submissionFile;
  final String? feedback;

  const Assignment({
    required this.assignmentId,
    required this.courseId,
    required this.courseCode,
    required this.courseName,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.assignedDate,
    required this.maxMarks,
    required this.status,
    this.obtainedMarks,
    this.submittedDate,
    this.submissionFile,
    this.feedback,
  });

  bool get isOverdue => status == AssignmentStatus.pending && DateTime.now().isAfter(dueDate);
  int get daysRemaining => dueDate.difference(DateTime.now()).inDays;
}

enum AssignmentStatus {
  pending,
  submitted,
  evaluated,
  late,
}

/// Attendance record
@immutable
class AttendanceRecord {
  final String courseId;
  final String courseCode;
  final String courseName;
  final int totalClasses;
  final int attendedClasses;
  final int absentClasses;
  final List<AttendanceSession> sessions;

  const AttendanceRecord({
    required this.courseId,
    required this.courseCode,
    required this.courseName,
    required this.totalClasses,
    required this.attendedClasses,
    required this.absentClasses,
    required this.sessions,
  });

  double get percentage =>
      totalClasses > 0 ? (attendedClasses / totalClasses) * 100 : 0.0;
}

@immutable
class AttendanceSession {
  final DateTime date;
  final String period;
  final bool isPresent;
  final String? reason; // For absences

  const AttendanceSession({
    required this.date,
    required this.period,
    required this.isPresent,
    this.reason,
  });
}

/// Exam results and grades
@immutable
class ExamResult {
  final String examId;
  final String courseId;
  final String courseCode;
  final String courseName;
  final String examType; // Mid-term, End-term, Quiz
  final DateTime examDate;
  final int maxMarks;
  final int obtainedMarks;
  final String grade;
  final double gradePoint;
  final String status; // Pass, Fail, Absent

  const ExamResult({
    required this.examId,
    required this.courseId,
    required this.courseCode,
    required this.courseName,
    required this.examType,
    required this.examDate,
    required this.maxMarks,
    required this.obtainedMarks,
    required this.grade,
    required this.gradePoint,
    required this.status,
  });

  double get percentage => (obtainedMarks / maxMarks) * 100;
}

@immutable
class SemesterResult {
  final String semester;
  final List<ExamResult> results;
  final double sgpa;
  final double cgpa;
  final int totalCredits;
  final int earnedCredits;

  const SemesterResult({
    required this.semester,
    required this.results,
    required this.sgpa,
    required this.cgpa,
    required this.totalCredits,
    required this.earnedCredits,
  });
}

/// Complaint submission
@immutable
class Complaint {
  final String complaintId;
  final String title;
  final String description;
  final ComplaintCategory category;
  final ComplaintStatus status;
  final DateTime submittedDate;
  final DateTime? resolvedDate;
  final String? response;
  final String? assignedTo;

  const Complaint({
    required this.complaintId,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.submittedDate,
    this.resolvedDate,
    this.response,
    this.assignedTo,
  });
}

enum ComplaintCategory {
  infrastructure,
  academic,
  hostel,
  transport,
  library,
  other,
}

enum ComplaintStatus {
  pending,
  inProgress,
  resolved,
  rejected,
}

/// Notification
@immutable
class Notification {
  final String notificationId;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? actionUrl;
  final String? sender;

  const Notification({
    required this.notificationId,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.isRead,
    this.actionUrl,
    this.sender,
  });
}

enum NotificationType {
  general,
  exam,
  assignment,
  attendance,
  fee,
  event,
  urgent,
}

/// Timetable entry
@immutable
class TimetableEntry {
  final String courseId;
  final String courseCode;
  final String courseName;
  final String facultyName;
  final String day; // Monday, Tuesday, etc.
  final String startTime; // HH:mm format
  final String endTime;
  final String room;
  final String type; // Lecture, Lab, Tutorial

  const TimetableEntry({
    required this.courseId,
    required this.courseCode,
    required this.courseName,
    required this.facultyName,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.type,
  });
}
