import 'package:flutter/material.dart';

class FacultyProfilePage extends StatelessWidget {
  const FacultyProfilePage({super.key});

  static const _bg = Color(0xFF0D1F3C);
  static const _card = Color(0xFF111D35);
  static const _border = Color(0xFF1E3055);
  static const _accent = Color(0xFF1565C0);
  static const _gold = Color(0xFFD4A843);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Faculty Profile', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF1565C0), Color(0xFF0D47A1)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white24,
                      border: Border.all(color: Colors.white30, width: 3),
                    ),
                    child: const Center(
                      child: Text('RK', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Dr. R. Kumaran', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text('Associate Professor', style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 16)),
                        const SizedBox(height: 4),
                        Text('Department of Computer Science & Engineering', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _ProfileBadge(label: 'FAC001', icon: Icons.badge),
                            const SizedBox(width: 10),
                            _ProfileBadge(label: 'Ph.D', icon: Icons.school),
                            const SizedBox(width: 10),
                            _ProfileBadge(label: '12 Yrs Exp', icon: Icons.work_history),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Info Sections in a grid
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column
                Expanded(
                  child: Column(
                    children: [
                      _InfoCard(
                        title: 'Personal Information',
                        icon: Icons.person,
                        items: const [
                          {'label': 'Full Name', 'value': 'Dr. Ravichandran Kumaran'},
                          {'label': 'Employee ID', 'value': 'FAC001'},
                          {'label': 'Date of Birth', 'value': '15 March 1978'},
                          {'label': 'Gender', 'value': 'Male'},
                          {'label': 'Blood Group', 'value': 'B+'},
                          {'label': 'Nationality', 'value': 'Indian'},
                          {'label': 'Aadhaar (Last 4)', 'value': 'XXXX-XXXX-4521'},
                          {'label': 'PAN', 'value': 'BXXPK4567X'},
                        ],
                      ),
                      const SizedBox(height: 16),
                      _InfoCard(
                        title: 'Contact Information',
                        icon: Icons.contact_phone,
                        items: const [
                          {'label': 'Email (Official)', 'value': 'r.kumaran@ksrce.ac.in'},
                          {'label': 'Email (Personal)', 'value': 'kumaran.ravi@gmail.com'},
                          {'label': 'Phone', 'value': '+91 98765 43210'},
                          {'label': 'Office', 'value': 'CSE Block, Room 204'},
                          {'label': 'Address', 'value': '14, Nehru Street, Tiruchengode, Namakkal - 637215'},
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Right Column
                Expanded(
                  child: Column(
                    children: [
                      _InfoCard(
                        title: 'Academic Details',
                        icon: Icons.school,
                        items: const [
                          {'label': 'Designation', 'value': 'Associate Professor'},
                          {'label': 'Department', 'value': 'Computer Science & Engineering'},
                          {'label': 'Date of Joining', 'value': '01 July 2014'},
                          {'label': 'Qualification', 'value': 'Ph.D (CSE) - Anna University'},
                          {'label': 'M.E.', 'value': 'Computer Science - Anna University'},
                          {'label': 'B.E.', 'value': 'Computer Science - Bharathiar University'},
                          {'label': 'Experience', 'value': '12 Years (Teaching) | 2 Years (Industry)'},
                        ],
                      ),
                      const SizedBox(height: 16),
                      _InfoCard(
                        title: 'Specialization Areas',
                        icon: Icons.lightbulb,
                        items: const [
                          {'label': 'Primary', 'value': 'Compiler Design & Optimization'},
                          {'label': 'Secondary', 'value': 'Embedded Systems & IoT'},
                          {'label': 'Research', 'value': 'Machine Learning for Code Analysis'},
                          {'label': 'Interest', 'value': 'Formal Verification, Edge Computing'},
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Research & Publications Stats
            const Text('Research & Publication Summary', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                _ResearchStat(icon: Icons.article, label: 'Journal Papers', value: '18', color: _accent),
                _ResearchStat(icon: Icons.group_work, label: 'Conference Papers', value: '12', color: Colors.teal),
                _ResearchStat(icon: Icons.menu_book, label: 'Book Chapters', value: '3', color: Colors.orange),
                _ResearchStat(icon: Icons.format_quote, label: 'Total Citations', value: '247', color: _gold),
                _ResearchStat(icon: Icons.trending_up, label: 'H-Index', value: '9', color: Colors.purple),
                _ResearchStat(icon: Icons.science, label: 'Funded Projects', value: '2', color: Colors.redAccent),
                _ResearchStat(icon: Icons.people, label: 'Ph.D Scholars', value: '3', color: Colors.cyan),
                _ResearchStat(icon: Icons.lightbulb, label: 'Patents', value: '1', color: Colors.green),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ProfileBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  const _ProfileBadge({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white70),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Map<String, String>> items;
  const _InfoCard({required this.title, required this.icon, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111D35),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E3055)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF1565C0), size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 14),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 140,
                  child: Text(item['label']!, style: const TextStyle(color: Colors.white54, fontSize: 13)),
                ),
                Expanded(
                  child: Text(item['value']!, style: const TextStyle(color: Colors.white, fontSize: 13)),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _ResearchStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _ResearchStat({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111D35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E3055)),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 18, backgroundColor: color.withOpacity(0.15), child: Icon(icon, color: color, size: 18)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}
