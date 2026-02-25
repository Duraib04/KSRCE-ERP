import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class FacultyTimetablePage extends StatefulWidget {
  const FacultyTimetablePage({super.key});

  @override
  State<FacultyTimetablePage> createState() => _FacultyTimetablePageState();
}

class _FacultyTimetablePageState extends State<FacultyTimetablePage> with SingleTickerProviderStateMixin {
  static const _bg = AppColors.background;
  static const _card = AppColors.surface;
  static const _border = AppColors.border;
  static const _accent = AppColors.primary;
  static const _gold = AppColors.accent;

  late TabController _tabController;
  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

  final Map<String, List<Map<String, String>>> _timetable = {
    'Monday': [
      {'time': '08:30 - 09:20', 'course': 'CS3501 - Compiler Design', 'section': 'A', 'room': 'Room 301', 'type': 'Theory'},
      {'time': '09:20 - 10:10', 'course': 'CS3501 - Compiler Design', 'section': 'B', 'room': 'Room 405', 'type': 'Theory'},
      {'time': '10:10 - 10:30', 'course': 'Break', 'section': '', 'room': '', 'type': 'Break'},
      {'time': '10:30 - 11:20', 'course': 'Free Period', 'section': '', 'room': '', 'type': 'Free'},
      {'time': '11:20 - 12:10', 'course': 'CS3691 - Embedded Systems & IoT', 'section': 'A', 'room': 'Room 302', 'type': 'Theory'},
      {'time': '12:10 - 13:00', 'course': 'Lunch Break', 'section': '', 'room': '', 'type': 'Break'},
      {'time': '13:00 - 13:50', 'course': 'Free Period', 'section': '', 'room': '', 'type': 'Free'},
      {'time': '14:00 - 15:40', 'course': 'CS3511 - Compiler Design Lab', 'section': 'A (Batch 1)', 'room': 'CSE Lab 2', 'type': 'Lab'},
    ],
    'Tuesday': [
      {'time': '08:30 - 09:20', 'course': 'CS3401 - Algorithms Design & Analysis', 'section': 'C', 'room': 'Room 201', 'type': 'Theory'},
      {'time': '09:20 - 10:10', 'course': 'CS3501 - Compiler Design', 'section': 'A', 'room': 'Room 301', 'type': 'Theory'},
      {'time': '10:10 - 10:30', 'course': 'Break', 'section': '', 'room': '', 'type': 'Break'},
      {'time': '10:30 - 11:20', 'course': 'CS3691 - Embedded Systems & IoT', 'section': 'A', 'room': 'Room 302', 'type': 'Theory'},
      {'time': '11:20 - 12:10', 'course': 'Free Period', 'section': '', 'room': '', 'type': 'Free'},
      {'time': '12:10 - 13:00', 'course': 'Lunch Break', 'section': '', 'room': '', 'type': 'Break'},
      {'time': '13:00 - 13:50', 'course': 'CS3401 - Algorithms Design & Analysis', 'section': 'C', 'room': 'Room 201', 'type': 'Theory'},
      {'time': '13:50 - 14:40', 'course': 'Free Period', 'section': '', 'room': '', 'type': 'Free'},
    ],
    'Wednesday': [
      {'time': '08:30 - 09:20', 'course': 'CS3501 - Compiler Design', 'section': 'B', 'room': 'Room 405', 'type': 'Theory'},
      {'time': '09:20 - 10:10', 'course': 'Free Period', 'section': '', 'room': '', 'type': 'Free'},
      {'time': '10:10 - 10:30', 'course': 'Break', 'section': '', 'room': '', 'type': 'Break'},
      {'time': '10:30 - 12:10', 'course': 'CS3511 - Compiler Design Lab', 'section': 'A (Batch 2)', 'room': 'CSE Lab 2', 'type': 'Lab'},
      {'time': '12:10 - 13:00', 'course': 'Lunch Break', 'section': '', 'room': '', 'type': 'Break'},
      {'time': '13:00 - 13:50', 'course': 'CS3691 - Embedded Systems & IoT', 'section': 'A', 'room': 'Room 302', 'type': 'Theory'},
      {'time': '13:50 - 14:40', 'course': 'CS3401 - Algorithms Design & Analysis', 'section': 'C', 'room': 'Room 201', 'type': 'Theory'},
    ],
    'Thursday': [
      {'time': '08:30 - 09:20', 'course': 'CS3501 - Compiler Design', 'section': 'A', 'room': 'Room 301', 'type': 'Theory'},
      {'time': '09:20 - 10:10', 'course': 'CS3501 - Compiler Design', 'section': 'B', 'room': 'Room 405', 'type': 'Theory'},
      {'time': '10:10 - 10:30', 'course': 'Break', 'section': '', 'room': '', 'type': 'Break'},
      {'time': '10:30 - 11:20', 'course': 'CS3401 - Algorithms Design & Analysis', 'section': 'C', 'room': 'Room 201', 'type': 'Theory'},
      {'time': '11:20 - 12:10', 'course': 'Free Period', 'section': '', 'room': '', 'type': 'Free'},
      {'time': '12:10 - 13:00', 'course': 'Lunch Break', 'section': '', 'room': '', 'type': 'Break'},
      {'time': '13:00 - 14:40', 'course': 'Department Meeting / Free', 'section': '', 'room': 'CSE Seminar Hall', 'type': 'Free'},
    ],
    'Friday': [
      {'time': '08:30 - 09:20', 'course': 'CS3691 - Embedded Systems & IoT', 'section': 'A', 'room': 'Room 302', 'type': 'Theory'},
      {'time': '09:20 - 10:10', 'course': 'CS3401 - Algorithms Design & Analysis', 'section': 'C', 'room': 'Room 201', 'type': 'Theory'},
      {'time': '10:10 - 10:30', 'course': 'Break', 'section': '', 'room': '', 'type': 'Break'},
      {'time': '10:30 - 11:20', 'course': 'CS3501 - Compiler Design', 'section': 'A', 'room': 'Room 301', 'type': 'Theory'},
      {'time': '11:20 - 12:10', 'course': 'CS3501 - Compiler Design', 'section': 'B', 'room': 'Room 405', 'type': 'Theory'},
      {'time': '12:10 - 13:00', 'course': 'Lunch Break', 'section': '', 'room': '', 'type': 'Break'},
      {'time': '13:00 - 14:40', 'course': 'Free Period', 'section': '', 'room': '', 'type': 'Free'},
    ],
    'Saturday': [
      {'time': '08:30 - 09:20', 'course': 'CS3501 - Compiler Design', 'section': 'B', 'room': 'Room 405', 'type': 'Theory'},
      {'time': '09:20 - 10:10', 'course': 'Free Period', 'section': '', 'room': '', 'type': 'Free'},
      {'time': '10:10 - 10:30', 'course': 'Break', 'section': '', 'room': '', 'type': 'Break'},
      {'time': '10:30 - 11:20', 'course': 'Mentoring Session', 'section': 'Batch 4', 'room': 'Room 204', 'type': 'Theory'},
      {'time': '11:20 - 12:10', 'course': 'Free Period', 'section': '', 'room': '', 'type': 'Free'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _days.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Weekly Timetable', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(color: _accent.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                  child: const Text('Even Semester 2025-26', style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text('Total: 18 hours/week | 14 Theory + 4 Lab', style: TextStyle(color: AppColors.textLight, fontSize: 14)),
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _border),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: false,
              indicatorColor: _accent,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textLight,
              labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              unselectedLabelStyle: const TextStyle(fontSize: 13),
              tabs: _days.map((d) => Tab(text: d.substring(0, 3))).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _days.map((day) {
                final slots = _timetable[day] ?? [];
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: slots.length,
                  itemBuilder: (ctx, i) {
                    final slot = slots[i];
                    final isBreak = slot['type'] == 'Break';
                    final isFree = slot['type'] == 'Free';
                    final isLab = slot['type'] == 'Lab';

                    Color barColor = _accent;
                    if (isBreak) barColor = AppColors.border;
                    if (isFree) barColor = AppColors.border;
                    if (isLab) barColor = _gold;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isBreak || isFree ? _card.withOpacity(0.5) : _card,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _border),
                      ),
                      child: Row(
                        children: [
                          Container(width: 4, height: 40, decoration: BoxDecoration(color: barColor, borderRadius: BorderRadius.circular(2))),
                          const SizedBox(width: 14),
                          SizedBox(
                            width: 120,
                            child: Text(slot['time']!, style: TextStyle(color: isBreak || isFree ? Colors.white38 : Colors.white70, fontSize: 13)),
                          ),
                          Expanded(
                            child: Text(slot['course']!, style: TextStyle(
                              color: isBreak ? AppColors.border : isFree ? Colors.white38 : Colors.white,
                              fontSize: 14,
                              fontWeight: isBreak || isFree ? FontWeight.normal : FontWeight.w500,
                              fontStyle: isFree ? FontStyle.italic : FontStyle.normal,
                            )),
                          ),
                          if (slot['section']!.isNotEmpty)
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: _accent.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                              child: Text('Sec ${slot['section']}', style: const TextStyle(color: AppColors.textLight, fontSize: 11)),
                            ),
                          if (slot['room']!.isNotEmpty)
                            Text(slot['room']!, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
