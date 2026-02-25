import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class StudentCertificatesPage extends StatelessWidget {
  const StudentCertificatesPage({super.key});

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
              Icon(Icons.card_membership, color: AppColors.primary, size: 28),
              SizedBox(width: 12),
              Text('Certificates', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            ]),
            const SizedBox(height: 8),
            const Text('Request and download academic certificates', style: TextStyle(color: AppColors.textLight, fontSize: 14)),
            const SizedBox(height: 24),
            _buildAvailableCertificates(),
            const SizedBox(height: 24),
            _buildRequestHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableCertificates() {
    final certs = [
      {'name': 'Bonafide Certificate', 'desc': 'Proof of being a bonafide student of the institution', 'icon': Icons.verified, 'fee': 'Rs. 50', 'time': '2-3 working days'},
      {'name': 'Transfer Certificate', 'desc': 'Required when transferring to another institution', 'icon': Icons.swap_horiz, 'fee': 'Rs. 100', 'time': '5-7 working days'},
      {'name': 'Character Certificate', 'desc': 'Certificate of good character and conduct', 'icon': Icons.person_pin, 'fee': 'Rs. 50', 'time': '2-3 working days'},
      {'name': 'Study Certificate', 'desc': 'Proof of study period at the institution', 'icon': Icons.school, 'fee': 'Rs. 50', 'time': '2-3 working days'},
      {'name': 'Medium of Instruction', 'desc': 'Certificate stating English as medium of instruction', 'icon': Icons.language, 'fee': 'Rs. 50', 'time': '2-3 working days'},
      {'name': 'Course Completion', 'desc': 'Provisional certificate of course completion', 'icon': Icons.assignment_turned_in, 'fee': 'Rs. 100', 'time': '5-7 working days'},
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
          const Text('Available Certificates', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: certs.map((c) => SizedBox(
              width: 320,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(c['icon'] as IconData, color: AppColors.accent, size: 24),
                      const SizedBox(width: 10),
                      Expanded(child: Text(c['name'] as String, style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 15))),
                    ]),
                    const SizedBox(height: 8),
                    Text(c['desc'] as String, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
                    const SizedBox(height: 10),
                    Row(children: [
                      const Icon(Icons.monetization_on, color: AppColors.textLight, size: 14),
                      const SizedBox(width: 4),
                      Text('Fee: ${c['fee']}', style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
                      const SizedBox(width: 16),
                      const Icon(Icons.schedule, color: AppColors.textLight, size: 14),
                      const SizedBox(width: 4),
                      Text(c['time'] as String, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
                    ]),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          textStyle: const TextStyle(fontSize: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        child: const Text('Request Certificate'),
                      ),
                    ),
                  ],
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestHistory() {
    final requests = [
      {'cert': 'Bonafide Certificate', 'date': '18 Feb 2026', 'purpose': 'Bank loan application', 'status': 'Ready', 'refNo': 'CERT-2026-0123'},
      {'cert': 'Bonafide Certificate', 'date': '10 Jan 2026', 'purpose': 'Passport application', 'status': 'Collected', 'refNo': 'CERT-2026-0089'},
      {'cert': 'Study Certificate', 'date': '05 Dec 2025', 'purpose': 'Scholarship application', 'status': 'Collected', 'refNo': 'CERT-2025-0456'},
      {'cert': 'Character Certificate', 'date': '15 Nov 2025', 'purpose': 'Internship application', 'status': 'Collected', 'refNo': 'CERT-2025-0398'},
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
          const Text('Request History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 16),
          Table(
            columnWidths: const {
              0: FixedColumnWidth(120),
              1: FlexColumnWidth(1.5),
              2: FixedColumnWidth(100),
              3: FlexColumnWidth(1.5),
              4: FixedColumnWidth(90),
              5: FixedColumnWidth(100),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
                children: ['Ref No', 'Certificate', 'Date', 'Purpose', 'Status', 'Action'].map((h) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(h, style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 13)),
                )).toList(),
              ),
              ...requests.map((r) {
                final isReady = r['status'] == 'Ready';
                return TableRow(
                  children: [
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(r['refNo']!, style: const TextStyle(color: Color(0xFF64B5F6), fontSize: 12))),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(r['cert']!, style: const TextStyle(color: AppColors.textDark, fontSize: 13))),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(r['date']!, style: const TextStyle(color: AppColors.textMedium, fontSize: 13))),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(r['purpose']!, style: const TextStyle(color: AppColors.textLight, fontSize: 13))),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: (isReady ? Colors.green : Colors.grey).withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                      child: Text(r['status']!, style: TextStyle(color: isReady ? Colors.green : Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
                    )),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: isReady
                      ? TextButton.icon(onPressed: () {}, icon: const Icon(Icons.download, size: 16), label: const Text('Download', style: TextStyle(fontSize: 12)), style: TextButton.styleFrom(foregroundColor: Colors.green))
                      : const Text('-', style: TextStyle(color: AppColors.textLight)),
                    ),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
