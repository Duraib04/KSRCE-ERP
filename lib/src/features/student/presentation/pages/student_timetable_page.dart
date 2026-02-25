import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class StudentTimetablePage extends StatefulWidget {
  const StudentTimetablePage({super.key});

  @override
  State<StudentTimetablePage> createState() => _StudentTimetablePageState();
}

class _StudentTimetablePageState extends State<StudentTimetablePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

  final Map<String, List<Map<String, String>>> _timetable = {
    'Monday': [
      {'time': '08:30 - 09:20', 'subject': 'CS3501 - Compiler Design', 'room': 'Room 301', 'faculty': 'Dr. K. Ramesh', 'type': 'Theory'},
      {'time': '09:20 - 10:10', 'subject': 'MA3391 - Probability & Statistics', 'room': 'Room 201', 'faculty': 'Dr. P. Anitha', 'type': 'Theory'},
      {'time': '10:20 - 11:10', 'subject': 'CS3591 - Computer Networks', 'room': 'Room 302', 'faculty': 'Prof. S. Lakshmi', 'type': 'Theory'},
      {'time': '11:10 - 12:00', 'subject': 'CS3551 - Distributed Computing', 'room': 'Room 301', 'faculty': 'Dr. M. Venkatesh', 'type': 'Theory'},
      {'time': '01:00 - 01:50', 'subject': 'GE3591 - Environmental Science', 'room': 'Room 105', 'faculty': 'Prof. R. Devi', 'type': 'Theory'},
      {'time': '01:50 - 02:40', 'subject': 'Library / Self Study', 'room': 'Library', 'faculty': '-', 'type': 'Free'},
    ],
    'Tuesday': [
      {'time': '08:30 - 09:20', 'subject': 'CS3501 - Compiler Design', 'room': 'Room 301', 'faculty': 'Dr. K. Ramesh', 'type': 'Theory'},
      {'time': '09:20 - 10:10', 'subject': 'CS3591 - Computer Networks', 'room': 'Room 302', 'faculty': 'Prof. S. Lakshmi', 'type': 'Theory'},
      {'time': '10:20 - 11:10', 'subject': 'CS3551 - Distributed Computing', 'room': 'Room 301', 'faculty': 'Dr. M. Venkatesh', 'type': 'Theory'},
      {'time': '11:10 - 12:00', 'subject': 'MA3391 - Probability & Statistics', 'room': 'Room 201', 'faculty': 'Dr. P. Anitha', 'type': 'Theory'},
      {'time': '01:00 - 01:50', 'subject': 'GE3591 - Environmental Science', 'room': 'Room 105', 'faculty': 'Prof. R. Devi', 'type': 'Theory'},
      {'time': '01:50 - 03:30', 'subject': 'CS3512 - Compiler Design Lab', 'room': 'Lab 4', 'faculty': 'Dr. K. Ramesh', 'type': 'Lab'},
    ],
    'Wednesday': [
      {'time': '08:30 - 09:20', 'subject': 'MA3391 - Probability & Statistics', 'room': 'Room 201', 'faculty': 'Dr. P. Anitha', 'type': 'Theory'},
      {'time': '09:20 - 10:10', 'subject': 'CS3501 - Compiler Design', 'room': 'Room 301', 'faculty': 'Dr. K. Ramesh', 'type': 'Theory'},
      {'time': '10:20 - 11:10', 'subject': 'GE3591 - Environmental Science', 'room': 'Room 105', 'faculty': 'Prof. R. Devi', 'type': 'Theory'},
      {'time': '11:10 - 12:00', 'subject': 'CS3591 - Computer Networks', 'room': 'Room 302', 'faculty': 'Prof. S. Lakshmi', 'type': 'Theory'},
      {'time': '01:00 - 03:30', 'subject': 'CS3592 - Computer Networks Lab', 'room': 'Lab 3', 'faculty': 'Prof. S. Lakshmi', 'type': 'Lab'},
    ],
    'Thursday': [
      {'time': '08:30 - 09:20', 'subject': 'CS3551 - Distributed Computing', 'room': 'Room 301', 'faculty': 'Dr. M. Venkatesh', 'type': 'Theory'},
      {'time': '09:20 - 10:10', 'subject': 'CS3501 - Compiler Design', 'room': 'Room 301', 'faculty': 'Dr. K. Ramesh', 'type': 'Theory'},
      {'time': '10:20 - 11:10', 'subject': 'MA3391 - Probability & Statistics', 'room': 'Room 201', 'faculty': 'Dr. P. Anitha', 'type': 'Theory'},
      {'time': '11:10 - 12:00', 'subject': 'CS3591 - Computer Networks', 'room': 'Room 302', 'faculty': 'Prof. S. Lakshmi', 'type': 'Theory'},
      {'time': '01:00 - 01:50', 'subject': 'GE3591 - Environmental Science', 'room': 'Room 105', 'faculty': 'Prof. R. Devi', 'type': 'Theory'},
      {'time': '01:50 - 02:40', 'subject': 'Mentor Meeting', 'room': 'Room 301', 'faculty': 'Dr. S. Meena', 'type': 'Free'},
    ],
    'Friday': [
      {'time': '08:30 - 09:20', 'subject': 'CS3591 - Computer Networks', 'room': 'Room 302', 'faculty': 'Prof. S. Lakshmi', 'type': 'Theory'},
      {'time': '09:20 - 10:10', 'subject': 'CS3551 - Distributed Computing', 'room': 'Room 301', 'faculty': 'Dr. M. Venkatesh', 'type': 'Theory'},
      {'time': '10:20 - 11:10', 'subject': 'CS3501 - Compiler Design', 'room': 'Room 301', 'faculty': 'Dr. K. Ramesh', 'type': 'Theory'},
      {'time': '11:10 - 12:00', 'subject': 'MA3391 - Probability & Statistics', 'room': 'Room 201', 'faculty': 'Dr. P. Anitha', 'type': 'Theory'},
      {'time': '01:00 - 03:30', 'subject': 'CS3512 - Compiler Design Lab', 'room': 'Lab 4', 'faculty': 'Dr. K. Ramesh', 'type': 'Lab'},
    ],
    'Saturday': [
      {'time': '08:30 - 09:20', 'subject': 'MA3391 - Probability & Statistics', 'room': 'Room 201', 'faculty': 'Dr. P. Anitha', 'type': 'Theory'},
      {'time': '09:20 - 10:10', 'subject': 'CS3551 - Distributed Computing', 'room': 'Room 301', 'faculty': 'Dr. M. Venkatesh', 'type': 'Theory'},
      {'time': '10:20 - 11:10', 'subject': 'GE3591 - Environmental Science', 'room': 'Room 105', 'faculty': 'Prof. R. Devi', 'type': 'Theory'},
      {'time': '11:10 - 12:00', 'subject': 'Sports / Activities', 'room': 'Ground', 'faculty': '-', 'type': 'Free'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _days.length, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;
          return Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.calendar_today, color: AppColors.primary, size: 28),
                    SizedBox(width: 12),
                    Text('Weekly Timetable', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Semester 5 - Academic Year 2025-26', style: TextStyle(color: AppColors.textLight, fontSize: 14)),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: isMobile,
                    indicatorColor: AppColors.accent,
                    labelColor: AppColors.accent,
                    unselectedLabelColor: AppColors.textLight,
                    tabs: _days.map((d) => Tab(text: d.substring(0, 3).toUpperCase())).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: _days.map((day) => _buildDaySchedule(day, isMobile)).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDaySchedule(String day, bool isMobile) {
    final periods = _timetable[day] ?? [];
    return ListView.builder(
      itemCount: periods.length,
      itemBuilder: (context, index) {
        final p = periods[index];
        final isLab = p['type'] == 'Lab';
        final isFree = p['type'] == 'Free';
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isLab ? Colors.teal.withOpacity(0.4) : isFree ? Colors.grey.withOpacity(0.3) : AppColors.border),
          ),
          child: isMobile ? _buildMobilePeriod(p, isLab, isFree) : _buildDesktopPeriod(p, isLab, isFree),
        );
      },
    );
  }

  Widget _buildDesktopPeriod(Map<String, String> p, bool isLab, bool isFree) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 50,
          decoration: BoxDecoration(
            color: isLab ? Colors.tealAccent : isFree ? Colors.grey : AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(p['time']!, style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600, fontSize: 14)),
              Text(isLab ? 'Lab Session' : isFree ? 'Free Period' : 'Lecture', style: TextStyle(color: isLab ? Colors.tealAccent : Colors.white54, fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(p['subject']!, style: const TextStyle(color: AppColors.textDark, fontSize: 15, fontWeight: FontWeight.w500)),
        ),
        SizedBox(
          width: 100,
          child: Row(
            children: [
              const Icon(Icons.room, color: AppColors.textLight, size: 16),
              const SizedBox(width: 4),
              Text(p['room']!, style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
            ],
          ),
        ),
        SizedBox(
          width: 150,
          child: Row(
            children: [
              const Icon(Icons.person, color: AppColors.textLight, size: 16),
              const SizedBox(width: 4),
              Text(p['faculty']!, style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobilePeriod(Map<String, String> p, bool isLab, bool isFree) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 70,
          decoration: BoxDecoration(
            color: isLab ? Colors.tealAccent : isFree ? Colors.grey : AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(p['time']!, style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(width: 8),
                  Text(
                    isLab ? 'Lab Session' : isFree ? 'Free Period' : 'Lecture',
                    style: TextStyle(color: isLab ? Colors.tealAccent : Colors.white54, fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(p['subject']!, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.room, color: AppColors.textLight, size: 14),
                  const SizedBox(width: 3),
                  Text(p['room']!, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
                  const SizedBox(width: 12),
                  const Icon(Icons.person, color: AppColors.textLight, size: 14),
                  const SizedBox(width: 3),
                  Flexible(child: Text(p['faculty']!, style: const TextStyle(color: AppColors.textLight, fontSize: 12), overflow: TextOverflow.ellipsis)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
