import 'package:ksrce_erp/src/features/faculty/domain/faculty_models.dart';

class FacultyDataService {
  static Future<void> _delay() => Future.delayed(const Duration(milliseconds: 500));

  // ==================== Faculty Profile ====================
  static Future<FacultyProfile> getFacultyProfile(String facultyId) async {
    await _delay();
    return FacultyProfile(
      facultyId: facultyId,
      name: 'Dr. Rajesh Kumar',
      email: 'rajesh.kumar@ksrce.edu',
      phone: '+91-9876543210',
      department: 'Computer Science & Engineering',
      qualification: 'Ph.D. in Computer Science',
      yearsOfExperience: 12,
      officeLocation: 'CS Block, Room 305',
      officeHours: 'Mon-Fri: 2:00 PM - 4:00 PM',
      profileImageUrl: null,
    );
  }

  // ==================== Classes/Courses ====================
  static Future<List<ClassAssignment>> getMyClasses(String facultyId) async {
    await _delay();
    return [
      ClassAssignment(
        courseId: 'CSC-301',
        courseCode: 'CS301',
        courseName: 'Data Structures and Algorithms',
        section: 'A',
        totalStudents: 45,
        enrolledStudents: 44,
        semester: '5',
        credits: 4,
        schedule: 'MWF 10:00-11:00 AM',
        room: 'CS-101',
        classType: ClassType.lecture,
      ),
      ClassAssignment(
        courseId: 'CSC-302',
        courseCode: 'CS302',
        courseName: 'Web Development',
        section: 'B',
        totalStudents: 38,
        enrolledStudents: 37,
        semester: '5',
        credits: 3,
        schedule: 'TTh 2:00-3:30 PM',
        room: 'CS-105',
        classType: ClassType.lecture,
      ),
      ClassAssignment(
        courseId: 'CSC-303',
        courseCode: 'CS303',
        courseName: 'Database Management Systems',
        section: 'A',
        totalStudents: 42,
        enrolledStudents: 41,
        semester: '5',
        credits: 3,
        schedule: 'MWF 11:00 AM-12:00 PM',
        room: 'CS-Lab-1',
        classType: ClassType.lab,
      ),
      ClassAssignment(
        courseId: 'CSC-304',
        courseCode: 'CS304',
        courseName: 'Software Engineering',
        section: 'A',
        totalStudents: 40,
        enrolledStudents: 39,
        semester: '6',
        credits: 4,
        schedule: 'TTh 10:00-11:30 AM',
        room: 'CS-102',
        classType: ClassType.lecture,
      ),
    ];
  }

  static Future<ClassAssignment> getClassDetails(String courseId) async {
    await _delay();
    final classes = await getMyClasses('FAC001');
    return classes.firstWhere(
      (c) => c.courseId == courseId,
      orElse: () => classes.first,
    );
  }

  // ==================== Attendance Management ====================
  static Future<List<ClassAttendance>> getClassAttendanceHistory(String courseId) async {
    await _delay();
    final now = DateTime.now();
    return [
      ClassAttendance(
        attendanceId: 'ATT-001',
        courseId: courseId,
        courseCode: 'CS301',
        sessionDate: now.subtract(const Duration(days: 5)),
        students: _generateStudentAttendance(44, presentCount: 42),
      ),
      ClassAttendance(
        attendanceId: 'ATT-002',
        courseId: courseId,
        courseCode: 'CS301',
        sessionDate: now.subtract(const Duration(days: 3)),
        students: _generateStudentAttendance(44, presentCount: 40),
      ),
      ClassAttendance(
        attendanceId: 'ATT-003',
        courseId: courseId,
        courseCode: 'CS301',
        sessionDate: now.subtract(const Duration(days: 1)),
        students: _generateStudentAttendance(44, presentCount: 41),
      ),
      ClassAttendance(
        attendanceId: 'ATT-004',
        courseId: courseId,
        courseCode: 'CS301',
        sessionDate: now,
        students: _generateStudentAttendance(44, presentCount: 43),
      ),
    ];
  }

  static Future<ClassAttendance> getTodayAttendance(String courseId) async {
    await _delay();
    return ClassAttendance(
      attendanceId: 'ATT-NEW',
      courseId: courseId,
      courseCode: 'CS301',
      sessionDate: DateTime.now(),
      students: _generateStudentAttendance(44),
    );
  }

  static List<StudentAttendanceEntry> _generateStudentAttendance(
    int count, {
    int? presentCount,
  }) {
    final list = <StudentAttendanceEntry>[];
    final actualPresent = presentCount ?? (count - 3); // Default: 3 absent
    for (int i = 1; i <= count; i++) {
      list.add(
        StudentAttendanceEntry(
          studentId: 'S202100${i.toString().padLeft(2, '0')}',
          studentName: 'Student ${i.toString().padLeft(2, '0')}',
          rollNumber: '${i.toString().padLeft(3, '0')}',
          isPresent: i <= actualPresent,
        ),
      );
    }
    return list;
  }

  // ==================== Grades Management ====================
  static Future<List<GradeEntry>> getCourseGrades(String courseId) async {
    await _delay();
    return [
      GradeEntry(
        gradeId: 'G001',
        studentId: 'S20210001',
        studentName: 'Student 01',
        rollNumber: '001',
        courseId: courseId,
        courseCode: 'CS301',
        maxMarks: 100,
        obtainedMarks: 92,
        grade: 'A+',
        status: GradeStatus.submitted,
        submittedDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
      GradeEntry(
        gradeId: 'G002',
        studentId: 'S20210002',
        studentName: 'Student 02',
        rollNumber: '002',
        courseId: courseId,
        courseCode: 'CS301',
        maxMarks: 100,
        obtainedMarks: 85,
        grade: 'A',
        status: GradeStatus.submitted,
        submittedDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
      GradeEntry(
        gradeId: 'G003',
        studentId: 'S20210003',
        studentName: 'Student 03',
        rollNumber: '003',
        courseId: courseId,
        courseCode: 'CS301',
        maxMarks: 100,
        obtainedMarks: null,
        grade: null,
        status: GradeStatus.pending,
      ),
      GradeEntry(
        gradeId: 'G004',
        studentId: 'S20210004',
        studentName: 'Student 04',
        rollNumber: '004',
        courseId: courseId,
        courseCode: 'CS301',
        maxMarks: 100,
        obtainedMarks: 78,
        grade: 'B+',
        status: GradeStatus.submitted,
        submittedDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
      GradeEntry(
        gradeId: 'G005',
        studentId: 'S20210005',
        studentName: 'Student 05',
        rollNumber: '005',
        courseId: courseId,
        courseCode: 'CS301',
        maxMarks: 100,
        obtainedMarks: 88,
        grade: 'A',
        status: GradeStatus.submitted,
        submittedDate: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }

  static Future<bool> updateGrade(
    String gradeId,
    int marks,
  ) async {
    await _delay();
    // Mock success
    return true;
  }

  static Future<bool> submitAllGrades(String courseId) async {
    await _delay();
    // Mock success
    return true;
  }

  // ==================== Schedule ====================
  static Future<List<ScheduleEntry>> getWeeklySchedule(String facultyId) async {
    await _delay();
    return [
      ScheduleEntry(
        scheduleId: 'SCH-001',
        courseId: 'CSC-301',
        courseCode: 'CS301',
        courseName: 'Data Structures and Algorithms',
        dayOfWeek: 'Monday',
        startTime: '10:00',
        endTime: '11:00',
        room: 'CS-101',
        classType: ClassType.lecture,
      ),
      ScheduleEntry(
        scheduleId: 'SCH-002',
        courseId: 'CSC-301',
        courseCode: 'CS301',
        courseName: 'Data Structures and Algorithms',
        dayOfWeek: 'Wednesday',
        startTime: '10:00',
        endTime: '11:00',
        room: 'CS-101',
        classType: ClassType.lecture,
      ),
      ScheduleEntry(
        scheduleId: 'SCH-003',
        courseId: 'CSC-302',
        courseCode: 'CS302',
        courseName: 'Web Development',
        dayOfWeek: 'Tuesday',
        startTime: '14:00',
        endTime: '15:30',
        room: 'CS-105',
        classType: ClassType.lecture,
      ),
      ScheduleEntry(
        scheduleId: 'SCH-004',
        courseId: 'CSC-302',
        courseCode: 'CS302',
        courseName: 'Web Development',
        dayOfWeek: 'Thursday',
        startTime: '14:00',
        endTime: '15:30',
        room: 'CS-105',
        classType: ClassType.lecture,
      ),
      ScheduleEntry(
        scheduleId: 'SCH-005',
        courseId: 'CSC-303',
        courseCode: 'CS303',
        courseName: 'Database Management Systems',
        dayOfWeek: 'Monday',
        startTime: '11:00',
        endTime: '12:00',
        room: 'CS-Lab-1',
        classType: ClassType.lab,
      ),
      ScheduleEntry(
        scheduleId: 'SCH-006',
        courseId: 'CSC-303',
        courseCode: 'CS303',
        courseName: 'Database Management Systems',
        dayOfWeek: 'Friday',
        startTime: '11:00',
        endTime: '12:00',
        room: 'CS-Lab-1',
        classType: ClassType.lab,
      ),
      ScheduleEntry(
        scheduleId: 'SCH-007',
        courseId: 'CSC-304',
        courseCode: 'CS304',
        courseName: 'Software Engineering',
        dayOfWeek: 'Tuesday',
        startTime: '10:00',
        endTime: '11:30',
        room: 'CS-102',
        classType: ClassType.lecture,
      ),
      ScheduleEntry(
        scheduleId: 'SCH-008',
        courseId: 'CSC-304',
        courseCode: 'CS304',
        courseName: 'Software Engineering',
        dayOfWeek: 'Thursday',
        startTime: '10:00',
        endTime: '11:30',
        room: 'CS-102',
        classType: ClassType.lecture,
      ),
    ];
  }

  // ==================== Notices ====================
  static Future<List<Notice>> getMyNotices(String facultyId) async {
    await _delay();
    final now = DateTime.now();
    return [
      Notice(
        noticeId: 'NOT-001',
        title: 'Assignment Submission Deadline Extended',
        content:
            'The deadline for Assignment 3 (Data Structures) has been extended to next Friday (5:00 PM).',
        postedDate: now.subtract(const Duration(days: 3)),
        audience: 'CS301 - Section A',
        category: 'Academic',
        isDraft: false,
      ),
      Notice(
        noticeId: 'NOT-002',
        title: 'Midterm Exam Schedule',
        content:
            'Midterm exams for all courses are scheduled from Feb 20-28. Check the timetable for your courses.',
        postedDate: now.subtract(const Duration(days: 5)),
        audience: 'All Students',
        category: 'Academic',
        isDraft: false,
      ),
      Notice(
        noticeId: 'NOT-003',
        title: 'Database Lab Practical - Next Session',
        content:
            'Complete the ER diagram exercise before the next lab session. Resources are available on the course portal.',
        postedDate: now.subtract(const Duration(days: 1)),
        audience: 'CS303 - Lab Group A',
        category: 'Academic',
        isDraft: false,
      ),
      Notice(
        noticeId: 'NOT-004',
        title: 'Draft Notice - Important Updates',
        content: 'This is a draft notice about important updates to the curriculum.',
        postedDate: DateTime.now(),
        audience: 'All Students',
        isDraft: true,
      ),
    ];
  }

  static Future<bool> postNotice(Notice notice) async {
    await _delay();
    // Mock success
    return true;
  }

  static Future<bool> deleteNotice(String noticeId) async {
    await _delay();
    // Mock success
    return true;
  }

  // ==================== Analytics (Stub) ====================
  static Future<Map<String, double>> getFacultyAnalytics(String facultyId) async {
    await _delay();
    return {
      'averageAttendance': 91.5,
      'gradingCompletion': 76.0,
      'studentSatisfaction': 4.4,
    };
  }

  // ==================== Exports (Stub) ====================
  static Future<String> exportAttendanceCsv(String courseId) async {
    await _delay();
    return 'exports/attendance_$courseId.csv';
  }

  static Future<String> exportAttendancePdf(String courseId) async {
    await _delay();
    return 'exports/attendance_$courseId.pdf';
  }

  static Future<String> exportGradesCsv(String courseId) async {
    await _delay();
    return 'exports/grades_$courseId.csv';
  }

  static Future<String> exportGradesPdf(String courseId) async {
    await _delay();
    return 'exports/grades_$courseId.pdf';
  }
}
