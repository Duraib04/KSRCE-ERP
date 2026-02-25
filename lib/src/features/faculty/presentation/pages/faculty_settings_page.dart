import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class FacultySettingsPage extends StatefulWidget {
  const FacultySettingsPage({super.key});

  @override
  State<FacultySettingsPage> createState() => _FacultySettingsPageState();
}

class _FacultySettingsPageState extends State<FacultySettingsPage> {
  static const _bg = AppColors.background;
  static const _card = AppColors.surface;
  static const _border = AppColors.border;
  static const _accent = AppColors.primary;
  static const _gold = AppColors.accent;

  bool _emailNotif = true;
  bool _smsNotif = false;
  bool _pushNotif = true;
  bool _assignmentNotif = true;
  bool _attendanceNotif = true;
  bool _examNotif = true;
  bool _leaveNotif = true;
  bool _complaintNotif = true;
  bool _darkMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Settings', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Manage your account settings and preferences', style: TextStyle(color: AppColors.textLight, fontSize: 14)),
            const SizedBox(height: 24),

            // Change Password
            _SectionCard(
              title: 'Change Password',
              icon: Icons.lock,
              child: Column(
                children: [
                  _SettingsField(label: 'Current Password', hint: 'Enter current password', isPassword: true),
                  const SizedBox(height: 14),
                  _SettingsField(label: 'New Password', hint: 'Enter new password', isPassword: true),
                  const SizedBox(height: 14),
                  _SettingsField(label: 'Confirm New Password', hint: 'Re-enter new password', isPassword: true),
                  const SizedBox(height: 6),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Password must be at least 8 characters with uppercase, lowercase, number, and special character.',
                      style: TextStyle(color: AppColors.border, fontSize: 11),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () => context.go('/faculty/change-password'),
                      style: ElevatedButton.styleFrom(backgroundColor: _accent, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                      child: const Text('Update Password'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Notification Preferences
            _SectionCard(
              title: 'Notification Preferences',
              icon: Icons.notifications,
              child: Column(
                children: [
                  _ToggleSetting(label: 'Email Notifications', subtitle: 'Receive notifications via email (r.kumaran@ksrce.ac.in)', value: _emailNotif, onChanged: (v) => setState(() => _emailNotif = v)),
                  _ToggleSetting(label: 'SMS Notifications', subtitle: 'Receive SMS alerts to +91 98765 43210', value: _smsNotif, onChanged: (v) => setState(() => _smsNotif = v)),
                  _ToggleSetting(label: 'Push Notifications', subtitle: 'Browser push notifications', value: _pushNotif, onChanged: (v) => setState(() => _pushNotif = v)),
                  const Divider(color: AppColors.border, height: 24),
                  const Text('Notification Categories', style: TextStyle(color: AppColors.textMedium, fontSize: 13, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  _ToggleSetting(label: 'Assignment Submissions', subtitle: 'When students submit assignments', value: _assignmentNotif, onChanged: (v) => setState(() => _assignmentNotif = v)),
                  _ToggleSetting(label: 'Attendance Alerts', subtitle: 'Low attendance warnings', value: _attendanceNotif, onChanged: (v) => setState(() => _attendanceNotif = v)),
                  _ToggleSetting(label: 'Exam Updates', subtitle: 'Exam schedule and evaluation reminders', value: _examNotif, onChanged: (v) => setState(() => _examNotif = v)),
                  _ToggleSetting(label: 'Leave Requests', subtitle: 'Student leave approval requests', value: _leaveNotif, onChanged: (v) => setState(() => _leaveNotif = v)),
                  _ToggleSetting(label: 'Complaints', subtitle: 'New student complaints', value: _complaintNotif, onChanged: (v) => setState(() => _complaintNotif = v)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Office Hours
            _SectionCard(
              title: 'Office Hours Setup',
              icon: Icons.access_time,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Set your office hours for student consultations', style: TextStyle(color: AppColors.textLight, fontSize: 13)),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: _border)),
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(const Color(0xFF1A2A4A)),
                      columns: const [
                        DataColumn(label: Text('Day', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 13))),
                        DataColumn(label: Text('Start Time', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 13))),
                        DataColumn(label: Text('End Time', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 13))),
                        DataColumn(label: Text('Location', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 13))),
                        DataColumn(label: Text('Status', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 13))),
                      ],
                      rows: const [
                        DataRow(cells: [
                          DataCell(Text('Monday', style: TextStyle(color: AppColors.textDark, fontSize: 13))),
                          DataCell(Text('03:00 PM', style: TextStyle(color: AppColors.textMedium, fontSize: 13))),
                          DataCell(Text('04:00 PM', style: TextStyle(color: AppColors.textMedium, fontSize: 13))),
                          DataCell(Text('Room 204', style: TextStyle(color: AppColors.textLight, fontSize: 13))),
                          DataCell(Text('Active', style: TextStyle(color: Colors.greenAccent, fontSize: 13))),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Wednesday', style: TextStyle(color: AppColors.textDark, fontSize: 13))),
                          DataCell(Text('03:00 PM', style: TextStyle(color: AppColors.textMedium, fontSize: 13))),
                          DataCell(Text('04:00 PM', style: TextStyle(color: AppColors.textMedium, fontSize: 13))),
                          DataCell(Text('Room 204', style: TextStyle(color: AppColors.textLight, fontSize: 13))),
                          DataCell(Text('Active', style: TextStyle(color: Colors.greenAccent, fontSize: 13))),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Friday', style: TextStyle(color: AppColors.textDark, fontSize: 13))),
                          DataCell(Text('02:00 PM', style: TextStyle(color: AppColors.textMedium, fontSize: 13))),
                          DataCell(Text('03:00 PM', style: TextStyle(color: AppColors.textMedium, fontSize: 13))),
                          DataCell(Text('Room 204', style: TextStyle(color: AppColors.textLight, fontSize: 13))),
                          DataCell(Text('Active', style: TextStyle(color: Colors.greenAccent, fontSize: 13))),
                        ]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Edit Office Hours'),
                      style: OutlinedButton.styleFrom(foregroundColor: _accent, side: BorderSide(color: _accent.withOpacity(0.4))),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Theme & Display
            _SectionCard(
              title: 'Theme & Display',
              icon: Icons.palette,
              child: Column(
                children: [
                  _ToggleSetting(label: 'Dark Mode', subtitle: 'Use dark theme for the application', value: _darkMode, onChanged: (v) => setState(() => _darkMode = v)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('Accent Color', style: TextStyle(color: AppColors.textMedium, fontSize: 14)),
                      const Spacer(),
                      ...[
                        AppColors.primary,
                        Colors.teal,
                        Colors.purple,
                        Colors.orange,
                        Colors.red,
                        AppColors.accent,
                      ].map((c) => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border: Border.all(color: c == _accent ? Colors.white : Colors.transparent, width: 2),
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Account Info
            _SectionCard(
              title: 'Account Information',
              icon: Icons.info,
              child: Column(
                children: [
                  _InfoRow('Employee ID', 'FAC001'),
                  _InfoRow('Username', 'r.kumaran'),
                  _InfoRow('Email', 'r.kumaran@ksrce.ac.in'),
                  _InfoRow('Role', 'Faculty'),
                  _InfoRow('Department', 'Computer Science & Engineering'),
                  _InfoRow('Last Login', '24 Feb 2026, 08:15 AM'),
                  _InfoRow('App Version', 'KSRCE ERP v2.5.1'),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.download, size: 16),
                        label: const Text('Download My Data'),
                        style: OutlinedButton.styleFrom(foregroundColor: AppColors.textMedium, side: const BorderSide(color: AppColors.border)),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.logout, size: 16),
                        label: const Text('Logout'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  const _SectionCard({required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _SettingsField extends StatelessWidget {
  final String label, hint;
  final bool isPassword;
  const _SettingsField({required this.label, required this.hint, this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textMedium, fontSize: 13)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            obscureText: isPassword,
            style: const TextStyle(color: AppColors.textDark, fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.border, fontSize: 13),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              suffixIcon: isPassword ? const Icon(Icons.visibility_off, color: AppColors.border, size: 18) : null,
            ),
          ),
        ),
      ],
    );
  }
}

class _ToggleSetting extends StatelessWidget {
  final String label, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleSetting({required this.label, required this.subtitle, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: AppColors.textDark, fontSize: 14)),
                Text(subtitle, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            inactiveTrackColor: AppColors.border,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(width: 150, child: Text(label, style: const TextStyle(color: AppColors.textLight, fontSize: 13))),
          Text(value, style: const TextStyle(color: AppColors.textDark, fontSize: 13)),
        ],
      ),
    );
  }
}
