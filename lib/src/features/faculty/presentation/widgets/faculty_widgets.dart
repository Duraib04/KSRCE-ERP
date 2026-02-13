import 'package:flutter/material.dart';
import '../../domain/models.dart';

/// FacultyProfileCard - Displays a faculty member's profile
class FacultyProfileCard extends StatelessWidget {
  final Faculty faculty;
  final VoidCallback? onTap;
  final bool showDetails;

  const FacultyProfileCard({
    Key? key,
    required this.faculty,
    this.onTap,
    this.showDetails = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(faculty.profileImageUrl),
                    backgroundColor: Colors.grey[300],
                    child: faculty.profileImageUrl.isEmpty
                        ? const Icon(Icons.person, size: 30)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          faculty.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          faculty.designation,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(faculty.status),
                ],
              ),
              if (showDetails) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _InfoColumn(
                      label: 'Department',
                      value: faculty.department,
                    ),
                    _InfoColumn(
                      label: 'Experience',
                      value: '${faculty.yearsOfExperience} yrs',
                    ),
                    _InfoColumn(
                      label: 'Rating',
                      value: faculty.rating.toStringAsFixed(1),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = status == 'active' ? Colors.green : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// FacultyListItem - Compact list tile for faculty display
class FacultyListItem extends StatelessWidget {
  final Faculty faculty;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const FacultyListItem({
    Key? key,
    required this.faculty,
    this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(faculty.profileImageUrl),
          backgroundColor: Colors.grey[300],
          child: faculty.profileImageUrl.isEmpty
              ? const Icon(Icons.person, size: 24)
              : null,
        ),
        title: Text(
          faculty.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${faculty.designation} • ${faculty.department}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              label: Text(
                '★ ${faculty.rating.toStringAsFixed(1)}',
              ),
              backgroundColor: _getRatingColor(faculty.rating),
              labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            if (onDelete != null) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: onDelete,
                iconSize: 20,
              ),
            ],
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 4.5) return Colors.green;
    if (rating >= 4.0) return Colors.blue;
    if (rating >= 3.5) return Colors.orange;
    return Colors.red;
  }
}

/// FacultyStats - Display key faculty statistics
class FacultyStats extends StatelessWidget {
  final Faculty faculty;

  const FacultyStats({
    Key? key,
    required this.faculty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Faculty Profile',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatTile(
                  icon: Icons.star,
                  value: faculty.rating.toStringAsFixed(1),
                  label: 'Rating',
                  color: Colors.amber,
                ),
                _StatTile(
                  icon: Icons.school,
                  value: '${faculty.teachingCourses.length}',
                  label: 'Courses',
                  color: Colors.blue,
                ),
                _StatTile(
                  icon: Icons.work,
                  value: '${faculty.yearsOfExperience}',
                  label: 'Years',
                  color: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Internal widget components
class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;

  const _InfoColumn({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
