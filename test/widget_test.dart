import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:lebenslauf_und_cokg/main.dart';
import 'package:lebenslauf_und_cokg/providers/theme_provider.dart';
import 'package:lebenslauf_und_cokg/providers/cv_provider.dart';
import 'package:lebenslauf_und_cokg/providers/joke_provider.dart';

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

void main() {
  testWidgets('LebenslaufApp shows title in AppBar',
      (WidgetTester tester) async {
    await tester.pumpWidget(wrapWithProviders(const LebenslaufApp()));

    expect(find.text('Lebenslauf und Co. KG'), findsOneWidget);
  });

  testWidgets('AppBar is present with theme switcher button',
      (WidgetTester tester) async {
    await tester.pumpWidget(wrapWithProviders(const LebenslaufApp()));

    expect(find.byType(AppBar), findsOneWidget);
    // Theme switcher icon button should be present
    expect(find.byIcon(Icons.brightness_auto), findsOneWidget);
  });

  testWidgets('CvProvider has correct initial state',
      (WidgetTester tester) async {
    final cvProvider = CvProvider();
    expect(cvProvider.cvData, isNull);
    expect(cvProvider.isLoading, false);
    expect(cvProvider.error, isNull);
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