import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});
  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  bool _emailNotif = true;
  bool _autoBackup = false;
  bool _maintenanceMode = false;
  String _sessionTimeout = '30 min';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Admin Settings', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 8),
        const Text('Configure system settings', style: TextStyle(fontSize: 14, color: AppColors.textLight)),
        const SizedBox(height: 32),
        _settingsSection('General', [
          _toggleTile('Maintenance Mode', 'Put the system in maintenance mode', Icons.engineering, _maintenanceMode, (v) => setState(() => _maintenanceMode = v)),
          _toggleTile('Email Notifications', 'Send email alerts for critical events', Icons.email, _emailNotif, (v) => setState(() => _emailNotif = v)),
          _toggleTile('Auto Backup', 'Automatically backup data daily', Icons.backup, _autoBackup, (v) => setState(() => _autoBackup = v)),
        ]),
        const SizedBox(height: 24),
        _settingsSection('Security', [
          _dropdownTile('Session Timeout', 'Auto-logout after inactivity', Icons.timer, _sessionTimeout, ['15 min', '30 min', '1 hour', '2 hours'], (v) => setState(() => _sessionTimeout = v!)),
        ]),
        const SizedBox(height: 24),
        _settingsSection('Data Management', [
          _actionTile('Export All Data', 'Download all data as CSV', Icons.download, AppColors.primary, () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data export started...'), backgroundColor: AppColors.primary));
          }),
          _actionTile('Clear Cache', 'Clear all cached data', Icons.cleaning_services, const Color(0xFFFF9800), () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cache cleared!'), backgroundColor: Color(0xFF4CAF50)));
          }),
          _actionTile('Reset Database', 'Reset all data to defaults (DANGER)', Icons.warning, Colors.red, () {
            showDialog(context: context, builder: (ctx) => AlertDialog(
              backgroundColor: AppColors.surface,
              title: const Text('Confirm Reset', style: TextStyle(color: Colors.white)),
              content: const Text('This will erase ALL data. Are you sure?', style: TextStyle(color: AppColors.textMedium)),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: AppColors.textLight))),
                ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: () => Navigator.pop(ctx), child: const Text('Reset')),
              ],
            ));
          }),
        ]),
      ]),
    );
  }

  Widget _settingsSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 16),
        ...children,
      ]),
    );
  }

  Widget _toggleTile(String title, String subtitle, IconData icon, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(children: [
        Icon(icon, color: const Color(0xFF42A5F5), size: 22),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w500)),
          Text(subtitle, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
        ])),
        Switch(value: value, onChanged: onChanged, activeColor: AppColors.primary),
      ]),
    );
  }

  Widget _dropdownTile(String title, String subtitle, IconData icon, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(children: [
        Icon(icon, color: const Color(0xFF42A5F5), size: 22),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w500)),
          Text(subtitle, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
          child: DropdownButtonHideUnderline(child: DropdownButton<String>(
            value: value, dropdownColor: AppColors.background,
            style: const TextStyle(color: AppColors.textDark, fontSize: 13),
            items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
            onChanged: onChanged,
          )),
        ),
      ]),
    );
  }

  Widget _actionTile(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap, borderRadius: BorderRadius.circular(8),
        child: Row(children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w500)),
            Text(subtitle, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
          ])),
          Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.3)),
        ]),
      ),
    );
  }
}
