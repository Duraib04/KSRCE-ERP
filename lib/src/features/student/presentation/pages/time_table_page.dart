import 'package:flutter/material.dart';

class StudentTimeTablePage extends StatefulWidget {
  final String userId;

  const StudentTimeTablePage({Key? key, required this.userId})
      : super(key: key);

  @override
  State<StudentTimeTablePage> createState() => _StudentTimeTablePageState();
}

class _StudentTimeTablePageState extends State<StudentTimeTablePage> {
  late Map<String, List<ClassSession>> timetable;

  @override
  void initState() {
    super.initState();
    _loadTimeTable();
  }

  void _loadTimeTable() {
    timetable = {
      'Monday': [
        ClassSession(
          time: '09:00 - 10:00',
          courseCode: 'CS201',
          courseName: 'Data Structures',
          room: 'Hall A-101',
          instructor: 'Dr. Rajesh Kumar',
        ),
        ClassSession(
          time: '10:15 - 11:15',
          courseCode: 'CS202',
          courseName: 'Database Management',
          room: 'Hall A-102',
          instructor: 'Prof. Meera Singh',
        ),
        ClassSession(
          time: '12:00 - 01:00',
          courseCode: 'CS203',
          courseName: 'Operating Systems',
          room: 'Lab L-201',
          instructor: 'Dr. Anil Patel',
        ),
      ],
      'Tuesday': [
        ClassSession(
          time: '10:15 - 11:15',
          courseCode: 'CS204',
          courseName: 'Computer Networks',
          room: 'Hall A-103',
          instructor: 'Dr. Rajesh Kumar',
        ),
        ClassSession(
          time: '02:00 - 03:00',
          courseCode: 'CS201',
          courseName: 'Data Structures',
          room: 'Lab L-202',
          instructor: 'Prof. Meera Singh',
        ),
      ],
      'Wednesday': [
        ClassSession(
          time: '09:00 - 10:00',
          courseCode: 'CS203',
          courseName: 'Operating Systems',
          room: 'Hall A-101',
          instructor: 'Dr. Anil Patel',
        ),
        ClassSession(
          time: '11:00 - 12:00',
          courseCode: 'CS202',
          courseName: 'Database Management',
          room: 'Lab L-201',
          instructor: 'Prof. Meera Singh',
        ),
      ],
      'Thursday': [
        ClassSession(
          time: '09:00 - 10:00',
          courseCode: 'CS204',
          courseName: 'Computer Networks',
          room: 'Hall A-102',
          instructor: 'Dr. Rajesh Kumar',
        ),
        ClassSession(
          time: '01:00 - 02:00',
          courseCode: 'CS203',
          courseName: 'Operating Systems',
          room: 'Lab L-202',
          instructor: 'Dr. Anil Patel',
        ),
      ],
      'Friday': [
        ClassSession(
          time: '10:15 - 11:15',
          courseCode: 'CS201',
          courseName: 'Data Structures',
          room: 'Hall A-103',
          instructor: 'Dr. Rajesh Kumar',
        ),
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Table'),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          final sessions = timetable[day] ?? [];

          return Column(
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
              if (sessions.isEmpty)
                Card(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'No classes scheduled',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                )
              else
                ...sessions
                    .map((session) => _buildSessionCard(session))
                    .toList(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSessionCard(ClassSession session) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          _showSessionDetails(session);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                        session.courseName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        session.courseCode,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      session.time,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.location_on,
                      size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 6),
                  Text(
                    session.room,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Icon(Icons.person, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 6),
                  Text(
                    session.instructor,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSessionDetails(ClassSession session) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              session.courseName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            _DetailItem('Course Code', session.courseCode),
            _DetailItem('Time', session.time),
            _DetailItem('Room', session.room),
            _DetailItem('Instructor', session.instructor),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const _DetailItem(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}

class ClassSession {
  final String time;
  final String courseCode;
  final String courseName;
  final String room;
  final String instructor;

  ClassSession({
    required this.time,
    required this.courseCode,
    required this.courseName,
    required this.room,
    required this.instructor,
  });
}
