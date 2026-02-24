import 'package:flutter/material.dart';

class StudentResultsPage extends StatefulWidget {
  const StudentResultsPage({super.key});

  @override
  State<StudentResultsPage> createState() => _StudentResultsPageState();
}

class _StudentResultsPageState extends State<StudentResultsPage> {
  String _selectedSemester = 'Semester 4';

  final Map<String, Map<String, dynamic>> _results = {
    'Semester 1': {
      'sgpa': 8.1,
      'subjects': [
        {'code': 'HS3152', 'name': 'Professional English I', 'int': 45, 'ext': 48, 'total': 93, 'grade': 'O', 'gp': 10, 'credits': 4},
        {'code': 'MA3151', 'name': 'Matrices and Calculus', 'int': 40, 'ext': 42, 'total': 82, 'grade': 'A+', 'gp': 9, 'credits': 4},
        {'code': 'PH3151', 'name': 'Engineering Physics', 'int': 38, 'ext': 35, 'total': 73, 'grade': 'B+', 'gp': 8, 'credits': 3},
        {'code': 'CY3151', 'name': 'Engineering Chemistry', 'int': 42, 'ext': 40, 'total': 82, 'grade': 'A+', 'gp': 9, 'credits': 3},
        {'code': 'GE3151', 'name': 'Problem Solving using Python', 'int': 44, 'ext': 38, 'total': 82, 'grade': 'A+', 'gp': 9, 'credits': 3},
        {'code': 'GE3152', 'name': 'Heritage of Tamils', 'int': 35, 'ext': 30, 'total': 65, 'grade': 'B', 'gp': 7, 'credits': 1},
      ],
    },
    'Semester 2': {
      'sgpa': 8.3,
      'subjects': [
        {'code': 'HS3252', 'name': 'Professional English II', 'int': 42, 'ext': 45, 'total': 87, 'grade': 'A+', 'gp': 9, 'credits': 4},
        {'code': 'MA3251', 'name': 'Statistics and Numerical Methods', 'int': 38, 'ext': 40, 'total': 78, 'grade': 'A', 'gp': 8, 'credits': 4},
        {'code': 'PH3256', 'name': 'Physics for IT', 'int': 40, 'ext': 38, 'total': 78, 'grade': 'A', 'gp': 8, 'credits': 3},
        {'code': 'BE3251', 'name': 'Basic Electrical Engineering', 'int': 44, 'ext': 46, 'total': 90, 'grade': 'O', 'gp': 10, 'credits': 3},
        {'code': 'CS3251', 'name': 'Programming in C', 'int': 46, 'ext': 44, 'total': 90, 'grade': 'O', 'gp': 10, 'credits': 3},
        {'code': 'GE3252', 'name': 'Tamils and Technology', 'int': 32, 'ext': 28, 'total': 60, 'grade': 'B', 'gp': 7, 'credits': 1},
      ],
    },
    'Semester 3': {
      'sgpa': 8.5,
      'subjects': [
        {'code': 'MA3354', 'name': 'Discrete Mathematics', 'int': 44, 'ext': 42, 'total': 86, 'grade': 'A+', 'gp': 9, 'credits': 4},
        {'code': 'CS3351', 'name': 'Digital Principles & Computer Org', 'int': 40, 'ext': 40, 'total': 80, 'grade': 'A', 'gp': 8, 'credits': 4},
        {'code': 'CS3352', 'name': 'Foundations of Data Science', 'int': 46, 'ext': 44, 'total': 90, 'grade': 'O', 'gp': 10, 'credits': 3},
        {'code': 'CS3301', 'name': 'Data Structures', 'int': 48, 'ext': 46, 'total': 94, 'grade': 'O', 'gp': 10, 'credits': 3},
        {'code': 'CS3391', 'name': 'Object Oriented Programming', 'int': 42, 'ext': 38, 'total': 80, 'grade': 'A', 'gp': 8, 'credits': 3},
      ],
    },
    'Semester 4': {
      'sgpa': 8.7,
      'subjects': [
        {'code': 'CS3452', 'name': 'Theory of Computation', 'int': 42, 'ext': 44, 'total': 86, 'grade': 'A+', 'gp': 9, 'credits': 4},
        {'code': 'CS3491', 'name': 'Artificial Intelligence', 'int': 46, 'ext': 48, 'total': 94, 'grade': 'O', 'gp': 10, 'credits': 4},
        {'code': 'CS3401', 'name': 'Algorithms', 'int': 44, 'ext': 42, 'total': 86, 'grade': 'A+', 'gp': 9, 'credits': 4},
        {'code': 'CS3451', 'name': 'Introduction to OS', 'int': 40, 'ext': 38, 'total': 78, 'grade': 'A', 'gp': 8, 'credits': 3},
        {'code': 'CS3492', 'name': 'Database Management Systems', 'int': 48, 'ext': 46, 'total': 94, 'grade': 'O', 'gp': 10, 'credits': 4},
        {'code': 'GE3451', 'name': 'Environmental Science', 'int': 35, 'ext': 30, 'total': 65, 'grade': 'B', 'gp': 7, 'credits': 2},
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    final semData = _results[_selectedSemester]!;
    final subjects = semData['subjects'] as List<Map<String, dynamic>>;
    return Scaffold(
      backgroundColor: const Color(0xFF0D1F3C),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: const [
              Icon(Icons.assessment, color: Color(0xFFD4A843), size: 28),
              SizedBox(width: 12),
              Text('Examination Results', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            ]),
            const SizedBox(height: 8),
            const Text('Anna University Examination Results', style: TextStyle(color: Colors.white60, fontSize: 14)),
            const SizedBox(height: 24),
            _buildGPASummary(),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text('Select Semester: ', style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111D35),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF1E3055)),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedSemester,
                    dropdownColor: const Color(0xFF111D35),
                    style: const TextStyle(color: Colors.white),
                    underline: const SizedBox(),
                    items: _results.keys.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (v) => setState(() => _selectedSemester = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildResultsTable(subjects),
            const SizedBox(height: 16),
            _buildSGPA(semData['sgpa'] as double),
          ],
        ),
      ),
    );
  }

  Widget _buildGPASummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111D35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E3055)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _gpaCard('Semester 1', '8.10'),
          _gpaCard('Semester 2', '8.30'),
          _gpaCard('Semester 3', '8.50'),
          _gpaCard('Semester 4', '8.70'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFD4A843).withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFD4A843).withOpacity(0.4)),
            ),
            child: Column(
              children: const [
                Text('CGPA', style: TextStyle(color: Color(0xFFD4A843), fontSize: 14, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('8.42', style: TextStyle(color: Color(0xFFD4A843), fontSize: 28, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _gpaCard(String sem, String gpa) {
    return Column(
      children: [
        Text(sem, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 4),
        Text(gpa, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        const Text('SGPA', style: TextStyle(color: Colors.white38, fontSize: 11)),
      ],
    );
  }

  Widget _buildResultsTable(List<Map<String, dynamic>> subjects) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111D35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E3055)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$_selectedSemester Results', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          Table(
            columnWidths: const {
              0: FixedColumnWidth(80),
              1: FlexColumnWidth(2),
              2: FixedColumnWidth(60),
              3: FixedColumnWidth(60),
              4: FixedColumnWidth(60),
              5: FixedColumnWidth(60),
              6: FixedColumnWidth(50),
              7: FixedColumnWidth(60),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: const Color(0xFF1E3055)))),
                children: ['Code', 'Subject', 'Internal', 'External', 'Total', 'Grade', 'GP', 'Credits'].map((h) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(h, style: const TextStyle(color: Color(0xFFD4A843), fontWeight: FontWeight.bold, fontSize: 12)),
                )).toList(),
              ),
              ...subjects.map((s) {
                Color gradeColor = s['grade'] == 'O' ? Colors.green : s['grade'] == 'A+' ? Colors.blue[300]! : s['grade'] == 'A' ? Colors.white : Colors.orange;
                return TableRow(
                  children: [
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(s['code'], style: const TextStyle(color: Color(0xFF64B5F6), fontSize: 12))),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(s['name'], style: const TextStyle(color: Colors.white, fontSize: 12))),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text('${s['int']}', style: const TextStyle(color: Colors.white70, fontSize: 12))),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text('${s['ext']}', style: const TextStyle(color: Colors.white70, fontSize: 12))),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text('${s['total']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(s['grade'], style: TextStyle(color: gradeColor, fontWeight: FontWeight.bold, fontSize: 12))),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text('${s['gp']}', style: const TextStyle(color: Colors.white70, fontSize: 12))),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text('${s['credits']}', style: const TextStyle(color: Colors.white70, fontSize: 12))),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSGPA(double sgpa) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1565C0).withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF1565C0).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events, color: Color(0xFFD4A843)),
          const SizedBox(width: 12),
          Text('$_selectedSemester SGPA: ', style: const TextStyle(color: Colors.white70, fontSize: 16)),
          Text(sgpa.toStringAsFixed(2), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(width: 40),
          const Text('CGPA: ', style: TextStyle(color: Colors.white70, fontSize: 16)),
          const Text('8.42', style: TextStyle(color: Color(0xFFD4A843), fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
