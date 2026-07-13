# Ausführungsplan

> Wer, wie, wann, wo und mit wem? Möglichst detaillierter Ausführungsplan.

## 1. Projekt-Setup (Phase 1)

### 1.1 Flutter-Projekt initialisieren
- [ ] Flutter Web-Plattform aktivieren: `flutter config --enable-web`
- [ ] Neues Flutter-Projekt anlegen: `flutter create .` (falls nicht bereits geschehen)
- [ ] Abhängigkeiten in `pubspec.yaml` definieren:
  - `yaml` (Daten aus `doc/ich/` parsen)
  - `provider` oder `riverpod` (State-Management)
  - `url_launcher` (Kontaktlinks / Social-Media-Buttons)
  - `flutter_lints` (Code-Qualität)
- [ ] Theme aus `theme/app_theme.dart` importieren und als App-Theme setzen

### 1.2 Datenschicht aufbauen
- [ ] Datenmodell in Dart definieren (z. B. `Lebenslauf`, `Station`, `Qualifikation`, etc.)
- [ ] Parser schreiben, der die YAML-/Markdown-Dateien aus `doc/ich/` einliest
- [ ] Daten in ein strukturiertes JSON- oder Dart-Objekt überführen
- [ ] Tests für das Parsen schreiben (siehe Abschnitt 6)

## 2. App-Entwicklung (Phase 2)

### 2.1 Grundgerüst der App
- [ ] `MaterialApp` mit dem Theme aus `theme/app_theme.dart` konfigurieren
- [ ] Theme-Switcher (Hell/Dunkel) einbauen:
  - Zustand über `Provider` oder `ChangeNotifier` verwalten
  - Umschalter z. B. in der AppBar oder in einem Drawer platzieren
  - Präferenz in `SharedPreferences` oder `Hive` speichern
- [ ] Responsive Layout sicherstellen (Desktop, Tablet, Mobil)

### 2.2 Seiten/Komponenten
- [ ] **Startseite / Header**: Name, Berufsbezeichnung, Kurzprofil
- [ ] **Berufserfahrung**: Zeitstrahl (`Timeline`) oder Karten (`Cards`)
- [ ] **Ausbildung**: Ähnliche Darstellung wie Berufserfahrung
- [ ] **Qualifikationen / Skills**: Tags, Balkendiagramm oder Icons
- [ ] **Projekte**: Galerie mit Beschreibungen und Links
- [ ] **Kontakt**: E-Mail, LinkedIn, GitHub etc. (mit `url_launcher`)
- [ ] **Footer**: Impressum / Letzte Aktualisierung

### 2.3 Navigation
- [ ] AppBar mit `TabBar` oder `NavigationRail` (responsive)
- [ ] Scroll-to-Top-Button bei langen Seiten
- [ ] Anker-Navigation (Hash-Links) für SPA-Freundlichkeit

## 3. CI/CD & Deployment (Phase 3)

### 3.1 GitHub Actions-Workflow
- [ ] `.github/workflows/deploy.yml` anlegen (siehe `3_Rahmenbedingungen.md` Abschnitt 3.2)
- [ ] `base href` dynamisch über `--base-href "/${{ github.event.repository.name }}/"` setzen
- [ ] 404.html für SPA-Routing erzeugen (Kopie von index.html)
- [ ] Workflow testen (Push auf `main` → automatischer Build + Deploy)

### 3.2 GitHub Pages konfigurieren
- [ ] *Settings → Pages → Source* auf **GitHub Actions** umstellen
- [ ] Optional: Eigene Domain (CNAME) einrichten

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