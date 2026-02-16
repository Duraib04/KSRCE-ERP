import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ksrce_erp/src/config/routes.dart';
import 'package:ksrce_erp/src/core/theme/design_tokens.dart';
import 'faculty_feature_configs.dart';

class FacultyFeaturesHubPage extends StatelessWidget {
  const FacultyFeaturesHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = facultyFeatureConfigs.values.toList()
      ..sort((a, b) => a.title.compareTo(b.title));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Features'),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: AppSpacing.paddingMd,
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final config = entries[index];
          return Card(
            margin: EdgeInsets.only(bottom: AppSpacing.md),
            child: ListTile(
              title: Text(config.title),
              subtitle: Text(config.subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(
                '${FacultyRoutes.features}/${config.key}',
              ),
            ),
          );
        },
      ),
    );
  }
}
