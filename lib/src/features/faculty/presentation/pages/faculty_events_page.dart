import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class FacultyEventsPage extends StatelessWidget {
  const FacultyEventsPage({super.key});

  static const _bg = AppColors.background;
  static const _card = AppColors.surface;
  static const _border = AppColors.border;
  static const _accent = AppColors.primary;
  static const _gold = AppColors.accent;

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
                const Text('Events', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Create Event'),
                  style: ElevatedButton.styleFrom(backgroundColor: _accent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Department events, seminars, workshops, and coordination', style: TextStyle(color: AppColors.textLight, fontSize: 14)),
            const SizedBox(height: 24),

            // Upcoming Events
            const Text('Upcoming Events', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _EventCard(
              title: 'CyberQuest 2026 - Annual Technical Symposium',
              date: '15-16 Mar 2026',
              time: '09:00 AM - 05:00 PM',
              venue: 'KSR Auditorium & CSE Block',
              type: 'Symposium',
              role: 'Faculty Coordinator',
              description: 'Annual technical symposium of the CSE Department featuring paper presentations, coding contests, hackathon, and guest lectures.',
              participants: '500+',
              status: 'Planning',
              color: _gold,
              events: const ['Paper Presentation', 'Code-a-thon', '24Hr Hackathon', 'Debugging Contest', 'Tech Quiz'],
            ),
            const SizedBox(height: 12),
            _EventCard(
              title: 'Guest Lecture: Compiler Optimization in Industry',
              date: '05 Mar 2026',
              time: '10:30 AM - 12:30 PM',
              venue: 'CSE Seminar Hall',
              type: 'Guest Lecture',
              role: 'Organizer',
              description: 'Guest lecture by Dr. Ramakrishnan S, Principal Engineer at Intel India, on modern compiler optimization techniques used in production compilers.',
              participants: '120',
              status: 'Confirmed',
              color: _accent,
              events: const [],
            ),
            const SizedBox(height: 12),
            _EventCard(
              title: 'Workshop on IoT using Raspberry Pi',
              date: '22 Mar 2026',
              time: '09:00 AM - 04:00 PM',
              venue: 'CSE Lab 3',
              type: 'Workshop',
              role: 'Resource Person',
              description: 'Hands-on workshop for 5th semester students on IoT application development using Raspberry Pi, MQTT protocol, and sensor interfacing.',
              participants: '60',
              status: 'Confirmed',
              color: Colors.teal,
              events: const [],
            ),
            const SizedBox(height: 12),
            _EventCard(
              title: 'NAAC Accreditation Preparation Meeting',
              date: '28 Feb 2026',
              time: '03:00 PM - 05:00 PM',
              venue: 'Conference Hall',
              type: 'Meeting',
              role: 'Criteria 3 In-charge',
              description: 'Department meeting for NAAC accreditation preparation. Discussion on Criterion 3 (Research, Innovations & Extension) documentation.',
              participants: '25',
              status: 'Scheduled',
              color: Colors.orange,
              events: const [],
            ),
            const SizedBox(height: 28),

            // Past Events
            const Text('Recent Past Events', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _PastEventTile(title: 'FDP on Machine Learning & AI', date: '10-14 Feb 2026', type: 'FDP', role: 'Participant', venue: 'Online (NPTEL-AICTE)', color: Colors.purple),
            _PastEventTile(title: 'Anna University BOS Meeting', date: '05 Feb 2026', type: 'Meeting', role: 'Member', venue: 'Anna University, Chennai', color: _accent),
            _PastEventTile(title: 'IEEE Conference Paper Presentation', date: '01 Feb 2026', type: 'Conference', role: 'Presenter', venue: 'IIT Madras, Chennai', color: _gold),
            _PastEventTile(title: 'Orientation for Even Semester', date: '20 Jan 2026', type: 'Department', role: 'Coordinator', venue: 'CSE Seminar Hall', color: Colors.teal),
            _PastEventTile(title: 'Republic Day Celebrations', date: '26 Jan 2026', type: 'Cultural', role: 'Participant', venue: 'College Ground', color: Colors.orange),
            const SizedBox(height: 28),

            // Create Event Form
            const Text('Create New Event', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(14), border: Border.all(color: _border)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: _EField(label: 'Event Title', hint: 'Enter event title')),
                      const SizedBox(width: 14),
                      Expanded(child: _EField(label: 'Event Type', hint: 'Workshop / Seminar / Meeting')),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(child: _EField(label: 'Date', hint: 'DD/MM/YYYY')),
                      const SizedBox(width: 14),
                      Expanded(child: _EField(label: 'Time', hint: 'Start - End')),
                      const SizedBox(width: 14),
                      Expanded(child: _EField(label: 'Venue', hint: 'Hall / Room')),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(flex: 2, child: _EField(label: 'Description', hint: 'Event description...')),
                      const SizedBox(width: 14),
                      Expanded(child: _EField(label: 'Expected Participants', hint: 'Number')),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _EField(label: 'Resource Person / Chief Guest', hint: 'Name, Designation, Organization'),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.event_available, size: 16),
                      label: const Text('Create Event'),
                      style: ElevatedButton.styleFrom(backgroundColor: _accent, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final String title, date, time, venue, type, role, description, participants, status;
  final Color color;
  final List<String> events;
  const _EventCard({required this.title, required this.date, required this.time, required this.venue,
    required this.type, required this.role, required this.description, required this.participants,
    required this.status, required this.color, required this.events});

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.greenAccent;
    if (status == 'Planning') statusColor = Colors.orangeAccent;
    if (status == 'Scheduled') statusColor = AppColors.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                child: Text(type, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                child: Text(status, style: TextStyle(color: statusColor, fontSize: 12)),
              ),
              const Spacer(),
              Text('Your Role: $role', style: TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(description, style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
          const SizedBox(height: 12),
          Row(
            children: [
              _EvInfo(Icons.calendar_today, date),
              const SizedBox(width: 16),
              _EvInfo(Icons.access_time, time),
              const SizedBox(width: 16),
              _EvInfo(Icons.location_on, venue),
              const SizedBox(width: 16),
              _EvInfo(Icons.people, '$participants participants'),
            ],
          ),
          if (events.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: events.map((e) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.border)),
                child: Text(e, style: const TextStyle(color: AppColors.textLight, fontSize: 11)),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _EvInfo extends StatelessWidget {
  final IconData icon;
  final String text;
  const _EvInfo(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textLight),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
      ],
    );
  }
}

class _PastEventTile extends StatelessWidget {
  final String title, date, type, role, venue;
  final Color color;
  const _PastEventTile({required this.title, required this.date, required this.type, required this.role, required this.venue, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
      child: Row(
        children: [
          CircleAvatar(radius: 20, backgroundColor: color.withOpacity(0.15), child: Icon(Icons.event, color: color, size: 20)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 3),
                Text('$date | $venue', style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
            child: Text(role, style: TextStyle(color: color, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

class _EField extends StatelessWidget {
  final String label, hint;
  const _EField({required this.label, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textMedium, fontSize: 13)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            style: const TextStyle(color: AppColors.textDark, fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.border, fontSize: 13),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
