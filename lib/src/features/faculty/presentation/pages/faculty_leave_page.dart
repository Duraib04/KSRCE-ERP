import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/data_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_card_styles.dart';

class FacultyLeavePage extends StatefulWidget {
  const FacultyLeavePage({super.key});

  @override
  State<FacultyLeavePage> createState() => _FacultyLeavePageState();
}

class _FacultyLeavePageState extends State<FacultyLeavePage> {
  String _leaveType = 'Casual Leave';
  final _reasonController = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(builder: (context, ds, _) {
      final fid = ds.currentUserId ?? '';
      final leaveHistory = ds.getUserLeave(fid);
      final balances = ds.getUserLeaveBalance(fid);
      final studentRequests = ds.getStudentLeaveRequests(fid);

      return Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: const [
              Icon(Icons.event_busy, color: AppColors.primary, size: 28),
              SizedBox(width: 12),
              Text('Leave Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            ]),
            const SizedBox(height: 24),
            _buildLeaveBalance(balances),
            const SizedBox(height: 24),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(flex: 3, child: _buildLeaveHistory(leaveHistory)),
              const SizedBox(width: 24),
              Expanded(flex: 2, child: _buildApplyForm(ds, fid)),
            ]),
            if (studentRequests.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildStudentLeaveRequests(studentRequests, ds),
            ],
          ]),
        ),
      );
    });
  }

  Widget _buildLeaveBalance(List<Map<String, dynamic>> balances) {
    if (balances.isEmpty) {
      return Row(children: [
        _balCard('Casual Leave', '0', '12', Colors.blue),
        const SizedBox(width: 16),
        _balCard('Medical Leave', '0', '10', Colors.redAccent),
        const SizedBox(width: 16),
        _balCard('On Duty', '0', 'Unlimited', Colors.green),
      ]);
    }
    return Row(children: balances.map((b) {
      final type = b['leaveType'] ?? '';
      final used = b['used']?.toString() ?? '0';
      final total = b['total']?.toString() ?? '-';
      final color = type.toString().contains('Casual') ? Colors.blue : type.toString().contains('Medical') ? Colors.redAccent : Colors.green;
      return Expanded(child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: _balCard(type.toString(), used, total, color),
      ));
    }).toList());
  }

  Widget _balCard(String label, String used, String total, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppCardStyles.elevated,
      child: Column(children: [
        Text(label, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
        const SizedBox(height: 8),
        RichText(text: TextSpan(children: [
          TextSpan(text: used, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          if (total != '-') TextSpan(text: '/$total', style: const TextStyle(fontSize: 14, color: AppColors.textLight)),
        ])),
      ]),
    );
  }

  Widget _buildLeaveHistory(List<Map<String, dynamic>> history) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppCardStyles.elevated,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('My Leave History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 16),
        if (history.isEmpty) const Center(child: Text('No leave records', style: TextStyle(color: AppColors.textLight))),
        ...history.map((l) {
          final status = l['status'] ?? 'pending';
          final color = status == 'approved' ? Colors.green : status == 'rejected' ? Colors.redAccent : Colors.orange;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l['leaveType'] ?? '', style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w500, fontSize: 14)),
                Text('${l['fromDate'] ?? ''} to ${l['toDate'] ?? ''} (${l['days'] ?? '-'} days)', style: const TextStyle(color: AppColors.textMedium, fontSize: 12)),
              ])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                child: Text(status.toString().toUpperCase(), style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ]),
          );
        }),
      ]),
    );
  }

  Widget _buildApplyForm(DataService ds, String uid) {
    final types = ['Casual Leave', 'Medical Leave', 'On Duty', 'Earned Leave'];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppCardStyles.elevated,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Apply for Leave', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: AppCardStyles.flat,
          child: DropdownButton<String>(
            value: _leaveType, isExpanded: true, dropdownColor: AppColors.surface,
            style: const TextStyle(color: AppColors.textDark), underline: const SizedBox(),
            items: types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
            onChanged: (v) => setState(() => _leaveType = v!),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _reasonController, maxLines: 3,
          style: const TextStyle(color: AppColors.textDark),
          decoration: InputDecoration(
            hintText: 'Reason...', hintStyle: const TextStyle(color: AppColors.textLight),
            filled: true, fillColor: AppColors.background,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.border)),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              if (_reasonController.text.isNotEmpty) {
                ds.applyLeave({'userId': uid, 'leaveType': _leaveType, 'fromDate': DateTime.now().toIso8601String().substring(0, 10), 'toDate': DateTime.now().toIso8601String().substring(0, 10), 'days': 1, 'reason': _reasonController.text});
                _reasonController.clear();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Leave application submitted')));
              }
            },
            icon: const Icon(Icons.send, size: 18),
            label: const Text('Submit'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
          ),
        ),
      ]),
    );
  }

  Widget _buildStudentLeaveRequests(List<Map<String, dynamic>> requests, DataService ds) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppCardStyles.elevated,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Student Leave Requests (Pending Approval)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 16),
        ...requests.map((r) {
          final studentName = ds.getStudentById(r['userId'] ?? '')?.containsKey('name') == true
              ? ds.getStudentById(r['userId'] ?? '')!['name'] : r['userId'] ?? '';
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('$studentName - ${r['leaveType'] ?? ''}', style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w500)),
                Text('${r['fromDate'] ?? ''} to ${r['toDate'] ?? ''} | ${r['reason'] ?? ''}', style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
              ])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.orange.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                child: const Text('PENDING', style: TextStyle(color: Colors.orange, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ]),
          );
        }),
      ]),
    );
  }
}
