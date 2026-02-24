import 'package:flutter/material.dart';

class FacultyAssignmentsPage extends StatefulWidget {
  const FacultyAssignmentsPage({super.key});

  @override
  State<FacultyAssignmentsPage> createState() => _FacultyAssignmentsPageState();
}

class _FacultyAssignmentsPageState extends State<FacultyAssignmentsPage> {
  static const _bg = Color(0xFF0D1F3C);
  static const _card = Color(0xFF111D35);
  static const _border = Color(0xFF1E3055);
  static const _accent = Color(0xFF1565C0);
  static const _gold = Color(0xFFD4A843);

  String _selectedFilter = 'All Courses';

  final List<Map<String, dynamic>> _assignments = [
    {
      'title': 'Lexical Analyzer Implementation',
      'course': 'CS3501 - Compiler Design',
      'section': 'A',
      'dueDate': '28 Feb 2026',
      'submissions': 48,
      'total': 65,
      'status': 'Active',
      'type': 'Lab Assignment',
    },
    {
      'title': 'LL(1) Parser - Parsing Table Construction',
      'course': 'CS3501 - Compiler Design',
      'section': 'B',
      'dueDate': '01 Mar 2026',
      'submissions': 32,
      'total': 63,
      'status': 'Active',
      'type': 'Theory Assignment',
    },
    {
      'title': 'IoT Sensor Data Collection using MQTT',
      'course': 'CS3691 - Embedded Systems & IoT',
      'section': 'A',
      'dueDate': '05 Mar 2026',
      'submissions': 12,
      'total': 62,
      'status': 'Active',
      'type': 'Lab Assignment',
    },
    {
      'title': 'Divide & Conquer - Problem Set',
      'course': 'CS3401 - Algorithms Design & Analysis',
      'section': 'C',
      'dueDate': '26 Feb 2026',
      'submissions': 52,
      'total': 58,
      'status': 'Due Soon',
      'type': 'Theory Assignment',
    },
    {
      'title': 'LEX & YACC Integration Project',
      'course': 'CS3511 - Compiler Design Lab',
      'section': 'A',
      'dueDate': '10 Mar 2026',
      'submissions': 5,
      'total': 65,
      'status': 'Active',
      'type': 'Lab Assignment',
    },
    {
      'title': 'Regular Expression to NFA/DFA Conversion',
      'course': 'CS3501 - Compiler Design',
      'section': 'A',
      'dueDate': '15 Feb 2026',
      'submissions': 65,
      'total': 65,
      'status': 'Completed',
      'type': 'Theory Assignment',
    },
    {
      'title': 'Embedded C - GPIO Programming',
      'course': 'CS3691 - Embedded Systems & IoT',
      'section': 'A',
      'dueDate': '18 Feb 2026',
      'submissions': 60,
      'total': 62,
      'status': 'Graded',
      'type': 'Lab Assignment',
    },
    {
      'title': 'Asymptotic Analysis Practice Problems',
      'course': 'CS3401 - Algorithms Design & Analysis',
      'section': 'C',
      'dueDate': '10 Feb 2026',
      'submissions': 58,
      'total': 58,
      'status': 'Graded',
      'type': 'Theory Assignment',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Assignment Management', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Create Assignment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Create, manage and grade student assignments', style: TextStyle(color: Colors.white54, fontSize: 14)),
            const SizedBox(height: 20),

            // Summary Stats
            Row(
              children: [
                _AStat(label: 'Total', value: '${_assignments.length}', color: _accent),
                const SizedBox(width: 12),
                _AStat(label: 'Active', value: '${_assignments.where((a) => a['status'] == 'Active').length}', color: Colors.greenAccent),
                const SizedBox(width: 12),
                _AStat(label: 'Due Soon', value: '${_assignments.where((a) => a['status'] == 'Due Soon').length}', color: Colors.orangeAccent),
                const SizedBox(width: 12),
                _AStat(label: 'Graded', value: '${_assignments.where((a) => a['status'] == 'Graded').length}', color: _gold),
              ],
            ),
            const SizedBox(height: 20),

            // Filter
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: _card,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedFilter,
                      dropdownColor: _card,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      items: ['All Courses', 'CS3501', 'CS3691', 'CS3511', 'CS3401'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (v) => setState(() => _selectedFilter = v!),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ...['All', 'Active', 'Due Soon', 'Graded'].map((f) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(f, style: const TextStyle(fontSize: 12)),
                    selected: false,
                    selectedColor: _accent.withOpacity(0.2),
                    backgroundColor: _card,
                    side: BorderSide(color: _border),
                    labelStyle: const TextStyle(color: Colors.white70),
                    onSelected: (_) {},
                  ),
                )),
              ],
            ),
            const SizedBox(height: 20),

            // Assignments List
            ..._assignments.map((a) {
              final status = a['status'] as String;
              Color statusColor = _accent;
              if (status == 'Active') statusColor = Colors.greenAccent;
              if (status == 'Due Soon') statusColor = Colors.orangeAccent;
              if (status == 'Completed') statusColor = Colors.blueAccent;
              if (status == 'Graded') statusColor = _gold;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: _card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(a['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                          child: Text(status, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _AInfo(icon: Icons.menu_book, text: a['course'] as String),
                        const SizedBox(width: 16),
                        _AInfo(icon: Icons.group, text: 'Section ${a['section']}'),
                        const SizedBox(width: 16),
                        _AInfo(icon: Icons.calendar_today, text: 'Due: ${a['dueDate']}'),
                        const SizedBox(width: 16),
                        _AInfo(icon: Icons.category, text: a['type'] as String),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Submissions: ${a['submissions']}/${a['total']}', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                                  Text('${((a['submissions'] as int) / (a['total'] as int) * 100).toStringAsFixed(0)}%', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: (a['submissions'] as int) / (a['total'] as int),
                                backgroundColor: Colors.white10,
                                valueColor: AlwaysStoppedAnimation(statusColor),
                                minHeight: 5,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _accent,
                            side: BorderSide(color: _accent.withOpacity(0.4)),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          ),
                          child: const Text('View Submissions', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _AStat extends StatelessWidget {
  final String label, value;
  final Color color;
  const _AStat({required this.label, required this.value, required this.color});

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
        child: Column(
          children: [
            Text(value, style: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _AInfo extends StatelessWidget {
  final IconData icon;
  final String text;
  const _AInfo({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.white38),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }
}
