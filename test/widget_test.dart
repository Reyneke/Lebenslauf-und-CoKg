import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:lebenslauf_und_cokg/main.dart';
import 'package:lebenslauf_und_cokg/providers/theme_provider.dart';
import 'package:lebenslauf_und_cokg/providers/cv_provider.dart';

Widget createTestApp() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => CvProvider()),
    ],
    child: const MaterialApp(
      home: Scaffold(
        body: Text('Test'),
      ),
    ),
  );
}

void main() {
  testWidgets('LebenslaufApp can be instantiated', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => CvProvider()),
        ],
        child: const LebenslaufApp(),
      ),
    );

    // Verify that the app title is shown in the AppBar
    expect(find.text('Lebenslauf und Co. KG'), findsOneWidget);
  });

  testWidgets('AppBar is present with theme switcher button',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => CvProvider()),
        ],
        child: const LebenslaufApp(),
      ),
    );

    // The AppBar should be present
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('ThemeProvider default theme mode is system',
      (WidgetTester tester) async {
    final themeProvider = ThemeProvider();
    expect(themeProvider.themeMode, ThemeMode.system);
  });

  testWidgets('ThemeProvider toggleTheme cycles through modes',
      (WidgetTester tester) async {
    final themeProvider = ThemeProvider();

    // initial: system
    expect(themeProvider.themeMode, ThemeMode.system);

    // first toggle: system -> light
    themeProvider.toggleTheme();
    expect(themeProvider.themeMode, ThemeMode.light);

    // second toggle: light -> dark
    themeProvider.toggleTheme();
    expect(themeProvider.themeMode, ThemeMode.dark);

    // third toggle: dark -> system
    themeProvider.toggleTheme();
    expect(themeProvider.themeMode, ThemeMode.system);
  });
}