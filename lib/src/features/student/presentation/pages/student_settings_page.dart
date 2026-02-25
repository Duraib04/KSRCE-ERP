import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/data_service.dart';
import '../../../../core/theme/app_colors.dart';

class StudentSettingsPage extends StatefulWidget {
  const StudentSettingsPage({super.key});

  @override
  State<StudentSettingsPage> createState() => _StudentSettingsPageState();
}

class _StudentSettingsPageState extends State<StudentSettingsPage> {
  bool _emailNotif = true;
  bool _smsNotif = false;
  bool _pushNotif = true;
  bool _assignmentReminder = true;
  bool _feeReminder = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(builder: (context, ds, _) {
      final student = ds.currentStudent ?? {};
      final uid = ds.currentUserId ?? '';
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: const [
                Icon(Icons.settings, color: AppColors.primary, size: 28),
                SizedBox(width: 12),
                Text('Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              ]),
              const SizedBox(height: 24),
              _buildNotificationSettings(),
              const SizedBox(height: 24),
              _buildAccountInfo(student, uid),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildNotificationSettings() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Notification Preferences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 16),
        _toggle('Email Notifications', _emailNotif, (v) => setState(() => _emailNotif = v)),
        _toggle('SMS Notifications', _smsNotif, (v) => setState(() => _smsNotif = v)),
        _toggle('Push Notifications', _pushNotif, (v) => setState(() => _pushNotif = v)),
        const Divider(color: AppColors.border, height: 24),
        _toggle('Assignment Reminders', _assignmentReminder, (v) => setState(() => _assignmentReminder = v)),
        _toggle('Fee Due Reminders', _feeReminder, (v) => setState(() => _feeReminder = v)),
      ]),
    );
  }

  Widget _toggle(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Expanded(child: Text(label, style: const TextStyle(color: AppColors.textDark, fontSize: 14))),
        Switch(value: value, onChanged: onChanged, activeColor: AppColors.primary),
      ]),
    );
  }

  Widget _buildAccountInfo(Map<String, dynamic> student, String uid) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Account Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 16),
        _infoRow('Student ID', uid),
        _infoRow('Name', student['name'] ?? '-'),
        _infoRow('Department', student['departmentId'] ?? '-'),
        _infoRow('Year', '${student['year'] ?? '-'}'),
        _infoRow('Section', student['section'] ?? '-'),
        _infoRow('Email', student['email'] ?? '-'),
        _infoRow('Phone', student['phone'] ?? '-'),
        _infoRow('CGPA', '${student['cgpa'] ?? '-'}'),
      ]),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        SizedBox(width: 140, child: Text(label, style: const TextStyle(color: AppColors.textLight, fontSize: 13))),
        Expanded(child: Text(value, style: const TextStyle(color: AppColors.textDark, fontSize: 14, fontWeight: FontWeight.w500))),
      ]),
    );
  }
}
