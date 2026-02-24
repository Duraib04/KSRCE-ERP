import 'package:flutter/material.dart';

class FacultyStudentsPage extends StatefulWidget {
  const FacultyStudentsPage({super.key});

  @override
  State<FacultyStudentsPage> createState() => _FacultyStudentsPageState();
}

class _FacultyStudentsPageState extends State<FacultyStudentsPage> {
  static const _bg = Color(0xFF0D1F3C);
  static const _card = Color(0xFF111D35);
  static const _border = Color(0xFF1E3055);
  static const _accent = Color(0xFF1565C0);
  static const _gold = Color(0xFFD4A843);

  String _selectedCourse = 'CS3501 - Compiler Design (Sec A)';
  String _searchQuery = '';

  final List<Map<String, dynamic>> _students = [
    {'rollNo': '7376222CS101', 'name': 'Abishek R', 'email': 'abishek.r@ksrce.ac.in', 'attendance': 92.3, 'grade': 'A', 'phone': '9876543210', 'section': 'A'},
    {'rollNo': '7376222CS102', 'name': 'Arun Kumar S', 'email': 'arun.s@ksrce.ac.in', 'attendance': 88.5, 'grade': 'A', 'phone': '9876543211', 'section': 'A'},
    {'rollNo': '7376222CS103', 'name': 'Bharathi M', 'email': 'bharathi.m@ksrce.ac.in', 'attendance': 95.0, 'grade': 'O', 'phone': '9876543212', 'section': 'A'},
    {'rollNo': '7376222CS104', 'name': 'Deepika V', 'email': 'deepika.v@ksrce.ac.in', 'attendance': 71.2, 'grade': 'D', 'phone': '9876543213', 'section': 'A'},
    {'rollNo': '7376222CS105', 'name': 'Gayathri P', 'email': 'gayathri.p@ksrce.ac.in', 'attendance': 85.6, 'grade': 'B+', 'phone': '9876543214', 'section': 'A'},
    {'rollNo': '7376222CS106', 'name': 'Hariharan K', 'email': 'hariharan.k@ksrce.ac.in', 'attendance': 90.1, 'grade': 'A+', 'phone': '9876543215', 'section': 'A'},
    {'rollNo': '7376222CS107', 'name': 'Janani S', 'email': 'janani.s@ksrce.ac.in', 'attendance': 68.9, 'grade': 'E', 'phone': '9876543216', 'section': 'A'},
    {'rollNo': '7376222CS108', 'name': 'Karthikeyan M', 'email': 'karthikeyan.m@ksrce.ac.in', 'attendance': 82.4, 'grade': 'B', 'phone': '9876543217', 'section': 'A'},
    {'rollNo': '7376222CS109', 'name': 'Lakshmi Priya R', 'email': 'lakshmi.r@ksrce.ac.in', 'attendance': 93.7, 'grade': 'O', 'phone': '9876543218', 'section': 'A'},
    {'rollNo': '7376222CS110', 'name': 'Manikandan T', 'email': 'manikandan.t@ksrce.ac.in', 'attendance': 76.3, 'grade': 'C', 'phone': '9876543219', 'section': 'A'},
    {'rollNo': '7376222CS111', 'name': 'Nithya Sri K', 'email': 'nithya.k@ksrce.ac.in', 'attendance': 97.2, 'grade': 'O', 'phone': '9876543220', 'section': 'A'},
    {'rollNo': '7376222CS112', 'name': 'Pavithra S', 'email': 'pavithra.s@ksrce.ac.in', 'attendance': 65.8, 'grade': 'F', 'phone': '9876543221', 'section': 'A'},
    {'rollNo': '7376222CS113', 'name': 'Rajesh Kumar B', 'email': 'rajesh.b@ksrce.ac.in', 'attendance': 84.1, 'grade': 'B+', 'phone': '9876543222', 'section': 'A'},
    {'rollNo': '7376222CS114', 'name': 'Sangeetha V', 'email': 'sangeetha.v@ksrce.ac.in', 'attendance': 91.5, 'grade': 'A+', 'phone': '9876543223', 'section': 'A'},
    {'rollNo': '7376222CS115', 'name': 'Tamilselvan R', 'email': 'tamilselvan.r@ksrce.ac.in', 'attendance': 79.8, 'grade': 'B', 'phone': '9876543224', 'section': 'A'},
    {'rollNo': '7376222CS116', 'name': 'Uma Maheshwari D', 'email': 'uma.d@ksrce.ac.in', 'attendance': 86.2, 'grade': 'A', 'phone': '9876543225', 'section': 'A'},
    {'rollNo': '7376222CS117', 'name': 'Vignesh S', 'email': 'vignesh.s@ksrce.ac.in', 'attendance': 72.5, 'grade': 'D', 'phone': '9876543226', 'section': 'A'},
    {'rollNo': '7376222CS118', 'name': 'Yuvaraj M', 'email': 'yuvaraj.m@ksrce.ac.in', 'attendance': 88.9, 'grade': 'A', 'phone': '9876543227', 'section': 'A'},
    {'rollNo': '7376222CS119', 'name': 'Pradeep Kumar N', 'email': 'pradeep.n@ksrce.ac.in', 'attendance': 83.6, 'grade': 'B+', 'phone': '9876543228', 'section': 'A'},
    {'rollNo': '7376222CS120', 'name': 'Surya Prakash A', 'email': 'surya.a@ksrce.ac.in', 'attendance': 91.0, 'grade': 'A+', 'phone': '9876543229', 'section': 'A'},
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _students.where((s) {
      if (_searchQuery.isEmpty) return true;
      return (s['name'] as String).toLowerCase().contains(_searchQuery.toLowerCase()) ||
             (s['rollNo'] as String).toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    final above75 = _students.where((s) => (s['attendance'] as double) >= 75).length;
    final below75 = _students.length - above75;

    return Scaffold(
      backgroundColor: _bg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;
          final pad = isMobile ? 16.0 : 24.0;

          return SingleChildScrollView(
            padding: EdgeInsets.all(pad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row
                isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Student List', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.download, size: 16),
                                label: const Text('Export to CSV'),
                                style: OutlinedButton.styleFrom(foregroundColor: _gold, side: BorderSide(color: _gold.withOpacity(0.4))),
                              ),
                              OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.print, size: 16),
                                label: const Text('Print'),
                                style: OutlinedButton.styleFrom(foregroundColor: Colors.white70, side: const BorderSide(color: Colors.white30)),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Student List', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.download, size: 16),
                                label: const Text('Export to CSV'),
                                style: OutlinedButton.styleFrom(foregroundColor: _gold, side: BorderSide(color: _gold.withOpacity(0.4))),
                              ),
                              const SizedBox(width: 10),
                              OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.print, size: 16),
                                label: const Text('Print'),
                                style: OutlinedButton.styleFrom(foregroundColor: Colors.white70, side: const BorderSide(color: Colors.white30)),
                              ),
                            ],
                          ),
                        ],
                      ),
                const SizedBox(height: 20),

                // Filters
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
                                  'CS3511 - Compiler Design Lab (Sec A)',
                                  'CS3401 - Algorithms Design & Analysis (Sec C)',
                                ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                                onChanged: (v) => setState(() => _selectedCourse = v!),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(10), border: Border.all(color: _border)),
                            child: TextField(
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                              decoration: const InputDecoration(
                                hintText: 'Search by name or roll no...',
                                hintStyle: TextStyle(color: Colors.white30, fontSize: 14),
                                prefixIcon: Icon(Icons.search, color: Colors.white30, size: 20),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                              ),
                              onChanged: (v) => setState(() => _searchQuery = v),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            flex: 2,
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
                                    'CS3511 - Compiler Design Lab (Sec A)',
                                    'CS3401 - Algorithms Design & Analysis (Sec C)',
                                  ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                                  onChanged: (v) => setState(() => _selectedCourse = v!),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(10), border: Border.all(color: _border)),
                              child: TextField(
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                                decoration: const InputDecoration(
                                  hintText: 'Search by name or roll no...',
                                  hintStyle: TextStyle(color: Colors.white30, fontSize: 14),
                                  prefixIcon: Icon(Icons.search, color: Colors.white30, size: 20),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                ),
                                onChanged: (v) => setState(() => _searchQuery = v),
                              ),
                            ),
                          ),
                        ],
                      ),
                const SizedBox(height: 16),

                // Quick Stats
                isMobile
                    ? Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          SizedBox(width: (constraints.maxWidth - pad * 2 - 12) / 2, child: _QStat(label: 'Total Students', value: '${_students.length}', color: _accent)),
                          SizedBox(width: (constraints.maxWidth - pad * 2 - 12) / 2, child: _QStat(label: 'Above 75%', value: '$above75', color: Colors.greenAccent)),
                          SizedBox(width: (constraints.maxWidth - pad * 2 - 12) / 2, child: _QStat(label: 'Below 75%', value: '$below75', color: Colors.redAccent)),
                          SizedBox(width: (constraints.maxWidth - pad * 2 - 12) / 2, child: _QStat(label: 'Avg Attendance', value: '${(_students.fold<double>(0, (sum, s) => sum + (s['attendance'] as double)) / _students.length).toStringAsFixed(1)}%', color: _gold)),
                        ],
                      )
                    : Row(
                        children: [
                          _QStat(label: 'Total Students', value: '${_students.length}', color: _accent),
                          const SizedBox(width: 12),
                          _QStat(label: 'Above 75%', value: '$above75', color: Colors.greenAccent),
                          const SizedBox(width: 12),
                          _QStat(label: 'Below 75%', value: '$below75', color: Colors.redAccent),
                          const SizedBox(width: 12),
                          _QStat(label: 'Avg Attendance', value: '${(_students.fold<double>(0, (sum, s) => sum + (s['attendance'] as double)) / _students.length).toStringAsFixed(1)}%', color: _gold),
                        ],
                      ),
                const SizedBox(height: 20),

                // Data Table
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(const Color(0xFF1A2A4A)),
                      columns: const [
                        DataColumn(label: Text('S.No', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                        DataColumn(label: Text('Roll Number', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                        DataColumn(label: Text('Student Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                        DataColumn(label: Text('Email', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                        DataColumn(label: Text('Attendance %', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                        DataColumn(label: Text('Grade', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                        DataColumn(label: Text('Actions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                      ],
                      rows: List.generate(filtered.length, (i) {
                        final s = filtered[i];
                        final att = s['attendance'] as double;
                        final g = s['grade'] as String;
                        Color gradeColor = Colors.white;
                        if (g == 'O') gradeColor = Colors.greenAccent;
                        if (g.startsWith('A')) gradeColor = Colors.lightGreenAccent;
                        if (g.startsWith('B')) gradeColor = Colors.cyan;
                        if (g == 'C') gradeColor = Colors.orangeAccent;
                        if (g == 'D' || g == 'E' || g == 'F') gradeColor = Colors.redAccent;

                        return DataRow(cells: [
                          DataCell(Text('${i + 1}', style: const TextStyle(color: Colors.white54, fontSize: 13))),
                          DataCell(Text(s['rollNo'] as String, style: const TextStyle(color: Colors.white70, fontSize: 13))),
                          DataCell(Text(s['name'] as String, style: const TextStyle(color: Colors.white, fontSize: 13))),
                          DataCell(Text(s['email'] as String, style: const TextStyle(color: Colors.white54, fontSize: 12))),
                          DataCell(Text('${att.toStringAsFixed(1)}%', style: TextStyle(
                            color: att >= 85 ? Colors.greenAccent : att >= 75 ? Colors.orangeAccent : Colors.redAccent,
                            fontSize: 13, fontWeight: FontWeight.w500,
                          ))),
                          DataCell(Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: gradeColor.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                            child: Text(g, style: TextStyle(color: gradeColor, fontSize: 12, fontWeight: FontWeight.bold)),
                          )),
                          DataCell(IconButton(
                            icon: const Icon(Icons.visibility, color: Colors.white38, size: 18),
                            onPressed: () {},
                            tooltip: 'View Details',
                          )),
                        ]);
                      }),
                    ),
                  ),
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

class _QStat extends StatelessWidget {
  final String label, value;
  final Color color;
  const _QStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF111D35),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1E3055)),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
