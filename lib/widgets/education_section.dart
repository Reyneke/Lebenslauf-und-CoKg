import 'package:flutter/material.dart';
import '../models/cv_data.dart';

class EducationSection extends StatelessWidget {
  final List<CvEntry> entries;

  const EducationSection({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    final educationEntries = entries
        .where((e) => e.type == 'education' || e.type == 'school' || e.type == 'vocational')
        .toList();

    if (educationEntries.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 16, top: 24),
          child: Text(
            'Ausbildung & Weiterbildung',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        ...educationEntries.map((entry) => _EducationCard(entry: entry)),
      ],
    );
  }
}

class _EducationCard extends StatelessWidget {
  final CvEntry entry;

  const _EducationCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(
          Icons.school,
          color: theme.colorScheme.primary,
        ),
        title: Text(entry.title, style: theme.textTheme.titleSmall),
        subtitle: Text(
          _formatDateRange(entry.startDate, entry.endDate),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        isThreeLine: entry.description != null && entry.description!.isNotEmpty,
        onTap: (entry.description != null && entry.description!.isNotEmpty)
            ? () => _showDescription(context, entry)
            : null,
      ),
    );
  }

  String _formatDateRange(String? start, String? end) {
    final startStr = start ?? '';
    final endStr = end ?? 'heute';
    if (startStr.isEmpty) return endStr;
    return '$startStr – $endStr';
  }
}

void _showDescription(BuildContext context, CvEntry entry) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(entry.title),
      content: SingleChildScrollView(
        child: Text(entry.description ?? ''),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Schließen'),
        ),
      ],
    ),
  );
}