import 'package:flutter/material.dart';

class StudentAttendancePage extends StatefulWidget {
  final String userId;

  const StudentAttendancePage({Key? key, required this.userId})
      : super(key: key);

  @override
  State<StudentAttendancePage> createState() => _StudentAttendancePageState();
}

class _StudentAttendancePageState extends State<StudentAttendancePage> {
  late List<CourseAttendance> attendanceList;

  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }

  void _loadAttendance() {
    attendanceList = [
      CourseAttendance(
        courseCode: 'CS201',
        courseName: 'Data Structures',
        attended: 28,
        total: 30,
        percentage: 93,
      ),
      CourseAttendance(
        courseCode: 'CS202',
        courseName: 'Database Management',
        attended: 27,
        total: 30,
        percentage: 90,
      ),
      CourseAttendance(
        courseCode: 'CS203',
        courseName: 'Web Development',
        attended: 29,
        total: 30,
        percentage: 97,
      ),
      CourseAttendance(
        courseCode: 'CS204',
        courseName: 'Algorithms',
        attended: 26,
        total: 30,
        percentage: 87,
      ),
      CourseAttendance(
        courseCode: 'CS205',
        courseName: 'Software Engineering',
        attended: 28,
        total: 30,
        percentage: 93,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    double overallAttendance =
        attendanceList.fold(0.0, (sum, a) => sum + a.percentage) /
            attendanceList.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Attendance'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Overall Attendance Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Overall Attendance',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          value: overallAttendance / 100,
                          strokeWidth: 8,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            overallAttendance >= 75 ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '${overallAttendance.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    overallAttendance >= 75 ? '✓ Eligible' : '✗ Not Eligible',
                    style: TextStyle(
                      fontSize: 14,
                      color: overallAttendance >= 75 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Course Attendance
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Course Wise Attendance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...attendanceList.map((attendance) =>
              _buildAttendanceCard(context, attendance)),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(
      BuildContext context, CourseAttendance attendance) {
    bool isEligible = attendance.percentage >= 75;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attendance.courseName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        attendance.courseCode,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isEligible ? Colors.green.shade100 : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${attendance.percentage}%',
                    style: TextStyle(
                      color: isEligible ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: attendance.percentage / 100,
                minHeight: 8,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isEligible ? Colors.green : Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${attendance.attended}/${attendance.total} classes attended',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseAttendance {
  final String courseCode;
  final String courseName;
  final int attended;
  final int total;
  final int percentage;

  CourseAttendance({
    required this.courseCode,
    required this.courseName,
    required this.attended,
    required this.total,
    required this.percentage,
  });
}
