import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cv_provider.dart';
import '../providers/theme_provider.dart';
import '../services/hash_link_service.dart';
import '../widgets/cv_header.dart';
import '../widgets/career_timeline.dart';
import '../widgets/education_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/joke_card.dart';
import '../widgets/cv_footer.dart';
import '../widgets/hash_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CvProvider>().loadCvData().then((_) {
        // After CV data is loaded, handle any initial URL hash
        HashLinkService.handleInitialHash();
      });
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final show = _scrollController.offset > 400;
    if (show != _showScrollToTop) {
      setState(() => _showScrollToTop = show);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cvProvider = context.watch<CvProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lebenslauf und Co. KG'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : themeProvider.themeMode == ThemeMode.light
                      ? Icons.dark_mode
                      : Icons.brightness_auto,
            ),
            tooltip: 'Theme umschalten',
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildBody(cvProvider, isWide),
          if (_showScrollToTop)
            Positioned(
              bottom: 24,
              right: 24,
              child: FloatingActionButton.small(
                heroTag: 'scrollToTop',
                onPressed: () {
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Icon(Icons.arrow_upward),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBody(CvProvider cvProvider, bool isWide) {
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

    // Build the content with hash-linkable sections
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),

        // Header
        HashSection(
          id: 'header',
          child: CvHeader(person: cvData.person),
        ),

        // Joke of the day
        const HashSection(
          id: 'joke',
          child: JokeCard(),
        ),

        // Contact info
        HashSection(
          id: 'kontakt',
          child: ContactSection(
            email: cvData.person.email,
            phone: cvData.person.phone,
            github: cvData.person.github,
            address: cvData.person.address,
          ),
        ),

        const Divider(height: 48),

        // Career timeline
        HashSection(
          id: 'berufserfahrung',
          child: CareerTimeline(entries: cvData.entries),
        ),

        // Education
        HashSection(
          id: 'ausbildung',
          child: EducationSection(entries: cvData.entries),
        ),

        const Divider(height: 48),

        // Skills
        HashSection(
          id: 'skills',
          child: SkillsSection(skills: cvData.skills),
        ),

        // Footer
        const CvFooter(),
      ],
    );

    // Apply responsive layout
    if (isWide) {
      content = Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: content,
        ),
      );
    }

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: content,
    );
  }
}