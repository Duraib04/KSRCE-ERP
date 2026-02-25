import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/data_service.dart';
import '../../../../core/theme/app_colors.dart';

class FacultyResearchPage extends StatelessWidget {
  const FacultyResearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(builder: (context, ds, _) {
      final fid = ds.currentUserId ?? '';
      final publications = ds.getFacultyPublications(fid);
      final projects = ds.getFacultyProjects(fid);
      final scholars = ds.getFacultyPhDScholars(fid);
      final citations = ds.getFacultyTotalCitations(fid);
      final allResearch = ds.getFacultyResearch(fid);

      return Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: const [
              Icon(Icons.science, color: AppColors.primary, size: 28),
              SizedBox(width: 12),
              Text('Research & Publications', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            ]),
            const SizedBox(height: 24),
            Row(children: [
              _stat('Publications', '${publications.length}', AppColors.primary, Icons.article),
              const SizedBox(width: 16),
              _stat('Projects', '${projects.length}', Colors.green, Icons.work),
              const SizedBox(width: 16),
              _stat('PhD Scholars', '${scholars.length}', Colors.orange, Icons.school),
              const SizedBox(width: 16),
              _stat('Citations', '$citations', Colors.purple, Icons.format_quote),
            ]),
            const SizedBox(height: 24),
            _buildPublications(publications),
            const SizedBox(height: 24),
            _buildProjects(projects),
            if (scholars.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildScholars(scholars),
            ],
          ]),
        ),
      );
    });
  }

  Widget _stat(String label, String value, Color color, IconData icon) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
      ]),
    ));
  }

  Widget _buildPublications(List<Map<String, dynamic>> pubs) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Publications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 16),
        if (pubs.isEmpty) const Center(child: Text('No publications', style: TextStyle(color: AppColors.textLight))),
        ...pubs.map((p) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p['title'] ?? '', style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 4),
            Text('${p['journal'] ?? p['conference'] ?? ''} | ${p['year'] ?? ''}', style: const TextStyle(color: AppColors.textMedium, fontSize: 12)),
            Row(children: [
              Text('Citations: ${p['citations'] ?? 0}', style: const TextStyle(color: AppColors.accent, fontSize: 12)),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                child: Text(p['type'] ?? '', style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ]),
          ]),
        )),
      ]),
    );
  }

  Widget _buildProjects(List<Map<String, dynamic>> projects) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Research Projects', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 16),
        if (projects.isEmpty) const Center(child: Text('No projects', style: TextStyle(color: AppColors.textLight))),
        ...projects.map((p) {
          final status = p['status'] ?? 'ongoing';
          final color = status == 'completed' ? Colors.green : Colors.blue;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p['title'] ?? '', style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 14)),
                Text('Fund: ${p['fundingAgency'] ?? '-'} | Rs. ${p['fundingAmount'] ?? '-'}', style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
              ])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                child: Text(status.toString().toUpperCase(), style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ]),
          );
        }),
      ]),
    );
  }

  Widget _buildScholars(List<Map<String, dynamic>> scholars) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('PhD Scholars', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 16),
        ...scholars.map((s) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
          child: Row(children: [
            const Icon(Icons.school, color: AppColors.accent, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s['title'] ?? s['scholarName'] ?? '', style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w500, fontSize: 14)),
              Text(s['researchArea'] ?? '', style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
            ])),
            Text(s['status'] ?? '', style: const TextStyle(color: AppColors.accent, fontSize: 12)),
          ]),
        )),
      ]),
    );
  }
}
