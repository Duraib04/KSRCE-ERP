import 'package:flutter/material.dart';
import 'package:ksrce_erp/src/core/theme/app_colors.dart';
import 'package:ksrce_erp/src/core/theme/design_tokens.dart';
import 'package:ksrce_erp/src/features/faculty/domain/faculty_models.dart';

// ==================== Class Card Widget ====================
class ClassCard extends StatelessWidget {
  final ClassAssignment classAssignment;
  final VoidCallback? onTap;
  final VoidCallback? onAttendance;
  final VoidCallback? onGrades;

  const ClassCard({
    required this.classAssignment,
    this.onTap,
    this.onAttendance,
    this.onGrades,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
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
                          classAssignment.courseCode,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.secondaryBlue,
                          ),
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          classAssignment.courseName,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: _getClassTypeColor().withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(
                      _getClassTypeLabel(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: _getClassTypeColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.sm),
              Divider(height: AppSpacing.sm),
              SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: _InfoBadge(
                      icon: Icons.people,
                      label: 'Students',
                      value: classAssignment.totalStudents.toString(),
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _InfoBadge(
                      icon: Icons.book,
                      label: 'Credits',
                      value: classAssignment.credits.toString(),
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _InfoBadge(
                      icon: Icons.calendar_today,
                      label: 'Semester',
                      value: classAssignment.semester,
                    ),
                  ),
                ],
              ),
              if (classAssignment.schedule != null) ...[
                SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 16, color: Colors.grey),
                    SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        classAssignment.schedule!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      classAssignment.room ?? 'N/A',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
              if (onAttendance != null || onGrades != null) ...[
                SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    if (onAttendance != null)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onAttendance,
                          icon: Icon(Icons.check_circle_outline, size: 16),
                          label: Text('Attendance'),
                        ),
                      ),
                    if (onAttendance != null && onGrades != null)
                      SizedBox(width: AppSpacing.sm),
                    if (onGrades != null)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onGrades,
                          icon: Icon(Icons.grade, size: 16),
                          label: Text('Grades'),
                        ),
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

  Color _getClassTypeColor() {
    switch (classAssignment.classType) {
      case ClassType.lecture:
        return AppColors.primaryBlue;
      case ClassType.lab:
        return Colors.green;
      case ClassType.tutorial:
        return Colors.orange;
    }
  }

  String _getClassTypeLabel() {
    switch (classAssignment.classType) {
      case ClassType.lecture:
        return 'Lecture';
      case ClassType.lab:
        return 'Lab';
      case ClassType.tutorial:
        return 'Tutorial';
    }
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoBadge({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.info),
        SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.info,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

// ==================== Student Attendance Row ====================
class StudentAttendanceRow extends StatelessWidget {
  final StudentAttendanceEntry entry;
  final ValueChanged<bool> onPresenceChanged;

  const StudentAttendanceRow({
    required this.entry,
    required this.onPresenceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  entry.studentName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Roll: ${entry.rollNumber}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _AttendanceButton(
                label: 'Present',
                isSelected: entry.isPresent,
                onPressed: () => onPresenceChanged(true),
                color: Colors.green,
              ),
              SizedBox(width: AppSpacing.sm),
              _AttendanceButton(
                label: 'Absent',
                isSelected: !entry.isPresent,
                onPressed: () => onPresenceChanged(false),
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AttendanceButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;
  final Color color;

  const _AttendanceButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// ==================== Grade Input Row ====================
class GradeInputRow extends StatefulWidget {
  final GradeEntry entry;
  final ValueChanged<int> onMarksChanged;

  const GradeInputRow({
    required this.entry,
    required this.onMarksChanged,
  });

  @override
  State<GradeInputRow> createState() => _GradeInputRowState();
}

class _GradeInputRowState extends State<GradeInputRow> {
  late TextEditingController _marksController;

  @override
  void initState() {
    super.initState();
    _marksController = TextEditingController(
      text: widget.entry.obtainedMarks?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _marksController.dispose();
    super.dispose();
  }

  String? _calculateGrade() {
    if (_marksController.text.isEmpty) return null;
    final marks = int.tryParse(_marksController.text);
    if (marks == null) return null;
    final percentage = (marks / widget.entry.maxMarks) * 100;
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B+';
    if (percentage >= 60) return 'B';
    if (percentage >= 50) return 'C';
    return 'F';
  }

  @override
  Widget build(BuildContext context) {
    final calculatedGrade = _calculateGrade();
    final statusColor = widget.entry.status == GradeStatus.submitted
        ? Colors.green
        : widget.entry.status == GradeStatus.pending
            ? Colors.orange
            : Colors.grey;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.entry.studentName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Roll: ${widget.entry.rollNumber}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TextField(
              controller: _marksController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '0-${widget.entry.maxMarks}',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                suffixText: '/${widget.entry.maxMarks}',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  final marks = int.tryParse(value);
                  if (marks != null) {
                    widget.onMarksChanged(marks);
                    setState(() {});
                  }
                }
              },
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              calculatedGrade ?? '--',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Container(
            width: 8,
            height: 24,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(AppRadius.xs),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== Timetable Cell ====================
class TimetableCell extends StatelessWidget {
  final ScheduleEntry entry;
  final VoidCallback? onTap;

  const TimetableCell({
    required this.entry,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getClassTypeColor();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        padding: EdgeInsets.all(AppSpacing.sm),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              entry.courseCode,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              '${entry.startTime} - ${entry.endTime}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.xs),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(AppRadius.xs),
              ),
              child: Text(
                entry.room,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getClassTypeColor() {
    switch (entry.classType) {
      case ClassType.lecture:
        return AppColors.primaryBlue;
      case ClassType.lab:
        return Colors.green;
      case ClassType.tutorial:
        return Colors.orange;
    }
  }
}

// ==================== Notice Widget ====================
class NoticeWidget extends StatelessWidget {
  final Notice notice;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const NoticeWidget({
    required this.notice,
    this.onEdit,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDraft = notice.isDraft;

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
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
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notice.title,
                                style:
                                    Theme.of(context).textTheme.titleMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isDraft)
                              Container(
                                margin: EdgeInsets.only(left: AppSpacing.sm),
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: AppSpacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.2),
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.sm),
                                ),
                                child: Text(
                                  'Draft',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          'Audience: ${notice.audience}',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (onEdit != null || onDelete != null)
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        if (isDraft && onEdit != null)
                          PopupMenuItem(
                            onTap: onEdit,
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 18),
                                SizedBox(width: AppSpacing.sm),
                                Text('Edit'),
                              ],
                            ),
                          ),
                        if (onDelete != null)
                          PopupMenuItem(
                            onTap: onDelete,
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 18, color: Colors.red),
                                SizedBox(width: AppSpacing.sm),
                                Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                ],
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                notice.content,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDate(notice.postedDate),
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: Colors.grey),
                  ),
                  if (notice.category != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Text(
                        notice.category!,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(
                              color: Colors.blue,
                            ),
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

