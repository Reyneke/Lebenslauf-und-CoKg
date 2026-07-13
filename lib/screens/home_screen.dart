import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cv_provider.dart';
import '../providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load CV data when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CvProvider>().loadCvData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cvProvider = context.watch<CvProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lebenslauf und Co. KG'),
        actions: [
          // Theme switcher
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            tooltip: 'Theme umschalten',
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: _buildBody(cvProvider),
    );
  }

  Widget _buildBody(CvProvider cvProvider) {
    if (cvProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (cvProvider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              cvProvider.error!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<CvProvider>().loadCvData(),
              child: const Text('Erneut versuchen'),
            ),
          ],
        ),
      );
    }

    if (cvProvider.cvData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Keine CV-Daten gefunden.',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<CvProvider>().loadCvData(),
              child: const Text('Daten laden'),
            ),
          ],
        ),
      );
    }

    final cvData = cvProvider.cvData!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header / Person
          Center(
            child: Column(
              children: [
                if (cvData.person.photo != null)
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(cvData.person.photo!),
                  ),
                const SizedBox(height: 16),
                Text(
                  cvData.person.name,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Skills
          if (cvData.skills.isNotEmpty) ...[
            Text(
              'Skills',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: cvData.skills.map((skill) {
                return Chip(
                  label: Text('${skill.name} (${skill.level}/5)'),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          // Entries (Experience, Education, Certificates)
          if (cvData.entries.isNotEmpty) ...[
            Text(
              'Stationen',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            ...cvData.entries.map((entry) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: Icon(_iconForType(entry.type)),
                    title: Text(entry.title),
                    subtitle: Text([
                      if (entry.organization != null) entry.organization!,
                      if (entry.startDate != null)
                        '${entry.startDate} – ${entry.endDate ?? 'heute'}',
                    ].join(' • ')),
                    isThreeLine: entry.description != null,
                  ),
                )),
          ],
        ],
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'experience':
        return Icons.work;
      case 'education':
        return Icons.school;
      case 'certificate':
        return Icons.verified;
      default:
        return Icons.article;
    }
  }
}