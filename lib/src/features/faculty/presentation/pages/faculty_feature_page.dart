import 'package:flutter/material.dart';
import 'package:ksrce_erp/src/core/presentation/core_widgets.dart';
import 'package:ksrce_erp/src/core/theme/design_tokens.dart';
import 'package:ksrce_erp/src/features/faculty/data/faculty_ai_service.dart';
import 'faculty_feature_configs.dart';

class FacultyFeaturePage extends StatelessWidget {
  final String featureKey;

  const FacultyFeaturePage({super.key, required this.featureKey});

  @override
  Widget build(BuildContext context) {
    final config = facultyFeatureConfigs[featureKey];

    if (config == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Feature Not Found'),
        ),
        body: const ErrorState(
          message: 'This feature is not available.',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(config.title),
        elevation: 0,
      ),
      body: ListView(
        padding: AppSpacing.paddingLg,
        children: [
          Text(
            config.subtitle,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(height: AppSpacing.lg),
          ...config.sections.map((section) => _buildSection(context, section)),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, FacultyFeatureSection section) {
    return AppCard.outlined(
      title: section.title,
      subtitle: section.description,
      margin: EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        children: [
          ...section.items.map((item) => _buildItem(context, item)),
          if (section.actions.isNotEmpty) ...[
            SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: section.actions
                  .map((action) => _buildActionButton(context, action))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, FacultyFeatureItem item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Icon(item.icon, size: 20),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  item.value,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if (item.status != null) _statusBadge(item.status!),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return StatusBadge.pending(label: status);
      case 'approved':
        return StatusBadge.approved(label: status);
      case 'completed':
        return StatusBadge.completed(label: status);
      case 'critical':
        return StatusBadge.critical(label: status);
      case 'high':
        return StatusBadge.high(label: status);
      case 'medium':
        return StatusBadge.medium(label: status);
      case 'low':
        return StatusBadge.low(label: status);
      case 'active':
        return StatusBadge.active(label: status);
      case 'in progress':
        return StatusBadge.inProgress(label: status);
      default:
        return StatusBadge(label: status, backgroundColor: Colors.grey.shade200, textColor: Colors.grey.shade800);
    }
  }

  Widget _buildActionButton(BuildContext context, FacultyFeatureAction action) {
    return OutlinedButton.icon(
      onPressed: () async {
        final result = await FacultyAIService.runAction(action.actionId);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result)),
          );
        }
      },
      icon: Icon(action.icon, size: 16),
      label: Text(action.label),
    );
  }
}
