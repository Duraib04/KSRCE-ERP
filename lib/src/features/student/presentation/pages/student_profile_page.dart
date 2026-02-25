import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/data_service.dart';
import '../../../../core/theme/app_colors.dart';

class StudentProfilePage extends StatelessWidget {
  const StudentProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(builder: (context, ds, _) {
      if (!ds.isLoaded) {
        return const Scaffold(backgroundColor: AppColors.background, body: Center(child: CircularProgressIndicator()));
      }
      final student = ds.currentStudent ?? {};
      final name = (student['name'] as String?) ?? 'Student';
      final rollNo = (student['studentId'] as String?) ?? ds.currentUserId ?? '';
      final dept = (student['department'] as String?) ?? '';
      final year = (student['year'] as String?) ?? '';
      final section = (student['section'] as String?) ?? '';
      final email = (student['email'] as String?) ?? '';
      final phone = (student['phone'] as String?) ?? '';
      final dob = (student['dateOfBirth'] as String?) ?? '';
      final bloodGroup = (student['bloodGroup'] as String?) ?? '';
      final address = (student['address'] as String?) ?? '';
      final parentName = (student['parentName'] as String?) ?? '';
      final parentPhone = (student['parentPhone'] as String?) ?? '';
      final cgpa = ds.currentCGPA;
      final initials = name.split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join().toUpperCase();

      return Scaffold(
        backgroundColor: AppColors.background,
        body: LayoutBuilder(builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;
          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('My Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 24),
              _buildProfileHeader(isMobile, name, initials, rollNo, dept, year, section),
              const SizedBox(height: 24),
              if (isMobile) ...[
                _buildPersonalInfo(isMobile, dob, bloodGroup),
                const SizedBox(height: 24),
                _buildAcademicInfo(isMobile, rollNo, dept, year, cgpa),
              ] else
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: _buildPersonalInfo(isMobile, dob, bloodGroup)),
                  const SizedBox(width: 24),
                  Expanded(child: _buildAcademicInfo(isMobile, rollNo, dept, year, cgpa)),
                ]),
              const SizedBox(height: 24),
              _buildContactInfo(email, phone, parentName, parentPhone, address),
            ]),
          );
        }),
      );
    });
  }

  Widget _buildProfileHeader(bool isMobile, String name, String initials, String rollNo, String dept, String year, String section) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: isMobile
          ? Column(children: [
              CircleAvatar(radius: 50, backgroundColor: AppColors.accent,
                child: Text(initials, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white))),
              const SizedBox(height: 16),
              Text(name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              const SizedBox(height: 4),
              Text('Roll No: $rollNo', style: const TextStyle(fontSize: 16, color: AppColors.accent)),
              const SizedBox(height: 4),
              Text('$dept | Year $year | Sec $section', style: const TextStyle(fontSize: 14, color: AppColors.textMedium)),
            ])
          : Row(children: [
              CircleAvatar(radius: 50, backgroundColor: AppColors.accent,
                child: Text(initials, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white))),
              const SizedBox(width: 24),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                const SizedBox(height: 4),
                Text('Roll No: $rollNo', style: const TextStyle(fontSize: 16, color: AppColors.accent)),
                const SizedBox(height: 4),
                Text('$dept | Year $year | Section $section', style: const TextStyle(fontSize: 14, color: AppColors.textMedium)),
              ]),
            ]),
    );
  }

  Widget _buildPersonalInfo(bool isMobile, String dob, String bloodGroup) {
    final details = [
      {'label': 'Date of Birth', 'value': dob},
      {'label': 'Blood Group', 'value': bloodGroup},
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: const [
          Icon(Icons.person, color: AppColors.primary, size: 20),
          SizedBox(width: 8),
          Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        ]),
        const SizedBox(height: 16),
        ...details.where((d) => d['value']!.isNotEmpty).map((d) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(children: [
            SizedBox(width: isMobile ? 110 : 150, child: Text(d['label']!, style: const TextStyle(color: AppColors.textLight, fontSize: 14))),
            Flexible(child: Text(d['value']!, style: const TextStyle(color: AppColors.textDark, fontSize: 14))),
          ]),
        )),
      ]),
    );
  }

  Widget _buildAcademicInfo(bool isMobile, String rollNo, String dept, String year, double cgpa) {
    final details = [
      {'label': 'Register Number', 'value': rollNo},
      {'label': 'Department', 'value': dept},
      {'label': 'Year', 'value': year},
      {'label': 'Current CGPA', 'value': cgpa.toStringAsFixed(1)},
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: const [
          Icon(Icons.school, color: AppColors.primary, size: 20),
          SizedBox(width: 8),
          Text('Academic Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        ]),
        const SizedBox(height: 16),
        ...details.map((d) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(children: [
            SizedBox(width: isMobile ? 110 : 150, child: Text(d['label']!, style: const TextStyle(color: AppColors.textLight, fontSize: 14))),
            Flexible(child: Text(d['value']!, style: const TextStyle(color: AppColors.textDark, fontSize: 14))),
          ]),
        )),
      ]),
    );
  }

  Widget _buildContactInfo(String email, String phone, String parentName, String parentPhone, String address) {
    final details = <Map<String, dynamic>>[
      if (email.isNotEmpty) {'label': 'Email', 'value': email, 'icon': Icons.email},
      if (phone.isNotEmpty) {'label': 'Phone', 'value': phone, 'icon': Icons.phone},
      if (parentName.isNotEmpty) {'label': 'Parent', 'value': parentName, 'icon': Icons.person_outline},
      if (parentPhone.isNotEmpty) {'label': 'Parent Phone', 'value': parentPhone, 'icon': Icons.phone_in_talk},
      if (address.isNotEmpty) {'label': 'Address', 'value': address, 'icon': Icons.location_on},
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: const [
          Icon(Icons.contact_mail, color: AppColors.primary, size: 20),
          SizedBox(width: 8),
          Text('Contact Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        ]),
        const SizedBox(height: 16),
        Wrap(spacing: 40, runSpacing: 12, children: details.map((d) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(d['icon'] as IconData, color: AppColors.primary, size: 18),
            const SizedBox(width: 8),
            Text('${d['label']}: ', style: const TextStyle(color: AppColors.textLight, fontSize: 14)),
            Flexible(child: Text(d['value'] as String, style: const TextStyle(color: AppColors.textDark, fontSize: 14))),
          ],
        )).toList()),
      ]),
    );
  }
}
