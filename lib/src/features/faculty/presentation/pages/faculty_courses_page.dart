import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class FacultyCoursesPage extends StatelessWidget {
  const FacultyCoursesPage({super.key});

  static const _bg = AppColors.background;
  static const _card = AppColors.surface;
  static const _border = AppColors.border;
  static const _accent = AppColors.primary;
  static const _gold = AppColors.accent;

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('My Courses', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: _accent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text('Even Semester 2025-26', style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Courses assigned for the current semester', style: TextStyle(color: AppColors.textLight, fontSize: 14)),
                const SizedBox(height: 20),

                // Summary stats
                Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: [
                    _MiniStat(label: 'Total Courses', value: '4', icon: Icons.menu_book, color: _accent),
                    _MiniStat(label: 'Theory', value: '3', icon: Icons.book, color: Colors.teal),
                    _MiniStat(label: 'Lab', value: '1', icon: Icons.computer, color: _gold),
                    _MiniStat(label: 'Total Students', value: '248', icon: Icons.people, color: Colors.orange),
                    _MiniStat(label: 'Total Hours/Week', value: '18', icon: Icons.access_time, color: Colors.purple),
                  ],
                ),
                const SizedBox(height: 24),

                // Course Cards
                _CourseCard(
                  code: 'CS3501',
                  name: 'Compiler Design',
                  semester: '5th Semester',
                  sections: const ['A', 'B'],
                  students: 128,
                  credits: 4,
                  hoursPerWeek: 5,
                  type: 'Theory',
                  syllabusProgress: 0.45,
                  avgAttendance: 84.2,
                  color: _accent,
                  isMobile: isMobile,
                ),
                const SizedBox(height: 14),
                _CourseCard(
                  code: 'CS3691',
                  name: 'Embedded Systems & IoT',
                  semester: '6th Semester',
                  sections: const ['A'],
                  students: 62,
                  credits: 3,
                  hoursPerWeek: 4,
                  type: 'Theory',
                  syllabusProgress: 0.38,
                  avgAttendance: 79.5,
                  color: Colors.teal,
                  isMobile: isMobile,
                ),
                const SizedBox(height: 14),
                _CourseCard(
                  code: 'CS3511',
                  name: 'Compiler Design Laboratory',
                  semester: '5th Semester',
                  sections: const ['A'],
                  students: 65,
                  credits: 2,
                  hoursPerWeek: 4,
                  type: 'Lab',
                  syllabusProgress: 0.50,
                  avgAttendance: 91.0,
                  color: _gold,
                  isMobile: isMobile,
                ),
                const SizedBox(height: 14),
                _CourseCard(
                  code: 'CS3401',
                  name: 'Algorithms Design & Analysis',
                  semester: '4th Semester',
                  sections: const ['C'],
                  students: 58,
                  credits: 4,
                  hoursPerWeek: 5,
                  type: 'Theory',
                  syllabusProgress: 0.42,
                  avgAttendance: 81.7,
                  color: Colors.orange,
                  isMobile: isMobile,
                ),
                const SizedBox(height: 24),

                // Course Details Table
                const Text('Course Details Summary', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _border),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(const Color(0xFF1A2A4A)),
                      columns: const [
                        DataColumn(label: Text('Code', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 13))),
                        DataColumn(label: Text('Course Name', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 13))),
                        DataColumn(label: Text('Sem', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 13))),
                        DataColumn(label: Text('Section', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 13))),
                        DataColumn(label: Text('Students', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 13))),
                        DataColumn(label: Text('Credits', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 13))),
                        DataColumn(label: Text('Type', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 13))),
                      ],
                      rows: const [
                        DataRow(cells: [
                          DataCell(Text('CS3501', style: TextStyle(color: AppColors.textMedium, fontSize: 13))),
                          DataCell(Text('Compiler Design', style: TextStyle(color: AppColors.textDark, fontSize: 13))),
                          DataCell(Text('V', style: TextStyle(color: AppColors.textMedium, fontSize: 13))),
                          DataCell(Text('A, B', style: TextStyle(color: AppColors.textMedium, fontSize: 13))),
                          DataCell(Text('128', style: TextStyle(color: AppColors.textMedium, fontSize: 13))),
                          DataCell(Text('4', style: TextStyle(color: AppColors.textMedium, fontSize: 13))),
                          DataCell(Text('Theory', style: TextStyle(color: AppColors.textMedium, fontSize: 13))),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('CS3691', style: TextStyle(color: AppColors.textMedium, fontSize: 13))),
                          DataCell(Text('Embedded Systems & IoT', style: TextStyle(color: AppColors.textDark, fontSize: 13))),
                          DataCell(Text('VI', style: TextStyle(color: AppColors.textMedium, fontSize: 13))),
                          DataCell(Text('A', style: TextStyle(color: AppColors.textMedium, fontSize: 13))),
                          DataCell(Text('62', style: TextStyle(color: AppColors.textMedium, fontSize: 13))),
                          DataCell(Text('3', style: TextStyle(color: AppColors.textMedium, fontSize: 13))),
                          DataCell(Text('Theory', style: TextStyle(color: AppColors.textMedium, fontSize: 13))),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('CS3511', style: TextStyle(color: AppColors.textMedium, fontSize: 13))),
                          DataCell(Text('Compiler Design Lab', style: TextStyle(color: AppColors.textDark, fontSize: 13))),
                          DataCell(Text('V', style: TextStyle(color: AppColors.textMedium, fontSize: 13))),
                          DataCell(Text('A', style: TextStyle(color: AppColors.textMedium, fontSize: 13))),
                          DataCell(Text('65', style: TextStyle(color: AppColors.textMedium, fontSize: 13))),
                          DataCell(Text('2', style: TextStyle(color: AppColors.textMedium, fontSize: 13))),
                          DataCell(Text('Lab', style: TextStyle(color: AppColors.textMedium, fontSize: 13))),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('CS3401', style: TextStyle(color: AppColors.textMedium, fontSize: 13))),
                          DataCell(Text('Algorithms Design & Analysis', style: TextStyle(color: AppColors.textDark, fontSize: 13))),
                          DataCell(Text('IV', style: TextStyle(color: AppColors.textMedium, fontSize: 13))),
                          DataCell(Text('C', style: TextStyle(color: AppColors.textMedium, fontSize: 13))),
                          DataCell(Text('58', style: TextStyle(color: AppColors.textMedium, fontSize: 13))),
                          DataCell(Text('4', style: TextStyle(color: AppColors.textMedium, fontSize: 13))),
                          DataCell(Text('Theory', style: TextStyle(color: AppColors.textMedium, fontSize: 13))),
                        ]),
                      ],
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

class _MiniStat extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _MiniStat({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 155,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Text(label, style: const TextStyle(color: AppColors.textLight, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final String code, name, semester, type;
  final List<String> sections;
  final int students, credits, hoursPerWeek;
  final double syllabusProgress, avgAttendance;
  final Color color;
  final bool isMobile;
  const _CourseCard({
    required this.code, required this.name, required this.semester, required this.type,
    required this.sections, required this.students, required this.credits, required this.hoursPerWeek,
    required this.syllabusProgress, required this.avgAttendance, required this.color,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final infoItems = [
      _CourseInfo(icon: Icons.group, text: 'Section ${sections.join(", ")}'),
      _CourseInfo(icon: Icons.people, text: '$students Students'),
      _CourseInfo(icon: Icons.star, text: '$credits Credits'),
      _CourseInfo(icon: Icons.access_time, text: '$hoursPerWeek Hrs/Week'),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                child: Text(code, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
                child: Text(type, style: TextStyle(color: type == 'Lab' ? AppColors.accent : Colors.white70, fontSize: 12)),
              ),
              const Spacer(),
              Text(semester, style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 12),
          Text(name, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          isMobile
              ? Wrap(
                  spacing: 20,
                  runSpacing: 8,
                  children: infoItems,
                )
              : Row(
                  children: [
                    infoItems[0],
                    const SizedBox(width: 20),
                    infoItems[1],
                    const SizedBox(width: 20),
                    infoItems[2],
                    const SizedBox(width: 20),
                    infoItems[3],
                  ],
                ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Syllabus Progress', style: TextStyle(color: AppColors.textLight, fontSize: 12)),
                        Text('${(syllabusProgress * 100).toInt()}%', style: const TextStyle(color: AppColors.textMedium, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: syllabusProgress,
                      backgroundColor: AppColors.border,
                      valueColor: AlwaysStoppedAnimation(color),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Avg Attendance', style: TextStyle(color: AppColors.textLight, fontSize: 12)),
                  Text('${avgAttendance.toStringAsFixed(1)}%',
                    style: TextStyle(color: avgAttendance >= 80 ? Colors.greenAccent : Colors.orangeAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CourseInfo extends StatelessWidget {
  final IconData icon;
  final String text;
  const _CourseInfo({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textLight),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
      ],
    );
  }
}
