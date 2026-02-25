import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/data_service.dart';
import '../../../../core/theme/app_colors.dart';

class FacultyEventsPage extends StatelessWidget {
  const FacultyEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(builder: (context, ds, _) {
      final upcoming = ds.getUpcomingEvents();
      final past = ds.getCompletedEvents();

      return Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: const [
              Icon(Icons.event, color: AppColors.primary, size: 28),
              SizedBox(width: 12),
              Text('Events & Activities', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            ]),
            const SizedBox(height: 24),
            _buildSection('Upcoming Events', upcoming, Colors.blue),
            const SizedBox(height: 24),
            _buildSection('Past Events', past, Colors.grey),
          ]),
        ),
      );
    });
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> events, Color accent) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 16),
        if (events.isEmpty) const Center(child: Text('No events', style: TextStyle(color: AppColors.textLight))),
        ...events.map((e) {
          final type = (e['type'] ?? '').toString();
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: accent.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                child: Icon(Icons.event, color: accent, size: 24)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(e['name'] ?? '', style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 15))),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: accent.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                    child: Text(type, style: TextStyle(color: accent, fontSize: 11, fontWeight: FontWeight.bold))),
                ]),
                const SizedBox(height: 6),
                Text(e['description'] ?? '', style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
                const SizedBox(height: 6),
                Row(children: [
                  const Icon(Icons.calendar_today, color: AppColors.textLight, size: 14),
                  const SizedBox(width: 4),
                  Text(e['date'] ?? '', style: const TextStyle(color: AppColors.textMedium, fontSize: 12)),
                  const SizedBox(width: 16),
                  const Icon(Icons.location_on, color: AppColors.textLight, size: 14),
                  const SizedBox(width: 4),
                  Text(e['venue'] ?? '', style: const TextStyle(color: AppColors.textMedium, fontSize: 12)),
                ]),
              ])),
            ]),
          );
        }),
      ]),
    );
  }
}
