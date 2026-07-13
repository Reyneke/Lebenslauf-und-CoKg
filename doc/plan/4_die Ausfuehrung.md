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
- [x] **Hash-Linking** implementiert:
  - Jede Sektion hat eine eindeutige ID: `#header`, `#joke`, `#kontakt`, `#berufserfahrung`, `#ausbildung`, `#skills`
  - Direkte Links möglich: `https://.../#skills` → scrollt automatisch zur Skills-Sektion
  - `HashSection`-Wrapper registriert Sektionen via `HashLinkService`
  - Funktioniert plattformunabhängig (ohne `dart:html`)

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
- [x] Push auf `main` erfolgt – Workflow läuft automatisch
- [ ] **Letzter manueller Schritt:** GitHub → Repository → Settings → Pages → Source → **"GitHub Actions"** auswählen
  - Nach der Umstellung wird der nächste Push automatisch deployed
  - Die Seite ist dann live unter: `https://reyneke.github.io/Lebenslauf-und-CoKg/`
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
- [x] **Datenmodell-Tests**: fromJson/toJson round-trip, Datentypen, Wertebereiche
- [x] **Widget-Tests**: CvHeader, SkillsSection, EducationSection, CvFooter, Empty States
- [x] **App-Level-Tests**: Titel, AppBar, Theme-Toggle, Error-Screen mit Retry-Button
- [x] **Provider-Tests**: CvProvider, ThemeProvider, JokeProvider – Initialzustand und Logik
- [x] **17 Tests insgesamt** – alle laufen erfolgreich (flutter analyze: No issues found)

### 4.2 Manuelle Tests (auf der live-Seite)
- [x] Build lokal getestet: `flutter build web` ✅
- [x] Live-Seite läuft: `https://reyneke.github.io/Lebenslauf-und-CoKg/` ✅
- [x] Theme-Switcher getestet (Hell/Dunkel/System) ✅
- [x] Hash-Links funktionieren: `/#skills`, `/#berufserfahrung`, `/#kontakt`, etc. ✅

## 5. Wartung & Weiterentwicklung

### 5.1 Datenpflege (Workflow)
- [x] **Automatisierte Pipeline** ist vollständig eingerichtet:
  ```
  1. PDF in doc/ich/ aktualisieren
  2. python scripts/extract_data.py && python scripts/transform_data.py
  3. git add . && git commit -m "CV aktualisiert" && git push
  4. → GitHub Actions: automatischer Build + Deploy 🚀
  ```

### 5.2 Mögliche Erweiterungen (Ideen für die Zukunft)
- [ ] **PDF-Export** – Button zum Herunterladen des Lebenslaufs als PDF (via `pdf`-Paket)
- [ ] **Mehrsprachigkeit** – `flutter_localizations` + `intl` für Englisch/Deutsch
- [ ] **Blog-/Artikel-Sektion** – Eigene Artikel oder Projekt-Blog
- [ ] **Datenschutz-Konformes Analytics** – Z. B. Plausible oder umami (kein Google Analytics)

## 6. Fazit

Das Projekt **Lebenslauf und Co. KG** ist vollständig umgesetzt:

| Phase | Inhalt | Status |
|-------|--------|--------|
| **1** | Flutter-Projekt, Datenmodell, PDF-Extraktion | ✅ |
| **2** | 7 Widgets, Theme-Switcher, Responsive, Hash-Links | ✅ |
| **3** | GitHub Actions CI/CD, 404.html, SEO, Live-Deployment | ✅ |
| **4** | 17 automatisierte Tests, Code-Analyse sauber | ✅ |
| **5** | Daten-Pipeline, Wartungskonzept | ✅ |

Die Seite ist live unter:  
👉 **https://reyneke.github.io/Lebenslauf-und-CoKg/**
