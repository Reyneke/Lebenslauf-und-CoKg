import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/cv_data.dart';

class EducationSection extends StatelessWidget {
  final List<CvEntry> entries;

  const EducationSection({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    final educationEntries = entries
        .where((e) => e.type == 'education' || e.type == 'school' || e.type == 'vocational')
        .toList();
    final certificateEntries = entries
        .where((e) => e.type == 'certificate')
        .toList();

    if (educationEntries.isEmpty && certificateEntries.isEmpty) {
      return const SizedBox.shrink();
    }

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
        if (certificateEntries.isNotEmpty) ...[
          const SizedBox(height: 8),
          _CertificatesSection(certificates: certificateEntries),
        ],
      ],
    );
  }
}

class _CertificatesSection extends StatelessWidget {
  final List<CvEntry> certificates;

  const _CertificatesSection({required this.certificates});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ExpansionTile(
        leading: Icon(Icons.verified, color: theme.colorScheme.primary),
        title: Text(
          'Zertifikate & Zeugnisse (${certificates.length})',
          style: theme.textTheme.titleSmall,
        ),
        subtitle: Text(
          'Zum Anzeigen aufklappen',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        children: certificates.map((cert) => ListTile(
          leading: const Icon(Icons.picture_as_pdf, size: 20),
          title: Text(cert.title, style: theme.textTheme.bodyMedium),
          subtitle: cert.issuer != null
              ? Text(cert.issuer!, style: theme.textTheme.bodySmall)
              : null,
          trailing: const Icon(Icons.open_in_new, size: 18),
          onTap: () {
            if (cert.file != null && cert.file!.isNotEmpty) {
              // Try to open the certificate file via url_launcher
              _openCertificate(context, cert.file!);
            } else if (cert.description != null && cert.description!.isNotEmpty) {
              _showDescription(context, cert);
            }
          },
        )).toList(),
      ),
    );
  }

  void _openCertificate(BuildContext context, String path) {
    // If the path looks like a URL, open it with url_launcher
    if (path.startsWith('http://') || path.startsWith('https://')) {
      _launchUrl(context, path);
      return;
    }

    // For local/assets paths, show a dialog explaining how to access it
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Zertifikat öffnen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Dieses Zertifikat liegt als PDF vor und kann nicht '
              'direkt im Browser geöffnet werden. Es sollte über einen '
              'Download-Link oder das Dateisystem zugänglich sein.',
            ),
            const SizedBox(height: 16),
            Text(
              'Datei: $path',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
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

  void _launchUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konnte Link nicht öffnen')),
      );
    }
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