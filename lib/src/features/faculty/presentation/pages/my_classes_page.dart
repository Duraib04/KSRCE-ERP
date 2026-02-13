import 'package:flutter/material.dart';

class FacultyMyClassesPage extends StatefulWidget {
  final String userId;

  const FacultyMyClassesPage({Key? key, required this.userId})
      : super(key: key);

  @override
  State<FacultyMyClassesPage> createState() => _FacultyMyClassesPageState();
}

class _FacultyMyClassesPageState extends State<FacultyMyClassesPage> {
  late List<FacultyClass> classes;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  void _loadClasses() {
    classes = [
      FacultyClass(
        courseCode: 'CS201',
        courseName: 'Data Structures',
        semester: 'IV',
        enrolled: 45,
        classesHeld: 28,
        classesRemaining: 2,
        status: 'Active',
      ),
      FacultyClass(
        courseCode: 'CS202',
        courseName: 'Database Management',
        semester: 'IV',
        enrolled: 48,
        classesHeld: 28,
        classesRemaining: 2,
        status: 'Active',
      ),
      FacultyClass(
        courseCode: 'CS303',
        courseName: 'Advanced Algorithms',
        semester: 'VI',
        enrolled: 38,
        classesHeld: 25,
        classesRemaining: 5,
        status: 'Active',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Classes'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Summary Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _SummaryItem(label: 'Total Classes', value: '${classes.length}'),
                  _SummaryItem(
                      label: 'Total Students',
                      value: '${classes.fold<int>(0, (sum, c) => sum + c.enrolled)}'),
                  _SummaryItem(
                      label: 'Avg Enrollment',
                      value: '${(classes.fold<int>(0, (sum, c) => sum + c.enrolled) / classes.length).toStringAsFixed(0)}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Classes List
          ...classes.map((cls) => _buildClassCard(context, cls)),
        ],
      ),
    );
  }

  Widget _buildClassCard(BuildContext context, FacultyClass cls) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Viewing ${cls.courseName}')),
          );
        },
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
                          cls.courseCode,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cls.courseName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Chip(
                    label: Text(cls.status),
                    backgroundColor: Colors.green.shade100,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _InfoColumn('Semester', cls.semester),
                  _InfoColumn('Enrolled', '${cls.enrolled}'),
                  _InfoColumn('Held', '${cls.classesHeld}'),
                  _InfoColumn('Remaining', '${cls.classesRemaining}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;

  const _InfoColumn(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
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

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryItem({
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

class FacultyClass {
  final String courseCode;
  final String courseName;
  final String semester;
  final int enrolled;
  final int classesHeld;
  final int classesRemaining;
  final String status;

  FacultyClass({
    required this.courseCode,
    required this.courseName,
    required this.semester,
    required this.enrolled,
    required this.classesHeld,
    required this.classesRemaining,
    required this.status,
  });
}
