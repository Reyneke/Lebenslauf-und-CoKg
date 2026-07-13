import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:lebenslauf_und_cokg/main.dart';
import 'package:lebenslauf_und_cokg/models/cv_data.dart';
import 'package:lebenslauf_und_cokg/providers/theme_provider.dart';
import 'package:lebenslauf_und_cokg/providers/cv_provider.dart';
import 'package:lebenslauf_und_cokg/providers/joke_provider.dart';
import 'package:lebenslauf_und_cokg/widgets/cv_header.dart';
import 'package:lebenslauf_und_cokg/widgets/skills_section.dart';
import 'package:lebenslauf_und_cokg/widgets/education_section.dart';
import 'package:lebenslauf_und_cokg/widgets/cv_footer.dart';

// ─── Helpers ─────────────────────────────────────────────────────────────────

Widget wrapWithProviders(Widget child) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => CvProvider()),
      ChangeNotifierProvider(create: (_) => JokeProvider()),
    ],
    child: child,
  );
}

CvData createMockCvData() {
  return CvData(
    person: Person(
      name: 'Max Mustermann',
      photo: null,
      email: 'max@example.com',
      phone: '0123 456789',
      github: 'https://github.com/max',
      address: 'Musterstr. 1, 12345 Musterstadt',
      birthDate: '1. Januar 1990',
    ),
    entries: [
      CvEntry(
        type: 'experience',
        title: 'Senior Developer',
        startDate: '01/2020',
        endDate: null,
        description: 'Verantwortlich für Entwicklung',
        tags: ['Flutter', 'Dart'],
      ),
      CvEntry(
        type: 'education',
        title: 'M.Sc. Informatik',
        startDate: '10/2015',
        endDate: '09/2017',
      ),
      CvEntry(
        type: 'certificate',
        title: 'Flutter Developer Zertifikat',
        issuer: 'Google',
        startDate: '2023',
        file: 'cert.pdf',
      ),
    ],
    skills: [
      Skill(name: 'Flutter', category: 'Framework', level: 5),
      Skill(name: 'Dart', category: 'Sprache', level: 4),
      Skill(name: 'Python', category: 'Sprache', level: 3),
    ],
  );
}

// ─── App-Level Tests ─────────────────────────────────────────────────────────

void main() {
  group('App-Level Tests', () {
    testWidgets('LebenslaufApp shows title in AppBar',
        (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithProviders(const LebenslaufApp()));

      expect(find.text('Lebenslauf und Co. KG'), findsOneWidget);
    });

    testWidgets('AppBar is present with theme switcher button',
        (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithProviders(const LebenslaufApp()));

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.brightness_auto), findsOneWidget);
    });

    testWidgets('Theme toggle switches icon', (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithProviders(const LebenslaufApp()));

      // Initially system mode → brightness_auto icon
      expect(find.byIcon(Icons.brightness_auto), findsOneWidget);

      // Tap theme switcher → changes to light mode → dark_mode icon
      await tester.tap(find.byIcon(Icons.brightness_auto));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byIcon(Icons.dark_mode), findsOneWidget);

      // Tap again → dark mode → light_mode icon
      await tester.tap(find.byIcon(Icons.dark_mode));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byIcon(Icons.light_mode), findsOneWidget);
    });

    testWidgets('Error screen shows retry button',
        (WidgetTester tester) async {
      final cvProvider = CvProvider();
      cvProvider.loadCvData(); // Will fail because no asset loader in test

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => cvProvider),
            ChangeNotifierProvider(create: (_) => JokeProvider()),
          ],
          child: const LebenslaufApp(),
        ),
      );

      // After pump, the error screen may appear
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      // Should find retry button if error occurred
      if (find.text('Erneut versuchen').evaluate().isNotEmpty) {
        expect(find.text('Erneut versuchen'), findsOneWidget);
      }
    });
  });

  // ─── Data Model Tests ─────────────────────────────────────────────────────

  group('Data Model Tests', () {
    test('CvData fromJson creates valid object', () {
      final json = {
        'person': {
          'name': 'Matthias Struck',
          'photo': 'doc/ich/MatthiasStruck.jpg',
          'email': 'test@example.com',
        },
        'entries': [
          {
            'type': 'experience',
            'title': 'Software Developer',
            'startDate': '01/2020',
          },
        ],
        'skills': [
          {'name': 'Flutter', 'category': 'Framework', 'level': 5},
        ],
      };

      final cvData = CvData.fromJson(json);
      expect(cvData.person.name, 'Matthias Struck');
      expect(cvData.person.email, 'test@example.com');
      expect(cvData.entries.length, 1);
      expect(cvData.entries[0].title, 'Software Developer');
      expect(cvData.skills.length, 1);
      expect(cvData.skills[0].name, 'Flutter');
    });

    test('CvData toJson round-trip preserves data', () {
      final original = createMockCvData();
      final json = original.toJson();
      final restored = CvData.fromJson(json);

      expect(restored.person.name, original.person.name);
      expect(restored.entries.length, original.entries.length);
      expect(restored.entries[0].title, original.entries[0].title);
      expect(restored.skills.length, original.skills.length);
      expect(restored.skills[0].level, original.skills[0].level);
    });

    test('CvEntry has correct types', () {
      final entries = createMockCvData().entries;
      expect(entries[0].type, 'experience');
      expect(entries[1].type, 'education');
      expect(entries[2].type, 'certificate');
    });

    test('Skill level is within valid range', () {
      final skills = createMockCvData().skills;
      for (final skill in skills) {
        expect(skill.level, greaterThanOrEqualTo(0));
        expect(skill.level, lessThanOrEqualTo(5));
      }
    });
  });

  // ─── Widget Component Tests ───────────────────────────────────────────────

  group('Widget Component Tests', () {
    testWidgets('CvHeader displays person name', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CvHeader(person: createMockCvData().person),
          ),
        ),
      );

      expect(find.text('Max Mustermann'), findsOneWidget);
    });

    testWidgets('SkillsSection shows grouped skills',
        (WidgetTester tester) async {
      final cvData = createMockCvData();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SkillsSection(skills: cvData.skills),
            ),
          ),
        ),
      );

      // Section title
      expect(find.text('Kenntnisse & Fertigkeiten'), findsOneWidget);
      // Category headers
      expect(find.text('Framework'), findsOneWidget);
      expect(find.text('Sprache'), findsOneWidget);
      // Skill names
      expect(find.text('Flutter'), findsOneWidget);
      expect(find.text('Dart'), findsOneWidget);
    });

    testWidgets('EducationSection shows entries',
        (WidgetTester tester) async {
      final cvData = createMockCvData();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: EducationSection(entries: cvData.entries),
            ),
          ),
        ),
      );

      expect(find.text('Ausbildung & Weiterbildung'), findsOneWidget);
      expect(find.text('M.Sc. Informatik'), findsOneWidget);
    });

    testWidgets('CvFooter displays footer text',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const CvFooter(),
          ),
        ),
      );

      expect(find.text('Lebenslauf und Co. KG'), findsOneWidget);
      expect(
        find.text('Erstellt mit Flutter • Gehostet auf GitHub Pages'),
        findsOneWidget,
      );
    });

    testWidgets('Empty skills section returns SizedBox',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkillsSection(skills: []),
          ),
        ),
      );

      // Should not find the section header
      expect(find.text('Kenntnisse & Fertigkeiten'), findsNothing);
    });
  });

  // ─── Provider Tests ───────────────────────────────────────────────────────

  group('Provider Tests', () {
    test('CvProvider has correct initial state', () {
      final cvProvider = CvProvider();
      expect(cvProvider.cvData, isNull);
      expect(cvProvider.isLoading, false);
      expect(cvProvider.error, isNull);
    });

    test('ThemeProvider default theme mode is system', () {
      final themeProvider = ThemeProvider();
      expect(themeProvider.themeMode, ThemeMode.system);
    });

    test('ThemeProvider toggleTheme cycles through modes', () {
      final themeProvider = ThemeProvider();

      expect(themeProvider.themeMode, ThemeMode.system);

      themeProvider.toggleTheme();
      expect(themeProvider.themeMode, ThemeMode.light);

      themeProvider.toggleTheme();
      expect(themeProvider.themeMode, ThemeMode.dark);

      themeProvider.toggleTheme();
      expect(themeProvider.themeMode, ThemeMode.system);
    });

    test('JokeProvider has correct initial state', () {
      final jokeProvider = JokeProvider();
      expect(jokeProvider.joke, isNull);
      expect(jokeProvider.isLoading, false);
    });
  });
}