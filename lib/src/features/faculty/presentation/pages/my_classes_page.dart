import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrce_erp/src/config/routes.dart';
import 'package:ksrce_erp/src/core/presentation/core_widgets.dart';
import 'package:ksrce_erp/src/core/theme/design_tokens.dart';
import 'package:ksrce_erp/src/features/faculty/data/faculty_data_service.dart';
import 'package:ksrce_erp/src/features/faculty/domain/faculty_models.dart';
import 'package:ksrce_erp/src/features/faculty/presentation/widgets/faculty_widgets.dart';

class FacultyMyClassesPage extends StatefulWidget {
  final String userId;

  const FacultyMyClassesPage({super.key, required this.userId});

  @override
  State<FacultyMyClassesPage> createState() => _FacultyMyClassesPageState();
}

class _FacultyMyClassesPageState extends State<FacultyMyClassesPage> {
  late Future<List<ClassAssignment>> _classesFuture;

  @override
  void initState() {
    super.initState();
    _classesFuture = FacultyDataService.getMyClasses(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Classes'),
        elevation: 0,
      ),
      body: FutureBuilder<List<ClassAssignment>>(
        future: _classesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingShimmer.list(count: 4);
          }

          if (snapshot.hasError) {
            return ErrorState(
              message: 'Failed to load classes',
              onRetry: () {
                setState(() {
                  _classesFuture = FacultyDataService.getMyClasses(widget.userId);
                });
              },
            );
          }

          final classes = snapshot.data ?? [];
          if (classes.isEmpty) {
            return const EmptyState(
              icon: Icons.class_,
              title: 'No Classes Assigned',
              message: 'You have no assigned classes yet.',
            );
          }

          return ListView(
            padding: AppSpacing.paddingMd,
            children: [
              AppCard.outlined(
                title: 'Summary',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _SummaryItem(
                      label: 'Total Classes',
                      value: classes.length.toString(),
                    ),
                    _SummaryItem(
                      label: 'Total Students',
                      value: classes
                          .fold<int>(0, (sum, c) => sum + c.totalStudents)
                          .toString(),
                    ),
                    _SummaryItem(
                      label: 'Avg Enrollment',
                      value: (classes
                                  .fold<int>(
                                      0, (sum, c) => sum + c.totalStudents) /
                              classes.length)
                          .toStringAsFixed(0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              ...classes.map(
                (classItem) => ClassCard(
                  classAssignment: classItem,
                  onTap: () => context.push(
                    '${FacultyRoutes.classDetail}/${classItem.courseId}',
                  ),
                  onAttendance: () => context.push(FacultyRoutes.attendance),
                  onGrades: () => context.push(FacultyRoutes.grades),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}
