import 'package:flutter/material.dart';

class FacultyAttendanceManagementPage extends StatefulWidget {
  final String userId;

  const FacultyAttendanceManagementPage({Key? key, required this.userId})
      : super(key: key);

  @override
  State<FacultyAttendanceManagementPage> createState() =>
      _FacultyAttendanceManagementPageState();
}

class _FacultyAttendanceManagementPageState
    extends State<FacultyAttendanceManagementPage> {
  String selectedCourse = 'CS201';
  late List<StudentAttendanceRecord> records;

  @override
  void initState() {
    super.initState();
    _loadAttendanceRecords();
  }

  void _loadAttendanceRecords() {
    records = [
      StudentAttendanceRecord(
        rollNumber: 'S001',
        name: 'Rahul Kumar',
        present: 28,
        absent: 2,
        percentage: 93,
      ),
      StudentAttendanceRecord(
        rollNumber: 'S002',
        name: 'Priya Singh',
        present: 27,
        absent: 3,
        percentage: 90,
      ),
      StudentAttendanceRecord(
        rollNumber: 'S003',
        name: 'Arjun Patel',
        present: 29,
        absent: 1,
        percentage: 97,
      ),
      StudentAttendanceRecord(
        rollNumber: 'S004',
        name: 'Neha Sharma',
        present: 26,
        absent: 4,
        percentage: 87,
      ),
      StudentAttendanceRecord(
        rollNumber: 'S005',
        name: 'Amit Verma',
        present: 28,
        absent: 2,
        percentage: 93,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Management'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Course Selection
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Course',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: selectedCourse,
                    isExpanded: true,
                    underline: Container(),
                    items: [
                      'CS201 - Data Structures',
                      'CS202 - Database Management',
                      'CS303 - Advanced Algorithms',
                    ]
                        .map((course) => DropdownMenuItem(
                              value: course.split(' - ')[0],
                              child: Text(course),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCourse = value ?? 'CS201';
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // Attendance Summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _AttendanceStat(
                      label: 'Total Students',
                      value: '${records.length}',
                    ),
                    _AttendanceStat(
                      label: 'Avg Attendance',
                      value: '${(records.fold<int>(0, (sum, r) => sum + r.percentage) / records.length).toStringAsFixed(1)}%',
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Student Attendance List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: records.length,
              itemBuilder: (context, index) {
                return _buildAttendanceRow(records[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showMarkAttendanceDialog();
        },
        child: const Icon(Icons.add),
        tooltip: 'Mark Today\'s Attendance',
      ),
    );
  }

  Widget _buildAttendanceRow(StudentAttendanceRecord record) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        record.rollNumber,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: record.percentage >= 75
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${record.percentage}%',
                    style: TextStyle(
                      color: record.percentage >= 75
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _AttendanceInfo('Present', '${record.present}'),
                _AttendanceInfo('Absent', '${record.absent}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showMarkAttendanceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark Attendance'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Course: $selectedCourse'),
            const SizedBox(height: 16),
            const Text('Mark all students present or select specific ones'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Attendance marked successfully')),
              );
            },
            child: const Text('Mark All Present'),
          ),
        ],
      ),
    );
  }
}

class _AttendanceStat extends StatelessWidget {
  final String label;
  final String value;

  const _AttendanceStat({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _AttendanceInfo extends StatelessWidget {
  final String label;
  final String value;

  const _AttendanceInfo(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class StudentAttendanceRecord {
  final String rollNumber;
  final String name;
  final int present;
  final int absent;
  final int percentage;

  StudentAttendanceRecord({
    required this.rollNumber,
    required this.name,
    required this.present,
    required this.absent,
    required this.percentage,
  });
}
