import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class StudentPlacementsPage extends StatelessWidget {
  const StudentPlacementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: const [
              Icon(Icons.work, color: AppColors.primary, size: 28),
              SizedBox(width: 12),
              Text('Placements', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            ]),
            const SizedBox(height: 8),
            const Text('Campus Placement Portal - Academic Year 2025-26', style: TextStyle(color: AppColors.textLight, fontSize: 14)),
            const SizedBox(height: 24),
            _buildPlacementStats(),
            const SizedBox(height: 24),
            _buildUpcomingDrives(),
            const SizedBox(height: 24),
            _buildAppliedDrives(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlacementStats() {
    return Row(
      children: [
        _statCard('Companies Visited', '24', Icons.business, AppColors.primary),
        const SizedBox(width: 16),
        _statCard('Total Offers', '156', Icons.handshake, Colors.green),
        const SizedBox(width: 16),
        _statCard('Avg Package', '6.2 LPA', Icons.currency_rupee, AppColors.accent),
        const SizedBox(width: 16),
        _statCard('Highest Package', '42 LPA', Icons.trending_up, Colors.purple),
        const SizedBox(width: 16),
        _statCard('Your Applications', '3', Icons.send, Colors.orange),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: AppColors.textLight, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingDrives() {
    final drives = [
      {'company': 'Tata Consultancy Services (TCS)', 'date': '28 Feb 2026', 'role': 'Software Developer', 'package': '7.0 LPA', 'eligibility': 'CGPA >= 7.0, No active backlogs', 'lastDate': '26 Feb 2026', 'logo': 'TCS'},
      {'company': 'Infosys Limited', 'date': '05 Mar 2026', 'role': 'Systems Engineer', 'package': '6.5 LPA', 'eligibility': 'CGPA >= 6.5, All branches', 'lastDate': '03 Mar 2026', 'logo': 'INF'},
      {'company': 'Wipro Technologies', 'date': '10 Mar 2026', 'role': 'Project Engineer', 'package': '6.0 LPA', 'eligibility': 'CGPA >= 6.0, CSE/IT/ECE', 'lastDate': '08 Mar 2026', 'logo': 'WIP'},
      {'company': 'Zoho Corporation', 'date': '15 Mar 2026', 'role': 'Member Technical Staff', 'package': '8.5 LPA', 'eligibility': 'CGPA >= 7.5, CSE/IT only', 'lastDate': '12 Mar 2026', 'logo': 'ZHO'},
      {'company': 'Cognizant Technology Solutions', 'date': '20 Mar 2026', 'role': 'Programmer Analyst', 'package': '5.5 LPA', 'eligibility': 'CGPA >= 6.0, All branches', 'lastDate': '18 Mar 2026', 'logo': 'CTS'},
    ];
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
          Row(children: const [
            Icon(Icons.upcoming, color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text('Upcoming Campus Drives', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          ]),
          const SizedBox(height: 16),
          ...drives.map((d) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(child: Text(d['logo']!, style: const TextStyle(color: Color(0xFF64B5F6), fontWeight: FontWeight.bold, fontSize: 14))),
                ),
                const SizedBox(width: 16),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(d['company']!, style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    Row(children: [
                      Text(d['role']!, style: const TextStyle(color: AppColors.textMedium, fontSize: 13)),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                        child: Text(d['package']!, style: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ]),
                    const SizedBox(height: 4),
                    Text('Eligibility: ${d['eligibility']}', style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
                  ],
                )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(children: [
                      const Icon(Icons.event, color: AppColors.textLight, size: 14),
                      const SizedBox(width: 4),
                      Text(d['date']!, style: const TextStyle(color: AppColors.textMedium, fontSize: 13)),
                    ]),
                    const SizedBox(height: 4),
                    Text('Apply by: ${d['lastDate']}', style: const TextStyle(color: Colors.orange, fontSize: 11)),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        textStyle: const TextStyle(fontSize: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      child: const Text('Apply Now'),
                    ),
                  ],
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildAppliedDrives() {
    final applied = [
      {'company': 'Accenture', 'role': 'Associate Software Engineer', 'package': '6.5 LPA', 'applied': '15 Feb 2026', 'status': 'Shortlisted', 'round': 'Technical Interview on 01 Mar'},
      {'company': 'HCLTech', 'role': 'Graduate Engineer Trainee', 'package': '5.0 LPA', 'applied': '10 Feb 2026', 'status': 'In Process', 'round': 'Aptitude Test Cleared'},
      {'company': 'L&T Infotech', 'role': 'Software Developer', 'package': '5.5 LPA', 'applied': '05 Feb 2026', 'status': 'Not Selected', 'round': 'Eliminated in GD Round'},
    ];
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
          Row(children: const [
            Icon(Icons.send, color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text('My Applications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          ]),
          const SizedBox(height: 16),
          ...applied.map((a) {
            Color statusColor = a['status'] == 'Shortlisted' ? Colors.green : a['status'] == 'In Process' ? Colors.blue : Colors.redAccent;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: statusColor.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(a['company']!, style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 14)),
                    Row(children: [
                      Text(a['role']!, style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
                      const SizedBox(width: 12),
                      Text(a['package']!, style: const TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold)),
                    ]),
                    Text(a['round']!, style: TextStyle(color: statusColor, fontSize: 12)),
                  ])),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                      child: Text(a['status']!, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 4),
                    Text('Applied: ${a['applied']}', style: const TextStyle(color: AppColors.textLight, fontSize: 11)),
                  ]),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
