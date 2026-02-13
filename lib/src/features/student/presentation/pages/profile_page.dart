import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/design_tokens.dart';

class StudentProfilePage extends StatefulWidget {
  final String userId;

  const StudentProfilePage({Key? key, required this.userId})
      : super(key: key);

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage>
    with SingleTickerProviderStateMixin {
  late StudentProfileData profileData;
  late AnimationController _animationController;
  late List<Animation<double>> _sectionAnimations;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _sectionAnimations = List.generate(4, (index) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(index * 0.1, 0.6 + (index * 0.1), curve: Curves.easeOut),
        ),
      );
    });

    _animationController.forward();
  }

  void _loadProfileData() {
    profileData = StudentProfileData(
      name: 'Rahul Kumar',
      registrationNumber: 'S20210001',
      email: 'rahul.kumar@college.edu',
      phone: '+91 9876543210',
      dateOfBirth: '15-05-2003',
      gender: 'Male',
      department: 'Computer Science',
      semester: 'IV',
      batch: '2021-2025',
      address: '123 Main Street, City, State',
      parentName: 'Suresh Kumar',
      parentPhone: '+91 9999999999',
      emergencyContact: '+91 9876543210',
      gpa: 3.85,
      totalCreditsCompleted: 56,
      totalCreditsRequired: 120,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Beautiful gradient header
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildGradientHeader(),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile stats with animations
                  _buildProfileStats(),
                  SizedBox(height: AppSpacing.xxl),

                  // Basic Information
                  _buildAnimatedSection(
                    0,
                    'Basic Information',
                    [
                      _buildInfoRow('Email', profileData.email, Icons.email_rounded),
                      _buildDivider(),
                      _buildInfoRow('Phone', profileData.phone, Icons.phone_rounded),
                      _buildDivider(),
                      _buildInfoRow('Date of Birth', profileData.dateOfBirth, Icons.cake_rounded),
                      _buildDivider(),
                      _buildInfoRow('Gender', profileData.gender, Icons.person_rounded),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xl),

                  // Academic Information
                  _buildAnimatedSection(
                    1,
                    'Academic Information',
                    [
                      _buildInfoRow('Department', profileData.department, Icons.school_rounded),
                      _buildDivider(),
                      _buildInfoRow('Semester', 'IV', Icons.calendar_today_rounded),
                      _buildDivider(),
                      _buildInfoRow('Batch', profileData.batch, Icons.group_rounded),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xl),

                  // Guardian Information
                  _buildAnimatedSection(
                    2,
                    'Guardian Information',
                    [
                      _buildInfoRow('Parent Name', profileData.parentName, Icons.family_restroom_rounded),
                      _buildDivider(),
                      _buildInfoRow('Parent Contact', profileData.parentPhone, Icons.call_rounded),
                      _buildDivider(),
                      _buildInfoRow('Emergency Contact', profileData.emergencyContact, Icons.warning_rounded),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xl),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.edit_rounded),
                          label: const Text('Edit Profile'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.student,
                            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                          ),
                        ),
                      ),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.download_rounded),
                          label: const Text('Download'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.student, AppColors.info],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.student.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Text(
                  profileData.name[0],
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.student,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                profileData.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                profileData.registrationNumber,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard('GPA', profileData.gpa.toStringAsFixed(2), AppColors.student),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: _buildStatCard(
            'Credits',
            '${profileData.totalCreditsCompleted}/${profileData.totalCreditsRequired}',
            AppColors.info,
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: _buildStatCard('Semester', 'IV', AppColors.success),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
        borderRadius: AppRadius.radiusMd,
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.2), blurRadius: 12, spreadRadius: 2),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedSection(int index, String title, List<Widget> children) {
    return AnimatedBuilder(
      animation: _sectionAnimations[index],
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(0, (1 - _sectionAnimations[index].value) * 30),
          child: Opacity(
            opacity: _sectionAnimations[index].value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppRadius.radiusMd,
                    border: Border.all(color: AppColors.outlineLight),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.student.withOpacity(0.08),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(children: children),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.student.withOpacity(0.1),
              borderRadius: AppRadius.radiusMd,
            ),
            child: Icon(icon, color: AppColors.student, size: AppIconSize.md),
          ),
          SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: AppSpacing.lg,
      endIndent: AppSpacing.lg,
      color: AppColors.outlineLight,
    );
  }
}

class StudentProfileData {
  final String name;
  final String registrationNumber;
  final String email;
  final String phone;
  final String dateOfBirth;
  final String gender;
  final String department;
  final String semester;
  final String batch;
  final String address;
  final String parentName;
  final String parentPhone;
  final String emergencyContact;
  final double gpa;
  final int totalCreditsCompleted;
  final int totalCreditsRequired;

  StudentProfileData({
    required this.name,
    required this.registrationNumber,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
    required this.department,
    required this.semester,
    required this.batch,
    required this.address,
    required this.parentName,
    required this.parentPhone,
    required this.emergencyContact,
    required this.gpa,
    required this.totalCreditsCompleted,
    required this.totalCreditsRequired,
  });
}
