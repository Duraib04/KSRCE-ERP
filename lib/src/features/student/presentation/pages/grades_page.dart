import 'package:flutter/material.dart';

class StudentGradesPage extends StatefulWidget {
  final String userId;

  const StudentGradesPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<StudentGradesPage> createState() => _StudentGradesPageState();
}

class _StudentGradesPageState extends State<StudentGradesPage> {
  late List<GradeRecord> grades;

  @override
  void initState() {
    super.initState();
    _loadGrades();
  }

  void _loadGrades() {
    grades = [
      GradeRecord(
        courseCode: 'CS201',
        courseName: 'Data Structures',
        assignment: 18,
        midterm: 38,
        endterm: 75,
        total: 131,
        grade: 'A',
        gpa: 4.0,
      ),
      GradeRecord(
        courseCode: 'CS202',
        courseName: 'Database Management',
        assignment: 17,
        midterm: 36,
        endterm: 72,
        total: 125,
        grade: 'B+',
        gpa: 3.7,
      ),
      GradeRecord(
        courseCode: 'CS203',
        courseName: 'Web Development',
        assignment: 19,
        midterm: 39,
        endterm: 78,
        total: 136,
        grade: 'A',
        gpa: 4.0,
      ),
      GradeRecord(
        courseCode: 'CS204',
        courseName: 'Algorithms',
        assignment: 16,
        midterm: 35,
        endterm: 70,
        total: 121,
        grade: 'B',
        gpa: 3.3,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    double semesterGPA =
        grades.fold(0.0, (sum, g) => sum + g.gpa) / grades.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Grades'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // GPA Card
          Card(
            color: Colors.blue.shade600,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Current GPA',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${semesterGPA.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Semester IV',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Grades Table
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Course Grades',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...grades.map((grade) => _buildGradeCard(grade)),
        ],
      ),
    );
  }

  Widget _buildGradeCard(GradeRecord grade) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    grade.courseName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    grade.courseCode,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getGradeColor(grade.grade),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                grade.grade,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _GradeRow('Assignment', '${grade.assignment}/20'),
                _GradeRow('Midterm', '${grade.midterm}/40'),
                _GradeRow('Endterm', '${grade.endterm}/40'),
                const Divider(height: 16),
                _GradeRow('Total', '${grade.total}/100', isBold: true),
                _GradeRow('GPA', grade.gpa.toStringAsFixed(1), isBold: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A':
      case 'A+':
        return Colors.green;
      case 'B+':
      case 'B':
        return Colors.blue;
      case 'C+':
      case 'C':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }
}

class _GradeRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _GradeRow(this.label, this.value, {this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

class GradeRecord {
  final String courseCode;
  final String courseName;
  final int assignment;
  final int midterm;
  final int endterm;
  final int total;
  final String grade;
  final double gpa;

  GradeRecord({
    required this.courseCode,
    required this.courseName,
    required this.assignment,
    required this.midterm,
    required this.endterm,
    required this.total,
    required this.grade,
    required this.gpa,
  });
}
