import 'package:flutter/material.dart';
import 'dart:math';

class StudentAttendancePage extends StatelessWidget {
  const StudentAttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1F3C),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;
          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: const [
                  Icon(Icons.fact_check, color: Color(0xFFD4A843), size: 28),
                  SizedBox(width: 12),
                  Text('Attendance', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                ]),
                const SizedBox(height: 8),
                const Text('Semester 5 - Academic Year 2025-26', style: TextStyle(color: Colors.white60, fontSize: 14)),
                const SizedBox(height: 24),
                if (isMobile)
                  Column(
                    children: [
                      _buildOverallAttendance(),
                      const SizedBox(height: 24),
                      _buildAttendanceSummary(),
                    ],
                  )
                else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 1, child: _buildOverallAttendance()),
                      const SizedBox(width: 24),
                      Expanded(flex: 1, child: _buildAttendanceSummary()),
                    ],
                  ),
                const SizedBox(height: 24),
                _buildSubjectWiseTable(),
                const SizedBox(height: 24),
                _buildAttendanceNote(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverallAttendance() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF111D35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E3055)),
      ),
      child: Column(
        children: [
          const Text('Overall Attendance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 24),
          SizedBox(
            width: 160,
            height: 160,
            child: CustomPaint(
              painter: _CircularProgressPainter(0.87),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('87%', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.green)),
                    Text('Present', style: TextStyle(color: Colors.white54, fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _statItem('Total Classes', '284', Colors.white),
              _statItem('Present', '247', Colors.green),
              _statItem('Absent', '37', Colors.redAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }

  Widget _buildAttendanceSummary() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF111D35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E3055)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Monthly Trend', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          _monthRow('August 2025', 92),
          _monthRow('September 2025', 88),
          _monthRow('October 2025', 85),
          _monthRow('November 2025', 90),
          _monthRow('December 2025', 82),
          _monthRow('January 2026', 86),
          _monthRow('February 2026', 89),
        ],
      ),
    );
  }

  Widget _monthRow(String month, int pct) {
    Color color = pct >= 85 ? Colors.green : pct >= 75 ? Colors.orange : Colors.redAccent;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(width: 140, child: Text(month, style: const TextStyle(color: Colors.white70, fontSize: 13))),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(value: pct / 100, backgroundColor: const Color(0xFF1E3055), valueColor: AlwaysStoppedAnimation(color), minHeight: 8),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(width: 40, child: Text('$pct%', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildSubjectWiseTable() {
    final subjects = [
      {'code': 'CS3501', 'name': 'Compiler Design', 'present': 42, 'total': 48, 'pct': 87.5},
      {'code': 'CS3591', 'name': 'Computer Networks', 'present': 44, 'total': 50, 'pct': 88.0},
      {'code': 'CS3551', 'name': 'Distributed Computing', 'present': 35, 'total': 42, 'pct': 83.3},
      {'code': 'MA3391', 'name': 'Probability & Statistics', 'present': 40, 'total': 48, 'pct': 83.3},
      {'code': 'GE3591', 'name': 'Environmental Science', 'present': 30, 'total': 32, 'pct': 93.7},
      {'code': 'CS3512', 'name': 'Compiler Design Lab', 'present': 28, 'total': 32, 'pct': 87.5},
      {'code': 'CS3592', 'name': 'Computer Networks Lab', 'present': 28, 'total': 32, 'pct': 87.5},
    ];
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
          const Text('Subject-wise Attendance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 600),
              child: Table(
                columnWidths: const {
                  0: FixedColumnWidth(90),
                  1: FlexColumnWidth(2),
                  2: FixedColumnWidth(70),
                  3: FixedColumnWidth(70),
                  4: FixedColumnWidth(80),
                  5: FixedColumnWidth(80),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: const Color(0xFF1E3055)))),
                    children: ['Code', 'Subject', 'Present', 'Total', 'Percentage', 'Status'].map((h) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(h, style: const TextStyle(color: Color(0xFFD4A843), fontWeight: FontWeight.bold, fontSize: 13)),
                    )).toList(),
                  ),
                  ...subjects.map((s) {
                    final pct = s['pct'] as double;
                    Color statusColor = pct >= 75 ? Colors.green : pct >= 70 ? Colors.orange : Colors.redAccent;
                    String status = pct >= 75 ? 'Safe' : pct >= 70 ? 'Warning' : 'Shortage';
                    return TableRow(
                      children: [
                        Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(s['code'] as String, style: const TextStyle(color: Color(0xFF64B5F6), fontSize: 13))),
                        Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(s['name'] as String, style: const TextStyle(color: Colors.white, fontSize: 13))),
                        Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text('${s['present']}', style: const TextStyle(color: Colors.white70, fontSize: 13))),
                        Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text('${s['total']}', style: const TextStyle(color: Colors.white70, fontSize: 13))),
                        Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text('${pct.toStringAsFixed(1)}%', style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 13))),
                        Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                          child: Text(status, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
                        )),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: const [
          Icon(Icons.info_outline, color: Colors.orange, size: 20),
          SizedBox(width: 12),
          Expanded(child: Text(
            'Minimum 75% attendance is required in each subject to be eligible for end semester examinations. Students with less than 75% may be detained.',
            style: TextStyle(color: Colors.orange, fontSize: 13),
          )),
        ],
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  _CircularProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    final bgPaint = Paint()..color = const Color(0xFF1E3055)..style = PaintingStyle.stroke..strokeWidth = 12;
    final fgPaint = Paint()..color = Colors.green..style = PaintingStyle.stroke..strokeWidth = 12..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, 2 * pi * progress, false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
