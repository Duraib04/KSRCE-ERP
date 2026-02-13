import 'package:flutter/material.dart';

class StudentCoursesPage extends StatefulWidget {
  final String userId;

  const StudentCoursesPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<StudentCoursesPage> createState() => _StudentCoursesPageState();
}

class _StudentCoursesPageState extends State<StudentCoursesPage> {
  late List<CourseCard> courses;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  void _loadCourses() {
    courses = [
      CourseCard(
        code: 'CS201',
        name: 'Data Structures',
        faculty: 'Dr. Rajesh Kumar',
        credits: 4,
        semester: 'IV',
        enrollment: '45 students',
      ),
      CourseCard(
        code: 'CS202',
        name: 'Database Management',
        faculty: 'Dr. Meera Sharma',
        credits: 4,
        semester: 'IV',
        enrollment: '48 students',
      ),
      CourseCard(
        code: 'CS203',
        name: 'Web Development',
        faculty: 'Dr. Vikram Singh',
        credits: 3,
        semester: 'IV',
        enrollment: '52 students',
      ),
      CourseCard(
        code: 'CS204',
        name: 'Algorithms',
        faculty: 'Dr. Priya Verma',
        credits: 4,
        semester: 'IV',
        enrollment: '43 students',
      ),
      CourseCard(
        code: 'CS205',
        name: 'Software Engineering',
        faculty: 'Dr. Arjun Patel',
        credits: 3,
        semester: 'IV',
        enrollment: '50 students',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
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
                  _SummaryItem(label: 'Total Courses', value: '5'),
                  _SummaryItem(label: 'Total Credits', value: '18'),
                  _SummaryItem(label: 'Avg Attendance', value: '92%'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Courses List
          ...courses.map((course) => _buildCourseCard(context, course)),
        ],
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, CourseCard course) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Viewing ${course.name}')),
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
                          course.code,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          course.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Chip(
                    label: Text('${course.credits} Credits'),
                    backgroundColor: Colors.blue.shade100,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      course.faculty,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.group, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    course.enrollment,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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

class CourseCard {
  final String code;
  final String name;
  final String faculty;
  final int credits;
  final String semester;
  final String enrollment;

  CourseCard({
    required this.code,
    required this.name,
    required this.faculty,
    required this.credits,
    required this.semester,
    required this.enrollment,
  });
}
