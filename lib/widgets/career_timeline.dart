import 'package:flutter/material.dart';
import '../models/cv_data.dart';

class CareerTimeline extends StatelessWidget {
  final List<CvEntry> entries;

  const CareerTimeline({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    final experiencedEntries = entries
        .where((e) => e.type == 'experience')
        .toList();

    if (experiencedEntries.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 16),
          child: Text(
            'Beruflicher Werdegang',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        ...experiencedEntries.map((entry) => _TimelineEntry(entry: entry)),
      ],
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  final CvEntry entry;

  const _TimelineEntry({required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          SizedBox(
            width: 48,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDateRange(entry.startDate, entry.endDate),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    if (entry.description != null &&
                        entry.description!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        entry.description!,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                    if (entry.tags != null && entry.tags!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: entry.tags!.map((tag) {
                          return Chip(
                            label: Text(tag, style: const TextStyle(fontSize: 11)),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
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