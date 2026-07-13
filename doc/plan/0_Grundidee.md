# Grundidee

Da mein Lebenslauf immer länger wird und, seien wir ehrlich, ich es leid bin, ihn stets und ständig mühselig zu ändern, wenn sich etwas Interessantes ergibt, wäre es sinnvoll, diesen in eine Webseite umzusetzen und auf GitHub zu hosten. Als Framework für die Webapplikation soll dabei **Flutter** dienen.

## 1. Die Daten

Die Daten liegen unter `doc/ich/` und müssen eingelesen und dann in ein passendes Format gebracht werden (z. B. JSON oder ein strukturiertes Datenmodell in Dart).

## 2. Die App

Die App soll als webfähiges Flutter-Projekt meinen aktuellen CV darstellen. Hierbei ist die Formatvorlage einzubauen, welche im Ordner `theme/` liegt (`theme/app_theme.dart`). Ein Themeswitcher ist dabei von Vorteil.

## 3. Rahmenbedingungen

Die Webseite soll auf GitHub (GitHub Pages) gehostet werden. Dazu wird **GitHub Actions** empfohlen – ein automatischer CI/CD-Workflow erzeugt bei jedem Push auf `main` einen neuen Build und veröffentlicht ihn.

### 3.1 Flutter-Projekt vorbereiten

- Web-Plattform aktivieren: `flutter config --enable-web`
- Flutter Web-Build testen: `flutter build web`
- **GitHub Pages-Subpfad konfigurieren** (wichtig, falls die Seite unter `https://<user>.github.io/<repo>/` erreichbar sein soll):
  ```yaml
  # In web/index.html – den `<base href="/">`-Tag anpassen:
  # Statisch:  <base href="/<repo-name>/">
  # Dynamisch: <base href="$FLUTTER_BASE_HREF">
  ```
  Besser: Das `base href` im CI/CD-Workflow über Umgebungsvariable setzen (siehe 3.2).

### 3.2 GitHub Actions-Workflow (empfohlen)

`.github/workflows/deploy.yml` anlegen:

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [main]

permissions:
  contents: read
  pages: write
  id-token: write

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          channel: stable

      - name: Build Flutter Web
        run: |
          flutter pub get
          flutter build web --base-href "/${{ github.event.repository.name }}/"

      - name: Setup Pages
        uses: actions/configure-pages@v5

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: build/web

      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

> **Hinweis:** Der Workflow nutzt die standardisierte `actions/deploy-pages`-Action, die direkt mit den *Settings → Pages*-Einstellungen zusammenarbeitet (Quelle: GitHub Actions, kein separater `gh-pages`-Branch nötig).

### 3.3 Repository-Einstellungen

- *Settings → Pages → Source* auf **GitHub Actions** umstellen (dadurch wird der o. g. Workflow automatisch ausgeführt).
- Optional: Eigenen Domain-Namen konfigurieren (CNAME-Eintrag im DNS + Eintrag in den Pages-Einstellungen).

### 3.4 404-Seite für SPA-Routing

Da Flutter Web eine Single-Page-Application ist, müssen alle Pfadanfragen auf `index.html` umgeleitet werden. Dazu in `build/web/` eine `404.html` ablegen – oder über den Workflow automatisch erzeugen lassen:

```bash
cp build/web/index.html build/web/404.html
```

(Dieser Schritt kann als zusätzlicher `run`-Step im Workflow vor dem Upload ergänzt werden.)

### 3.5 Manuelle Alternative (nicht empfohlen)

Falls dennoch manuell veröffentlicht werden soll:

```bash
flutter build web --base-href "/<repo-name>/"
# Danach build/web/ in den gh-pages-Branch kopieren und pushen
```

> **Fazit:** GitHub Actions ist die sauberste und wartungsärmste Lösung – einmal eingerichtet, aktualisiert sich die Seite automatisch bei jedem Push.
