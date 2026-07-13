## 2. Die App

### 2.1 Zielsetzung

Die App wird als webfähiges Flutter-Projekt realisiert und zeigt meinen aktuellen CV an.
Zentrales Design-Element ist die im Ordner `theme/` definierte Formatvorlage (`theme/app_theme.dart`),
die sowohl ein helles als auch ein dunkles Farbschema vorgibt (basierend auf `ColorScheme.fromSeed`
mit `Colors.purple` als Saatfarbe). Die App soll seriös wirken, aber nicht übermäßig steif –
eine Prise Humor und kleine Hintergrundgags lockern das Gesamtbild auf.

### 2.2 Theme & ThemeSwitcher

- Die App verwendet das vorgegebene `AppTheme`-Objekt aus `theme/app_theme.dart`.
- Ein **ThemeSwitcher** (Umschaltung zwischen hell, dunkel und systemautomatisch) ist
  fester Bestandteil der App. Dazu wird der bereits vorhandene
  `AppTheme.themeModeNotifier` (`ValueNotifier<ThemeMode>`) genutzt, der reaktiv
  vom UI konsumiert wird (z. B. via `ListenableBuilder` oder `ValueListenableBuilder`).
- Der aktive Modus sollte persistiert werden (z. B. über `SharedPreferences` oder
  `dart:io` / `localStorage` im Web), damit die Wahl beim nächsten Besuch erhalten bleibt.

### 2.3 IT-Jokes als täglicher Hintergrundgag

Ein zentrales "kleines Extra" sind täglich wechselnde IT-Jokes, die aus einer externen
Quelle geladen werden. Vorschläge für die Datenquelle:

- **[icanhazdadjoke.com](https://icanhazdadjoke.com/)** – freie API, JSON-Antwort,
  oft Programmierer- und IT-Witze, keine Authentifizierung nötig.
- **[ChuckNorris.io](https://api.chucknorris.io/)** – große Sammlung an Chuck-Norris-Witzen,
  viele mit IT-Bezug.
- **[JokeAPI](https://sv443.net/jokeapi/v2/)** – kategorisierbar ("Programming" als Kategorie),
  zweistufige Witze möglich, erlaubt das Filtern nach Inhalt.

**Empfohlenes Vorgehen:**

1. Witze-Daten über HTTP abrufen (z. B. mit `http`-Paket).
2. Antwort parsen (JSON → Dart-Objekt).
3. Angezeigten Witz in `localStorage` oder einer App-Präferenz zwischenspeichern,
   damit er nicht bei jedem Seitenwechsel oder Widget-Build neu geladen werden muss.
   Ein Cache-Key mit dem aktuellen Datum stellt sicher, dass maximal einmal pro Tag
   ein neuer Witz geladen wird.

### 2.4 Datenfluss (CV-Daten)

Die zugrunde liegenden Lebenslaufdaten liegen im Ordner `doc/ich/` und werden
– wie in „0_Grundidee.md" skizziert – einmalig eingelesen und in ein strukturiertes
Dart-Datenmodell überführt. Die App stellt diese Daten in klar gegliederten Sektionen dar
(z. B. Persönliches, Berufserfahrung, Ausbildung, Skills, Projekte).

### 2.5 Rahmenbedingungen (siehe auch „0_Grundidee.md")

Die App wird **auf GitHub (GitHub Pages) gehostet**. Daraus ergeben sich folgende
technische Anforderungen:

- **CI/CD mit GitHub Actions:** Bei jedem Push auf `main` wird automatisch
  `flutter build web` ausgeführt und das Ergebnis deployed (Workflow in
  `.github/workflows/deploy.yml`).
- **SPA-konformes Routing:** Damit Flutter Web auf GitHub Pages korrekt funktioniert,
  muss im Build-Schritt eine `404.html` erzeugt werden (Kopie von `index.html`).
- **`<base href>`:** Der vom CI/CD-Workflow gesetzte `--base-href`-Parameter
  stellt sicher, dass alle Asset-Pfade zum Repository-Namen passen.

Detaillierte Workflow-Beschreibung und Repository-Einstellungen sind in
„0_Grundidee.md" unter Punkt 3 nachzulesen.