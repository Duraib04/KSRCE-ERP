import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class StudentComplaintsPage extends StatefulWidget {
  const StudentComplaintsPage({super.key});

  @override
  State<StudentComplaintsPage> createState() => _StudentComplaintsPageState();
}

class _StudentComplaintsPageState extends State<StudentComplaintsPage> {
  String _selectedCategory = 'Infrastructure';
  final _subjectController = TextEditingController();
  final _descController = TextEditingController();

  final List<Map<String, String>> _complaints = [
    {'id': 'CMP-2026-045', 'category': 'Infrastructure', 'subject': 'AC not working in Room 301', 'description': 'The air conditioner in Room 301 has not been working for the past week. It is very difficult to concentrate during afternoon classes.', 'date': '20 Feb 2026', 'status': 'Pending'},
    {'id': 'CMP-2026-032', 'category': 'IT Services', 'subject': 'WiFi connectivity issues in Lab 4', 'description': 'The WiFi in Lab 4 keeps disconnecting frequently during lab sessions making it difficult to complete online exercises.', 'date': '15 Feb 2026', 'status': 'In Progress'},
    {'id': 'CMP-2026-018', 'category': 'Academic', 'subject': 'Request for additional lab hours', 'description': 'The current 2-hour lab slot for Compiler Design Lab is insufficient. Requesting additional practice hours during weekends.', 'date': '05 Feb 2026', 'status': 'Resolved'},
    {'id': 'CMP-2025-198', 'category': 'Hostel', 'subject': 'Hot water issue in Block C', 'description': 'Hot water supply is not available in the mornings in Hostel Block C for the past 3 days.', 'date': '20 Dec 2025', 'status': 'Resolved'},
  ];

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
                Row(children: const [
                  Icon(Icons.report_problem, color: AppColors.primary, size: 28),
                  SizedBox(width: 12),
                  Text('Complaints & Grievances', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                ]),
                const SizedBox(height: 8),
                const Text('Submit and track your complaints', style: TextStyle(color: AppColors.textLight, fontSize: 14)),
                const SizedBox(height: 24),
                if (isMobile)
                  Column(
                    children: [
                      _buildComplaintsList(),
                      const SizedBox(height: 24),
                      _buildNewComplaintForm(),
                    ],
                  )
                else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _buildComplaintsList()),
                      const SizedBox(width: 24),
                      Expanded(flex: 2, child: _buildNewComplaintForm()),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildComplaintsList() {
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
          const Text('My Complaints', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 16),
          ..._complaints.map((c) {
            Color statusColor;
            IconData statusIcon;
            switch (c['status']) {
              case 'Pending': statusColor = Colors.orange; statusIcon = Icons.hourglass_empty; break;
              case 'In Progress': statusColor = Colors.blue; statusIcon = Icons.autorenew; break;
              case 'Resolved': statusColor = Colors.green; statusIcon = Icons.check_circle; break;
              default: statusColor = Colors.grey; statusIcon = Icons.help;
            }
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: statusColor.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(statusIcon, color: statusColor, size: 18),
                      const SizedBox(width: 8),
                      Text(c['id']!, style: const TextStyle(color: Color(0xFF64B5F6), fontSize: 12, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                        child: Text(c['status']!, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(c['subject']!, style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(c['description']!, style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                        child: Text(c['category']!, style: const TextStyle(color: Color(0xFF64B5F6), fontSize: 11)),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.calendar_today, color: AppColors.textLight, size: 14),
                      const SizedBox(width: 4),
                      Text(c['date']!, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNewComplaintForm() {
    final categories = ['Infrastructure', 'Academic', 'IT Services', 'Hostel', 'Transport', 'Canteen', 'Library', 'Other'];
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
          const Text('File New Complaint', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 20),
          const Text('Category', style: TextStyle(color: AppColors.textMedium, fontSize: 13)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
            child: DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              dropdownColor: AppColors.surface,
              style: const TextStyle(color: Colors.white),
              underline: const SizedBox(),
              items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _selectedCategory = v!),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Subject', style: TextStyle(color: AppColors.textMedium, fontSize: 13)),
          const SizedBox(height: 8),
          TextField(
            controller: _subjectController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Brief subject of complaint',
              hintStyle: const TextStyle(color: AppColors.textLight),
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
            style: const TextStyle(color: Colors.white),
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Describe your complaint in detail...',
              hintStyle: const TextStyle(color: AppColors.textLight),
              filled: true, fillColor: AppColors.background,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: AppColors.border)),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.send, size: 18),
              label: const Text('Submit Complaint'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
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
}
