# Ausführungsplan

> Wer, wie, wann, wo und mit wem? Möglichst detaillierter Ausführungsplan.

## 1. Projekt-Setup (Phase 1)

### 1.1 Flutter-Projekt initialisieren
- [x] Flutter Web-Plattform aktivieren: `flutter config --enable-web`
- [x] Neues Flutter-Projekt anlegen: `flutter create . --project-name=lebenslauf_und_cokg --platforms=web`
- [x] Abhängigkeiten in `pubspec.yaml` definieren:
  - `google_fonts` – Schriftarten (kompatibel mit Theme)
  - `provider` – State-Management
  - `yaml` – YAML-Parsing für Daten aus `doc/ich/`
  - `url_launcher` – Kontaktlinks
  - `shared_preferences` – Theme-Präferenz speichern
  - `json_annotation` / `json_serializable` / `build_runner` – JSON-Code-Generierung
  - `intl` – Datumsformatierung
  - `flutter_lints` – Code-Qualität
- [x] Theme aus `theme/app_theme.dart` importieren und als App-Theme in `main.dart` setzen
- [x] Provider eingerichtet: `ThemeProvider` (Theme-Switcher mit Persistenz), `CvProvider` (Daten-Lader)
- [x] UI-Screens: `HomeScreen` mit AppBar, Theme-Umschalter, Personen-Header, Skills & Stationen
- [x] Tests: 4 Widget-/Unit-Tests laufen erfolgreich

### 1.2 Datenschicht aufbauen
- [x] Datenmodell in Dart definiert: `CvData`, `Person`, `CvEntry`, `Skill` in `lib/models/cv_data.dart`
- [x] Python-Extraktions-Skript (`scripts/extract_data.py`) erstellt:
  - Extrahiert Text aus PDF via PyMuPDF
  - Parst Abschnitte (Berufserfahrung, Ausbildung, Skills, Zertifikate)
  - Schreibt `scripts/raw_data.json`
- [x] Python-Transformations-Skript (`scripts/transform_data.py`) erstellt:
  - Liest `raw_data.json`, normalisiert und schreibt `data/cv.json`
- [x] Extraktion erfolgreich getestet: 25 Einträge, 80 Skills aus PDF extrahiert
- [x] Daten in `data/cv.json` überführt (wird von Flutter-APP geladen)

## 2. App-Entwicklung (Phase 2)

### 2.1 Grundgerüst der App
- [x] `MaterialApp` mit dem Theme aus `theme/app_theme.dart` konfiguriert
- [x] Theme-Switcher (Hell/Dunkel/System) eingebaut:
  - Zustand über `ThemeProvider` (`ChangeNotifier`) verwaltet
  - Umschalter in der AppBar platziert (3 Modi: System → Hell → Dunkel)
  - Präferenz in `SharedPreferences` gespeichert
- [x] Responsive Layout: ConstrainedBox (maxWidth 960px) auf breiten Bildschirmen

### 2.2 Seiten/Komponenten
- [x] **Startseite / Header**: `CvHeader` – Name, Profilbild, Berufsbezeichnung
- [x] **Berufserfahrung**: `CareerTimeline` – Zeitstrahl mit Punkten, Karten, Datumsangabe
- [x] **Ausbildung & Weiterbildung**: `EducationSection` – Karten mit School-Icon, Detail-Dialog
- [x] **Qualifikationen / Skills**: `SkillsSection` – Kategorisiert mit Fortschrittsbalken (1–5)
- [x] **IT-Joke des Tages**: `JokeCard` – Lädt täglich wechselnden Witz via JokeAPI/icanhazdadjoke
- [x] **Kontakt**: `ContactSection` – E-Mail, Telefon, GitHub, Adresse mit `url_launcher`
- [x] **Footer**: `CvFooter` – Impressum, Erstellungsinfo, letzte Aktualisierung

### 2.3 Navigation
- [x] AppBar mit Theme-Umschalter
- [x] Scroll-to-Top-Button (erscheint bei >400px Scroll)
- [ ] Anker-Navigation (Hash-Links) für SPA-Freundlichkeit (Phase 3/4)

## 3. CI/CD & Deployment (Phase 3)

### 3.1 GitHub Actions-Workflow
- [x] `.github/workflows/deploy.yml` angelegt (basierend auf `3_Rahmenbedingungen.md` Abschnitt 3.2)
  - Nutzt `subosito/flutter-action` für Flutter-Setup
  - Build mit `--base-href "/${{ github.event.repository.name }}/"`
  - 404.html für SPA-Routing wird automatisch erzeugt
  - Verwendet `actions/deploy-pages@v4` (kein separater gh-pages-Branch nötig)
- [x] `base href` dynamisch über `--base-href "/${{ github.event.repository.name }}/"` gesetzt
- [x] 404.html wird im Workflow per `cp build/web/index.html build/web/404.html` erzeugt
- [ ] Workflow testen (Push auf `main` → automatischer Build + Deploy) – **nach erstem Push prüfen**

### 3.2 GitHub Pages konfigurieren
- [ ] *Settings → Pages → Source* auf **GitHub Actions** umstellen
  - Nach dem ersten Push auf `main` muss in den Repository-Settings umgestellt werden
  - Dazu: GitHub → Repository → Settings → Pages → Source → "GitHub Actions" auswählen
- [ ] Optional: Eigene Domain (CNAME) einrichten

### 3.3 Web-Frontend optimiert
- [x] `web/index.html` aktualisiert:
  - Bessere Meta-Tags (SEO, Open Graph)
  - Korrekter Titel: "Lebenslauf und Co. KG – Matthias Struck"
  - Beschreibung und Keywords
- [x] `web/manifest.json` aktualisiert:
  - App-Name: "Lebenslauf und Co. KG"
  - Theme-Farbe: Purple (#7B1FA2) passend zum App-Theme

## 4. Qualitätssicherung (Phase 4)

### 4.1 Automatisierte Tests
- [ ] Unit-Tests für Daten-Parser (`test/data_parser_test.dart`)
- [ ] Widget-Tests für Kernkomponenten (`test/widget_test.dart`)
- [ ] Integrationstests (optional, `integration_test/`)

### 4.2 Manuelle Tests
- [ ] Build lokal testen: `flutter build web`
- [ ] Responsive Design auf verschiedenen Bildschirmgrößen prüfen
- [ ] Theme-Switcher-Funktionalität testen
- [ ] SPA-Routing testen (Browser-Reload auf Unterseite)

## 5. Wartung & Weiterentwicklung

### 5.1 Datenpflege
- [ ] Bei Änderungen im Lebenslauf nur die Dateien in `doc/ich/` aktualisieren
- [ ] Nach Push auf `main` aktualisiert sich die Seite automatisch

### 5.2 Mögliche Erweiterungen
- [ ] PDF-Export-Funktion (z. B. über `pdf`-Paket)
- [ ] Mehrsprachigkeit (z. B. `flutter_localizations` + `intl`)
- [ ] Blog-/Artikel-Sektion
- [ ] Besucherzähler / Analytics (z. B. Plausible, um datenschutzkonform zu bleiben)

## 6. Zeitplan & Verantwortlichkeiten

| Phase | Aufgabe | Verantwortlich | Geschätzter Aufwand | Deadline |
|-------|---------|----------------|---------------------|----------|
| 1     | Projekt-Setup & Datenschicht | — | 2–3 Tage | — |
| 2     | App-Entwicklung | — | 5–7 Tage | — |
| 3     | CI/CD & Deployment | — | 1 Tag | — |
| 4     | Qualitätssicherung | — | 1–2 Tage | — |

> **Hinweis:** Die genauen Deadlines und Verantwortlichkeiten sind noch zu ergänzen (siehe Fragezeichen in der Überschrift).