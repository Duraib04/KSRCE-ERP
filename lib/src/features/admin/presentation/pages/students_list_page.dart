import 'package:flutter/material.dart';

class StudentsListPage extends StatefulWidget {
  final String userId;

  const StudentsListPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<StudentsListPage> createState() => _StudentsListPageState();
}

class _StudentsListPageState extends State<StudentsListPage> {
  late List<StudentInfo> students;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  void _loadStudents() {
    students = [
      StudentInfo(
        rollNumber: 'S001',
        name: 'Rahul Kumar',
        email: 'rahul@college.edu',
        phone: '+91 98765 43210',
        semester: 'IV',
        status: 'Active',
      ),
      StudentInfo(
        rollNumber: 'S002',
        name: 'Priya Singh',
        email: 'priya@college.edu',
        phone: '+91 98765 43211',
        semester: 'IV',
        status: 'Active',
      ),
      StudentInfo(
        rollNumber: 'S003',
        name: 'Arjun Patel',
        email: 'arjun@college.edu',
        phone: '+91 98765 43212',
        semester: 'VI',
        status: 'Active',
      ),
      StudentInfo(
        rollNumber: 'S004',
        name: 'Neha Sharma',
        email: 'neha@college.edu',
        phone: '+91 98765 43213',
        semester: 'IV',
        status: 'Inactive',
      ),
      StudentInfo(
        rollNumber: 'S005',
        name: 'Amit Verma',
        email: 'amit@college.edu',
        phone: '+91 98765 43214',
        semester: 'VI',
        status: 'Active',
      ),
    ];
  }

  List<StudentInfo> getFilteredStudents() {
    if (searchQuery.isEmpty) return students;
    return students
        .where((student) =>
            student.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            student.rollNumber.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name or roll number',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          // Students List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: getFilteredStudents().length,
              itemBuilder: (context, index) {
                return _buildStudentCard(getFilteredStudents()[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(StudentInfo student) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          _showStudentDetailsDialog(student);
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
                          student.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          student.rollNumber,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Chip(
                    label: Text(student.status),
                    backgroundColor: student.status == 'Active'
                        ? Colors.green.shade100
                        : Colors.grey.shade100,
                    labelStyle: TextStyle(
                      color: student.status == 'Active'
                          ? Colors.green
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StudentInfo('Semester', student.semester),
                  _StudentInfo('Email', student.email),
                  _StudentInfo('Phone', student.phone),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showStudentDetailsDialog(StudentInfo student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(student.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailRow('Roll Number', student.rollNumber),
            _DetailRow('Email', student.email),
            _DetailRow('Phone', student.phone),
            _DetailRow('Semester', student.semester),
            _DetailRow('Status', student.status),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Message sent to ${student.name}')),
              );
            },
            child: const Text('Contact'),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(value),
        ],
      ),
    );
  }
}

class _StudentInfo extends StatelessWidget {
  final String label;
  final String value;

  const _StudentInfo(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class StudentInfo {
  final String rollNumber;
  final String name;
  final String email;
  final String phone;
  final String semester;
  final String status;

  StudentInfo({
    required this.rollNumber,
    required this.name,
    required this.email,
    required this.phone,
    required this.semester,
    required this.status,
  });
}
