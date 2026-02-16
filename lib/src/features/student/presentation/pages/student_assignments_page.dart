import 'package:flutter/material.dart';
import '../../../data/student_data_service.dart';
import '../../../domain/student_models.dart';

class StudentAssignmentsPage extends StatefulWidget {
  final String userId;

  const StudentAssignmentsPage({super.key, required this.userId});

  @override
  State<StudentAssignmentsPage> createState() => _StudentAssignmentsPageState();
}

class _StudentAssignmentsPageState extends State<StudentAssignmentsPage> {
  List<Assignment>? _assignments;
  bool _isLoading = true;
  String _filter = 'all'; // all, pending, submitted, evaluated

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  Future<void> _loadAssignments() async {
    try {
      final assignments = await StudentDataService.getAssignments(widget.userId);
      if (mounted) {
        setState(() {
          _assignments = assignments;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading assignments: $e')),
        );
      }
    }
  }

  List<Assignment> get _filteredAssignments {
    if (_assignments == null) return [];
    if (_filter == 'all') return _assignments!;
    
    AssignmentStatus status;
    switch (_filter) {
      case 'pending':
        status = AssignmentStatus.pending;
        break;
      case 'submitted':
        status = AssignmentStatus.submitted;
        break;
      case 'evaluated':
        status = AssignmentStatus.evaluated;
        break;
      default:
        return _assignments!;
    }
    
    return _assignments!.where((a) => a?.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            initialValue: _filter,
            onSelected: (value) => setState(() => _filter = value),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All')),
              const PopupMenuItem(value: 'pending', child: Text('Pending')),
              const PopupMenuItem(value: 'submitted', child: Text('Submitted')),
              const PopupMenuItem(value: 'evaluated', child: Text('Evaluated')),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _assignments == null || _assignments!.isEmpty
              ? const Center(child: Text('No assignments available'))
              : RefreshIndicator(
                  onRefresh: _loadAssignments,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredAssignments.length,
                    itemBuilder: (context, index) => _buildAssignmentCard(_filteredAssignments[index]),
                  ),
                ),
    );
  }

  Widget _buildAssignmentCard(Assignment assignment) {
    final isOverdue = assignment.status == AssignmentStatus.pending && 
                      DateTime.now().isAfter(assignment.dueDate);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showAssignmentDetails(assignment),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      assignment.courseCode,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(assignment.status, isOverdue),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _getStatusText(assignment.status, isOverdue),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                assignment.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                assignment.courseName,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              const SizedBox(height: 8),
              Text(
                assignment.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: isOverdue ? Colors.red : Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Due: ${_formatDate(assignment.dueDate)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isOverdue ? Colors.red : Colors.grey[600],
                      fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (isOverdue) ...[
                    const SizedBox(width: 8),
                    Text(
                      '(${assignment.daysRemaining.abs()} days overdue)',
                      style: const TextStyle(fontSize: 11, color: Colors.red),
                    ),
                  ] else if (assignment.status == AssignmentStatus.pending) ...[
                    const SizedBox(width: 8),
                    Text(
                      '(${assignment.daysRemaining} days left)',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                  const Spacer(),
                  if (assignment.obtainedMarks != null)
                    Text(
                      '${assignment.obtainedMarks}/${assignment.maxMarks}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    )
                  else
                    Text(
                      'Max: ${assignment.maxMarks}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAssignmentDetails(Assignment assignment) {
    final isOverdue = assignment.status == AssignmentStatus.pending && 
                      DateTime.now().isAfter(assignment.dueDate);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      assignment.courseCode,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(assignment.status, isOverdue),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getStatusText(assignment.status, isOverdue),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                assignment.title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                assignment.courseName,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                assignment.description,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),
              _buildInfoRow(Icons.calendar_today, 'Assigned', _formatDate(assignment.assignedDate)),
              _buildInfoRow(
                Icons.event,
                'Due Date',
                _formatDate(assignment.dueDate),
                isOverdue ? Colors.red : null,
              ),
              _buildInfoRow(Icons.score, 'Max Marks', '${assignment.maxMarks}'),
              if (assignment.submittedDate != null)
                _buildInfoRow(Icons.check, 'Submitted', _formatDate(assignment.submittedDate!)),
              if (assignment.obtainedMarks != null)
                _buildInfoRow(Icons.grade, 'Marks Obtained', '${assignment.obtainedMarks}/${assignment.maxMarks}'),
              if (assignment.feedback != null) ...[
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  'Feedback',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Text(
                    assignment.feedback!,
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              if (assignment.status == AssignmentStatus.pending)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('File upload - Coming Soon!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Text('Submit Assignment'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, [Color? valueColor]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(AssignmentStatus status, bool isOverdue) {
    if (isOverdue) return Colors.red;
    switch (status) {
      case AssignmentStatus.pending:
        return Colors.orange;
      case AssignmentStatus.submitted:
        return Colors.blue;
      case AssignmentStatus.evaluated:
        return Colors.green;
      case AssignmentStatus.late:
        return Colors.red;
    }
    return Colors.grey; // Default fallback
  }

  String _getStatusText(AssignmentStatus status, bool isOverdue) {
    if (isOverdue) return 'OVERDUE';
    switch (status) {
      case AssignmentStatus.pending:
        return 'PENDING';
      case AssignmentStatus.submitted:
        return 'SUBMITTED';
      case AssignmentStatus.evaluated:
        return 'EVALUATED';
      case AssignmentStatus.late:
        return 'LATE';
    }
    return 'UNKNOWN'; // Default fallback
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
