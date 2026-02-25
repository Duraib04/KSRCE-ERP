import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class FacultyLeavePage extends StatelessWidget {
  const FacultyLeavePage({super.key});

  static const _bg = AppColors.background;
  static const _card = AppColors.surface;
  static const _border = AppColors.border;
  static const _accent = AppColors.primary;
  static const _gold = AppColors.accent;

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
                const Text('Leave Management', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Apply Leave'),
                  style: ElevatedButton.styleFrom(backgroundColor: _accent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('View leave balance, apply for leave, and manage student leave requests', style: TextStyle(color: AppColors.textLight, fontSize: 14)),
            const SizedBox(height: 24),

            // Leave Balance Cards
            const Text('My Leave Balance (2025-26)', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                _LeaveBalanceCard(type: 'Casual Leave (CL)', total: 12, used: 4, color: _accent),
                const SizedBox(width: 14),
                _LeaveBalanceCard(type: 'Medical Leave (ML)', total: 10, used: 2, color: Colors.teal),
                const SizedBox(width: 14),
                _LeaveBalanceCard(type: 'Earned Leave (EL)', total: 15, used: 3, color: _gold),
                const SizedBox(width: 14),
                _LeaveBalanceCard(type: 'On Duty (OD)', total: 10, used: 5, color: Colors.orange),
                const SizedBox(width: 14),
                _LeaveBalanceCard(type: 'Comp. Off', total: 4, used: 1, color: Colors.purple),
              ],
            ),
            const SizedBox(height: 28),

            // My Leave History
            const Text('My Leave History', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(const Color(0xFF1A2A4A)),
                columns: const [
                  DataColumn(label: Text('Leave ID', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Type', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('From', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('To', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Days', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Reason', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 13))),
                  DataColumn(label: Text('Status', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 13))),
                ],
                rows: [
                  _leaveRow('LV-2026-042', 'CL', '20 Feb', '20 Feb', '1', 'Personal work', 'Approved', Colors.greenAccent),
                  _leaveRow('LV-2026-038', 'OD', '14 Feb', '15 Feb', '2', 'IEEE Conference, Chennai', 'Approved', Colors.greenAccent),
                  _leaveRow('LV-2026-031', 'CL', '05 Feb', '05 Feb', '1', 'Family function', 'Approved', Colors.greenAccent),
                  _leaveRow('LV-2026-025', 'ML', '20 Jan', '21 Jan', '2', 'Health checkup', 'Approved', Colors.greenAccent),
                  _leaveRow('LV-2026-018', 'OD', '10 Jan', '12 Jan', '3', 'AICTE Workshop, Coimbatore', 'Approved', Colors.greenAccent),
                  _leaveRow('LV-2025-298', 'CL', '22 Dec', '23 Dec', '2', 'Family emergency', 'Approved', Colors.greenAccent),
                  _leaveRow('LV-2025-285', 'EL', '10 Dec', '12 Dec', '3', 'Annual vacation', 'Approved', Colors.greenAccent),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Apply Leave Form
            const Text('Apply for Leave', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: _FormField(label: 'Leave Type', hint: 'Select leave type')),
                      const SizedBox(width: 14),
                      Expanded(child: _FormField(label: 'From Date', hint: 'DD/MM/YYYY')),
                      const SizedBox(width: 14),
                      Expanded(child: _FormField(label: 'To Date', hint: 'DD/MM/YYYY')),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(flex: 2, child: _FormField(label: 'Reason', hint: 'Enter reason for leave')),
                      const SizedBox(width: 14),
                      Expanded(child: _FormField(label: 'Alternative Faculty', hint: 'Select faculty')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: _accent, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14)),
                      child: const Text('Submit Leave Request'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Student Leave Requests (HOD/Mentor view)
            Row(
              children: [
                const Text('Student Leave Requests (Mentor Approval)', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: Colors.orangeAccent.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                  child: const Text('3 Pending', style: TextStyle(color: Colors.orangeAccent, fontSize: 12, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _StudentLeaveRequest(
              student: 'Deepika V (7376222CS104)',
              dates: '25 Feb - 26 Feb 2026',
              days: '2',
              reason: 'Fever - Doctor advised rest',
              type: 'ML',
              status: 'Pending',
            ),
            const SizedBox(height: 8),
            _StudentLeaveRequest(
              student: 'Vignesh S (7376222CS117)',
              dates: '27 Feb 2026',
              days: '1',
              reason: 'Family function - Sister\'s wedding',
              type: 'CL',
              status: 'Pending',
            ),
            const SizedBox(height: 8),
            _StudentLeaveRequest(
              student: 'Janani S (7376222CS107)',
              dates: '28 Feb - 01 Mar 2026',
              days: '2',
              reason: 'Paper presentation at VIT, Vellore',
              type: 'OD',
              status: 'Pending',
            ),
            const SizedBox(height: 8),
            _StudentLeaveRequest(
              student: 'Pavithra S (7376222CS112)',
              dates: '18 Feb - 19 Feb 2026',
              days: '2',
              reason: 'Medical emergency',
              type: 'ML',
              status: 'Approved',
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  DataRow _leaveRow(String id, String type, String from, String to, String days, String reason, String status, Color statusColor) {
    return DataRow(cells: [
      DataCell(Text(id, style: const TextStyle(color: AppColors.textMedium, fontSize: 13))),
      DataCell(Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(color: _accent.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
        child: Text(type, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
      )),
      DataCell(Text(from, style: const TextStyle(color: AppColors.textMedium, fontSize: 13))),
      DataCell(Text(to, style: const TextStyle(color: AppColors.textMedium, fontSize: 13))),
      DataCell(Text(days, style: const TextStyle(color: AppColors.textDark, fontSize: 13))),
      DataCell(Text(reason, style: const TextStyle(color: AppColors.textLight, fontSize: 13))),
      DataCell(Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
        child: Text(status, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w500)),
      )),
    ]);
  }
}

class _LeaveBalanceCard extends StatelessWidget {
  final String type;
  final int total, used;
  final Color color;
  const _LeaveBalanceCard({required this.type, required this.total, required this.used, required this.color});

  @override
  Widget build(BuildContext context) {
    final remaining = total - used;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
        child: Column(
          children: [
            Text(type, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Text('$remaining', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            const Text('Remaining', style: TextStyle(color: AppColors.textLight, fontSize: 11)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: used / total,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 5,
              borderRadius: BorderRadius.circular(3),
            ),
            const SizedBox(height: 6),
            Text('$used / $total used', style: const TextStyle(color: AppColors.textLight, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final String label, hint;
  const _FormField({required this.label, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textMedium, fontSize: 13)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            style: const TextStyle(color: AppColors.textDark, fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.border, fontSize: 13),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}

class _StudentLeaveRequest extends StatelessWidget {
  final String student, dates, days, reason, type, status;
  const _StudentLeaveRequest({required this.student, required this.dates, required this.days, required this.reason, required this.type, required this.status});

  @override
  Widget build(BuildContext context) {
    final isPending = status == 'Pending';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isPending ? Colors.orangeAccent.withOpacity(0.3) : AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(student, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                      child: Text(type, style: const TextStyle(color: AppColors.primary, fontSize: 11)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('$dates ($days days) - $reason', style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
              ],
            ),
          ),
          if (isPending) ...[
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.check_circle, color: Colors.greenAccent, size: 28),
              tooltip: 'Approve',
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.cancel, color: Colors.redAccent, size: 28),
              tooltip: 'Reject',
            ),
          ] else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.greenAccent.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
              child: const Text('Approved', style: TextStyle(color: Colors.greenAccent, fontSize: 12)),
            ),
        ],
      ),
    );
  }
}
