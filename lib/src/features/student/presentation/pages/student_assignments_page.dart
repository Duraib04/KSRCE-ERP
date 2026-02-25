import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class StudentAssignmentsPage extends StatefulWidget {
  const StudentAssignmentsPage({super.key});

  @override
  State<StudentAssignmentsPage> createState() => _StudentAssignmentsPageState();
}

class _StudentAssignmentsPageState extends State<StudentAssignmentsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _assignments = [
    {'title': 'Implement Lexical Analyzer using Lex Tool', 'course': 'CS3501 - Compiler Design', 'faculty': 'Dr. K. Ramesh', 'due': '25 Feb 2026', 'status': 'Pending', 'marks': '-', 'total': 20, 'type': 'Lab'},
    {'title': 'Subnetting and IP Address Calculation', 'course': 'CS3591 - Computer Networks', 'faculty': 'Prof. S. Lakshmi', 'due': '27 Feb 2026', 'status': 'Pending', 'marks': '-', 'total': 15, 'type': 'Assignment'},
    {'title': 'Distributed Mutual Exclusion - Ricart Agrawala', 'course': 'CS3551 - Distributed Computing', 'faculty': 'Dr. M. Venkatesh', 'due': '01 Mar 2026', 'status': 'Pending', 'marks': '-', 'total': 20, 'type': 'Assignment'},
    {'title': 'Socket Programming - TCP Chat Application', 'course': 'CS3592 - CN Lab', 'faculty': 'Prof. S. Lakshmi', 'due': '20 Feb 2026', 'status': 'Submitted', 'marks': '18', 'total': 20, 'type': 'Lab'},
    {'title': 'Predictive Parser Implementation', 'course': 'CS3501 - Compiler Design', 'faculty': 'Dr. K. Ramesh', 'due': '18 Feb 2026', 'status': 'Submitted', 'marks': '16', 'total': 20, 'type': 'Lab'},
    {'title': 'Probability Distribution Problems - Set 3', 'course': 'MA3391 - Probability & Statistics', 'faculty': 'Dr. P. Anitha', 'due': '15 Feb 2026', 'status': 'Graded', 'marks': '13', 'total': 15, 'type': 'Assignment'},
    {'title': 'NFA to DFA Conversion - 10 Problems', 'course': 'CS3501 - Compiler Design', 'faculty': 'Dr. K. Ramesh', 'due': '10 Feb 2026', 'status': 'Graded', 'marks': '17', 'total': 20, 'type': 'Assignment'},
    {'title': 'OSI Model Case Study Report', 'course': 'CS3591 - Computer Networks', 'faculty': 'Prof. S. Lakshmi', 'due': '05 Feb 2026', 'status': 'Graded', 'marks': '14', 'total': 15, 'type': 'Assignment'},
    {'title': 'Hypothesis Testing - Practice Problems', 'course': 'MA3391 - Probability & Statistics', 'faculty': 'Dr. P. Anitha', 'due': '01 Feb 2026', 'status': 'Graded', 'marks': '12', 'total': 15, 'type': 'Assignment'},
  ];

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

  List<Map<String, dynamic>> _filterAssignments(String tab) {
    switch (tab) {
      case 'Pending': return _assignments.where((a) => a['status'] == 'Pending').toList();
      case 'Submitted': return _assignments.where((a) => a['status'] == 'Submitted' || a['status'] == 'Graded').toList();
      default: return _assignments;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMobile = constraints.maxWidth < 700;
          return Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: const [
                  Icon(Icons.assignment, color: AppColors.primary, size: 28),
                  SizedBox(width: 12),
                  Text('Assignments', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                ]),
                const SizedBox(height: 8),
                const Text('Manage your assignments and submissions', style: TextStyle(color: AppColors.textLight, fontSize: 14)),
                const SizedBox(height: 20),
                _buildSummaryRow(isMobile),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8)),
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: AppColors.accent,
                    labelColor: AppColors.accent,
                    unselectedLabelColor: AppColors.textLight,
                    tabs: const [Tab(text: 'Pending'), Tab(text: 'Submitted'), Tab(text: 'All')],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: ['Pending', 'Submitted', 'All'].map((tab) {
                      final filtered = _filterAssignments(tab);
                      return ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) => _buildAssignmentCard(filtered[index], isMobile),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryRow(bool isMobile) {
    int pending = _assignments.where((a) => a['status'] == 'Pending').length;
    int submitted = _assignments.where((a) => a['status'] == 'Submitted').length;
    int graded = _assignments.where((a) => a['status'] == 'Graded').length;

    final cards = [
      _summaryCard('Pending', '$pending', Colors.orange, Icons.hourglass_empty),
      _summaryCard('Submitted', '$submitted', Colors.blue, Icons.upload_file),
      _summaryCard('Graded', '$graded', Colors.green, Icons.grading),
      _summaryCard('Total', '${_assignments.length}', AppColors.accent, Icons.assignment),
    ];

    if (isMobile) {
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: cards.map((card) => SizedBox(
          width: (MediaQuery.of(context).size.width - 44) / 2,
          child: card,
        )).toList(),
      );
    }

    return Row(
      children: [
        Expanded(child: cards[0]),
        const SizedBox(width: 16),
        Expanded(child: cards[1]),
        const SizedBox(width: 16),
        Expanded(child: cards[2]),
        const SizedBox(width: 16),
        Expanded(child: cards[3]),
      ],
    );
  }

  Widget _summaryCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
          ]),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(Map<String, dynamic> a, bool isMobile) {
    Color statusColor = a['status'] == 'Pending' ? Colors.orange : a['status'] == 'Submitted' ? Colors.blue : Colors.green;
    IconData statusIcon = a['status'] == 'Pending' ? Icons.hourglass_empty : a['status'] == 'Submitted' ? Icons.upload_file : Icons.check_circle;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: a['status'] == 'Pending' ? Colors.orange.withOpacity(0.3) : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(a['title'], style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 15))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                child: Text(a['status'], style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          isMobile
              ? _buildCardInfoMobile(a, statusColor)
              : _buildCardInfoDesktop(a, statusColor),
        ],
      ),
    );
  }

  Widget _buildCardInfoDesktop(Map<String, dynamic> a, Color statusColor) {
    return Row(
      children: [
        const Icon(Icons.book, color: AppColors.textLight, size: 16),
        const SizedBox(width: 6),
        Text(a['course'], style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
        const SizedBox(width: 20),
        const Icon(Icons.person, color: AppColors.textLight, size: 16),
        const SizedBox(width: 6),
        Text(a['faculty'], style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
        const SizedBox(width: 20),
        const Icon(Icons.calendar_today, color: AppColors.textLight, size: 16),
        const SizedBox(width: 6),
        Text('Due: ${a['due']}', style: TextStyle(color: a['status'] == 'Pending' ? Colors.orange : Colors.white54, fontSize: 13)),
        const Spacer(),
        if (a['marks'] != '-') Text('Marks: ${a['marks']}/${a['total']}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13)),
        if (a['status'] == 'Pending') ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.upload, size: 16),
          label: const Text('Upload'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textStyle: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildCardInfoMobile(Map<String, dynamic> a, Color statusColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.book, color: AppColors.textLight, size: 16),
                const SizedBox(width: 6),
                Flexible(child: Text(a['course'], style: const TextStyle(color: AppColors.textLight, fontSize: 13))),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person, color: AppColors.textLight, size: 16),
                const SizedBox(width: 6),
                Flexible(child: Text(a['faculty'], style: const TextStyle(color: AppColors.textLight, fontSize: 13))),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.calendar_today, color: AppColors.textLight, size: 16),
            const SizedBox(width: 6),
            Text('Due: ${a['due']}', style: TextStyle(color: a['status'] == 'Pending' ? Colors.orange : Colors.white54, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            if (a['marks'] != '-') Text('Marks: ${a['marks']}/${a['total']}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13)),
            const Spacer(),
            if (a['status'] == 'Pending') ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.upload, size: 16),
              label: const Text('Upload'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                textStyle: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
