import 'package:flutter/material.dart';

class StudentAssignmentsPage extends StatefulWidget {
  final String userId;

  const StudentAssignmentsPage({Key? key, required this.userId})
      : super(key: key);

  @override
  State<StudentAssignmentsPage> createState() => _StudentAssignmentsPageState();
}

class _StudentAssignmentsPageState extends State<StudentAssignmentsPage> {
  late List<Assignment> assignments;
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  void _loadAssignments() {
    assignments = [
      Assignment(
        id: 'A001',
        courseCode: 'CS201',
        courseName: 'Data Structures',
        title: 'Implement Binary Search Tree',
        description: 'Implement a complete BST with insert, delete, and search operations',
        issueDate: DateTime.now().subtract(const Duration(days: 5)),
        dueDate: DateTime.now().add(const Duration(days: 2)),
        status: 'Pending',
        submitted: false,
        marks: null,
      ),
      Assignment(
        id: 'A002',
        courseCode: 'CS202',
        courseName: 'Database Management',
        title: 'SQL Query Optimization',
        description: 'Write optimized SQL queries for given database scenarios',
        issueDate: DateTime.now().subtract(const Duration(days: 10)),
        dueDate: DateTime.now().subtract(const Duration(days: 3)),
        status: 'Submitted',
        submitted: true,
        marks: 18,
      ),
      Assignment(
        id: 'A003',
        courseCode: 'CS203',
        courseName: 'Operating Systems',
        title: 'Process Scheduling Simulation',
        description: 'Simulate different process scheduling algorithms',
        issueDate: DateTime.now().subtract(const Duration(days: 7)),
        dueDate: DateTime.now().add(const Duration(days: 5)),
        status: 'In Progress',
        submitted: false,
        marks: null,
      ),
      Assignment(
        id: 'A004',
        courseCode: 'CS204',
        courseName: 'Computer Networks',
        title: 'Network Protocol Analysis',
        description: 'Analyze and document a network protocol',
        issueDate: DateTime.now().subtract(const Duration(days: 8)),
        dueDate: DateTime.now().add(const Duration(days: 1)),
        status: 'Pending',
        submitted: false,
        marks: null,
      ),
    ];
  }

  List<Assignment> getFilteredAssignments() {
    if (selectedFilter == 'All') return assignments;
    return assignments.where((a) => a.status == selectedFilter).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'In Progress':
        return Colors.blue;
      case 'Submitted':
        return Colors.green;
      case 'Overdue':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter Chips
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  'All',
                  'Pending',
                  'In Progress',
                  'Submitted',
                ]
                    .map(
                      (filter) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(filter),
                          selected: selectedFilter == filter,
                          onSelected: (selected) {
                            setState(() {
                              selectedFilter = filter;
                            });
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),

          // Assignments List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: getFilteredAssignments().length,
              itemBuilder: (context, index) {
                return _buildAssignmentCard(getFilteredAssignments()[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(Assignment assignment) {
    bool isOverdue = assignment.dueDate.isBefore(DateTime.now()) &&
        assignment.status == 'Pending';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          _showAssignmentDetails(assignment);
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
                          assignment.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          '${assignment.courseCode} - ${assignment.courseName}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Chip(
                    label: Text(assignment.status),
                    backgroundColor: _getStatusColor(assignment.status).withValues(alpha: 0.15),
                    labelStyle:
                        TextStyle(color: _getStatusColor(assignment.status)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _AssignmentInfo(
                    label: 'Due Date',
                    value: _formatDate(assignment.dueDate),
                    color: isOverdue ? Colors.red : Colors.grey,
                  ),
                  if (assignment.marks != null)
                    _AssignmentInfo(
                      label: 'Marks',
                      value: '${assignment.marks}/20',
                      color: Colors.blue,
                    )
                  else
                    _AssignmentInfo(
                      label: 'Issue Date',
                      value: _formatDate(assignment.issueDate),
                      color: Colors.grey,
                    ),
                ],
              ),
              if (isOverdue)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                    ),
                    child: const Text(
                      'Overdue - Submit immediately',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showAssignmentDetails(Assignment assignment) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              assignment.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${assignment.courseCode} - ${assignment.courseName}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Description',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            Text(assignment.description),
            const SizedBox(height: 16),
            _ModalDetailRow('Issue Date', _formatDate(assignment.issueDate)),
            _ModalDetailRow('Due Date', _formatDate(assignment.dueDate)),
            _ModalDetailRow('Status', assignment.status),
            if (assignment.marks != null)
              _ModalDetailRow('Marks', '${assignment.marks}/20'),
            const SizedBox(height: 20),
            if (!assignment.submitted)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Assignment submitted successfully')),
                    );
                  },
                  child: const Text('Submit Assignment'),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
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

class _AssignmentInfo extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _AssignmentInfo({
    required this.label,
    required this.value,
    required this.color,
  });

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
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _ModalDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _ModalDetailRow(this.label, this.value);

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

class Assignment {
  final String id;
  final String courseCode;
  final String courseName;
  final String title;
  final String description;
  final DateTime issueDate;
  final DateTime dueDate;
  final String status;
  final bool submitted;
  final int? marks;

  Assignment({
    required this.id,
    required this.courseCode,
    required this.courseName,
    required this.title,
    required this.description,
    required this.issueDate,
    required this.dueDate,
    required this.status,
    required this.submitted,
    required this.marks,
  });
}
