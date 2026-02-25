import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class StudentExamsPage extends StatelessWidget {
  const StudentExamsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: const [
              Icon(Icons.event_note, color: AppColors.primary, size: 28),
              SizedBox(width: 12),
              Text('Exam Schedule', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            ]),
            const SizedBox(height: 8),
            const Text('Upcoming Internal & External Examinations', style: TextStyle(color: AppColors.textLight, fontSize: 14)),
            const SizedBox(height: 24),
            _buildNextExamCountdown(),
            const SizedBox(height: 24),
            _buildInternalExams(),
            const SizedBox(height: 24),
            _buildExternalExams(),
          ],
        ),
      ),
    );
  }

  Widget _buildNextExamCountdown() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primary]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer, color: Colors.white, size: 40),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Next Exam', style: TextStyle(color: AppColors.textMedium, fontSize: 14)),
              SizedBox(height: 4),
              Text('CS3501 - Compiler Design (Internal Assessment 2)', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Text('02 March 2026 | 09:30 AM | Room 301', style: TextStyle(color: AppColors.textMedium, fontSize: 14)),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: const [
                Text('6', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                Text('DAYS LEFT', style: TextStyle(color: AppColors.textMedium, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInternalExams() {
    final exams = [
      {'date': '02 Mar 2026', 'time': '09:30 AM', 'subject': 'CS3501 - Compiler Design', 'room': 'Room 301', 'type': 'IA-2', 'syllabus': 'Units 1-3'},
      {'date': '04 Mar 2026', 'time': '09:30 AM', 'subject': 'CS3591 - Computer Networks', 'room': 'Room 302', 'type': 'IA-2', 'syllabus': 'Units 1-3'},
      {'date': '06 Mar 2026', 'time': '09:30 AM', 'subject': 'CS3551 - Distributed Computing', 'room': 'Room 301', 'type': 'IA-2', 'syllabus': 'Units 1-3'},
      {'date': '09 Mar 2026', 'time': '09:30 AM', 'subject': 'MA3391 - Probability & Statistics', 'room': 'Room 201', 'type': 'IA-2', 'syllabus': 'Units 1-3'},
      {'date': '11 Mar 2026', 'time': '09:30 AM', 'subject': 'GE3591 - Environmental Science', 'room': 'Room 105', 'type': 'IA-2', 'syllabus': 'Units 1-3'},
    ];
    return _buildExamSection('Internal Assessment 2 - March 2026', exams, Colors.orange);
  }

  Widget _buildExternalExams() {
    final exams = [
      {'date': '20 Apr 2026', 'time': '10:00 AM', 'subject': 'MA3391 - Probability & Statistics', 'room': 'TBA', 'type': 'End Sem', 'syllabus': 'All Units'},
      {'date': '23 Apr 2026', 'time': '10:00 AM', 'subject': 'CS3501 - Compiler Design', 'room': 'TBA', 'type': 'End Sem', 'syllabus': 'All Units'},
      {'date': '27 Apr 2026', 'time': '10:00 AM', 'subject': 'CS3591 - Computer Networks', 'room': 'TBA', 'type': 'End Sem', 'syllabus': 'All Units'},
      {'date': '30 Apr 2026', 'time': '10:00 AM', 'subject': 'CS3551 - Distributed Computing', 'room': 'TBA', 'type': 'End Sem', 'syllabus': 'All Units'},
      {'date': '04 May 2026', 'time': '10:00 AM', 'subject': 'GE3591 - Environmental Science', 'room': 'TBA', 'type': 'End Sem', 'syllabus': 'All Units'},
    ];
    return _buildExamSection('End Semester Examination - April/May 2026', exams, Colors.redAccent);
  }

  Widget _buildExamSection(String title, List<Map<String, String>> exams, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(width: 4, height: 20, decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          ]),
          const SizedBox(height: 16),
          Table(
            columnWidths: const {
              0: FixedColumnWidth(110),
              1: FixedColumnWidth(90),
              2: FlexColumnWidth(2),
              3: FixedColumnWidth(90),
              4: FixedColumnWidth(80),
              5: FixedColumnWidth(90),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
                children: ['Date', 'Time', 'Subject', 'Room', 'Type', 'Syllabus'].map((h) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(h, style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 13)),
                )).toList(),
              ),
              ...exams.map((e) => TableRow(
                children: [
                  Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(e['date']!, style: const TextStyle(color: AppColors.textDark, fontSize: 13))),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(e['time']!, style: const TextStyle(color: AppColors.textMedium, fontSize: 13))),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(e['subject']!, style: const TextStyle(color: AppColors.textDark, fontSize: 13))),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(e['room']!, style: const TextStyle(color: AppColors.textLight, fontSize: 13))),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: accentColor.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                    child: Text(e['type']!, style: TextStyle(color: accentColor, fontSize: 11, fontWeight: FontWeight.bold)),
                  )),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(e['syllabus']!, style: const TextStyle(color: AppColors.textLight, fontSize: 13))),
                ],
              )),
            ],
          ),
        ],
      ),
    );
  }
}
