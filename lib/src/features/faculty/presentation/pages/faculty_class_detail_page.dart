import 'package:flutter/material.dart';
import 'package:ksrce_erp/src/core/presentation/core_widgets.dart';
import 'package:ksrce_erp/src/core/theme/app_colors.dart';
import 'package:ksrce_erp/src/core/theme/design_tokens.dart';
import 'package:ksrce_erp/src/features/faculty/data/faculty_data_service.dart';
import 'package:ksrce_erp/src/features/faculty/domain/faculty_models.dart';

class FacultyClassDetailPage extends StatefulWidget {
  final String facultyId;
  final String courseId;

  const FacultyClassDetailPage({
    super.key,
    required this.facultyId,
    required this.courseId,
  });

  @override
  State<FacultyClassDetailPage> createState() => _FacultyClassDetailPageState();
}

class _FacultyClassDetailPageState extends State<FacultyClassDetailPage> {
  late Future<ClassAssignment> _classFuture;
  late Future<List<ClassAttendance>> _attendanceFuture;
  late Future<List<GradeEntry>> _gradesFuture;

  @override
  void initState() {
    super.initState();
    _classFuture = FacultyDataService.getClassDetails(widget.courseId);
    _attendanceFuture =
        FacultyDataService.getClassAttendanceHistory(widget.courseId);
    _gradesFuture = FacultyDataService.getCourseGrades(widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Details'),
        elevation: 0,
      ),
      body: FutureBuilder<ClassAssignment>(
        future: _classFuture,
        builder: (context, classSnapshot) {
          if (classSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (classSnapshot.hasError || classSnapshot.data == null) {
            return ErrorState(
              message: 'Failed to load class details',
              onRetry: () {
                setState(() {
                  _classFuture =
                      FacultyDataService.getClassDetails(widget.courseId);
                });
              },
            );
          }

          final classData = classSnapshot.data!;

          return ListView(
            padding: AppSpacing.paddingLg,
            children: [
              Text(
                '${classData.courseCode} • ${classData.courseName}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  _InfoChip(label: 'Section ${classData.section}'),
                  _InfoChip(label: 'Semester ${classData.semester}'),
                  _InfoChip(label: '${classData.credits} credits'),
                  if (classData.room != null)
                    _InfoChip(label: classData.room!),
                ],
              ),
              SizedBox(height: AppSpacing.lg),
              ResponsiveGrid(
                minItemWidth: 150,
                children: [
                  StatCard(
                    icon: Icons.people,
                    value: classData.totalStudents.toString(),
                    title: 'Students',
                    color: AppColors.faculty,
                  ),
                  StatCard(
                    icon: Icons.event_available,
                    value: '${classData.enrolledStudents ?? classData.totalStudents}',
                    title: 'Enrolled',
                    color: Colors.green,
                  ),
                  StatCard(
                    icon: Icons.schedule,
                    value: classData.schedule ?? 'TBA',
                    title: 'Schedule',
                    color: AppColors.info,
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.lg),
              FutureBuilder<List<ClassAttendance>>(
                future: _attendanceFuture,
                builder: (context, attendanceSnapshot) {
                  if (!attendanceSnapshot.hasData ||
                      attendanceSnapshot.data!.isEmpty) {
                    return const SizedBox();
                  }

                  final latest = attendanceSnapshot.data!.first;
                  final percentage = latest.attendancePercentage.toStringAsFixed(1);

                  return AppCard.outlined(
                    title: 'Attendance Summary',
                    child: Column(
                      children: [
                        InfoRow(
                          icon: Icons.check_circle,
                          label: 'Present',
                          value: latest.presentCount.toString(),
                        ),
                        InfoRow(
                          icon: Icons.cancel,
                          label: 'Absent',
                          value: latest.absentCount.toString(),
                        ),
                        InfoRow(
                          icon: Icons.percent,
                          label: 'Latest Session',
                          value: '$percentage%',
                          showDivider: false,
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: AppSpacing.lg),
              FutureBuilder<List<GradeEntry>>(
                future: _gradesFuture,
                builder: (context, gradesSnapshot) {
                  if (!gradesSnapshot.hasData || gradesSnapshot.data!.isEmpty) {
                    return const SizedBox();
                  }

                  final grades = gradesSnapshot.data!;
                  final avg = grades
                          .where((g) => g.obtainedMarks != null)
                          .fold<int>(0, (sum, g) => sum + g.obtainedMarks!) /
                      grades.where((g) => g.obtainedMarks != null).length;

                  return AppCard.outlined(
                    title: 'Grade Summary',
                    child: Column(
                      children: [
                        InfoRow(
                          icon: Icons.bar_chart,
                          label: 'Class Average',
                          value: avg.toStringAsFixed(1),
                        ),
                        InfoRow(
                          icon: Icons.assignment_turned_in,
                          label: 'Graded',
                          value: grades
                              .where((g) => g.obtainedMarks != null)
                              .length
                              .toString(),
                        ),
                        InfoRow(
                          icon: Icons.pending_actions,
                          label: 'Pending',
                          value: grades
                              .where((g) => g.obtainedMarks == null)
                              .length
                              .toString(),
                          showDivider: false,
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: AppSpacing.lg),
              Text(
                'Roster',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: AppSpacing.sm),
              FutureBuilder<List<ClassAttendance>>(
                future: _attendanceFuture,
                builder: (context, rosterSnapshot) {
                  if (!rosterSnapshot.hasData ||
                      rosterSnapshot.data!.isEmpty) {
                    return const EmptyState(
                      icon: Icons.people_outline,
                      title: 'No Students',
                      message: 'Roster data is unavailable.',
                    );
                  }

                  final students = rosterSnapshot.data!.first.students;
                  return Column(
                    children: students
                        .take(15)
                        .map(
                          (s) => ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.faculty.withOpacity(0.2),
                              child: const Icon(Icons.person, color: AppColors.faculty),
                            ),
                            title: Text(s.studentName),
                            subtitle: Text('Roll: ${s.rollNumber}'),
                            trailing: Icon(
                              s.isPresent ? Icons.check_circle : Icons.cancel,
                              color: s.isPresent ? Colors.green : Colors.red,
                              size: 18,
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;

  const _InfoChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.grey.shade100,
      labelStyle: Theme.of(context).textTheme.labelSmall,
    );
  }
}
