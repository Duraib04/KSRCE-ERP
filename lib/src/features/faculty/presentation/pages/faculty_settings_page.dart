import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/data_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_card_styles.dart';

class FacultySettingsPage extends StatefulWidget {
  const FacultySettingsPage({super.key});

  @override
  State<FacultySettingsPage> createState() => _FacultySettingsPageState();
}

class _FacultySettingsPageState extends State<FacultySettingsPage> {
  bool _emailNotif = true;
  bool _smsNotif = false;
  bool _pushNotif = true;
  bool _leaveNotif = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(builder: (context, ds, _) {
      final fac = ds.currentFaculty ?? {};
      final fid = ds.currentUserId ?? '';
      final dept = ds.getDepartmentName(fac['departmentId'] ?? '');

      return Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: const [
              Icon(Icons.settings, color: AppColors.primary, size: 28),
              SizedBox(width: 12),
              Text('Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            ]),
            const SizedBox(height: 24),
            _buildNotificationSettings(),
            const SizedBox(height: 24),
            _buildAccountInfo(fac, fid, dept),
          ]),
        ),
      );
    });
  }

  Widget _buildNotificationSettings() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppCardStyles.elevated,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Notification Preferences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 16),
        _toggle('Email Notifications', _emailNotif, (v) => setState(() => _emailNotif = v)),
        _toggle('SMS Notifications', _smsNotif, (v) => setState(() => _smsNotif = v)),
        _toggle('Push Notifications', _pushNotif, (v) => setState(() => _pushNotif = v)),
        const Divider(color: AppColors.border, height: 24),
        _toggle('Leave Request Alerts', _leaveNotif, (v) => setState(() => _leaveNotif = v)),
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

  Widget _buildAccountInfo(Map<String, dynamic> fac, String fid, String dept) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppCardStyles.elevated,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Account Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 16),
        _infoRow('Employee ID', fid),
        _infoRow('Name', fac['name'] ?? '-'),
        _infoRow('Department', dept),
        _infoRow('Designation', fac['designation'] ?? '-'),
        _infoRow('Qualification', fac['qualification'] ?? '-'),
        _infoRow('Experience', '${fac['experience'] ?? '-'} years'),
        _infoRow('Email', fac['email'] ?? '-'),
        _infoRow('Phone', fac['phone'] ?? '-'),
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
