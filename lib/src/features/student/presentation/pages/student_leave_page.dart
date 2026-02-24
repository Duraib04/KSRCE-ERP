import 'package:flutter/material.dart';

class StudentLeavePage extends StatefulWidget {
  const StudentLeavePage({super.key});

  @override
  State<StudentLeavePage> createState() => _StudentLeavePageState();
}

class _StudentLeavePageState extends State<StudentLeavePage> {
  String _leaveType = 'Medical Leave';
  final _reasonController = TextEditingController();

  final List<Map<String, String>> _leaveHistory = [
    {'type': 'Medical Leave', 'from': '10 Feb 2026', 'to': '11 Feb 2026', 'days': '2', 'reason': 'Fever and cold', 'status': 'Approved', 'approvedBy': 'Dr. S. Meena'},
    {'type': 'On Duty', 'from': '22 Jan 2026', 'to': '23 Jan 2026', 'days': '2', 'reason': 'Inter-college tech symposium at PSG Tech', 'status': 'Approved', 'approvedBy': 'Dr. S. Meena'},
    {'type': 'Personal Leave', 'from': '15 Jan 2026', 'to': '15 Jan 2026', 'days': '1', 'reason': 'Family function', 'status': 'Approved', 'approvedBy': 'Dr. S. Meena'},
    {'type': 'Medical Leave', 'from': '02 Dec 2025', 'to': '04 Dec 2025', 'days': '3', 'reason': 'Dengue fever - medical certificate attached', 'status': 'Approved', 'approvedBy': 'Dr. S. Meena'},
    {'type': 'Personal Leave', 'from': '20 Nov 2025', 'to': '20 Nov 2025', 'days': '1', 'reason': 'Personal work', 'status': 'Rejected', 'approvedBy': 'Dr. S. Meena'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1F3C),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: const [
              Icon(Icons.event_busy, color: Color(0xFFD4A843), size: 28),
              SizedBox(width: 12),
              Text('Leave Applications', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            ]),
            const SizedBox(height: 8),
            const Text('Apply for leave and track your leave history', style: TextStyle(color: Colors.white60, fontSize: 14)),
            const SizedBox(height: 24),
            _buildLeaveBalance(),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: _buildLeaveHistory()),
                const SizedBox(width: 24),
                Expanded(flex: 2, child: _buildApplyLeaveForm()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveBalance() {
    return Row(
      children: [
        _leaveCard('Medical Leave', '5', '10', Colors.redAccent),
        const SizedBox(width: 16),
        _leaveCard('Personal Leave', '2', '5', Colors.orange),
        const SizedBox(width: 16),
        _leaveCard('On Duty', '2', 'Unlimited', Colors.blue),
        const SizedBox(width: 16),
        _leaveCard('Total Used', '9', '-', const Color(0xFFD4A843)),
      ],
    );
  }

  Widget _leaveCard(String label, String used, String total, Color color) {
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
            Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
            const SizedBox(height: 8),
            RichText(text: TextSpan(children: [
              TextSpan(text: used, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
              if (total != '-') TextSpan(text: '/$total', style: const TextStyle(fontSize: 14, color: Colors.white38)),
            ])),
            const SizedBox(height: 4),
            Text(total == '-' ? 'Days' : 'Used/Total', style: const TextStyle(color: Colors.white38, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveHistory() {
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
          const Text('Leave History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          Table(
            columnWidths: const {
              0: FixedColumnWidth(120),
              1: FixedColumnWidth(100),
              2: FixedColumnWidth(100),
              3: FixedColumnWidth(50),
              4: FlexColumnWidth(2),
              5: FixedColumnWidth(90),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: const Color(0xFF1E3055)))),
                children: ['Type', 'From', 'To', 'Days', 'Reason', 'Status'].map((h) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(h, style: const TextStyle(color: Color(0xFFD4A843), fontWeight: FontWeight.bold, fontSize: 13)),
                )).toList(),
              ),
              ..._leaveHistory.map((l) {
                final isApproved = l['status'] == 'Approved';
                return TableRow(
                  children: [
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(l['type']!, style: const TextStyle(color: Colors.white, fontSize: 13))),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(l['from']!, style: const TextStyle(color: Colors.white70, fontSize: 13))),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(l['to']!, style: const TextStyle(color: Colors.white70, fontSize: 13))),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(l['days']!, style: const TextStyle(color: Colors.white70, fontSize: 13))),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(l['reason']!, style: const TextStyle(color: Colors.white54, fontSize: 13))),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: (isApproved ? Colors.green : Colors.redAccent).withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                      child: Text(l['status']!, style: TextStyle(color: isApproved ? Colors.green : Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                    )),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildApplyLeaveForm() {
    final types = ['Medical Leave', 'Personal Leave', 'On Duty', 'Emergency Leave'];
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
          const Text('Apply for Leave', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 20),
          const Text('Leave Type', style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: const Color(0xFF0D1F3C), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF1E3055))),
            child: DropdownButton<String>(
              value: _leaveType,
              isExpanded: true,
              dropdownColor: const Color(0xFF111D35),
              style: const TextStyle(color: Colors.white),
              underline: const SizedBox(),
              items: types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (v) => setState(() => _leaveType = v!),
            ),
          ),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('From Date', style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 8),
              _dateField('Select start date'),
            ])),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('To Date', style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 8),
              _dateField('Select end date'),
            ])),
          ]),
          const SizedBox(height: 16),
          const Text('Reason', style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 8),
          TextField(
            controller: _reasonController,
            style: const TextStyle(color: Colors.white),
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Describe the reason for leave...',
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true, fillColor: const Color(0xFF0D1F3C),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: const Color(0xFF1E3055))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: const Color(0xFF1E3055))),
            ),
          ),
          const SizedBox(height: 16),
          Row(children: [
            const Icon(Icons.attach_file, color: Colors.white38, size: 18),
            const SizedBox(width: 8),
            TextButton(onPressed: () {}, child: const Text('Attach Supporting Document', style: TextStyle(color: Color(0xFF1565C0)))),
          ]),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.send, size: 18),
              label: const Text('Submit Leave Application'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateField(String hint) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      readOnly: true,
      onTap: () {},
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
        suffixIcon: const Icon(Icons.calendar_today, color: Colors.white38, size: 18),
        filled: true, fillColor: const Color(0xFF0D1F3C),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: const Color(0xFF1E3055))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: const Color(0xFF1E3055))),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}
