import 'package:flutter/material.dart';

class FacultyGradesPage extends StatefulWidget {
  const FacultyGradesPage({super.key});

  @override
  State<FacultyGradesPage> createState() => _FacultyGradesPageState();
}

class _FacultyGradesPageState extends State<FacultyGradesPage> {
  static const _bg = Color(0xFF0D1F3C);
  static const _card = Color(0xFF111D35);
  static const _border = Color(0xFF1E3055);
  static const _accent = Color(0xFF1565C0);
  static const _gold = Color(0xFFD4A843);

  String _selectedCourse = 'CS3501 - Compiler Design (Sec A)';
  String _selectedExam = 'Internal Assessment - II';

  final List<Map<String, dynamic>> _students = [
    {'rollNo': '7376222CS101', 'name': 'Abishek R', 'ia1': 42, 'ia2': 38, 'model': null, 'assignment': 18, 'grade': 'A'},
    {'rollNo': '7376222CS102', 'name': 'Arun Kumar S', 'ia1': 35, 'ia2': 40, 'model': null, 'assignment': 16, 'grade': 'A'},
    {'rollNo': '7376222CS103', 'name': 'Bharathi M', 'ia1': 48, 'ia2': 45, 'model': null, 'assignment': 20, 'grade': 'O'},
    {'rollNo': '7376222CS104', 'name': 'Deepika V', 'ia1': 22, 'ia2': 18, 'model': null, 'assignment': 12, 'grade': 'D'},
    {'rollNo': '7376222CS105', 'name': 'Gayathri P', 'ia1': 38, 'ia2': 35, 'model': null, 'assignment': 17, 'grade': 'B+'},
    {'rollNo': '7376222CS106', 'name': 'Hariharan K', 'ia1': 44, 'ia2': 42, 'model': null, 'assignment': 19, 'grade': 'A+'},
    {'rollNo': '7376222CS107', 'name': 'Janani S', 'ia1': 18, 'ia2': 15, 'model': null, 'assignment': 10, 'grade': 'E'},
    {'rollNo': '7376222CS108', 'name': 'Karthikeyan M', 'ia1': 32, 'ia2': 30, 'model': null, 'assignment': 15, 'grade': 'B'},
    {'rollNo': '7376222CS109', 'name': 'Lakshmi Priya R', 'ia1': 46, 'ia2': 44, 'model': null, 'assignment': 20, 'grade': 'O'},
    {'rollNo': '7376222CS110', 'name': 'Manikandan T', 'ia1': 28, 'ia2': 25, 'model': null, 'assignment': 14, 'grade': 'C'},
    {'rollNo': '7376222CS111', 'name': 'Nithya Sri K', 'ia1': 49, 'ia2': 47, 'model': null, 'assignment': 20, 'grade': 'O'},
    {'rollNo': '7376222CS112', 'name': 'Pavithra S', 'ia1': 15, 'ia2': 12, 'model': null, 'assignment': 8, 'grade': 'F'},
    {'rollNo': '7376222CS113', 'name': 'Rajesh Kumar B', 'ia1': 36, 'ia2': 33, 'model': null, 'assignment': 16, 'grade': 'B+'},
    {'rollNo': '7376222CS114', 'name': 'Sangeetha V', 'ia1': 43, 'ia2': 41, 'model': null, 'assignment': 19, 'grade': 'A+'},
    {'rollNo': '7376222CS115', 'name': 'Tamilselvan R', 'ia1': 30, 'ia2': 28, 'model': null, 'assignment': 15, 'grade': 'B'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;
          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row with buttons
                isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Grade Entry', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.upload_file, size: 16),
                                label: const Text('Import from Excel'),
                                style: OutlinedButton.styleFrom(foregroundColor: _gold, side: BorderSide(color: _gold.withOpacity(0.4))),
                              ),
                              OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.download, size: 16),
                                label: const Text('Download Template'),
                                style: OutlinedButton.styleFrom(foregroundColor: Colors.white70, side: const BorderSide(color: Colors.white30)),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Grade Entry', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.upload_file, size: 16),
                                label: const Text('Import from Excel'),
                                style: OutlinedButton.styleFrom(foregroundColor: _gold, side: BorderSide(color: _gold.withOpacity(0.4))),
                              ),
                              const SizedBox(width: 10),
                              OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.download, size: 16),
                                label: const Text('Download Template'),
                                style: OutlinedButton.styleFrom(foregroundColor: Colors.white70, side: const BorderSide(color: Colors.white30)),
                              ),
                            ],
                          ),
                        ],
                      ),
                const SizedBox(height: 8),
                const Text('Enter and manage student marks for internal assessments', style: TextStyle(color: Colors.white54, fontSize: 14)),
                const SizedBox(height: 20),

                // Selectors
                isMobile
                    ? Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(10), border: Border.all(color: _border)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedCourse,
                                dropdownColor: _card,
                                isExpanded: true,
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                                items: [
                                  'CS3501 - Compiler Design (Sec A)',
                                  'CS3501 - Compiler Design (Sec B)',
                                  'CS3691 - Embedded Systems & IoT (Sec A)',
                                  'CS3401 - Algorithms Design & Analysis (Sec C)',
                                ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                                onChanged: (v) => setState(() => _selectedCourse = v!),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(10), border: Border.all(color: _border)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedExam,
                                dropdownColor: _card,
                                isExpanded: true,
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                                items: [
                                  'Internal Assessment - I',
                                  'Internal Assessment - II',
                                  'Internal Assessment - III',
                                  'Model Exam',
                                  'Assignment Marks',
                                ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                                onChanged: (v) => setState(() => _selectedExam = v!),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(10), border: Border.all(color: _border)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedCourse,
                                  dropdownColor: _card,
                                  isExpanded: true,
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                  items: [
                                    'CS3501 - Compiler Design (Sec A)',
                                    'CS3501 - Compiler Design (Sec B)',
                                    'CS3691 - Embedded Systems & IoT (Sec A)',
                                    'CS3401 - Algorithms Design & Analysis (Sec C)',
                                  ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                                  onChanged: (v) => setState(() => _selectedCourse = v!),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(10), border: Border.all(color: _border)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedExam,
                                  dropdownColor: _card,
                                  isExpanded: true,
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                  items: [
                                    'Internal Assessment - I',
                                    'Internal Assessment - II',
                                    'Internal Assessment - III',
                                    'Model Exam',
                                    'Assignment Marks',
                                  ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                                  onChanged: (v) => setState(() => _selectedExam = v!),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                const SizedBox(height: 20),

                // Grade Distribution
                const Text('Grade Distribution', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _GradeBar(grade: 'O', count: 3, total: 15, color: Colors.greenAccent),
                        const SizedBox(width: 16),
                        _GradeBar(grade: 'A+', count: 2, total: 15, color: Colors.lightGreenAccent),
                        const SizedBox(width: 16),
                        _GradeBar(grade: 'A', count: 2, total: 15, color: _accent),
                        const SizedBox(width: 16),
                        _GradeBar(grade: 'B+', count: 2, total: 15, color: Colors.cyan),
                        const SizedBox(width: 16),
                        _GradeBar(grade: 'B', count: 2, total: 15, color: Colors.orange),
                        const SizedBox(width: 16),
                        _GradeBar(grade: 'C', count: 1, total: 15, color: Colors.orangeAccent),
                        const SizedBox(width: 16),
                        _GradeBar(grade: 'D', count: 1, total: 15, color: Colors.deepOrange),
                        const SizedBox(width: 16),
                        _GradeBar(grade: 'E', count: 1, total: 15, color: Colors.redAccent),
                        const SizedBox(width: 16),
                        _GradeBar(grade: 'F', count: 1, total: 15, color: Colors.red),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Marks Table
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(const Color(0xFF1A2A4A)),
                      columnSpacing: 20,
                      columns: const [
                        DataColumn(label: Text('S.No', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                        DataColumn(label: Text('Roll No', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                        DataColumn(label: Text('Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                        DataColumn(label: Text('IA-I (50)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                        DataColumn(label: Text('IA-II (50)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                        DataColumn(label: Text('Assign (20)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                        DataColumn(label: Text('Total', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                        DataColumn(label: Text('Grade', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                      ],
                      rows: List.generate(_students.length, (i) {
                        final s = _students[i];
                        final total = ((s['ia1'] as int) + (s['ia2'] as int) + (s['assignment'] as int));
                        Color gradeColor = Colors.white;
                        final g = s['grade'] as String;
                        if (g == 'O') gradeColor = Colors.greenAccent;
                        if (g == 'A+' || g == 'A') gradeColor = Colors.lightGreenAccent;
                        if (g == 'B+' || g == 'B') gradeColor = Colors.cyan;
                        if (g == 'C' || g == 'D') gradeColor = Colors.orangeAccent;
                        if (g == 'E' || g == 'F') gradeColor = Colors.redAccent;

                        return DataRow(cells: [
                          DataCell(Text('${i + 1}', style: const TextStyle(color: Colors.white54, fontSize: 12))),
                          DataCell(Text(s['rollNo'] as String, style: const TextStyle(color: Colors.white70, fontSize: 12))),
                          DataCell(Text(s['name'] as String, style: const TextStyle(color: Colors.white, fontSize: 12))),
                          DataCell(Text('${s['ia1']}', style: const TextStyle(color: Colors.white70, fontSize: 12))),
                          DataCell(Text('${s['ia2']}', style: const TextStyle(color: Colors.white70, fontSize: 12))),
                          DataCell(Text('${s['assignment']}', style: const TextStyle(color: Colors.white70, fontSize: 12))),
                          DataCell(Text('$total', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
                          DataCell(Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: gradeColor.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                            child: Text(g, style: TextStyle(color: gradeColor, fontSize: 12, fontWeight: FontWeight.bold)),
                          )),
                        ]);
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Actions
                isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Showing 15 of 65 students', style: TextStyle(color: Colors.white38, fontSize: 12)),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            runSpacing: 10,
                            children: [
                              OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(foregroundColor: Colors.white70, side: const BorderSide(color: Colors.white30), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
                                child: const Text('Save Draft'),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.check, size: 18),
                                label: const Text('Submit Marks'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _accent,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Showing 15 of 65 students', style: TextStyle(color: Colors.white38, fontSize: 12)),
                          Row(
                            children: [
                              OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(foregroundColor: Colors.white70, side: const BorderSide(color: Colors.white30), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
                                child: const Text('Save Draft'),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.check, size: 18),
                                label: const Text('Submit Marks'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _accent,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _GradeBar extends StatelessWidget {
  final String grade;
  final int count, total;
  final Color color;
  const _GradeBar({required this.grade, required this.count, required this.total, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$count', style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          width: 28,
          height: (count / total) * 100 + 10,
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 28,
              height: (count / total) * 100,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(grade, style: const TextStyle(color: Colors.white54, fontSize: 11)),
      ],
    );
  }
}
