import 'package:flutter/material.dart';

class FacultyReportsPage extends StatelessWidget {
  const FacultyReportsPage({super.key});

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Reports & Analytics', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.picture_as_pdf, size: 16),
                      label: const Text('Export PDF'),
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent, side: const BorderSide(color: Colors.redAccent)),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.table_chart, size: 16),
                      label: const Text('Export Excel'),
                      style: OutlinedButton.styleFrom(foregroundColor: _gold, side: BorderSide(color: _gold.withOpacity(0.5))),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Course-wise attendance, result analysis, and performance trends', style: TextStyle(color: Colors.white54, fontSize: 14)),
            const SizedBox(height: 24),

            // Course-wise Attendance Report
            const Text('Course-wise Attendance Summary', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(const Color(0xFF1A2A4A)),
                columns: const [
                  DataColumn(label: Text('Course', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Section', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Total Students', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Avg Attendance', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Above 90%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('75-90%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Below 75%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Classes Held', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                ],
                rows: [
                  _attendanceRow('CS3501', 'A', '65', '84.2%', '28', '29', '8', '32', Colors.greenAccent),
                  _attendanceRow('CS3501', 'B', '63', '81.5%', '24', '30', '9', '32', Colors.orangeAccent),
                  _attendanceRow('CS3691', 'A', '62', '79.5%', '18', '32', '12', '28', Colors.orangeAccent),
                  _attendanceRow('CS3511', 'A', '65', '91.0%', '48', '14', '3', '14', Colors.greenAccent),
                  _attendanceRow('CS3401', 'C', '58', '81.7%', '22', '28', '8', '30', Colors.orangeAccent),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Attendance Trends (Mock Visual)
            const Text('Monthly Attendance Trends', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _MonthBar(month: 'Jan', value: 88, color: _accent),
                      _MonthBar(month: 'Feb', value: 84, color: _accent),
                      _MonthBar(month: 'Mar', value: 0, color: Colors.white12),
                      _MonthBar(month: 'Apr', value: 0, color: Colors.white12),
                      _MonthBar(month: 'May', value: 0, color: Colors.white12),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 12, height: 12, decoration: BoxDecoration(color: _accent, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 6),
                      const Text('Avg Attendance %', style: TextStyle(color: Colors.white54, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Result Analysis
            const Text('Internal Assessment Result Analysis', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _ResultCard(course: 'CS3501 (Sec A)', passPercent: 90.8, avgMark: 34.2, highest: 48, lowest: 12, maxMark: 50, color: _accent)),
                const SizedBox(width: 14),
                Expanded(child: _ResultCard(course: 'CS3501 (Sec B)', passPercent: 87.3, avgMark: 32.5, highest: 47, lowest: 10, maxMark: 50, color: _accent)),
                const SizedBox(width: 14),
                Expanded(child: _ResultCard(course: 'CS3691 (Sec A)', passPercent: 85.5, avgMark: 31.8, highest: 46, lowest: 14, maxMark: 50, color: Colors.teal)),
                const SizedBox(width: 14),
                Expanded(child: _ResultCard(course: 'CS3401 (Sec C)', passPercent: 89.7, avgMark: 33.1, highest: 49, lowest: 11, maxMark: 50, color: Colors.orange)),
              ],
            ),
            const SizedBox(height: 28),

            // Grade Distribution
            const Text('Grade Distribution - CS3501 (IA-I)', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _GDist(grade: 'O (91-100%)', count: 8, pct: '12.3%', color: Colors.greenAccent),
                  _GDist(grade: 'A+ (81-90%)', count: 12, pct: '18.5%', color: Colors.lightGreenAccent),
                  _GDist(grade: 'A (71-80%)', count: 15, pct: '23.1%', color: _accent),
                  _GDist(grade: 'B+ (61-70%)', count: 10, pct: '15.4%', color: Colors.cyan),
                  _GDist(grade: 'B (51-60%)', count: 8, pct: '12.3%', color: Colors.orange),
                  _GDist(grade: 'C (41-50%)', count: 5, pct: '7.7%', color: Colors.orangeAccent),
                  _GDist(grade: 'Below 40%', count: 7, pct: '10.8%', color: Colors.redAccent),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Student Performance Trends
            const Text('Students Requiring Attention', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Students with low attendance OR low marks across courses', style: TextStyle(color: Colors.white54, fontSize: 13)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(const Color(0xFF1A2A4A)),
                columns: const [
                  DataColumn(label: Text('Roll No', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Attendance', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('IA-I Marks', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Risk Level', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Remarks', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                ],
                rows: [
                  _riskRow('CS112', 'Pavithra S', '65.8%', '15/50', 'High', 'Both attendance & marks below threshold'),
                  _riskRow('CS107', 'Janani S', '68.9%', '18/50', 'High', 'Attendance shortage, low marks'),
                  _riskRow('CS104', 'Deepika V', '71.2%', '22/50', 'Medium', 'Attendance below 75%'),
                  _riskRow('CS117', 'Vignesh S', '72.5%', '24/50', 'Medium', 'Attendance below 75%'),
                  _riskRow('CS110', 'Manikandan T', '76.3%', '28/50', 'Low', 'Marks below class average'),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  DataRow _attendanceRow(String course, String section, String total, String avg, String above90, String mid, String below75, String classes, Color color) {
    return DataRow(cells: [
      DataCell(Text(course, style: const TextStyle(color: Colors.white, fontSize: 13))),
      DataCell(Text(section, style: const TextStyle(color: Colors.white70, fontSize: 13))),
      DataCell(Text(total, style: const TextStyle(color: Colors.white70, fontSize: 13))),
      DataCell(Text(avg, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold))),
      DataCell(Text(above90, style: const TextStyle(color: Colors.greenAccent, fontSize: 13))),
      DataCell(Text(mid, style: const TextStyle(color: Colors.orangeAccent, fontSize: 13))),
      DataCell(Text(below75, style: const TextStyle(color: Colors.redAccent, fontSize: 13))),
      DataCell(Text(classes, style: const TextStyle(color: Colors.white54, fontSize: 13))),
    ]);
  }

  DataRow _riskRow(String roll, String name, String att, String marks, String risk, String remarks) {
    Color riskColor = Colors.greenAccent;
    if (risk == 'High') riskColor = Colors.redAccent;
    if (risk == 'Medium') riskColor = Colors.orangeAccent;

    return DataRow(cells: [
      DataCell(Text(roll, style: const TextStyle(color: Colors.white70, fontSize: 13))),
      DataCell(Text(name, style: const TextStyle(color: Colors.white, fontSize: 13))),
      DataCell(Text(att, style: const TextStyle(color: Colors.redAccent, fontSize: 13))),
      DataCell(Text(marks, style: const TextStyle(color: Colors.redAccent, fontSize: 13))),
      DataCell(Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(color: riskColor.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
        child: Text(risk, style: TextStyle(color: riskColor, fontSize: 11, fontWeight: FontWeight.w500)),
      )),
      DataCell(Text(remarks, style: const TextStyle(color: Colors.white54, fontSize: 12))),
    ]);
  }
}

class _MonthBar extends StatelessWidget {
  final String month;
  final double value;
  final Color color;
  const _MonthBar({required this.month, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (value > 0) Text('${value.toInt()}%', style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          width: 40,
          height: value > 0 ? value * 1.5 : 20,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(height: 6),
        Text(month, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  final String course;
  final double passPercent, avgMark;
  final int highest, lowest, maxMark;
  final Color color;
  const _ResultCard({required this.course, required this.passPercent, required this.avgMark,
    required this.highest, required this.lowest, required this.maxMark, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: const Color(0xFF111D35), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF1E3055))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(course, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _ResultItem('Pass %', '${passPercent.toStringAsFixed(1)}%', passPercent >= 90 ? Colors.greenAccent : Colors.orangeAccent),
          _ResultItem('Avg. Mark', '${avgMark.toStringAsFixed(1)}/$maxMark', Colors.white),
          _ResultItem('Highest', '$highest/$maxMark', Colors.greenAccent),
          _ResultItem('Lowest', '$lowest/$maxMark', Colors.redAccent),
        ],
      ),
    );
  }
}

class _ResultItem extends StatelessWidget {
  final String label, value;
  final Color valueColor;
  const _ResultItem(this.label, this.value, this.valueColor);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
          Text(value, style: TextStyle(color: valueColor, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _GDist extends StatelessWidget {
  final String grade, pct;
  final int count;
  final Color color;
  const _GDist({required this.grade, required this.count, required this.pct, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$count', style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          width: 36,
          height: count.toDouble() * 5 + 10,
          decoration: BoxDecoration(color: color.withOpacity(0.6), borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(height: 6),
        Text(grade, style: const TextStyle(color: Colors.white54, fontSize: 10), textAlign: TextAlign.center),
        Text(pct, style: const TextStyle(color: Colors.white38, fontSize: 10)),
      ],
    );
  }
}
