import 'package:flutter/material.dart';

class FacultyResearchPage extends StatelessWidget {
  const FacultyResearchPage({super.key});

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Research & Publications', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Publication'),
                  style: ElevatedButton.styleFrom(backgroundColor: _accent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Manage publications, research projects, and academic contributions', style: TextStyle(color: Colors.white54, fontSize: 14)),
            const SizedBox(height: 24),

            // Research Stats
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                _RStat(icon: Icons.article, label: 'Journal Papers', value: '18', color: _accent),
                _RStat(icon: Icons.groups, label: 'Conference Papers', value: '12', color: Colors.teal),
                _RStat(icon: Icons.auto_stories, label: 'Book Chapters', value: '3', color: Colors.orange),
                _RStat(icon: Icons.format_quote, label: 'Total Citations', value: '247', color: _gold),
                _RStat(icon: Icons.trending_up, label: 'H-Index', value: '9', color: Colors.purple),
                _RStat(icon: Icons.star, label: 'i10-Index', value: '7', color: Colors.cyan),
                _RStat(icon: Icons.science, label: 'Funded Projects', value: '2', color: Colors.redAccent),
                _RStat(icon: Icons.school, label: 'Ph.D Scholars', value: '3', color: Colors.lightGreen),
              ],
            ),
            const SizedBox(height: 28),

            // Publications List
            const Text('Recent Publications', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _PublicationCard(
              title: 'Deep Learning-Based Optimization of Compiler Intermediate Representations for Edge Computing',
              journal: 'IEEE Transactions on Software Engineering',
              year: '2025',
              citations: 12,
              impactFactor: 9.322,
              type: 'SCI',
              doi: '10.1109/TSE.2025.3456789',
              coAuthors: 'Dr. S. Priya, Dr. M. Anitha',
              color: _accent,
            ),
            const SizedBox(height: 10),
            _PublicationCard(
              title: 'IoT-Enabled Smart Campus Framework: Architecture and Implementation for Indian Engineering Colleges',
              journal: 'Journal of Network and Computer Applications (Elsevier)',
              year: '2025',
              citations: 8,
              impactFactor: 7.574,
              type: 'SCI',
              doi: '10.1016/j.jnca.2025.103456',
              coAuthors: 'Dr. K. Senthilkumar, Mr. A. Balamurugan',
              color: _accent,
            ),
            const SizedBox(height: 10),
            _PublicationCard(
              title: 'RTOS Task Scheduling Optimization using Genetic Algorithms for Embedded IoT Devices',
              journal: 'Microprocessors and Microsystems (Elsevier)',
              year: '2024',
              citations: 22,
              impactFactor: 2.608,
              type: 'SCI',
              doi: '10.1016/j.micro.2024.104891',
              coAuthors: 'Dr. P. Venkatesh',
              color: Colors.teal,
            ),
            const SizedBox(height: 10),
            _PublicationCard(
              title: 'Peephole Optimization Techniques for LLVM-Based Compilers: A Comprehensive Survey',
              journal: 'ACM Computing Surveys',
              year: '2024',
              citations: 35,
              impactFactor: 16.6,
              type: 'SCI',
              doi: '10.1145/3589132',
              coAuthors: 'Dr. R. Kumaran (Single Author)',
              color: _gold,
            ),
            const SizedBox(height: 10),
            _PublicationCard(
              title: 'Machine Learning for Automated Vulnerability Detection in Compiled Code',
              journal: 'International Conference on Software Engineering (ICSE 2024)',
              year: '2024',
              citations: 18,
              impactFactor: 0,
              type: 'Scopus',
              doi: '10.1145/3597503.3623',
              coAuthors: 'Ms. Lakshmi Priya R (Student), Dr. S. Priya',
              color: Colors.orange,
            ),
            const SizedBox(height: 28),

            // Research Projects
            const Text('Research Projects', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _ProjectCard(
              title: 'AI-Driven Compiler Optimization Framework for IoT Edge Devices',
              fundingAgency: 'AICTE - Research Promotion Scheme (RPS)',
              amount: '25,00,000',
              duration: 'Jan 2024 - Dec 2026 (3 Years)',
              status: 'Ongoing',
              pi: 'Dr. R. Kumaran (PI)',
              coPi: 'Dr. S. Priya (Co-PI)',
              color: _accent,
            ),
            const SizedBox(height: 10),
            _ProjectCard(
              title: 'Smart Campus IoT Infrastructure for Rural Engineering Colleges',
              fundingAgency: 'DST - Science & Engineering Research Board (SERB)',
              amount: '18,50,000',
              duration: 'Apr 2023 - Mar 2026 (3 Years)',
              status: 'Ongoing',
              pi: 'Dr. R. Kumaran (PI)',
              coPi: 'Dr. K. Senthilkumar (Co-PI)',
              color: Colors.teal,
            ),
            const SizedBox(height: 10),
            _ProjectCard(
              title: 'Formal Verification Methods for Safety-Critical Embedded Software',
              fundingAgency: 'UGC - Minor Research Project',
              amount: '6,00,000',
              duration: 'Jul 2021 - Jun 2023 (2 Years)',
              status: 'Completed',
              pi: 'Dr. R. Kumaran (PI)',
              coPi: '',
              color: _gold,
            ),
            const SizedBox(height: 28),

            // Ph.D Scholars
            const Text('Ph.D Research Scholars', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _ScholarCard(name: 'Mr. A. Balamurugan', regNo: 'RS2022001', topic: 'Energy-Efficient Code Compilation for IoT Edge Devices', university: 'Anna University', status: 'Pursuing (3rd Year)', publications: 4),
            const SizedBox(height: 8),
            _ScholarCard(name: 'Ms. R. Divya', regNo: 'RS2023015', topic: 'ML-Based Vulnerability Detection in Compiler-Generated Code', university: 'Anna University', status: 'Pursuing (2nd Year)', publications: 2),
            const SizedBox(height: 8),
            _ScholarCard(name: 'Mr. S. Karthik', regNo: 'RS2024008', topic: 'Formal Methods for RTOS Verification in Automotive Systems', university: 'Anna University', status: 'Pursuing (1st Year)', publications: 1),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _RStat extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color;
  const _RStat({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF111D35), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF1E3055))),
      child: Row(
        children: [
          CircleAvatar(radius: 18, backgroundColor: color.withOpacity(0.15), child: Icon(icon, color: color, size: 18)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PublicationCard extends StatelessWidget {
  final String title, journal, year, doi, coAuthors, type;
  final int citations;
  final double impactFactor;
  final Color color;
  const _PublicationCard({required this.title, required this.journal, required this.year, required this.citations,
    required this.impactFactor, required this.type, required this.doi, required this.coAuthors, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: const Color(0xFF111D35), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF1E3055))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600))),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                child: Text(type, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(journal, style: const TextStyle(color: Colors.white54, fontSize: 13, fontStyle: FontStyle.italic)),
          const SizedBox(height: 6),
          Text('Co-authors: $coAuthors', style: const TextStyle(color: Colors.white38, fontSize: 12)),
          const SizedBox(height: 10),
          Row(
            children: [
              _PubInfo(Icons.calendar_today, year),
              const SizedBox(width: 16),
              _PubInfo(Icons.format_quote, '$citations Citations'),
              if (impactFactor > 0) ...[
                const SizedBox(width: 16),
                _PubInfo(Icons.trending_up, 'IF: ${impactFactor.toStringAsFixed(3)}'),
              ],
              const SizedBox(width: 16),
              _PubInfo(Icons.link, doi),
            ],
          ),
        ],
      ),
    );
  }
}

class _PubInfo extends StatelessWidget {
  final IconData icon;
  final String text;
  const _PubInfo(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: Colors.white30),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Colors.white54, fontSize: 11)),
      ],
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final String title, fundingAgency, amount, duration, status, pi, coPi;
  final Color color;
  const _ProjectCard({required this.title, required this.fundingAgency, required this.amount, required this.duration,
    required this.status, required this.pi, required this.coPi, required this.color});

  @override
  Widget build(BuildContext context) {
    final isOngoing = status == 'Ongoing';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: const Color(0xFF111D35), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF1E3055))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.science, color: color, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isOngoing ? Colors.greenAccent.withOpacity(0.12) : const Color(0xFFD4A843).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(status, style: TextStyle(color: isOngoing ? Colors.greenAccent : const Color(0xFFD4A843), fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _PubInfo(Icons.account_balance, fundingAgency),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _PubInfo(Icons.currency_rupee, 'Rs. $amount'),
              const SizedBox(width: 20),
              _PubInfo(Icons.date_range, duration),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _PubInfo(Icons.person, pi),
              if (coPi.isNotEmpty) ...[const SizedBox(width: 20), _PubInfo(Icons.person_outline, coPi)],
            ],
          ),
        ],
      ),
    );
  }
}

class _ScholarCard extends StatelessWidget {
  final String name, regNo, topic, university, status;
  final int publications;
  const _ScholarCard({required this.name, required this.regNo, required this.topic, required this.university, required this.status, required this.publications});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF111D35), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF1E3055))),
      child: Row(
        children: [
          CircleAvatar(radius: 22, backgroundColor: const Color(0xFF1565C0).withOpacity(0.15), child: const Icon(Icons.school, color: Color(0xFF1565C0), size: 20)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                    const SizedBox(width: 8),
                    Text('($regNo)', style: const TextStyle(color: Colors.white38, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(topic, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                const SizedBox(height: 4),
                Text('$university | $status | $publications publications', style: const TextStyle(color: Colors.white38, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
