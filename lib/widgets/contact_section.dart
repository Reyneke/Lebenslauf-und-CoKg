import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatelessWidget {
  final String? email;
  final String? phone;
  final String? github;
  final String? address;

  const ContactSection({
    super.key,
    this.email,
    this.phone,
    this.github,
    this.address,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tiles = <Widget>[];

    if (email != null) {
      tiles.add(_ContactTile(
        icon: Icons.email,
        label: email!,
        onTap: () => launchUrl(Uri.parse('mailto:$email')),
      ));
    }

    if (phone != null) {
      tiles.add(_ContactTile(
        icon: Icons.phone,
        label: phone!,
        onTap: () => launchUrl(Uri.parse('tel:${phone!.replaceAll(RegExp(r'\s+'), '')}')),
      ));
    }

    if (github != null) {
      tiles.add(_ContactTile(
        icon: Icons.code,
        label: 'GitHub',
        onTap: () => launchUrl(Uri.parse(github!)),
      ));
    }

    if (address != null) {
      tiles.add(_ContactTile(
        icon: Icons.location_on,
        label: address!,
        onTap: () => launchUrl(Uri.parse(
          'https://www.google.com/maps/search/${Uri.encodeComponent(address!)}',
        )),
      ));
    }

    if (tiles.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 16, top: 24),
          child: Text(
            'Kontakt',
            style: theme.textTheme.headlineMedium,
          ),
        ),
        ...tiles,
      ],
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ContactTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(label),
        trailing: const Icon(Icons.open_in_new, size: 16),
        onTap: onTap,
      ),
    );
  }
}