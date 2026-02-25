import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class HodSettingsPage extends StatelessWidget {
  const HodSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: const Center(child: Text('HOD settings coming soon', style: TextStyle(color: AppColors.textLight, fontSize: 14))),
          ),
        ]),
      ),
    );
  }
}
