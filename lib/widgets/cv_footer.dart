import 'package:flutter/material.dart';
import '../screens/legal_screen.dart';

class CvFooter extends StatelessWidget {
  const CvFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(top: 32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Lebenslauf und Co. KG',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Erstellt mit Flutter • Gehostet auf GitHub Pages',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Letzte Aktualisierung: ${_lastUpdateDate()}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 4,
            alignment: WrapAlignment.center,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.info_outline, size: 16),
                label: const Text('Impressum'),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const LegalScreen(showPrivacy: false),
                  ),
                ),
              ),
              TextButton.icon(
                icon: const Icon(Icons.shield_outlined, size: 16),
                label: const Text('Datenschutz'),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const LegalScreen(showPrivacy: true),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _lastUpdateDate() {
    final now = DateTime.now();
    final months = [
      'Januar', 'Februar', 'März', 'April', 'Mai', 'Juni',
      'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember',
    ];
    return '${now.day}. ${months[now.month - 1]} ${now.year}';
  }
}