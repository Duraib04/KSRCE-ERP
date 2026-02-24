import 'package:flutter/material.dart';

class FacultyComplaintsPage extends StatelessWidget {
  const FacultyComplaintsPage({super.key});

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
            const Text('Complaints Management', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('View and respond to student complaints and grievances', style: TextStyle(color: Colors.white54, fontSize: 14)),
            const SizedBox(height: 24),

            // Stats
            Row(
              children: [
                _CStat(label: 'Total Complaints', value: '14', icon: Icons.receipt_long, color: _accent),
                const SizedBox(width: 12),
                _CStat(label: 'Pending', value: '3', icon: Icons.pending_actions, color: Colors.orangeAccent),
                const SizedBox(width: 12),
                _CStat(label: 'In Progress', value: '2', icon: Icons.autorenew, color: Colors.cyan),
                const SizedBox(width: 12),
                _CStat(label: 'Resolved', value: '9', icon: Icons.check_circle, color: Colors.greenAccent),
              ],
            ),
            const SizedBox(height: 24),

            // Complaints Table
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(const Color(0xFF1A2A4A)),
                columnSpacing: 16,
                columns: const [
                  DataColumn(label: Text('ID', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Student', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Subject', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Category', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Date', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Priority', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Status', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Action', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                ],
                rows: [
                  _complaintRow('CMP-042', 'Deepika V (CS104)', 'IA-I marks discrepancy in Q3', 'Academic', '22 Feb', 'High', 'Pending', Colors.orangeAccent),
                  _complaintRow('CMP-041', 'Vignesh S (CS117)', 'Lab system not working - PC #14', 'Infrastructure', '21 Feb', 'Medium', 'Pending', Colors.orangeAccent),
                  _complaintRow('CMP-040', 'Janani S (CS107)', 'Request for attendance condonation', 'Attendance', '20 Feb', 'High', 'Pending', Colors.orangeAccent),
                  _complaintRow('CMP-039', 'Manikandan T (CS110)', 'Projector issue in Room 301', 'Infrastructure', '18 Feb', 'Low', 'In Progress', Colors.cyan),
                  _complaintRow('CMP-038', 'Pavithra S (CS112)', 'Request for make-up test (IA-I)', 'Academic', '15 Feb', 'Medium', 'In Progress', Colors.cyan),
                  _complaintRow('CMP-037', 'Arun Kumar S (CS102)', 'WiFi connectivity in CSE Lab 2', 'Infrastructure', '12 Feb', 'Medium', 'Resolved', Colors.greenAccent),
                  _complaintRow('CMP-036', 'Gayathri P (CS105)', 'Course material not updated on LMS', 'Academic', '10 Feb', 'Low', 'Resolved', Colors.greenAccent),
                  _complaintRow('CMP-035', 'Rajesh Kumar B (CS113)', 'Seating arrangement issue in exam', 'Exam', '08 Feb', 'Medium', 'Resolved', Colors.greenAccent),
                  _complaintRow('CMP-034', 'Bharathi M (CS103)', 'Compiler Design reference book not available in library', 'Library', '05 Feb', 'Low', 'Resolved', Colors.greenAccent),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Response Form
            const Text('Respond to Complaint', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.orangeAccent.withOpacity(0.2)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CMP-042 | Deepika V (7376222CS104)', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                        SizedBox(height: 4),
                        Text('Subject: IA-I marks discrepancy in Q3 - Student claims Q3(a) was fully answered but received only 3/10 marks.',
                          style: TextStyle(color: Colors.white54, fontSize: 13)),
                        SizedBox(height: 4),
                        Text('Filed: 22 Feb 2026 | Priority: High | Category: Academic', style: TextStyle(color: Colors.white38, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Response', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(8), border: Border.all(color: _border)),
                    child: const TextField(
                      maxLines: 3,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Type your response here...',
                        hintStyle: TextStyle(color: Colors.white24),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Update Status', style: TextStyle(color: Colors.white70, fontSize: 13)),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(8), border: Border.all(color: _border)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: 'In Progress',
                                  dropdownColor: _card,
                                  isExpanded: true,
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                  items: ['Pending', 'In Progress', 'Resolved', 'Rejected'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                                  onChanged: (_) {},
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Padding(
                        padding: const EdgeInsets.only(top: 22),
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.send, size: 16),
                          label: const Text('Submit Response'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _accent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  DataRow _complaintRow(String id, String student, String subject, String category, String date, String priority, String status, Color statusColor) {
    Color priorityColor = Colors.white54;
    if (priority == 'High') priorityColor = Colors.redAccent;
    if (priority == 'Medium') priorityColor = Colors.orangeAccent;
    if (priority == 'Low') priorityColor = Colors.greenAccent;

    return DataRow(cells: [
      DataCell(Text(id, style: const TextStyle(color: Colors.white70, fontSize: 12))),
      DataCell(Text(student, style: const TextStyle(color: Colors.white, fontSize: 12))),
      DataCell(SizedBox(width: 200, child: Text(subject, style: const TextStyle(color: Colors.white70, fontSize: 12), overflow: TextOverflow.ellipsis))),
      DataCell(Text(category, style: const TextStyle(color: Colors.white54, fontSize: 12))),
      DataCell(Text(date, style: const TextStyle(color: Colors.white54, fontSize: 12))),
      DataCell(Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(color: priorityColor.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
        child: Text(priority, style: TextStyle(color: priorityColor, fontSize: 11, fontWeight: FontWeight.w500)),
      )),
      DataCell(Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
        child: Text(status, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w500)),
      )),
      DataCell(IconButton(icon: const Icon(Icons.reply, color: Colors.white38, size: 18), onPressed: () {}, tooltip: 'Respond')),
    ]);
  }
}

class _CStat extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _CStat({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFF111D35), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF1E3055))),
        child: Row(
          children: [
            CircleAvatar(radius: 22, backgroundColor: color.withOpacity(0.12), child: Icon(icon, color: color, size: 22)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
