import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/data_service.dart';
import '../../../../core/theme/app_colors.dart';

class StudentAssignmentsPage extends StatefulWidget {
  const StudentAssignmentsPage({super.key});

  @override
  State<StudentAssignmentsPage> createState() => _StudentAssignmentsPageState();
}

class _StudentAssignmentsPageState extends State<StudentAssignmentsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _filterAssignments(List<Map<String, dynamic>> all, String tab) {
    switch (tab) {
      case 'Pending': return all.where((a) => a['status'] == 'pending').toList();
      case 'Completed': return all.where((a) => a['status'] != 'pending').toList();
      default: return all;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(builder: (context, ds, _) {
      if (!ds.isLoaded) {
        return const Scaffold(backgroundColor: AppColors.background, body: Center(child: CircularProgressIndicator()));
      }
      final allAssignments = ds.assignments;
      int pending = allAssignments.where((a) => a['status'] == 'pending').length;
      int submitted = allAssignments.where((a) => a['status'] == 'submitted').length;
      int evaluated = allAssignments.where((a) => a['status'] == 'evaluated' || a['status'] == 'late').length;

      return Scaffold(
        backgroundColor: AppColors.background,
        body: LayoutBuilder(builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;
          return Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: const [
                Icon(Icons.assignment, color: AppColors.primary, size: 28),
                SizedBox(width: 12),
                Text('Assignments', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              ]),
              const SizedBox(height: 8),
              const Text('Manage your assignments and submissions', style: TextStyle(color: AppColors.textLight, fontSize: 14)),
              const SizedBox(height: 20),
              _buildSummaryRow(isMobile, pending, submitted, evaluated, allAssignments.length),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8)),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.accent,
                  labelColor: AppColors.accent,
                  unselectedLabelColor: AppColors.textLight,
                  tabs: const [Tab(text: 'Pending'), Tab(text: 'Completed'), Tab(text: 'All')],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: ['Pending', 'Completed', 'All'].map((tab) {
                    final filtered = _filterAssignments(allAssignments, tab);
                    if (filtered.isEmpty) {
                      return const Center(child: Text('No assignments found', style: TextStyle(color: AppColors.textLight)));
                    }
                    return ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) => _buildAssignmentCard(filtered[index], isMobile),
                    );
                  }).toList(),
                ),
              ),
            ]),
          );
        }),
      );
    });
  }

  Widget _buildSummaryRow(bool isMobile, int pending, int submitted, int evaluated, int total) {
    final cards = [
      _summaryCard('Pending', '$pending', Colors.orange, Icons.hourglass_empty),
      _summaryCard('Submitted', '$submitted', Colors.blue, Icons.upload_file),
      _summaryCard('Evaluated', '$evaluated', Colors.green, Icons.grading),
      _summaryCard('Total', '$total', AppColors.accent, Icons.assignment),
    ];
    if (isMobile) {
      return Wrap(spacing: 12, runSpacing: 12, children: cards.map((c) => SizedBox(width: (MediaQuery.of(context).size.width - 44) / 2, child: c)).toList());
    }
    return Row(children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: c))).toList());
  }

  Widget _summaryCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
      child: Row(children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
        ]),
      ]),
    );
  }

  Widget _buildAssignmentCard(Map<String, dynamic> a, bool isMobile) {
    final status = a['status'] as String? ?? 'pending';
    Color statusColor = status == 'pending' ? Colors.orange : status == 'submitted' ? Colors.blue : status == 'late' ? Colors.redAccent : Colors.green;
    IconData statusIcon = status == 'pending' ? Icons.hourglass_empty : status == 'submitted' ? Icons.upload_file : Icons.check_circle;
    final statusLabel = status[0].toUpperCase() + status.substring(1);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface, borderRadius: BorderRadius.circular(10),
        border: Border.all(color: status == 'pending' ? Colors.orange.withOpacity(0.3) : AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(statusIcon, color: statusColor, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(a['title'] as String? ?? '', style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 15))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
            child: Text(statusLabel, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ]),
        const SizedBox(height: 10),
        Wrap(spacing: 16, runSpacing: 8, children: [
          _iconText(Icons.book, '${a['courseCode'] ?? ''} - ${a['courseName'] ?? ''}'),
          _iconText(Icons.calendar_today, 'Due: ${a['dueDate'] ?? ''}'),
          if (a['obtainedMarks'] != null) _iconText(Icons.grade, 'Marks: ${a['obtainedMarks']}/${a['maxMarks'] ?? ''}'),
          if (a['feedback'] != null) _iconText(Icons.comment, a['feedback'] as String),
        ]),
      ]),
    );
  }

  Widget _iconText(IconData icon, String text) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: AppColors.textLight, size: 16),
      const SizedBox(width: 6),
      Flexible(child: Text(text, style: const TextStyle(color: AppColors.textMedium, fontSize: 13))),
    ]);
  }
}
