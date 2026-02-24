import 'package:flutter/material.dart';

class StudentEventsPage extends StatelessWidget {
  const StudentEventsPage({super.key});

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
              Icon(Icons.event, color: Color(0xFFD4A843), size: 28),
              SizedBox(width: 12),
              Text('Events', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            ]),
            const SizedBox(height: 8),
            const Text('College events, workshops, and activities', style: TextStyle(color: Colors.white60, fontSize: 14)),
            const SizedBox(height: 24),
            _buildUpcomingEvents(),
            const SizedBox(height: 24),
            _buildRegisteredEvents(),
            const SizedBox(height: 24),
            _buildPastEvents(),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingEvents() {
    final events = [
      {'name': 'KSRCE Hackathon 2026 - InnoVate', 'date': '15-16 Mar 2026', 'venue': 'Seminar Hall & Labs', 'type': 'Technical', 'desc': '24-hour hackathon on Sustainable Development Goals. Team size: 3-4 members. Prizes worth Rs. 50,000.', 'color': Colors.purple},
      {'name': 'Annual Sports Day', 'date': '10 Mar 2026', 'venue': 'College Ground', 'type': 'Sports', 'desc': 'Inter-department sports competitions. Events: Cricket, Football, Volleyball, Athletics, Kabaddi.', 'color': Colors.green},
      {'name': 'Guest Lecture: 5G and Beyond', 'date': '27 Feb 2026', 'venue': 'Seminar Hall', 'type': 'Academic', 'desc': 'Guest lecture by Dr. Arvind Kumar, IIT Madras. Mandatory for CS and IT students.', 'color': Colors.blue},
      {'name': 'Cultural Fest - Rhapsody 2026', 'date': '20-22 Mar 2026', 'venue': 'Auditorium & Campus', 'type': 'Cultural', 'desc': 'Annual cultural festival with music, dance, drama, fine arts competitions. Open to all colleges.', 'color': Colors.orange},
      {'name': 'Workshop: Cloud Computing with AWS', 'date': '08 Mar 2026', 'venue': 'Lab 2', 'type': 'Workshop', 'desc': '1-day hands-on workshop on AWS services. Learn EC2, S3, Lambda, DynamoDB. Certificate provided.', 'color': Colors.cyan},
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
          Row(children: const [
            Icon(Icons.upcoming, color: Color(0xFFD4A843), size: 20),
            SizedBox(width: 8),
            Text('Upcoming Events', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ]),
          const SizedBox(height: 16),
          ...events.map((e) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1F3C),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: (e['color'] as Color).withOpacity(0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (e['color'] as Color).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    e['type'] == 'Technical' ? Icons.code : e['type'] == 'Sports' ? Icons.sports : e['type'] == 'Academic' ? Icons.school : e['type'] == 'Cultural' ? Icons.music_note : Icons.computer,
                    color: e['color'] as Color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(child: Text(e['name'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: (e['color'] as Color).withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                        child: Text(e['type'] as String, style: TextStyle(color: e['color'] as Color, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ]),
                    const SizedBox(height: 6),
                    Text(e['desc'] as String, style: const TextStyle(color: Colors.white54, fontSize: 13)),
                    const SizedBox(height: 8),
                    Row(children: [
                      const Icon(Icons.calendar_today, color: Colors.white38, size: 14),
                      const SizedBox(width: 4),
                      Text(e['date'] as String, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      const SizedBox(width: 16),
                      const Icon(Icons.location_on, color: Colors.white38, size: 14),
                      const SizedBox(width: 4),
                      Text(e['venue'] as String, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (e['color'] as Color).withOpacity(0.2),
                          foregroundColor: e['color'] as Color,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          textStyle: const TextStyle(fontSize: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        child: const Text('Register'),
                      ),
                    ]),
                  ],
                )),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildRegisteredEvents() {
    final registered = [
      {'name': 'KSRCE Hackathon 2026 - InnoVate', 'date': '15-16 Mar 2026', 'team': 'Team AlphaCoders', 'status': 'Confirmed'},
      {'name': 'Workshop: Cloud Computing with AWS', 'date': '08 Mar 2026', 'team': 'Individual', 'status': 'Confirmed'},
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
          Row(children: const [
            Icon(Icons.how_to_reg, color: Colors.green, size: 20),
            SizedBox(width: 8),
            Text('My Registered Events', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ]),
          const SizedBox(height: 16),
          ...registered.map((r) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFF0D1F3C), borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(r['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14)),
                  Text('${r['date']} | ${r['team']}', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ])),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                  child: Text(r['status']!, style: const TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildPastEvents() {
    final past = [
      {'name': 'Tech Symposium - Innovista 2025', 'date': '15 Nov 2025', 'participation': 'Paper Presentation - 2nd Prize'},
      {'name': 'Coding Contest - CodeStorm', 'date': '20 Oct 2025', 'participation': 'Participant - Top 10'},
      {'name': 'Workshop: Full Stack with MERN', 'date': '05 Sep 2025', 'participation': 'Completed with Certificate'},
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
          Row(children: const [
            Icon(Icons.history, color: Colors.white54, size: 20),
            SizedBox(width: 8),
            Text('Past Events', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ]),
          const SizedBox(height: 16),
          ...past.map((p) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFF0D1F3C), borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                const Icon(Icons.emoji_events, color: Color(0xFFD4A843), size: 20),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(p['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14)),
                  Text(p['date']!, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                ])),
                Text(p['participation']!, style: const TextStyle(color: Color(0xFFD4A843), fontSize: 12)),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
