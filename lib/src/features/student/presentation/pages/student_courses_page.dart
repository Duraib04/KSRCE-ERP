import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class StudentCoursesPage extends StatelessWidget {
  const StudentCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;
          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.menu_book, color: AppColors.primary, size: 28),
                    SizedBox(width: 12),
                    Text('My Courses', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Semester 5 - Academic Year 2025-26', style: TextStyle(color: AppColors.textLight, fontSize: 14)),
                const SizedBox(height: 24),
                _buildCourseSummary(),
                const SizedBox(height: 24),
                ..._buildCourseCards(isMobile),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCourseSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryItem('Total Courses', '6', Icons.book),
          _summaryItem('Theory', '4', Icons.class_),
          _summaryItem('Lab', '2', Icons.computer),
          _summaryItem('Total Credits', '23', Icons.stars),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        Text(label, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
      ],
    );
  }

  List<Widget> _buildCourseCards(bool isMobile) {
    final courses = [
      {
        'code': 'CS3501',
        'name': 'Compiler Design',
        'faculty': 'Dr. K. Ramesh',
        'credits': '4',
        'type': 'Theory',
        'hours': '4 hrs/week',
        'dept': 'CSE',
        'description': 'Lexical Analysis, Syntax Analysis, Intermediate Code Generation, Code Optimization, Code Generation',
      },
      {
        'code': 'CS3591',
        'name': 'Computer Networks',
        'faculty': 'Prof. S. Lakshmi',
        'credits': '4',
        'type': 'Theory',
        'hours': '4 hrs/week',
        'dept': 'CSE',
        'description': 'OSI Model, TCP/IP, Routing Algorithms, Network Security, Application Layer Protocols',
      },
      {
        'code': 'CS3551',
        'name': 'Distributed Computing',
        'faculty': 'Dr. M. Venkatesh',
        'credits': '3',
        'type': 'Theory',
        'hours': '3 hrs/week',
        'dept': 'CSE',
        'description': 'Distributed Systems, Mutual Exclusion, Deadlock Detection, Agreement Protocols, Fault Tolerance',
      },
      {
        'code': 'MA3391',
        'name': 'Probability and Statistics',
        'faculty': 'Dr. P. Anitha',
        'credits': '4',
        'type': 'Theory',
        'hours': '4 hrs/week',
        'dept': 'Mathematics',
        'description': 'Random Variables, Distributions, Testing of Hypothesis, Regression, Queuing Theory',
      },
      {
        'code': 'CS3512',
        'name': 'Compiler Design Laboratory',
        'faculty': 'Dr. K. Ramesh',
        'credits': '4',
        'type': 'Lab',
        'hours': '4 hrs/week',
        'dept': 'CSE',
        'description': 'Lexer implementation, Parser construction using Yacc, Intermediate code generation, Code optimization',
      },
      {
        'code': 'CS3592',
        'name': 'Computer Networks Laboratory',
        'faculty': 'Prof. S. Lakshmi',
        'credits': '4',
        'type': 'Lab',
        'hours': '4 hrs/week',
        'dept': 'CSE',
        'description': 'Socket Programming, TCP/UDP, Network simulation using NS2, Routing protocols, Wireshark analysis',
      },
    ];

    return courses.map((c) => Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: c['type'] == 'Lab' ? Colors.teal.withOpacity(0.2) : AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(c['code']!, style: TextStyle(
                  color: c['type'] == 'Lab' ? Colors.tealAccent : const Color(0xFF64B5F6),
                  fontWeight: FontWeight.bold, fontSize: 14,
                )),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(c['name']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: c['type'] == 'Lab' ? Colors.teal.withOpacity(0.15) : Colors.blue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(c['type']!, style: TextStyle(color: c['type'] == 'Lab' ? Colors.tealAccent : Colors.blue[200], fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(c['description']!, style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
          const SizedBox(height: 12),
          isMobile
              ? Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _iconText(Icons.person, c['faculty']!),
                    _iconText(Icons.stars, '${c['credits']} Credits'),
                    _iconText(Icons.schedule, c['hours']!),
                    _iconText(Icons.business, c['dept']!),
                  ],
                )
              : Row(
                  children: [
                    const Icon(Icons.person, color: AppColors.textLight, size: 16),
                    const SizedBox(width: 6),
                    Text(c['faculty']!, style: const TextStyle(color: AppColors.textMedium, fontSize: 13)),
                    const SizedBox(width: 24),
                    const Icon(Icons.stars, color: AppColors.textLight, size: 16),
                    const SizedBox(width: 6),
                    Text('${c['credits']} Credits', style: const TextStyle(color: AppColors.textMedium, fontSize: 13)),
                    const SizedBox(width: 24),
                    const Icon(Icons.schedule, color: AppColors.textLight, size: 16),
                    const SizedBox(width: 6),
                    Text(c['hours']!, style: const TextStyle(color: AppColors.textMedium, fontSize: 13)),
                    const SizedBox(width: 24),
                    const Icon(Icons.business, color: AppColors.textLight, size: 16),
                    const SizedBox(width: 6),
                    Text(c['dept']!, style: const TextStyle(color: AppColors.textMedium, fontSize: 13)),
                  ],
                ),
        ],
      ),
    )).toList();
  }

  Widget _iconText(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.textLight, size: 16),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: AppColors.textMedium, fontSize: 13)),
      ],
    );
  }
}
