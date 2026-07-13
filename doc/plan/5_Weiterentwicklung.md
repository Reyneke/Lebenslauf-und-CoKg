# Weiterentwicklung & Optimierungspotenzial

> Konkrete Vorschläge für Erweiterungen, Verbesserungen und offene Fragen, die über den aktuellen MVP-Status hinausgehen.

## 1. Blog-/Artikel-Sektion

### 1.1 Zielsetzung
Eigene Artikel oder ein Projekt-Blog direkt auf der Seite – z. B. um über Projekte, Erfahrungen oder technische Themen zu schreiben.

### 1.2 Mögliche Implementierungen

| Ansatz | Vorteile | Nachteile |
|--------|----------|-----------|
| **Statische Markdown-Dateien** – Artikel liegen als `.md` in `doc/blog/`, werden zur Build-Zeit eingelesen und als HTML gerendert | Einfach, versionierbar, kein Backend nötig | Kein dynamisches CMS, manuelles Erstellen der Dateien |
| **GitHub Issues / Discussions als Blog** – API nutzen um Issues mit Label `blog` als Artikel zu laden | Kein zusätzliches Hosting, Github-Ökosystem | Abhängig von GitHub-Verfügbarkeit, API-Rate-Limits |
| **Headless CMS (Strapi, TinaCMS, Decap CMS)** – Flutter löst Artikel via REST/GraphQL ab | Komfortables Redigieren, Rich-Text-Editor | Zusätzlicher Hosting-Aufwand, Overkill für kleine Seite |
| **Eigener statischer Generator (Jekyll / Hugo)** – Blog als Subdomain oder Unterordner | Ausgereiftes Blog-System, SEO-optimiert | Zwei getrennte Systeme, erhöhte Wartung |

### 1.3 Empfehlung (MVP)
- [ ] **Starten mit Markdown-Dateien in `doc/blog/`** – analog zur bestehenden Daten-Pipeline
- [ ] Einfaches Parsing: Metadaten (Titel, Datum, Tags) via YAML-Frontmatter, Inhalt als Markdown
- [ ] Flutter-seitig: `flutter_markdown`-Paket einbinden (bereits im Flutter-Ökosystem etabliert)
- [ ] Artikel-Übersichtsseite (Karten-Layout) + Detailseite mit Markdown-Rendering
- [ ] Optional: RSS-Feed generieren (`xml`-Paket, oder statische Datei) – wichtig für SEO und Leser

### 1.4 Datenmodell (Vorschlag)
```dart
@JsonSerializable()
class BlogPost {
  final String slug;        // z. B. "flutter-web-deployment"
  final String title;
  final DateTime date;
  final String? description; // Teaser für Übersicht
  final List<String> tags;
  final String content;      // Markdown-Rohinhalt
  final bool published;
}
```

## 2. Datenschutz-Konformes Analytics

### 2.1 Anforderung
Kein Google Analytics (DSGVO-Problematik, Tracking ohne Einwilligung). Stattdessen eine **datenschutzfreundliche, self-hosted** Lösung.

### 2.2 Geeignete Alternativen

| Tool | Hosting | Besonderheiten |
|------|---------|----------------|
| **Plausible** | Self-hosted (Docker) oder Cloud | Cookie-frei, Open Source, Fokus auf Privatsphäre |
| **Umami** | Self-hosted (Docker, Node.js) | Leichtgewichtig, kein Cookie-Banner nötig |
| **Fathom** | Self-hosted oder Cloud | Ähnlich wie Plausible, aber kostenpflichtig |
| **GoatCounter** | Self-hosted | Open Source, minimales Tracking, kein JS nötig (Pixel) |

### 2.3 Implementierung (Plausible/Umami)

- [ ] **Self-Hosting prüfen**: Eigenen Server oder z. B. Railway / Fly.io (kostenloser Tier möglich)
- [ ] **Tracking-Skript einbinden** (nur in Produktion, nicht lokal):
  ```html
  <!-- In web/index.html vor </head> -->
  <script defer data-domain="reyneke.github.io" src="https://analytics.example.com/js/script.js"></script>
  ```
- [ ] **Umgebungsabhängig einbinden** – nur auf `main`-Deployment aktiv schalten (nicht im Dev-Modus)
- [ ] **Kein Cookie-Banner nötig** bei Plausible/Umami, da keine personenbezogenen Daten gespeichert werden (IP-Anonymisierung, kein Cross-Site-Tracking)

### 2.4 Alternativ: Server-Log-Analyse (noch datenschutzfreundlicher)
- [ ] **GoAccess** oder **Matomo (On-Premise, ohne Cookies)** analysieren GitHub-Pages-Logs
- [ ] Kein JavaScript-Tracking nötig – nur Server-Logs auswerten
- [ ] Nachteil: GitHub Pages bietet keine einfache Log-Einsicht; Workaround über CDN-Logs (Cloudflare) oder eigene Middleware

## 3. Rechtliche Fragen (DSGVO / Impressum)

### 3.1 Aktueller Status
Die Seite enthält bereits:
- [x] **Impressum** im `CvFooter` (Name, Kontaktdaten)
- [x] **Kein Google Analytics** (keine externen Tracker)
- [x] **Keine Cookies** (Theme-Präferenz wird in `localStorage` gespeichert – kein Cookie im rechtlichen Sinne)

### 3.2 Noch zu prüfen / umzusetzen

- [ ] **Datenschutzerklärung (Privacy Policy)** erstellen – auch wenn keine aktive Datenerhebung stattfindet (§ 13 TMV / Art. 13 DSGVO):
  - Welche Daten werden verarbeitet? (Theme-Präferenz im localStorage, ggf. Joke-API-Aufrufe)
  - Werden externen Dienste genutzt? (icanhazdadjoke.com – reiner Lese-Zugriff, keine Datenübermittlung)
  - Welche Rechte haben Nutzer? (Auskunft, Löschung, etc. – auch wenn technisch nichts gespeichert wird)
  - Haftungsausschluss für externe Links
- [ ] **Impressum prüfen lassen** – folgende Pflichtangaben sind erforderlich:
  - Name (vollständig) ✅
  - Anschrift (ladungsfähig) ✅ (Adresse in `cv.json` vorhanden)
  - Kontaktdaten (E-Mail, Telefon) ✅ (in `ContactSection`)
  - Vertretungsberechtigte (bei Unternehmen) – bei natürlicher Person entbehrlich
  - Umsatzsteuer-ID (falls vorhanden) – optional
- [ ] **Cookie-Hinweis**: Aktuell nicht nötig, aber falls Analytics (auch Plausible/Umami) implementiert wird → prüfen, ob ein Hinweis benötigt wird (bei Plausible/Umami meist nicht, da keine Cookies gesetzt werden)
- [ ] **Fonts / externe Ressourcen**: `google_fonts` lädt Schriftarten von Google-Servern – das überträgt die IP an Google. Lösung:
  - **Fonts lokal einbetten** statt von Google-Servern laden (setze `google_fonts` auf `usesGoogleFonts: false` und hoste die .ttf/.otf-Dateien selbst)
  - Oder: Hinweis in der Datenschutzerklärung aufnehmen

### 3.3 Empfohlenes Vorgehen

1. **Datenschutzerklärung** als separate Seite (oder im Footer verlinkt) anlegen
   - Inhalt: Welche Daten, Zweck, Rechtsgrundlage, Speicherdauer, Rechte
   - Vorlage: [e-recht24.de DSGVO-Muster](https://www.e-recht24.de/artikel/datenschutz/9140-impressum-datenschutzgenerator.html) oder ähnliche vertrauenswürdige Quelle
2. **Impressum finalisieren**: Adresse aus CV-Daten in Footer klar sichtbar machen, ggf. um fehlende Angaben ergänzen
3. **Font-Strategie überprüfen**: Google-Fonts lokal hosten (z. B. Dateien in `assets/fonts/` und im Theme referenzieren)
4. **Rechtliche Prüfung**: Im Zweifel einen Anwalt für IT-Recht konsultieren – diese Dokumentation ersetzt keine Rechtsberatung

## 4. Zertifikate & Zeugnisse

### 4.1 Ausgangslage
In den PDF-Dokumenten `Matthias Struck - Zertifikat (komprimiert)(1).pdf` und als Teil des Lebenslaufs in `Lebenslauf-MatthiasStruck_21052026_bq.pdf` sind Zertifikate und Zeugnisse enthalten. Es gibt zwei Kernfragen:
- **Wie einbinden?** – Ohne die Seite zu überladen oder die Optik zu stören
- **Notwendigkeit?** – Sind sie auf der Webseite überhaupt erforderlich?

### 4.2 Notwendigkeit – Abwägung

| Pro | Contra |
|-----|--------|
| Erhöht Glaubwürdigkeit und Transparenz bei Bewerbungen | Kann überladen wirken |
| Ermöglicht interessierten Besuchern (Recruitern) eine schnelle Validierung | Enthält ggf. sensible Daten (Noten, persönliche Bewertungen) |
| Präsentiert Weiterbildungsengagement anschaulich | PDF-Scanns sind optisch oft nicht ansprechend |

**Fazit**: Für eine CV-Seite, die primär als digitale Visitenkarte dient, sind Zertifikate **nicht zwingend erforderlich** – der Lebenslauf in strukturierter Form vermittelt die wesentlichen Informationen. Sie sind jedoch ein **klares Plus** für tiefgehend interessierte Besucher.

### 4.3 Implementierungsvorschläge (optisch unaufdringlich)

| Ansatz | Beschreibung | Aufwand |
|--------|-------------|---------|
| **Link-Liste (minimal)** | In der `EducationSection`/Footer ein versteckter Abschnitt "Zertifikate anzeigen" (Accordion/Collapsible) | Gering |
| **Download-Buttons** | Jeder Zertifikat-Eintrag (`CvEntry.type == "certificate"`) erhält einen "PDF anzeigen"-Button | Mittel |
| **Lightbox/Galerie** | Klick auf Zertifikat öffnet eine vergrößerte Ansicht (Overlay) – kein Verlassen der Seite | Mittel |
| **Separate "Zertifikate"-Seite** | Eigenes Tab oder Route (z. B. `/#zertifikate`) – nur auf Anforderung sichtbar | Höher |

### 4.4 Empfohlene Implementierung

- [ ] **Bestehendes Datenmodell nutzen**: Im `CvEntry`-Modell ist bereits ein `file`-Feld vorhanden (`lib/models/cv_data.dart`, Zeile 54) – dies für Zertifikat-PDFs verwenden
- [ ] **Collapsible-Sektion** unterhalb der Ausbildung:
  ```dart
  ExpansionTile(
    title: const Text('Zertifikate & Zeugnisse'),
    children: certificates.map((cert) => ListTile(
      leading: const Icon(Icons.verified),
      title: Text(cert.title),
      subtitle: cert.issuer != null ? Text(cert.issuer!) : null,
      trailing: const Icon(Icons.download),
      onTap: () => _openPdf(cert.file),
    )).toList(),
  )
  ```
  - Standardmäßig **eingeklappt** – kein visuelles Rauschen
  - Nur bei Bedarf aufklappbar
  - PDF-Download oder -Ansicht über `url_launcher` (bereits als Dependency vorhanden)
- [ ] **PDF-Hosting**: PDFs in `assets/certificates/` ablegen oder via GitHub-Raw-Links einbinden
- [ ] **Alternative: Lightbox-Funktion** – PDF im Browser anzeigen (Flutter Web unterstützt `iframe` oder `dart:html`/ `universal_html`)

## 5. Weitere Optimierungsvorschläge

### 5.1 Performance

- [ ] **Lazy Loading** für CV-Daten: Bereits vorhanden (`CvProvider.loadCvData()` asynchron)
- [ ] **Caching** des Joke-API-Aufrufs prüfen – aktuell nur localStorage; ggf. Service Worker einbinden
- [ ] **Bildoptimierung** – Profilbild (`person.photo`) in WebP/Avif konvertieren, bei Bedarf responsive

### 5.2 SEO & Auffindbarkeit

- [ ] **Structured Data (JSON-LD)** einbinden – Schema.org `Person`-Profil für Google/Verticals:
  ```json
  {
    "@context": "https://schema.org",
    "@type": "Person",
    "name": "Matthias Struck",
    "jobTitle": "...",
    "email": "...",
    ...
  }
  ```
- [ ] **Sitemap.xml** generieren – besonders wichtig, sobald Blog-Artikel hinzukommen
- [ ] **Meta-Beschreibungen** pro Bereich/Seite dynamisieren

### 5.3 Code-Qualität

- [ ] **Provider auf Riverpod / BLoC migrieren** (bei Bedarf) – aktuelles Provider-basiertes Setup ist für die Größe aber völlig ausreichend
- [ ] **Testabdeckung ausbauen**: Aktuell 17 Tests – Ziel >30 für erweiterte Funktionalität
- [ ] **Error Handling** in der Daten-Pipeline: Was passiert, wenn PDF-Extraktion fehlschlägt? Fallback-Mechanismus für `cv.json`

## 6. Priorisierung (Roadmap-Vorschlag)

| Priorität | Maßnahme | Geschätzter Aufwand | Abhängigkeiten |
|-----------|----------|---------------------|----------------|
| 🔴 **Hoch** | Datenschutzerklärung + Impressum finalisieren | 1–2 Tage | Rechtliche Prüfung |
| 🔴 **Hoch** | Google-Fonts lokal hosten | ½ Tag | – |
| 🟡 **Mittel** | Zertifikate (Collapsible + Datenmodell) | 1–2 Tage | PDFs in Assets |
| 🟡 **Mittel** | Blog/Artikel (statisches Markdown) | 3–5 Tage | `flutter_markdown` |
| 🟢 **Niedrig** | Analytics (Plausible/Umami) | 2–3 Tage + Server | Datenschutzerklärung |
| 🟢 **Niedrig** | SEO (JSON-LD, Sitemap) | 1–2 Tage | – |

---

> **Hinweis:** Dieses Dokument ersetzt keine Rechtsberatung. Die rechtlichen Einschätzungen basieren auf dem Kenntnisstand zum Zeitpunkt der Erstellung und sollten vor der Umsetzung von einem Fachanwalt für IT-Recht geprüft werden.