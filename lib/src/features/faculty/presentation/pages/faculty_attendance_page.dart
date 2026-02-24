import 'package:flutter/material.dart';

class FacultyAttendancePage extends StatefulWidget {
  const FacultyAttendancePage({super.key});

  @override
  State<FacultyAttendancePage> createState() => _FacultyAttendancePageState();
}

class _FacultyAttendancePageState extends State<FacultyAttendancePage> {
  static const _bg = Color(0xFF0D1F3C);
  static const _card = Color(0xFF111D35);
  static const _border = Color(0xFF1E3055);
  static const _accent = Color(0xFF1565C0);
  static const _gold = Color(0xFFD4A843);

  String _selectedCourse = 'CS3501 - Compiler Design (Sec A)';
  final List<String> _courses = [
    'CS3501 - Compiler Design (Sec A)',
    'CS3501 - Compiler Design (Sec B)',
    'CS3691 - Embedded Systems & IoT (Sec A)',
    'CS3511 - Compiler Design Lab (Sec A)',
    'CS3401 - Algorithms Design & Analysis (Sec C)',
  ];

  final List<Map<String, dynamic>> _students = [
    {'rollNo': '7376222CS101', 'name': 'Abishek R', 'present': true, 'totalPct': 92.3},
    {'rollNo': '7376222CS102', 'name': 'Arun Kumar S', 'present': true, 'totalPct': 88.5},
    {'rollNo': '7376222CS103', 'name': 'Bharathi M', 'present': true, 'totalPct': 95.0},
    {'rollNo': '7376222CS104', 'name': 'Deepika V', 'present': false, 'totalPct': 71.2},
    {'rollNo': '7376222CS105', 'name': 'Gayathri P', 'present': true, 'totalPct': 85.6},
    {'rollNo': '7376222CS106', 'name': 'Hariharan K', 'present': true, 'totalPct': 90.1},
    {'rollNo': '7376222CS107', 'name': 'Janani S', 'present': false, 'totalPct': 68.9},
    {'rollNo': '7376222CS108', 'name': 'Karthikeyan M', 'present': true, 'totalPct': 82.4},
    {'rollNo': '7376222CS109', 'name': 'Lakshmi Priya R', 'present': true, 'totalPct': 93.7},
    {'rollNo': '7376222CS110', 'name': 'Manikandan T', 'present': true, 'totalPct': 76.3},
    {'rollNo': '7376222CS111', 'name': 'Nithya Sri K', 'present': true, 'totalPct': 97.2},
    {'rollNo': '7376222CS112', 'name': 'Pavithra S', 'present': false, 'totalPct': 65.8},
    {'rollNo': '7376222CS113', 'name': 'Rajesh Kumar B', 'present': true, 'totalPct': 84.1},
    {'rollNo': '7376222CS114', 'name': 'Sangeetha V', 'present': true, 'totalPct': 91.5},
    {'rollNo': '7376222CS115', 'name': 'Tamilselvan R', 'present': true, 'totalPct': 79.8},
    {'rollNo': '7376222CS116', 'name': 'Uma Maheshwari D', 'present': true, 'totalPct': 86.2},
    {'rollNo': '7376222CS117', 'name': 'Vignesh S', 'present': false, 'totalPct': 72.5},
    {'rollNo': '7376222CS118', 'name': 'Yuvaraj M', 'present': true, 'totalPct': 88.9},
    {'rollNo': '7376222CS119', 'name': 'Pradeep Kumar N', 'present': true, 'totalPct': 83.6},
    {'rollNo': '7376222CS120', 'name': 'Surya Prakash A', 'present': true, 'totalPct': 91.0},
  ];

  @override
  Widget build(BuildContext context) {
    final presentCount = _students.where((s) => s['present'] == true).length;
    final absentCount = _students.length - presentCount;

    return Scaffold(
      backgroundColor: _bg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Attendance Management', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Mark and manage student attendance', style: TextStyle(color: Colors.white54, fontSize: 14)),
            const SizedBox(height: 20),

            // Filters Row
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: _card,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCourse,
                        dropdownColor: _card,
                        isExpanded: true,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        items: _courses.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (v) => setState(() => _selectedCourse = v!),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _border),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.white54, size: 18),
                          SizedBox(width: 8),
                          Text('24 Feb 2026', style: TextStyle(color: Colors.white, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: _card,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _border),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.white54, size: 18),
                      SizedBox(width: 8),
                      Text('Hour: 1 (08:30 - 09:20)', style: TextStyle(color: Colors.white, fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Attendance Summary Cards
            Row(
              children: [
                _AttendanceStat(label: 'Total Students', value: '${_students.length}', icon: Icons.people, color: _accent),
                const SizedBox(width: 12),
                _AttendanceStat(label: 'Present', value: '$presentCount', icon: Icons.check_circle, color: Colors.greenAccent),
                const SizedBox(width: 12),
                _AttendanceStat(label: 'Absent', value: '$absentCount', icon: Icons.cancel, color: Colors.redAccent),
                const SizedBox(width: 12),
                _AttendanceStat(label: 'Percentage', value: '${((presentCount / _students.length) * 100).toStringAsFixed(1)}%', icon: Icons.percent, color: _gold),
              ],
            ),
            const SizedBox(height: 20),

            // Quick Actions
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () => setState(() { for (var s in _students) { s['present'] = true; } }),
                  icon: const Icon(Icons.select_all, size: 16),
                  label: const Text('Mark All Present'),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.greenAccent, side: const BorderSide(color: Colors.greenAccent)),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: () => setState(() { for (var s in _students) { s['present'] = false; } }),
                  icon: const Icon(Icons.deselect, size: 16),
                  label: const Text('Mark All Absent'),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent, side: const BorderSide(color: Colors.redAccent)),
                ),
                const Spacer(),
                const Text('Showing 20 of 65 students', style: TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 16),

            // Student List
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _border),
              ),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(const Color(0xFF1A2A4A)),
                columns: const [
                  DataColumn(label: Text('S.No', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Roll Number', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Student Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Overall %', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Status', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                ],
                rows: List.generate(_students.length, (i) {
                  final s = _students[i];
                  final pct = s['totalPct'] as double;
                  return DataRow(
                    cells: [
                      DataCell(Text('${i + 1}', style: const TextStyle(color: Colors.white54, fontSize: 13))),
                      DataCell(Text(s['rollNo'] as String, style: const TextStyle(color: Colors.white70, fontSize: 13))),
                      DataCell(Text(s['name'] as String, style: const TextStyle(color: Colors.white, fontSize: 13))),
                      DataCell(Text('${pct.toStringAsFixed(1)}%', style: TextStyle(
                        color: pct >= 85 ? Colors.greenAccent : pct >= 75 ? Colors.orangeAccent : Colors.redAccent,
                        fontSize: 13, fontWeight: FontWeight.w500,
                      ))),
                      DataCell(
                        InkWell(
                          onTap: () => setState(() => s['present'] = !(s['present'] as bool)),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: (s['present'] as bool) ? Colors.greenAccent.withOpacity(0.12) : Colors.redAccent.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: (s['present'] as bool) ? Colors.greenAccent.withOpacity(0.3) : Colors.redAccent.withOpacity(0.3)),
                            ),
                            child: Text(
                              (s['present'] as bool) ? 'Present' : 'Absent',
                              style: TextStyle(color: (s['present'] as bool) ? Colors.greenAccent : Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),

            // Submit Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    side: const BorderSide(color: Colors.white30),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                  child: const Text('Save as Draft'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Submit Attendance'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _AttendanceStat extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _AttendanceStat({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF111D35),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1E3055)),
        ),
        child: Row(
          children: [
            CircleAvatar(radius: 20, backgroundColor: color.withOpacity(0.12), child: Icon(icon, color: color, size: 20)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
