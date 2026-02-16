import 'package:flutter/material.dart';
import 'package:ksrce_erp/src/features/faculty/data/faculty_data_service.dart';

class FacultyGradesManagementPage extends StatefulWidget {
  final String userId;

  const FacultyGradesManagementPage({Key? key, required this.userId})
      : super(key: key);

  @override
  State<FacultyGradesManagementPage> createState() =>
      _FacultyGradesManagementPageState();
}

class _FacultyGradesManagementPageState
    extends State<FacultyGradesManagementPage> {
  String selectedCourse = 'CS201';
  late List<StudentGradeRecord> records;
  String selectedEvaluation = 'Assignment';

  @override
  void initState() {
    super.initState();
    _loadGradeRecords();
  }

  void _loadGradeRecords() {
    records = [
      StudentGradeRecord(
        rollNumber: 'S001',
        name: 'Rahul Kumar',
        assignment: 18,
        midterm: 38,
        endterm: 75,
      ),
      StudentGradeRecord(
        rollNumber: 'S002',
        name: 'Priya Singh',
        assignment: 17,
        midterm: 36,
        endterm: 72,
      ),
      StudentGradeRecord(
        rollNumber: 'S003',
        name: 'Arjun Patel',
        assignment: 19,
        midterm: 39,
        endterm: 78,
      ),
      StudentGradeRecord(
        rollNumber: 'S004',
        name: 'Neha Sharma',
        assignment: 16,
        midterm: 35,
        endterm: 70,
      ),
      StudentGradeRecord(
        rollNumber: 'S005',
        name: 'Amit Verma',
        assignment: 18,
        midterm: 37,
        endterm: 76,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grades Management'),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => _exportGrades(value),
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'csv',
                child: Text('Export CSV'),
              ),
              PopupMenuItem(
                value: 'pdf',
                child: Text('Export PDF'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
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
                const SizedBox(height: 16),
                const Text(
                  'Select Evaluation',
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
                    value: selectedEvaluation,
                    isExpanded: true,
                    underline: Container(),
                    items: [
                      'Assignment',
                      'Midterm',
                      'Endterm',
                    ]
                        .map((eval) => DropdownMenuItem(
                              value: eval,
                              child: Text(eval),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedEvaluation = value ?? 'Assignment';
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // Grades Summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _GradeStat(
                      label: 'Class Avg',
                      value: _calculateAverage().toStringAsFixed(1),
                    ),
                    _GradeStat(
                      label: 'High Score',
                      value: _getHighScore().toString(),
                    ),
                    _GradeStat(
                      label: 'Low Score',
                      value: _getLowScore().toString(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Grades List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: records.length,
              itemBuilder: (context, index) {
                return _buildGradeRow(records[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showEditGradesDialog();
        },
        child: const Icon(Icons.edit),
        tooltip: 'Edit Grades',
      ),
    );
  }

  Widget _buildGradeRow(StudentGradeRecord record) {
    int evaluationScore = 0;
    if (selectedEvaluation == 'Assignment') {
      evaluationScore = record.assignment;
    } else if (selectedEvaluation == 'Midterm') {
      evaluationScore = record.midterm;
    } else {
      evaluationScore = record.endterm;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          _showStudentGradesDialog(record);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$evaluationScore',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    selectedEvaluation,
                    style: const TextStyle(
                      color: Colors.grey,
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

  double _calculateAverage() {
    if (records.isEmpty) return 0;
    int total = 0;
    for (var record in records) {
      if (selectedEvaluation == 'Assignment') {
        total += record.assignment;
      } else if (selectedEvaluation == 'Midterm') {
        total += record.midterm;
      } else {
        total += record.endterm;
      }
    }
    return total / records.length;
  }

  int _getHighScore() {
    if (records.isEmpty) return 0;
    int max = 0;
    for (var record in records) {
      int score = selectedEvaluation == 'Assignment'
          ? record.assignment
          : selectedEvaluation == 'Midterm'
              ? record.midterm
              : record.endterm;
      if (score > max) max = score;
    }
    return max;
  }

  int _getLowScore() {
    if (records.isEmpty) return 0;
    int min = 100;
    for (var record in records) {
      int score = selectedEvaluation == 'Assignment'
          ? record.assignment
          : selectedEvaluation == 'Midterm'
              ? record.midterm
              : record.endterm;
      if (score < min) min = score;
    }
    return min;
  }

  void _showEditGradesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $selectedEvaluation Grades'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Grade/Marks',
                hintText: 'Enter marks out of 100',
              ),
            ),
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
                SnackBar(
                    content: Text('$selectedEvaluation grades updated')),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showStudentGradesDialog(StudentGradeRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${record.name} - All Grades'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GradeDetail('Assignment', '${record.assignment}/20'),
            _GradeDetail('Midterm', '${record.midterm}/40'),
            _GradeDetail('Endterm', '${record.endterm}/40'),
            const Divider(height: 16),
            _GradeDetail(
                'Total',
                '${record.assignment + record.midterm + record.endterm}'
                '/100'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportGrades(String format) async {
    final courseId = selectedCourse;
    final path = format == 'pdf'
        ? await FacultyDataService.exportGradesPdf(courseId)
        : await FacultyDataService.exportGradesCsv(courseId);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Exported: $path')),
    );
  }
}

class _GradeDetail extends StatelessWidget {
  final String label;
  final String value;

  const _GradeDetail(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

class _GradeStat extends StatelessWidget {
  final String label;
  final String value;

  const _GradeStat({
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

class StudentGradeRecord {
  final String rollNumber;
  final String name;
  final int assignment;
  final int midterm;
  final int endterm;

  StudentGradeRecord({
    required this.rollNumber,
    required this.name,
    required this.assignment,
    required this.midterm,
    required this.endterm,
  });
}
