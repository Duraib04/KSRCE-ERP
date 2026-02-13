import 'package:flutter/material.dart';

class StudentResultsPage extends StatefulWidget {
  final String userId;

  const StudentResultsPage({Key? key, required this.userId})
      : super(key: key);

  @override
  State<StudentResultsPage> createState() => _StudentResultsPageState();
}

class _StudentResultsPageState extends State<StudentResultsPage> {
  late List<SemesterResult> results;
  String selectedSemester = 'Semester IV';

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  void _loadResults() {
    results = [
      SemesterResult(
        semester: 'Semester IV',
        subjects: [
          SubjectResult(
            code: 'CS201',
            name: 'Data Structures',
            credits: 4,
            marks: 85,
            grade: 'A+',
          ),
          SubjectResult(
            code: 'CS202',
            name: 'Database Management',
            credits: 4,
            marks: 78,
            grade: 'A',
          ),
          SubjectResult(
            code: 'CS203',
            name: 'Operating Systems',
            credits: 3,
            marks: 82,
            grade: 'A+',
          ),
          SubjectResult(
            code: 'CS204',
            name: 'Computer Networks',
            credits: 4,
            marks: 75,
            grade: 'B+',
          ),
        ],
      ),
      SemesterResult(
        semester: 'Semester III',
        subjects: [
          SubjectResult(
            code: 'CS101',
            name: 'Programming in C',
            credits: 4,
            marks: 88,
            grade: 'A+',
          ),
          SubjectResult(
            code: 'CS102',
            name: 'Digital Logic',
            credits: 3,
            marks: 80,
            grade: 'A',
          ),
        ],
      ),
    ];
  }

  SemesterResult? getSelectedSemester() {
    try {
      return results.firstWhere((r) => r.semester == selectedSemester);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedResult = getSelectedSemester();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        elevation: 0,
      ),
      body: selectedResult == null
          ? const Center(child: Text('No results found'))
          : Column(
              children: [
                // Semester Selector
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: selectedSemester,
                      isExpanded: true,
                      underline: Container(),
                      items: results
                          .map((r) => DropdownMenuItem(
                                value: r.semester,
                                child: Text(r.semester),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSemester = value ?? 'Semester IV';
                        });
                      },
                    ),
                  ),
                ),

                // Performance Summary
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _ResultStat(
                            label: 'Average',
                            value: _calculateAverage(selectedResult)
                                .toStringAsFixed(2),
                          ),
                          _ResultStat(
                            label: 'Credits',
                            value: _calculateTotalCredits(selectedResult)
                                .toString(),
                          ),
                          _ResultStat(
                            label: 'CGPA',
                            value: _calculateCGPA(selectedResult)
                                .toStringAsFixed(2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Subjects List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: selectedResult.subjects.length,
                    itemBuilder: (context, index) {
                      return _buildSubjectCard(
                          selectedResult.subjects[index]);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSubjectCard(SubjectResult subject) {
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
                        subject.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        subject.code,
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
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    subject.grade,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ResultInfo('Marks', '${subject.marks}'),
                _ResultInfo('Credits', '${subject.credits}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _calculateAverage(SemesterResult result) {
    if (result.subjects.isEmpty) return 0;
    int total = result.subjects.fold(0, (sum, s) => sum + s.marks);
    return total / result.subjects.length;
  }

  int _calculateTotalCredits(SemesterResult result) {
    return result.subjects.fold(0, (sum, s) => sum + s.credits);
  }

  double _calculateCGPA(SemesterResult result) {
    return _calculateAverage(result) / 10;
  }
}

class _ResultStat extends StatelessWidget {
  final String label;
  final String value;

  const _ResultStat({
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
            fontSize: 20,
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

class _ResultInfo extends StatelessWidget {
  final String label;
  final String value;

  const _ResultInfo(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.blue,
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

class SemesterResult {
  final String semester;
  final List<SubjectResult> subjects;

  SemesterResult({
    required this.semester,
    required this.subjects,
  });
}

class SubjectResult {
  final String code;
  final String name;
  final int credits;
  final int marks;
  final String grade;

  SubjectResult({
    required this.code,
    required this.name,
    required this.credits,
    required this.marks,
    required this.grade,
  });
}
