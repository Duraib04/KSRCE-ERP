import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/data_service.dart';
import '../../../../core/theme/app_colors.dart';

class StudentComplaintsPage extends StatefulWidget {
  const StudentComplaintsPage({super.key});

  @override
  State<StudentComplaintsPage> createState() => _StudentComplaintsPageState();
}

class _StudentComplaintsPageState extends State<StudentComplaintsPage> {
  String _selectedCategory = 'infrastructure';
  final _subjectController = TextEditingController();
  final _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(builder: (context, ds, _) {
      if (!ds.isLoaded) {
        return const Scaffold(backgroundColor: AppColors.background, body: Center(child: CircularProgressIndicator()));
      }
      final complaintsList = ds.complaints;

      return Scaffold(
        backgroundColor: AppColors.background,
        body: LayoutBuilder(builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;
          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: const [
                Icon(Icons.report_problem, color: AppColors.primary, size: 28),
                SizedBox(width: 12),
                Text('Complaints & Grievances', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              ]),
              const SizedBox(height: 8),
              const Text('Submit and track your complaints', style: TextStyle(color: AppColors.textLight, fontSize: 14)),
              const SizedBox(height: 24),
              if (isMobile) ...[
                _buildComplaintsList(complaintsList),
                const SizedBox(height: 24),
                _buildNewComplaintForm(ds),
              ] else
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(flex: 3, child: _buildComplaintsList(complaintsList)),
                  const SizedBox(width: 24),
                  Expanded(flex: 2, child: _buildNewComplaintForm(ds)),
                ]),
            ]),
          );
        }),
      );
    });
  }

  Widget _buildComplaintsList(List<Map<String, dynamic>> complaintsList) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('My Complaints', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 16),
        if (complaintsList.isEmpty)
          const Padding(padding: EdgeInsets.all(16), child: Center(child: Text('No complaints filed', style: TextStyle(color: AppColors.textLight))))
        else
          ...complaintsList.map((c) {
            final status = c['status'] as String? ?? 'pending';
            Color statusColor;
            IconData statusIcon;
            String statusLabel;
            switch (status) {
              case 'inProgress': statusColor = Colors.blue; statusIcon = Icons.autorenew; statusLabel = 'In Progress'; break;
              case 'resolved': statusColor = Colors.green; statusIcon = Icons.check_circle; statusLabel = 'Resolved'; break;
              default: statusColor = Colors.orange; statusIcon = Icons.hourglass_empty; statusLabel = 'Pending';
            }
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10), border: Border.all(color: statusColor.withOpacity(0.2))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Icon(statusIcon, color: statusColor, size: 18),
                  const SizedBox(width: 8),
                  Text(c['complaintId'] as String? ?? '', style: const TextStyle(color: Color(0xFF64B5F6), fontSize: 12, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                    child: Text(statusLabel, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ]),
                const SizedBox(height: 8),
                Text(c['title'] as String? ?? '', style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(c['description'] as String? ?? '', style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
                const SizedBox(height: 8),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                    child: Text(c['category'] as String? ?? '', style: const TextStyle(color: Color(0xFF64B5F6), fontSize: 11)),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.calendar_today, color: AppColors.textLight, size: 14),
                  const SizedBox(width: 4),
                  Text(c['submittedDate'] as String? ?? '', style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
                  if (c['response'] != null) ...[
                    const SizedBox(width: 12),
                    Flexible(child: Text('Response: ${c['response']}', style: const TextStyle(color: AppColors.secondary, fontSize: 11))),
                  ],
                ]),
              ]),
            );
          }),
      ]),
    );
  }

  Widget _buildNewComplaintForm(DataService ds) {
    final categories = ['infrastructure', 'academic', 'library', 'hostel', 'transport', 'other'];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('File New Complaint', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 20),
        const Text('Category', style: TextStyle(color: AppColors.textMedium, fontSize: 13)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
          child: DropdownButton<String>(
            value: _selectedCategory, isExpanded: true, dropdownColor: AppColors.surface,
            style: const TextStyle(color: AppColors.textDark), underline: const SizedBox(),
            items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c[0].toUpperCase() + c.substring(1)))).toList(),
            onChanged: (v) => setState(() => _selectedCategory = v!),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Subject', style: TextStyle(color: AppColors.textMedium, fontSize: 13)),
        const SizedBox(height: 8),
        TextField(
          controller: _subjectController,
          style: const TextStyle(color: AppColors.textDark),
          decoration: InputDecoration(
            hintText: 'Brief subject of complaint', hintStyle: const TextStyle(color: AppColors.textLight),
            filled: true, fillColor: AppColors.background,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.border)),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Description', style: TextStyle(color: AppColors.textMedium, fontSize: 13)),
        const SizedBox(height: 8),
        TextField(
          controller: _descController,
          style: const TextStyle(color: AppColors.textDark),
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Describe your complaint in detail...', hintStyle: const TextStyle(color: AppColors.textLight),
            filled: true, fillColor: AppColors.background,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.border)),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              if (_subjectController.text.isNotEmpty && _descController.text.isNotEmpty) {
                ds.addComplaint({
                  'title': _subjectController.text,
                  'description': _descController.text,
                  'category': _selectedCategory,
                });
                _subjectController.clear();
                _descController.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Complaint submitted successfully!'), backgroundColor: AppColors.secondary),
                );
              }
            },
            icon: const Icon(Icons.send, size: 18),
            label: const Text('Submit Complaint'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary, foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      ]),
    );
  }
}
