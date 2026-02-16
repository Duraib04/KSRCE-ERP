import '../domain/student_models.dart';

/// Service for fetching student-related data
/// Currently uses mock data - will be replaced with API calls
class StudentDataService {
  /// Simulates network delay
  static Future<void> _delay() => Future.delayed(const Duration(milliseconds: 500));

  /// Get student profile information
  static Future<StudentProfile> getStudentProfile(String studentId) async {
    await _delay();
    return StudentProfile(
      studentId: studentId,
      name: 'Rajesh Kumar',
      email: '$studentId@student.ksrce.edu.in',
      phone: '+91 98765 43210',
      department: 'Computer Science and Engineering',
      year: '3rd Year',
      section: 'A',
      dateOfBirth: '2004-05-15',
      bloodGroup: 'O+',
      address: '123, MG Road, Tiruchengode, Namakkal - 637211',
      parentName: 'Kumar Moorthy',
      parentPhone: '+91 98765 00000',
      admissionDate: '2022-08-15',
      cgpa: 8.5,
    );
  }

  /// Get enrolled courses
  static Future<List<Course>> getCourses(String studentId) async {
    await _delay();
    return const [
      Course(
        courseId: 'CS301',
        courseCode: 'CS301',
        courseName: 'Data Structures and Algorithms',
        facultyName: 'Dr. Priya Sharma',
        facultyId: 'FAC001',
        credits: 4,
        department: 'CSE',
        semester: '5th Semester',
        schedule: 'Mon, Wed, Fri 10:00-11:00',
        room: 'Lab 3',
        totalClasses: 45,
        attendedClasses: 42,
      ),
      Course(
        courseId: 'CS302',
        courseCode: 'CS302',
        courseName: 'Database Management Systems',
        facultyName: 'Prof. Suresh Babu',
        facultyId: 'FAC002',
        credits: 4,
        department: 'CSE',
        semester: '5th Semester',
        schedule: 'Tue, Thu 11:00-12:30',
        room: 'Room 201',
        totalClasses: 40,
        attendedClasses: 38,
      ),
      Course(
        courseId: 'CS303',
        courseCode: 'CS303',
        courseName: 'Operating Systems',
        facultyName: 'Dr. Anitha Rani',
        facultyId: 'FAC003',
        credits: 3,
        department: 'CSE',
        semester: '5th Semester',
        schedule: 'Mon, Thu 2:00-3:00',
        room: 'Room 305',
        totalClasses: 38,
        attendedClasses: 35,
      ),
      Course(
        courseId: 'CS304',
        courseCode: 'CS304',
        courseName: 'Computer Networks',
        facultyName: 'Prof. Venkatesh Kumar',
        facultyId: 'FAC004',
        credits: 3,
        department: 'CSE',
        semester: '5th Semester',
        schedule: 'Tue, Fri 3:00-4:00',
        room: 'Lab 5',
        totalClasses: 42,
        attendedClasses: 40,
      ),
      Course(
        courseId: 'HS301',
        courseCode: 'HS301',
        courseName: 'Professional Ethics',
        facultyName: 'Dr. Lakshmi Narayan',
        facultyId: 'FAC005',
        credits: 2,
        department: 'Humanities',
        semester: '5th Semester',
        schedule: 'Wed 4:00-5:30',
        room: 'Room 101',
        totalClasses: 30,
        attendedClasses: 28,
      ),
    ];
  }

  /// Get assignments
  static Future<List<Assignment>> getAssignments(String studentId) async {
    await _delay();
    final now = DateTime.now();
    return [
      Assignment(
        assignmentId: 'A001',
        courseId: 'CS301',
        courseCode: 'CS301',
        courseName: 'Data Structures and Algorithms',
        title: 'Implement Binary Search Tree',
        description: 'Create a complete BST implementation with insert, delete, search, and traversal operations.',
        dueDate: now.add(const Duration(days: 3)),
        assignedDate: now.subtract(const Duration(days: 7)),
        maxMarks: 20,
        status: AssignmentStatus.pending,
      ),
      Assignment(
        assignmentId: 'A002',
        courseId: 'CS302',
        courseCode: 'CS302',
        courseName: 'Database Management Systems',
        title: 'SQL Query Assignment',
        description: 'Write complex SQL queries for the given hospital database schema.',
        dueDate: now.add(const Duration(days: 5)),
        assignedDate: now.subtract(const Duration(days: 5)),
        maxMarks: 15,
        status: AssignmentStatus.pending,
      ),
      Assignment(
        assignmentId: 'A003',
        courseId: 'CS303',
        courseCode: 'CS303',
        courseName: 'Operating Systems',
        title: 'CPU Scheduling Algorithms',
        description: 'Implement FCFS, SJF, and Round Robin scheduling algorithms.',
        dueDate: now.subtract(const Duration(days: 2)),
        assignedDate: now.subtract(const Duration(days: 14)),
        maxMarks: 25,
        status: AssignmentStatus.submitted,
        submittedDate: now.subtract(const Duration(days: 3)),
        obtainedMarks: 23,
        feedback: 'Excellent work! Well-documented code.',
      ),
      Assignment(
        assignmentId: 'A004',
        courseId: 'CS304',
        courseCode: 'CS304',
        courseName: 'Computer Networks',
        title: 'Network Protocol Analysis',
        description: 'Analyze TCP/IP packet transmissions using Wireshark.',
        dueDate: now.add(const Duration(days: 10)),
        assignedDate: now.subtract(const Duration(days: 2)),
        maxMarks: 20,
        status: AssignmentStatus.pending,
      ),
    ];
  }

  /// Get attendance records
  static Future<List<AttendanceRecord>> getAttendanceRecords(String studentId) async {
    await _delay();
    return [
      AttendanceRecord(
        courseId: 'CS301',
        courseCode: 'CS301',
        courseName: 'Data Structures and Algorithms',
        totalClasses: 45,
        attendedClasses: 42,
        absentClasses: 3,
        sessions: _generateSessions(45, 42),
      ),
      AttendanceRecord(
        courseId: 'CS302',
        courseCode: 'CS302',
        courseName: 'Database Management Systems',
        totalClasses: 40,
        attendedClasses: 38,
        absentClasses: 2,
        sessions: _generateSessions(40, 38),
      ),
      AttendanceRecord(
        courseId: 'CS303',
        courseCode: 'CS303',
        courseName: 'Operating Systems',
        totalClasses: 38,
        attendedClasses: 35,
        absentClasses: 3,
        sessions: _generateSessions(38, 35),
      ),
      AttendanceRecord(
        courseId: 'CS304',
        courseCode: 'CS304',
        courseName: 'Computer Networks',
        totalClasses: 42,
        attendedClasses: 40,
        absentClasses: 2,
        sessions: _generateSessions(42, 40),
      ),
      AttendanceRecord(
        courseId: 'HS301',
        courseCode: 'HS301',
        courseName: 'Professional Ethics',
        totalClasses: 30,
        attendedClasses: 28,
        absentClasses: 2,
        sessions: _generateSessions(30, 28),
      ),
    ];
  }

  static List<AttendanceSession> _generateSessions(int total, int attended) {
    final sessions = <AttendanceSession>[];
    final now = DateTime.now();
    int absentCount = total - attended;
    
    for (int i = 0; i < total; i++) {
      final date = now.subtract(Duration(days: total - i));
      final isPresent = absentCount > 0 && (i % 10 == 0) ? false : true;
      if (!isPresent) absentCount--;
      
      sessions.add(AttendanceSession(
        date: date,
        period: 'Period ${(i % 6) + 1}',
        isPresent: isPresent,
        reason: !isPresent ? 'Medical leave' : null,
      ));
    }
    return sessions;
  }

  /// Get exam results
  static Future<List<SemesterResult>> getResults(String studentId) async {
    await _delay();
    return [
      SemesterResult(
        semester: 'Semester 5 (Current)',
        sgpa: 8.6,
        cgpa: 8.5,
        totalCredits: 20,
        earnedCredits: 20,
        results: [
          ExamResult(
            examId: 'E501',
            courseId: 'CS301',
            courseCode: 'CS301',
            courseName: 'Data Structures and Algorithms',
            examType: 'Mid-term',
            examDate: DateTime.now().subtract(const Duration(days: 30)),
            maxMarks: 50,
            obtainedMarks: 44,
            grade: 'A',
            gradePoint: 9.0,
            status: 'Pass',
          ),
          ExamResult(
            examId: 'E502',
            courseId: 'CS302',
            courseCode: 'CS302',
            courseName: 'Database Management Systems',
            examType: 'Mid-term',
            examDate: DateTime.now().subtract(const Duration(days: 28)),
            maxMarks: 50,
            obtainedMarks: 41,
            grade: 'A',
            gradePoint: 8.5,
            status: 'Pass',
          ),
        ],
      ),
      SemesterResult(
        semester: 'Semester 4',
        sgpa: 8.4,
        cgpa: 8.3,
        totalCredits: 22,
        earnedCredits: 22,
        results: [
          ExamResult(
            examId: 'E401',
            courseId: 'CS201',
            courseCode: 'CS201',
            courseName: 'Java Programming',
            examType: 'End-term',
            examDate: DateTime(2025, 11, 15),
            maxMarks: 100,
            obtainedMarks: 85,
            grade: 'A',
            gradePoint: 9.0,
            status: 'Pass',
          ),
        ],
      ),
    ];
  }

  /// Get complaints
  static Future<List<Complaint>> getComplaints(String studentId) async {
    await _delay();
    return [
      Complaint(
        complaintId: 'C001',
        title: 'Library AC not working',
        description: 'The air conditioning in the library reading hall has not been working for 3 days.',
        category: ComplaintCategory.infrastructure,
        status: ComplaintStatus.inProgress,
        submittedDate: DateTime.now().subtract(const Duration(days: 2)),
        assignedTo: 'Admin Department',
      ),
      Complaint(
        complaintId: 'C002',
        title: 'Request for additional lab sessions',
        description: 'Need more practice sessions for Data Structures lab before exams.',
        category: ComplaintCategory.academic,
        status: ComplaintStatus.resolved,
        submittedDate: DateTime.now().subtract(const Duration(days: 10)),
        resolvedDate: DateTime.now().subtract(const Duration(days: 5)),
        response: 'Additional lab session scheduled on Saturday 10 AM - 12 PM.',
        assignedTo: 'HOD - CSE',
      ),
    ];
  }

  /// Get notifications
  static Future<List<Notification>> getNotifications(String studentId) async {
    await _delay();
    final now = DateTime.now();
    return [
      Notification(
        notificationId: 'N001',
        title: 'Mid-term Exam Schedule Released',
        message: 'The mid-term examination schedule for Semester 5 has been published. Check your courses page.',
        type: NotificationType.exam,
        timestamp: now.subtract(const Duration(hours: 2)),
        isRead: false,
        sender: 'Examination Cell',
      ),
      Notification(
        notificationId: 'N002',
        title: 'New Assignment: Binary Search Tree',
        message: 'Dr. Priya Sharma has assigned a new task for CS301. Due in 3 days.',
        type: NotificationType.assignment,
        timestamp: now.subtract(const Duration(hours: 5)),
        isRead: false,
        actionUrl: '/dashboard/student/assignments',
        sender: 'Dr. Priya Sharma',
      ),
      Notification(
        notificationId: 'N003',
        title: 'Low Attendance Alert',
        message: 'Your attendance in CS303 has fallen below 80%. Current: 75%',
        type: NotificationType.attendance,
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: true,
        sender: 'System',
      ),
      Notification(
        notificationId: 'N004',
        title: 'College Annual Day - Feb 28',
        message: 'Annual day celebrations on Feb 28, 2026. All students are requested to attend.',
        type: NotificationType.event,
        timestamp: now.subtract(const Duration(days: 3)),
        isRead: true,
        sender: 'Student Affairs',
      ),
    ];
  }

  /// Get timetable
  static Future<List<TimetableEntry>> getTimetable(String studentId) async {
    await _delay();
    return const [
      // Monday
      TimetableEntry(
        courseId: 'CS301',
        courseCode: 'CS301',
        courseName: 'Data Structures and Algorithms',
        facultyName: 'Dr. Priya Sharma',
        day: 'Monday',
        startTime: '10:00',
        endTime: '11:00',
        room: 'Lab 3',
        type: 'Lecture',
      ),
      TimetableEntry(
        courseId: 'CS303',
        courseCode: 'CS303',
        courseName: 'Operating Systems',
        facultyName: 'Dr. Anitha Rani',
        day: 'Monday',
        startTime: '14:00',
        endTime: '15:00',
        room: 'Room 305',
        type: 'Lecture',
      ),
      // Tuesday
      TimetableEntry(
        courseId: 'CS302',
        courseCode: 'CS302',
        courseName: 'Database Management Systems',
        facultyName: 'Prof. Suresh Babu',
        day: 'Tuesday',
        startTime: '11:00',
        endTime: '12:30',
        room: 'Room 201',
        type: 'Lecture',
      ),
      TimetableEntry(
        courseId: 'CS304',
        courseCode: 'CS304',
        courseName: 'Computer Networks',
        facultyName: 'Prof. Venkatesh Kumar',
        day: 'Tuesday',
        startTime: '15:00',
        endTime: '16:00',
        room: 'Lab 5',
        type: 'Lab',
      ),
      // Wednesday
      TimetableEntry(
        courseId: 'CS301',
        courseCode: 'CS301',
        courseName: 'Data Structures and Algorithms',
        facultyName: 'Dr. Priya Sharma',
        day: 'Wednesday',
        startTime: '10:00',
        endTime: '11:00',
        room: 'Lab 3',
        type: 'Lab',
      ),
      TimetableEntry(
        courseId: 'HS301',
        courseCode: 'HS301',
        courseName: 'Professional Ethics',
        facultyName: 'Dr. Lakshmi Narayan',
        day: 'Wednesday',
        startTime: '16:00',
        endTime: '17:30',
        room: 'Room 101',
        type: 'Lecture',
      ),
      // Thursday
      TimetableEntry(
        courseId: 'CS302',
        courseCode: 'CS302',
        courseName: 'Database Management Systems',
        facultyName: 'Prof. Suresh Babu',
        day: 'Thursday',
        startTime: '11:00',
        endTime: '12:30',
        room: 'Room 201',
        type: 'Tutorial',
      ),
      TimetableEntry(
        courseId: 'CS303',
        courseCode: 'CS303',
        courseName: 'Operating Systems',
        facultyName: 'Dr. Anitha Rani',
        day: 'Thursday',
        startTime: '14:00',
        endTime: '15:00',
        room: 'Room 305',
        type: 'Lecture',
      ),
      // Friday
      TimetableEntry(
        courseId: 'CS301',
        courseCode: 'CS301',
        courseName: 'Data Structures and Algorithms',
        facultyName: 'Dr. Priya Sharma',
        day: 'Friday',
        startTime: '10:00',
        endTime: '11:00',
        room: 'Lab 3',
        type: 'Lecture',
      ),
      TimetableEntry(
        courseId: 'CS304',
        courseCode: 'CS304',
        courseName: 'Computer Networks',
        facultyName: 'Prof. Venkatesh Kumar',
        day: 'Friday',
        startTime: '15:00',
        endTime: '16:00',
        room: 'Lab 5',
        type: 'Lecture',
      ),
    ];
  }
}
