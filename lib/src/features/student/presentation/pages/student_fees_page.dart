import 'package:flutter/material.dart';

class StudentFeesPage extends StatelessWidget {
  const StudentFeesPage({super.key});

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
              Icon(Icons.payment, color: Color(0xFFD4A843), size: 28),
              SizedBox(width: 12),
              Text('Fee Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            ]),
            const SizedBox(height: 8),
            const Text('Academic Year 2025-26 | Semester 5', style: TextStyle(color: Colors.white60, fontSize: 14)),
            const SizedBox(height: 24),
            _buildFeeSummary(),
            const SizedBox(height: 24),
            _buildFeeBreakdown(),
            const SizedBox(height: 24),
            _buildPaymentHistory(),
            const SizedBox(height: 24),
            _buildPayButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeeSummary() {
    return Row(
      children: [
        _feeCard('Total Fee', '1,25,000', const Color(0xFF1565C0), Icons.account_balance),
        const SizedBox(width: 16),
        _feeCard('Paid', '75,000', Colors.green, Icons.check_circle),
        const SizedBox(width: 16),
        _feeCard('Pending', '50,000', Colors.redAccent, Icons.pending),
        const SizedBox(width: 16),
        _feeCard('Due Date', '15 Mar 2026', Colors.orange, Icons.event),
      ],
    );
  }

  Widget _feeCard(String label, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF111D35),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1E3055)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.white60, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildFeeBreakdown() {
    final fees = [
      {'description': 'Tuition Fee', 'amount': '55,000', 'status': 'Paid', 'date': '15 Jul 2025'},
      {'description': 'Laboratory Fee', 'amount': '10,000', 'status': 'Paid', 'date': '15 Jul 2025'},
      {'description': 'Library Fee', 'amount': '3,000', 'status': 'Paid', 'date': '15 Jul 2025'},
      {'description': 'Exam Fee', 'amount': '5,000', 'status': 'Paid', 'date': '20 Jul 2025'},
      {'description': 'Transport Fee', 'amount': '15,000', 'status': 'Pending', 'date': '-'},
      {'description': 'Hostel Fee', 'amount': '25,000', 'status': 'Pending', 'date': '-'},
      {'description': 'Sports & Activities', 'amount': '2,000', 'status': 'Paid', 'date': '15 Jul 2025'},
      {'description': 'Development Fund', 'amount': '5,000', 'status': 'Pending', 'date': '-'},
      {'description': 'Insurance', 'amount': '2,500', 'status': 'Pending', 'date': '-'},
      {'description': 'Identity Card', 'amount': '500', 'status': 'Pending', 'date': '-'},
      {'description': 'Caution Deposit', 'amount': '2,000', 'status': 'Paid', 'date': '22 Jul 2022'},
    ];
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
          const Text('Fee Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FixedColumnWidth(100),
              2: FixedColumnWidth(80),
              3: FixedColumnWidth(110),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: const Color(0xFF1E3055)))),
                children: ['Description', 'Amount', 'Status', 'Date'].map((h) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(h, style: const TextStyle(color: Color(0xFFD4A843), fontWeight: FontWeight.bold, fontSize: 13)),
                )).toList(),
              ),
              ...fees.map((f) {
                final isPaid = f['status'] == 'Paid';
                return TableRow(
                  children: [
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(f['description']!, style: const TextStyle(color: Colors.white, fontSize: 13))),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(f['amount']!, style: const TextStyle(color: Colors.white70, fontSize: 13))),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: (isPaid ? Colors.green : Colors.orange).withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                      child: Text(f['status']!, style: TextStyle(color: isPaid ? Colors.green : Colors.orange, fontSize: 11, fontWeight: FontWeight.bold)),
                    )),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(f['date']!, style: const TextStyle(color: Colors.white54, fontSize: 13))),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentHistory() {
    final payments = [
      {'id': 'TXN20250715001', 'date': '15 Jul 2025', 'amount': '70,000', 'mode': 'Net Banking', 'status': 'Success'},
      {'id': 'TXN20250720002', 'date': '20 Jul 2025', 'amount': '5,000', 'mode': 'UPI', 'status': 'Success'},
      {'id': 'TXN20220722001', 'date': '22 Jul 2022', 'amount': '2,000', 'mode': 'Cash', 'status': 'Success'},
    ];
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
          const Text('Payment History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          ...payments.map((p) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFF0D1F3C), borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                const Icon(Icons.receipt_long, color: Colors.green, size: 20),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Transaction: ${p['id']}', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                  Text('${p['date']} | ${p['mode']}', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ])),
                Text(p['amount']!, style: const TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                  child: const Text('Success', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildPayButton() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.payment, size: 20),
        label: const Text('Pay Pending Fees - Rs. 50,000'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1565C0),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
