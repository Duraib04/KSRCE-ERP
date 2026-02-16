import 'package:flutter/material.dart';
import 'package:ksrce_erp/src/core/presentation/core_widgets.dart';
import 'package:ksrce_erp/src/core/theme/design_tokens.dart';
import 'package:ksrce_erp/src/features/faculty/data/faculty_data_service.dart';
import 'package:ksrce_erp/src/features/faculty/domain/faculty_models.dart';
import 'package:ksrce_erp/src/features/faculty/presentation/widgets/faculty_widgets.dart';

class FacultyNoticesPage extends StatefulWidget {
  final String facultyId;

  const FacultyNoticesPage({
    required this.facultyId,
  });

  @override
  State<FacultyNoticesPage> createState() => _FacultyNoticesPageState();
}

class _FacultyNoticesPageState extends State<FacultyNoticesPage> {
  late Future<List<Notice>> _noticesFuture;
  bool _showDraftsOnly = false;

  @override
  void initState() {
    super.initState();
    _loadNotices();
  }

  void _loadNotices() {
    _noticesFuture = FacultyDataService.getMyNotices(widget.facultyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notices'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showComposeDialog,
            tooltip: 'Compose Notice',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter tabs
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.paddingMd,
                vertical: AppSpacing.paddingMd,
              ),
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: !_showDraftsOnly,
                    onSelected: (selected) {
                      setState(() => _showDraftsOnly = false);
                    },
                  ),
                  SizedBox(width: AppSpacing.sm),
                  FilterChip(
                    label: const Text('Drafts'),
                    selected: _showDraftsOnly,
                    onSelected: (selected) {
                      setState(() => _showDraftsOnly = true);
                    },
                  ),
                ],
              ),
            ),
            // Notices list
            FutureBuilder<List<Notice>>(
              future: _noticesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: EdgeInsets.all(AppSpacing.paddingMd),
                    child: LoadingShimmer.list(count: 3),
                  );
                }

                if (snapshot.hasError) {
                  return ErrorState(
                    message: 'Failed to load notices',
                    onRetry: _loadNotices,
                  );
                }

                final allNotices = snapshot.data ?? [];
                final notices = _showDraftsOnly
                    ? allNotices.where((n) => n.isDraft).toList()
                    : allNotices;

                if (notices.isEmpty) {
                  return EmptyState(
                    icon: Icons.notifications_none,
                    title: _showDraftsOnly ? 'No Drafts' : 'No Notices',
                    message: _showDraftsOnly
                        ? 'You haven\'t saved any draft notices'
                        : 'You haven\'t posted any notices yet',
                    actionLabel: 'Compose',
                    onAction: _showComposeDialog,
                  );
                }

                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSpacing.paddingMd,
                  ),
                  child: Column(
                    children: notices
                        .map(
                          (notice) => NoticeWidget(
                            notice: notice,
                            onEdit: notice.isDraft
                                ? () => _showComposeDialog(notice)
                                : null,
                            onDelete: () => _confirmDelete(notice),
                            onTap: () => _showNoticeDetail(notice),
                          ),
                        )
                        .toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showComposeDialog([Notice? existingNotice]) {
    showDialog(
      context: context,
      builder: (context) => _ComposeNoticeDialog(
        existingNotice: existingNotice,
        onSubmit: (notice) {
          Navigator.pop(context);
          _saveNotice(notice);
        },
      ),
    );
  }

  void _saveNotice(Notice notice) async {
    final success = await FacultyDataService.postNotice(notice);
    if (success && mounted) {
      setState(() => _loadNotices());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(notice.isDraft
              ? 'Notice saved as draft'
              : 'Notice posted successfully'),
        ),
      );
    }
  }

  void _confirmDelete(Notice notice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Notice?'),
        content: Text('Are you sure you want to delete "${notice.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success =
                  await FacultyDataService.deleteNotice(notice.noticeId);
              if (success && mounted) {
                setState(() => _loadNotices());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notice deleted')),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showNoticeDetail(Notice notice) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _NoticeDetailView(notice: notice),
    );
  }
}

class _ComposeNoticeDialog extends StatefulWidget {
  final Notice? existingNotice;
  final Function(Notice) onSubmit;

  const _ComposeNoticeDialog({
    this.existingNotice,
    required this.onSubmit,
  });

  @override
  State<_ComposeNoticeDialog> createState() => _ComposeNoticeDialogState();
}

class _ComposeNoticeDialogState extends State<_ComposeNoticeDialog> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late String _audience;
  late String? _category;
  late bool _isDraft;

  @override
  void initState() {
    super.initState();
    if (widget.existingNotice != null) {
      _titleController = TextEditingController(text: widget.existingNotice!.title);
      _contentController =
          TextEditingController(text: widget.existingNotice!.content);
      _audience = widget.existingNotice!.audience;
      _category = widget.existingNotice!.category;
      _isDraft = widget.existingNotice!.isDraft;
    } else {
      _titleController = TextEditingController();
      _contentController = TextEditingController();
      _audience = 'All Students';
      _category = null;
      _isDraft = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Compose Notice'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              maxLines: 5,
            ),
            SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              value: _audience,
              onChanged: (value) => setState(() => _audience = value ?? ''),
              items: [
                'All Students',
                'Specific Class',
                'Department',
              ]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              decoration: InputDecoration(
                labelText: 'Audience',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            CheckboxListTile(
              title: const Text('Save as Draft'),
              value: _isDraft,
              onChanged: (value) => setState(() => _isDraft = value ?? true),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Post'),
        ),
      ],
    );
  }

  void _submit() {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final notice = Notice(
      noticeId: widget.existingNotice?.noticeId ?? 'NOT-${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text,
      content: _contentController.text,
      postedDate: DateTime.now(),
      audience: _audience,
      category: _category,
      isDraft: _isDraft,
    );

    widget.onSubmit(notice);
  }
}

class _NoticeDetailView extends StatelessWidget {
  final Notice notice;

  const _NoticeDetailView({required this.notice});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.paddingLg),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    notice.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                if (notice.isDraft)
                  StatusBadge.pending(label: 'Draft'),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              'Audience: ${notice.audience}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            if (notice.category != null) ...[
              SizedBox(height: AppSpacing.sm),
              Text(
                'Category: ${notice.category}',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
            SizedBox(height: AppSpacing.md),
            Text(
              notice.content,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              'Posted on ${_formatDate(notice.postedDate)}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
