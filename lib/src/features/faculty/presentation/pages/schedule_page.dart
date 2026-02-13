import 'package:flutter/material.dart';

class FacultySchedulePage extends StatefulWidget {
  final String userId;

  const FacultySchedulePage({Key? key, required this.userId})
      : super(key: key);

  @override
  State<FacultySchedulePage> createState() => _FacultySchedulePageState();
}

class _FacultySchedulePageState extends State<FacultySchedulePage> {
  late List<ScheduleSlot> weekSchedule;

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }

  void _loadSchedule() {
    weekSchedule = [
      ScheduleSlot(
        day: 'Monday',
        time: '09:00 - 10:00',
        courseCode: 'CS201',
        courseName: 'Data Structures',
        room: 'Hall A-101',
        batch: 'A',
      ),
      ScheduleSlot(
        day: 'Monday',
        time: '10:00 - 11:00',
        courseCode: 'CS202',
        courseName: 'Database Management',
        room: 'Hall A-102',
        batch: 'B',
      ),
      ScheduleSlot(
        day: 'Tuesday',
        time: '09:00 - 10:00',
        courseCode: 'CS201',
        courseName: 'Data Structures',
        room: 'Hall A-101',
        batch: 'A',
      ),
      ScheduleSlot(
        day: 'Wednesday',
        time: '10:00 - 11:00',
        courseCode: 'CS303',
        courseName: 'Advanced Algorithms',
        room: 'Lab L-201',
        batch: 'VI SEM',
      ),
      ScheduleSlot(
        day: 'Thursday',
        time: '09:00 - 10:00',
        courseCode: 'CS202',
        courseName: 'Database Management',
        room: 'Hall A-102',
        batch: 'B',
      ),
      ScheduleSlot(
        day: 'Friday',
        time: '11:00 - 12:00',
        courseCode: 'CS201',
        courseName: 'Data Structures',
        room: 'Hall A-101',
        batch: 'A',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<ScheduleSlot>> scheduleByDay = {};
    for (var slot in weekSchedule) {
      scheduleByDay.putIfAbsent(slot.day, () => []);
      scheduleByDay[slot.day]!.add(slot);
    }

    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Schedule'),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          final slots = scheduleByDay[day] ?? [];

          if (slots.isEmpty) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      day,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No classes scheduled',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...slots.map((slot) => _buildScheduleSlot(slot)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScheduleSlot(ScheduleSlot slot) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.left(
          color: Colors.blue.shade500,
          width: 4,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    slot.courseName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    slot.courseCode,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  slot.batch,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(
                slot.time,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                slot.room,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ScheduleSlot {
  final String day;
  final String time;
  final String courseCode;
  final String courseName;
  final String room;
  final String batch;

  ScheduleSlot({
    required this.day,
    required this.time,
    required this.courseCode,
    required this.courseName,
    required this.room,
    required this.batch,
  });
}
