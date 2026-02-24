import 'package:flutter/material.dart';

class StudentLibraryPage extends StatelessWidget {
  const StudentLibraryPage({super.key});

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
              Icon(Icons.local_library, color: Color(0xFFD4A843), size: 28),
              SizedBox(width: 12),
              Text('Library', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            ]),
            const SizedBox(height: 8),
            const Text('Book Issues, Returns & Search', style: TextStyle(color: Colors.white60, fontSize: 14)),
            const SizedBox(height: 24),
            _buildLibrarySummary(),
            const SizedBox(height: 24),
            _buildBooksIssued(),
            const SizedBox(height: 24),
            _buildFineDetails(),
            const SizedBox(height: 24),
            _buildSearchBooks(),
          ],
        ),
      ),
    );
  }

  Widget _buildLibrarySummary() {
    return Row(
      children: [
        _summaryCard('Books Issued', '4', const Color(0xFF1565C0), Icons.book),
        const SizedBox(width: 16),
        _summaryCard('Books Returned', '12', Colors.green, Icons.assignment_return),
        const SizedBox(width: 16),
        _summaryCard('Overdue', '1', Colors.redAccent, Icons.warning),
        const SizedBox(width: 16),
        _summaryCard('Total Fine', 'Rs. 50', Colors.orange, Icons.money),
      ],
    );
  }

  Widget _summaryCard(String label, String value, Color color, IconData icon) {
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
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildBooksIssued() {
    final books = [
      {'title': 'Compilers: Principles, Techniques & Tools', 'author': 'Aho, Lam, Sethi, Ullman', 'isbn': '978-0321486813', 'issue': '10 Feb 2026', 'due': '10 Mar 2026', 'status': 'Issued'},
      {'title': 'Computer Networking: A Top-Down Approach', 'author': 'James F. Kurose, Keith W. Ross', 'isbn': '978-0132856201', 'issue': '12 Feb 2026', 'due': '12 Mar 2026', 'status': 'Issued'},
      {'title': 'Distributed Systems: Concepts & Design', 'author': 'George Coulouris et al.', 'isbn': '978-0132143011', 'issue': '05 Feb 2026', 'due': '05 Mar 2026', 'status': 'Issued'},
      {'title': 'Probability & Statistics for Engineers', 'author': 'R.E. Walpole, R.H. Myers', 'isbn': '978-0321629111', 'issue': '15 Jan 2026', 'due': '15 Feb 2026', 'status': 'Overdue'},
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
          const Text('Currently Issued Books', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2.5),
              1: FlexColumnWidth(2),
              2: FixedColumnWidth(130),
              3: FixedColumnWidth(100),
              4: FixedColumnWidth(100),
              5: FixedColumnWidth(80),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: const Color(0xFF1E3055)))),
                children: ['Book Title', 'Author', 'ISBN', 'Issue Date', 'Due Date', 'Status'].map((h) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(h, style: const TextStyle(color: Color(0xFFD4A843), fontWeight: FontWeight.bold, fontSize: 13)),
                )).toList(),
              ),
              ...books.map((b) {
                final isOverdue = b['status'] == 'Overdue';
                return TableRow(
                  children: [
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(b['title']!, style: const TextStyle(color: Colors.white, fontSize: 13))),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(b['author']!, style: const TextStyle(color: Colors.white70, fontSize: 13))),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(b['isbn']!, style: const TextStyle(color: Colors.white54, fontSize: 12))),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(b['issue']!, style: const TextStyle(color: Colors.white70, fontSize: 13))),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(b['due']!, style: TextStyle(color: isOverdue ? Colors.redAccent : Colors.white70, fontSize: 13, fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal))),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: (isOverdue ? Colors.redAccent : Colors.green).withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                      child: Text(b['status']!, style: TextStyle(color: isOverdue ? Colors.redAccent : Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
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

  Widget _buildFineDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
      ),
      child: Row(
        children: const [
          Icon(Icons.warning, color: Colors.redAccent, size: 20),
          SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Overdue Fine Notice', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 14)),
              SizedBox(height: 4),
              Text('"Probability & Statistics for Engineers" is overdue by 9 days. Fine: Rs. 5/day. Current fine: Rs. 50. Please return immediately to avoid further charges.', style: TextStyle(color: Colors.white70, fontSize: 13)),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildSearchBooks() {
    final searchResults = [
      {'title': 'Introduction to Algorithms', 'author': 'Cormen, Leiserson, Rivest', 'available': true, 'shelf': 'CS-A3-14'},
      {'title': 'Operating System Concepts', 'author': 'Silberschatz, Galvin', 'available': true, 'shelf': 'CS-A2-08'},
      {'title': 'Database System Concepts', 'author': 'Korth, Sudarshan', 'available': false, 'shelf': 'CS-A2-12'},
      {'title': 'Artificial Intelligence: A Modern Approach', 'author': 'Stuart Russell, Peter Norvig', 'available': true, 'shelf': 'CS-A4-03'},
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
          const Text('Search Books', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search by title, author, or ISBN...',
              hintStyle: const TextStyle(color: Colors.white38),
              prefixIcon: const Icon(Icons.search, color: Colors.white38),
              filled: true,
              fillColor: const Color(0xFF0D1F3C),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: const Color(0xFF1E3055))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: const Color(0xFF1E3055))),
            ),
          ),
          const SizedBox(height: 16),
          ...searchResults.map((r) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF0D1F3C), borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                const Icon(Icons.menu_book, color: Color(0xFF1565C0), size: 20),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(r['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                  Text(r['author'] as String, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ])),
                Text('Shelf: ${r['shelf']}', style: const TextStyle(color: Colors.white38, fontSize: 12)),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: ((r['available'] as bool) ? Colors.green : Colors.redAccent).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text((r['available'] as bool) ? 'Available' : 'Issued', style: TextStyle(color: (r['available'] as bool) ? Colors.green : Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
