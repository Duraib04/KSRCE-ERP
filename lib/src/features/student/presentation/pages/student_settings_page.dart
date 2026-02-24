import 'package:flutter/material.dart';

class StudentSettingsPage extends StatefulWidget {
  const StudentSettingsPage({super.key});

  @override
  State<StudentSettingsPage> createState() => _StudentSettingsPageState();
}

class _StudentSettingsPageState extends State<StudentSettingsPage> {
  bool _academicNotif = true;
  bool _assignmentNotif = true;
  bool _examNotif = true;
  bool _feeNotif = true;
  bool _placementNotif = true;
  bool _eventNotif = false;
  bool _darkTheme = true;
  String _language = 'English';
  final _currentPwdController = TextEditingController();
  final _newPwdController = TextEditingController();
  final _confirmPwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1F3C),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: const [
              Icon(Icons.settings, color: Color(0xFFD4A843), size: 28),
              SizedBox(width: 12),
              Text('Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            ]),
            const SizedBox(height: 8),
            const Text('Manage your account preferences', style: TextStyle(color: Colors.white60, fontSize: 14)),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Column(
                  children: [
                    _buildChangePassword(),
                    const SizedBox(height: 24),
                    _buildAppearance(),
                  ],
                )),
                const SizedBox(width: 24),
                Expanded(child: Column(
                  children: [
                    _buildNotificationPreferences(),
                    const SizedBox(height: 24),
                    _buildAccountInfo(),
                  ],
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChangePassword() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111D35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E3055)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: const [
            Icon(Icons.lock, color: Color(0xFFD4A843), size: 20),
            SizedBox(width: 8),
            Text('Change Password', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ]),
          const SizedBox(height: 20),
          _pwdField('Current Password', _currentPwdController),
          const SizedBox(height: 14),
          _pwdField('New Password', _newPwdController),
          const SizedBox(height: 14),
          _pwdField('Confirm New Password', _confirmPwdController),
          const SizedBox(height: 8),
          const Text('Password must be at least 8 characters with uppercase, lowercase, number and special character.', style: TextStyle(color: Colors.white38, fontSize: 12)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.save, size: 18),
            label: const Text('Update Password'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1565C0),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pwdField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter $label',
            hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
            filled: true, fillColor: const Color(0xFF0D1F3C),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: const Color(0xFF1E3055))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: const Color(0xFF1E3055))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            suffixIcon: const Icon(Icons.visibility_off, color: Colors.white38, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationPreferences() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111D35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E3055)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: const [
            Icon(Icons.notifications_active, color: Color(0xFFD4A843), size: 20),
            SizedBox(width: 8),
            Text('Notification Preferences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ]),
          const SizedBox(height: 16),
          _toggleItem('Academic Notifications', 'Classes, syllabus, course updates', _academicNotif, (v) => setState(() => _academicNotif = v)),
          _toggleItem('Assignment Reminders', 'Due dates, submission alerts', _assignmentNotif, (v) => setState(() => _assignmentNotif = v)),
          _toggleItem('Exam Notifications', 'Exam schedules, results', _examNotif, (v) => setState(() => _examNotif = v)),
          _toggleItem('Fee Reminders', 'Payment due dates, receipts', _feeNotif, (v) => setState(() => _feeNotif = v)),
          _toggleItem('Placement Updates', 'Drive schedules, company visits', _placementNotif, (v) => setState(() => _placementNotif = v)),
          _toggleItem('Event Alerts', 'College events, workshops', _eventNotif, (v) => setState(() => _eventNotif = v)),
        ],
      ),
    );
  }

  Widget _toggleItem(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
            Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 12)),
          ])),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF1565C0),
            activeTrackColor: const Color(0xFF1565C0).withOpacity(0.3),
            inactiveTrackColor: const Color(0xFF1E3055),
            inactiveThumbColor: Colors.white38,
          ),
        ],
      ),
    );
  }

  Widget _buildAppearance() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111D35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E3055)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: const [
            Icon(Icons.palette, color: Color(0xFFD4A843), size: 20),
            SizedBox(width: 8),
            Text('Appearance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ]),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                Text('Dark Theme', style: TextStyle(color: Colors.white, fontSize: 14)),
                Text('Use dark color scheme', style: TextStyle(color: Colors.white38, fontSize: 12)),
              ])),
              Switch(
                value: _darkTheme,
                onChanged: (v) => setState(() => _darkTheme = v),
                activeColor: const Color(0xFF1565C0),
                activeTrackColor: const Color(0xFF1565C0).withOpacity(0.3),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                Text('Language', style: TextStyle(color: Colors.white, fontSize: 14)),
                Text('Select display language', style: TextStyle(color: Colors.white38, fontSize: 12)),
              ])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(color: const Color(0xFF0D1F3C), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF1E3055))),
                child: DropdownButton<String>(
                  value: _language,
                  dropdownColor: const Color(0xFF111D35),
                  style: const TextStyle(color: Colors.white),
                  underline: const SizedBox(),
                  items: ['English', 'Tamil', 'Hindi'].map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                  onChanged: (v) => setState(() => _language = v!),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111D35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E3055)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: const [
            Icon(Icons.info_outline, color: Color(0xFFD4A843), size: 20),
            SizedBox(width: 8),
            Text('Account Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ]),
          const SizedBox(height: 16),
          _infoRow('Username', '727622BCS052'),
          _infoRow('Email', 'rahul.anand@ksrce.ac.in'),
          _infoRow('Role', 'Student'),
          _infoRow('Last Login', '24 Feb 2026, 08:15 AM'),
          _infoRow('Account Created', '15 Jul 2022'),
          _infoRow('App Version', 'v2.1.0'),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout, size: 18),
              label: const Text('Sign Out'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.redAccent,
                side: const BorderSide(color: Colors.redAccent),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(width: 140, child: Text(label, style: const TextStyle(color: Colors.white54, fontSize: 13))),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 13)),
        ],
      ),
    );
  }
}
