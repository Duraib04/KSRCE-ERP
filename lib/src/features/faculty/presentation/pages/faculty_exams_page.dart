import 'package:flutter/material.dart';

class FacultyExamsPage extends StatelessWidget {
  const FacultyExamsPage({super.key});

  static const _bg = Color(0xFF0D1F3C);
  static const _card = Color(0xFF111D35);
  static const _border = Color(0xFF1E3055);
  static const _accent = Color(0xFF1565C0);
  static const _gold = Color(0xFFD4A843);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Exam Management', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Manage exams, question papers, and invigilation duties', style: TextStyle(color: Colors.white54, fontSize: 14)),
            const SizedBox(height: 24),

            // Upcoming Exams
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Upcoming Exams Schedule', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.upload_file, size: 16),
                  label: const Text('Upload Question Paper'),
                  style: ElevatedButton.styleFrom(backgroundColor: _accent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _ExamCard(
              title: 'Internal Assessment - II',
              course: 'CS3501 - Compiler Design',
              date: '03 Mar 2026',
              time: '09:30 AM - 11:00 AM',
              duration: '1.5 Hours',
              maxMarks: '50',
              sections: 'A, B',
              status: 'Upcoming',
              qpStatus: 'Submitted',
              color: _accent,
            ),
            const SizedBox(height: 10),
            _ExamCard(
              title: 'Internal Assessment - II',
              course: 'CS3691 - Embedded Systems & IoT',
              date: '04 Mar 2026',
              time: '09:30 AM - 11:00 AM',
              duration: '1.5 Hours',
              maxMarks: '50',
              sections: 'A',
              status: 'Upcoming',
              qpStatus: 'Draft',
              color: Colors.teal,
            ),
            const SizedBox(height: 10),
            _ExamCard(
              title: 'Internal Assessment - II',
              course: 'CS3401 - Algorithms Design & Analysis',
              date: '05 Mar 2026',
              time: '02:00 PM - 03:30 PM',
              duration: '1.5 Hours',
              maxMarks: '50',
              sections: 'C',
              status: 'Upcoming',
              qpStatus: 'Pending',
              color: Colors.orange,
            ),
            const SizedBox(height: 10),
            _ExamCard(
              title: 'Model Examination',
              course: 'CS3501 - Compiler Design',
              date: '20 Apr 2026',
              time: '09:30 AM - 12:30 PM',
              duration: '3 Hours',
              maxMarks: '100',
              sections: 'A, B',
              status: 'Scheduled',
              qpStatus: 'Not Started',
              color: _gold,
            ),
            const SizedBox(height: 28),

            // Invigilation Duties
            const Text('Invigilation Duties', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(const Color(0xFF1A2A4A)),
                columns: const [
                  DataColumn(label: Text('Date', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Session', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Time', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Room', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Course (Exam)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Students', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Co-Invigilator', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text('03 Mar', style: TextStyle(color: Colors.white70, fontSize: 13))),
                    DataCell(Text('FN', style: TextStyle(color: Colors.white70, fontSize: 13))),
                    DataCell(Text('09:30 - 11:00', style: TextStyle(color: Colors.white70, fontSize: 13))),
                    DataCell(Text('Exam Hall 3', style: TextStyle(color: Colors.white, fontSize: 13))),
                    DataCell(Text('CS3501 - Compiler Design', style: TextStyle(color: Colors.white, fontSize: 13))),
                    DataCell(Text('30', style: TextStyle(color: Colors.white70, fontSize: 13))),
                    DataCell(Text('Dr. S. Priya', style: TextStyle(color: Colors.white54, fontSize: 13))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('05 Mar', style: TextStyle(color: Colors.white70, fontSize: 13))),
                    DataCell(Text('AN', style: TextStyle(color: Colors.white70, fontSize: 13))),
                    DataCell(Text('14:00 - 15:30', style: TextStyle(color: Colors.white70, fontSize: 13))),
                    DataCell(Text('Exam Hall 1', style: TextStyle(color: Colors.white, fontSize: 13))),
                    DataCell(Text('MA3351 - Transforms & PDE (Mech)', style: TextStyle(color: Colors.white, fontSize: 13))),
                    DataCell(Text('28', style: TextStyle(color: Colors.white70, fontSize: 13))),
                    DataCell(Text('Prof. K. Ramesh', style: TextStyle(color: Colors.white54, fontSize: 13))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('07 Mar', style: TextStyle(color: Colors.white70, fontSize: 13))),
                    DataCell(Text('FN', style: TextStyle(color: Colors.white70, fontSize: 13))),
                    DataCell(Text('09:30 - 11:00', style: TextStyle(color: Colors.white70, fontSize: 13))),
                    DataCell(Text('Exam Hall 5', style: TextStyle(color: Colors.white, fontSize: 13))),
                    DataCell(Text('CS3691 - Embedded Systems & IoT', style: TextStyle(color: Colors.white, fontSize: 13))),
                    DataCell(Text('32', style: TextStyle(color: Colors.white70, fontSize: 13))),
                    DataCell(Text('Dr. M. Anitha', style: TextStyle(color: Colors.white54, fontSize: 13))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('10 Mar', style: TextStyle(color: Colors.white70, fontSize: 13))),
                    DataCell(Text('FN', style: TextStyle(color: Colors.white70, fontSize: 13))),
                    DataCell(Text('09:30 - 11:00', style: TextStyle(color: Colors.white70, fontSize: 13))),
                    DataCell(Text('Exam Hall 2', style: TextStyle(color: Colors.white, fontSize: 13))),
                    DataCell(Text('EC3501 - VLSI Design (ECE)', style: TextStyle(color: Colors.white, fontSize: 13))),
                    DataCell(Text('35', style: TextStyle(color: Colors.white70, fontSize: 13))),
                    DataCell(Text('Dr. P. Venkatesh', style: TextStyle(color: Colors.white54, fontSize: 13))),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Hall Ticket Status
            const Text('Hall Ticket Generation Status', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                _HallTicketStat(course: 'CS3501 (Sec A)', eligible: 60, detained: 5, total: 65, color: _accent),
                _HallTicketStat(course: 'CS3501 (Sec B)', eligible: 59, detained: 4, total: 63, color: _accent),
                _HallTicketStat(course: 'CS3691 (Sec A)', eligible: 56, detained: 6, total: 62, color: Colors.teal),
                _HallTicketStat(course: 'CS3401 (Sec C)', eligible: 54, detained: 4, total: 58, color: Colors.orange),
              ],
            ),
            const SizedBox(height: 24),

            // Question Paper Status
            const Text('Question Paper Status', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(const Color(0xFF1A2A4A)),
                columns: const [
                  DataColumn(label: Text('Course', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Exam', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Status', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Deadline', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Action', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                ],
                rows: [
                  _qpRow('CS3501', 'IA-II', 'Submitted', '28 Feb', Colors.greenAccent),
                  _qpRow('CS3691', 'IA-II', 'Draft', '28 Feb', Colors.orangeAccent),
                  _qpRow('CS3401', 'IA-II', 'Pending', '28 Feb', Colors.redAccent),
                  _qpRow('CS3501', 'Model', 'Not Started', '15 Apr', Colors.white30),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  DataRow _qpRow(String course, String exam, String status, String deadline, Color color) {
    return DataRow(cells: [
      DataCell(Text(course, style: const TextStyle(color: Colors.white, fontSize: 13))),
      DataCell(Text(exam, style: const TextStyle(color: Colors.white70, fontSize: 13))),
      DataCell(Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
        child: Text(status, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
      )),
      DataCell(Text(deadline, style: const TextStyle(color: Colors.white54, fontSize: 13))),
      DataCell(TextButton(onPressed: () {}, child: Text(status == 'Submitted' ? 'View' : 'Upload', style: TextStyle(color: _accent, fontSize: 12)))),
    ]);
  }
}

class _ExamCard extends StatelessWidget {
  final String title, course, date, time, duration, maxMarks, sections, status, qpStatus;
  final Color color;
  const _ExamCard({required this.title, required this.course, required this.date, required this.time,
    required this.duration, required this.maxMarks, required this.sections, required this.status,
    required this.qpStatus, required this.color});

  @override
  Widget build(BuildContext context) {
    Color qpColor = Colors.white30;
    if (qpStatus == 'Submitted') qpColor = Colors.greenAccent;
    if (qpStatus == 'Draft') qpColor = Colors.orangeAccent;
    if (qpStatus == 'Pending') qpColor = Colors.redAccent;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: const Color(0xFF111D35), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF1E3055))),
      child: Row(
        children: [
          Container(width: 4, height: 70, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                const SizedBox(height: 2),
                Text(course, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _ExInfo(Icons.calendar_today, date),
                    const SizedBox(width: 16),
                    _ExInfo(Icons.access_time, time),
                    const SizedBox(width: 16),
                    _ExInfo(Icons.timer, duration),
                    const SizedBox(width: 16),
                    _ExInfo(Icons.score, 'Max: $maxMarks'),
                    const SizedBox(width: 16),
                    _ExInfo(Icons.group, 'Sec $sections'),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                child: Text(status, style: TextStyle(color: color, fontSize: 12))),
              const SizedBox(height: 6),
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: qpColor.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                child: Text('QP: $qpStatus', style: TextStyle(color: qpColor, fontSize: 11))),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExInfo extends StatelessWidget {
  final IconData icon;
  final String text;
  const _ExInfo(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: Colors.white38),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }
}

class _HallTicketStat extends StatelessWidget {
  final String course;
  final int eligible, detained, total;
  final Color color;
  const _HallTicketStat({required this.course, required this.eligible, required this.detained, required this.total, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF111D35), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF1E3055))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(course, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(children: [
                Text('$eligible', style: const TextStyle(color: Colors.greenAccent, fontSize: 20, fontWeight: FontWeight.bold)),
                const Text('Eligible', style: TextStyle(color: Colors.white54, fontSize: 11)),
              ]),
              Column(children: [
                Text('$detained', style: const TextStyle(color: Colors.redAccent, fontSize: 20, fontWeight: FontWeight.bold)),
                const Text('Detained', style: TextStyle(color: Colors.white54, fontSize: 11)),
              ]),
              Column(children: [
                Text('$total', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const Text('Total', style: TextStyle(color: Colors.white54, fontSize: 11)),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
