import 'package:flutter/material.dart';

class StudentComplaintsPage extends StatefulWidget {
  final String userId;

  const StudentComplaintsPage({Key? key, required this.userId})
      : super(key: key);

  @override
  State<StudentComplaintsPage> createState() => _StudentComplaintsPageState();
}

class _StudentComplaintsPageState extends State<StudentComplaintsPage> {
  late List<ComplaintRecord> complaints;
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadComplaints();
  }

  void _loadComplaints() {
    complaints = [
      ComplaintRecord(
        id: 'C001',
        title: 'Issue with Course Materials',
        description: 'Course materials not available on portal',
        category: 'Academic',
        status: 'Resolved',
        dateSubmitted: DateTime(2024, 1, 15),
        resolution: 'Materials uploaded to portal',
      ),
      ComplaintRecord(
        id: 'C002',
        title: 'Hostel Maintenance Issue',
        description: 'Water supply problem in Block B',
        category: 'Infrastructure',
        status: 'In Progress',
        dateSubmitted: DateTime(2024, 1, 20),
        resolution: 'Repair work scheduled',
      ),
      ComplaintRecord(
        id: 'C003',
        title: 'Grade Discrepancy',
        description: 'Marks in semester exam not matching',
        category: 'Academic',
        status: 'Pending',
        dateSubmitted: DateTime(2024, 1, 25),
        resolution: '',
      ),
    ];
  }

  List<ComplaintRecord> getFilteredComplaints() {
    if (selectedFilter == 'All') return complaints;
    return complaints.where((c) => c.status == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaints'),
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
                  'Resolved',
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

          // Complaints List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: getFilteredComplaints().length,
              itemBuilder: (context, index) {
                return _buildComplaintCard(
                    context, getFilteredComplaints()[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNewComplaintDialog();
        },
        child: const Icon(Icons.add),
        tooltip: 'File New Complaint',
      ),
    );
  }

  Widget _buildComplaintCard(
      BuildContext context, ComplaintRecord complaint) {
    Color statusColor = complaint.status == 'Resolved'
        ? Colors.green
        : complaint.status == 'In Progress'
            ? Colors.orange
            : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    complaint.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                Chip(
                  label: Text(complaint.status),
                  backgroundColor: statusColor.withValues(alpha: 0.15),
                  labelStyle: TextStyle(color: statusColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.tag, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  complaint.category,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.calendar_today,
                    size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  '${complaint.dateSubmitted.day}/${complaint.dateSubmitted.month}/${complaint.dateSubmitted.year}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Description',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(complaint.description),
                const SizedBox(height: 12),
                if (complaint.resolution.isNotEmpty) ...[
                  const Text(
                    'Resolution',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(complaint.resolution),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showNewComplaintDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedCategory = 'Academic';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('File New Complaint'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Brief title of complaint',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Detailed description',
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                items: ['Academic', 'Infrastructure', 'Staff', 'Other']
                    .map((cat) =>
                        DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) => selectedCategory = value ?? 'Academic',
                decoration: const InputDecoration(labelText: 'Category'),
              ),
            ],
          ),
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
                const SnackBar(content: Text('Complaint submitted successfully')),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

class ComplaintRecord {
  final String id;
  final String title;
  final String description;
  final String category;
  final String status;
  final DateTime dateSubmitted;
  final String resolution;

  ComplaintRecord({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.dateSubmitted,
    required this.resolution,
  });
}
