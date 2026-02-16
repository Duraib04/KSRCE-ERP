import 'package:flutter/material.dart';
import 'package:ksrce_erp/src/core/presentation/core_widgets.dart';
import 'package:ksrce_erp/src/core/theme/app_colors.dart';
import 'package:ksrce_erp/src/core/theme/design_tokens.dart';
import 'package:ksrce_erp/src/features/faculty/data/faculty_data_service.dart';
import 'package:ksrce_erp/src/features/faculty/domain/faculty_models.dart';

class FacultyProfilePage extends StatefulWidget {
  final String facultyId;

  const FacultyProfilePage({super.key, required this.facultyId});

  @override
  State<FacultyProfilePage> createState() => _FacultyProfilePageState();
}

class _FacultyProfilePageState extends State<FacultyProfilePage> {
  late Future<FacultyProfile> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = FacultyDataService.getFacultyProfile(widget.facultyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Profile'),
        elevation: 0,
      ),
      body: FutureBuilder<FacultyProfile>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return ErrorState(
              message: 'Failed to load profile',
              onRetry: () {
                setState(() {
                  _profileFuture =
                      FacultyDataService.getFacultyProfile(widget.facultyId);
                });
              },
            );
          }

          final profile = snapshot.data;
          if (profile == null) {
            return const EmptyState(
              icon: Icons.person_off,
              title: 'Profile Missing',
              message: 'No profile data available.',
            );
          }

          return ListView(
            padding: AppSpacing.paddingLg,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 42,
                  backgroundColor: AppColors.faculty.withOpacity(0.2),
                  child: const Icon(Icons.person, size: 42, color: AppColors.faculty),
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              Center(
                child: Text(
                  profile.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Center(
                child: Text(
                  profile.department,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              AppCard.outlined(
                title: 'Contact',
                child: Column(
                  children: [
                    InfoRow(
                      icon: Icons.badge,
                      label: 'Faculty ID',
                      value: profile.facultyId,
                    ),
                    InfoRow(
                      icon: Icons.email,
                      label: 'Email',
                      value: profile.email,
                    ),
                    InfoRow(
                      icon: Icons.phone,
                      label: 'Phone',
                      value: profile.phone,
                      showDivider: false,
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              AppCard.outlined(
                title: 'Professional',
                child: Column(
                  children: [
                    InfoRow(
                      icon: Icons.school,
                      label: 'Qualification',
                      value: profile.qualification,
                    ),
                    InfoRow(
                      icon: Icons.work,
                      label: 'Experience',
                      value: '${profile.yearsOfExperience} years',
                    ),
                    InfoRow(
                      icon: Icons.location_on,
                      label: 'Office',
                      value: profile.officeLocation,
                    ),
                    InfoRow(
                      icon: Icons.schedule,
                      label: 'Office Hours',
                      value: profile.officeHours,
                      showDivider: false,
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit profile coming soon')),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit Profile'),
              ),
            ],
          );
        },
      ),
    );
  }
}
