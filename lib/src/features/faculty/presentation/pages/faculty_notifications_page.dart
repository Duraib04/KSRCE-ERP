import 'package:flutter/material.dart';

class FacultyNotificationsPage extends StatelessWidget {
  const FacultyNotificationsPage({super.key});

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
            const Text('Notifications', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('View notifications and send announcements to students', style: TextStyle(color: Colors.white54, fontSize: 14)),
            const SizedBox(height: 24),

            // Send Notification Form
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _accent.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.send, color: Color(0xFF1565C0), size: 20),
                      const SizedBox(width: 8),
                      const Text('Send Notification to Students', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Target', style: TextStyle(color: Colors.white70, fontSize: 13)),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(8), border: Border.all(color: _border)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: 'CS3501 - Sec A',
                                  dropdownColor: _card,
                                  isExpanded: true,
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                  items: [
                                    'All My Students',
                                    'CS3501 - Sec A',
                                    'CS3501 - Sec B',
                                    'CS3691 - Sec A',
                                    'CS3511 - Sec A',
                                    'CS3401 - Sec C',
                                  ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                                  onChanged: (_) {},
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Category', style: TextStyle(color: Colors.white70, fontSize: 13)),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(8), border: Border.all(color: _border)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: 'Assignment',
                                  dropdownColor: _card,
                                  isExpanded: true,
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                  items: ['Assignment', 'Exam', 'General', 'Attendance', 'Event', 'Urgent'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                                  onChanged: (_) {},
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text('Title', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(8), border: Border.all(color: _border)),
                    child: const TextField(
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(hintText: 'Notification title...', hintStyle: TextStyle(color: Colors.white24), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Message', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(8), border: Border.all(color: _border)),
                    child: const TextField(
                      maxLines: 3,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(hintText: 'Type your message...', hintStyle: TextStyle(color: Colors.white24), border: InputBorder.none, contentPadding: EdgeInsets.all(12)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.send, size: 16),
                      label: const Text('Send Notification'),
                      style: ElevatedButton.styleFrom(backgroundColor: _accent, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Sent Notifications
            const Text('Sent Notifications', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _SentNotification(
              title: 'IA-II Preparation - Important Topics',
              message: 'Focus on Unit II (Syntax Analysis) and Unit III (Intermediate Code Generation). Practice LL(1) parsing table construction and Three Address Code generation.',
              target: 'CS3501 - Sec A, B',
              time: '22 Feb 2026, 10:30 AM',
              category: 'Exam',
              icon: Icons.quiz,
              color: Colors.orange,
              readCount: 115,
              totalCount: 128,
            ),
            const SizedBox(height: 8),
            _SentNotification(
              title: 'Assignment 3 - Lexical Analyzer Submission',
              message: 'Submit the Lexical Analyzer implementation by 28 Feb 2026. Use LEX tool and attach the .l file along with output screenshots.',
              target: 'CS3501 - Sec A',
              time: '20 Feb 2026, 09:15 AM',
              category: 'Assignment',
              icon: Icons.assignment,
              color: _accent,
              readCount: 52,
              totalCount: 65,
            ),
            const SizedBox(height: 8),
            _SentNotification(
              title: 'IoT Lab - MQTT Setup Instructions',
              message: 'Install Mosquitto MQTT broker before the next lab. Follow the setup guide shared on Google Classroom. Bring your Raspberry Pi kits.',
              target: 'CS3691 - Sec A',
              time: '18 Feb 2026, 02:00 PM',
              category: 'General',
              icon: Icons.info,
              color: Colors.teal,
              readCount: 58,
              totalCount: 62,
            ),
            const SizedBox(height: 8),
            _SentNotification(
              title: 'Low Attendance Warning',
              message: 'Students below 75% attendance are requested to meet the faculty during office hours (Wed 3-4 PM). Attendance shortage may lead to exam detention.',
              target: 'CS3501 - Sec A',
              time: '15 Feb 2026, 11:00 AM',
              category: 'Attendance',
              icon: Icons.warning_amber,
              color: Colors.redAccent,
              readCount: 8,
              totalCount: 8,
            ),
            const SizedBox(height: 28),

            // Received Notifications
            const Text('Received Notifications', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...[
              _ReceivedNotification(title: 'Faculty Senate Meeting', from: 'Principal Office', time: '24 Feb, 08:00 AM', icon: Icons.event, color: _accent, isRead: false),
              _ReceivedNotification(title: 'IA-II Marks Entry Deadline', from: 'CoE Office', time: '23 Feb, 04:30 PM', icon: Icons.assignment_late, color: Colors.orange, isRead: false),
              _ReceivedNotification(title: 'Revised Academic Calendar', from: 'Anna University', time: '22 Feb, 10:00 AM', icon: Icons.calendar_month, color: _gold, isRead: true),
              _ReceivedNotification(title: 'CyberQuest 2026 Coordination', from: 'HOD Office', time: '21 Feb, 03:00 PM', icon: Icons.event_note, color: Colors.purple, isRead: true),
              _ReceivedNotification(title: 'AICTE Grant Update', from: 'R&D Cell', time: '20 Feb, 11:30 AM', icon: Icons.science, color: Colors.teal, isRead: true),
              _ReceivedNotification(title: 'Workshop on NEP 2020', from: 'IQAC', time: '19 Feb, 09:00 AM', icon: Icons.school, color: Colors.cyan, isRead: true),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _SentNotification extends StatelessWidget {
  final String title, message, target, time, category;
  final IconData icon;
  final Color color;
  final int readCount, totalCount;
  const _SentNotification({required this.title, required this.message, required this.target, required this.time,
    required this.category, required this.icon, required this.color, required this.readCount, required this.totalCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF111D35), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF1E3055))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 18, backgroundColor: color.withOpacity(0.15), child: Icon(icon, color: color, size: 18)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                    Text('To: $target | $category', style: const TextStyle(color: Colors.white38, fontSize: 11)),
                  ],
                ),
              ),
              Text(time, style: const TextStyle(color: Colors.white30, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 8),
          Text(message, style: const TextStyle(color: Colors.white54, fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.visibility, size: 14, color: Colors.white30),
              const SizedBox(width: 4),
              Text('Read by $readCount/$totalCount students', style: const TextStyle(color: Colors.white30, fontSize: 11)),
              const SizedBox(width: 8),
              SizedBox(
                width: 80,
                child: LinearProgressIndicator(
                  value: readCount / totalCount,
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation(color),
                  minHeight: 3,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReceivedNotification extends StatelessWidget {
  final String title, from, time;
  final IconData icon;
  final Color color;
  final bool isRead;
  const _ReceivedNotification({required this.title, required this.from, required this.time, required this.icon, required this.color, required this.isRead});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111D35),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isRead ? const Color(0xFF1E3055) : color.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 18, backgroundColor: color.withOpacity(0.15), child: Icon(icon, color: color, size: 18)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: isRead ? FontWeight.normal : FontWeight.bold)),
                Text('From: $from', style: const TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
          ),
          if (!isRead)
            Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
          const SizedBox(width: 8),
          Text(time, style: const TextStyle(color: Colors.white30, fontSize: 11)),
        ],
      ),
    );
  }
}
