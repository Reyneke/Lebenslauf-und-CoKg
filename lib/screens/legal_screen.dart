import 'package:flutter/material.dart';

/// Shows legal information: Imprint (Impressum) and Privacy Policy (Datenschutzerklärung).
class LegalScreen extends StatelessWidget {
  final bool showPrivacy;

  const LegalScreen({super.key, this.showPrivacy = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      initialIndex: showPrivacy ? 1 : 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rechtliches'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Impressum'),
              Tab(text: 'Datenschutz'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildImpressum(context, theme),
            _buildPrivacyPolicy(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildImpressum(BuildContext context, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Impressum', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Angaben gemäß § 5 TMG',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          _section(theme, 'Verantwortlicher', [
            'Matthias Struck',
            'Glacisweg 9',
            '13583 Berlin',
            'Deutschland',
          ]),
          const SizedBox(height: 16),
          _section(theme, 'Kontakt', [
            'E-Mail: MatthiasStruck@gmx.net',
            'Telefon: 030 3337311',
          ]),
          const SizedBox(height: 16),
          _section(theme, 'Haftungsausschluss', [
            'Die Inhalte dieser Seite wurden mit größter Sorgfalt erstellt. '
                'Für die Richtigkeit, Vollständigkeit und Aktualität der Inhalte '
                'kann jedoch keine Gewähr übernommen werden.',
            'Als Diensteanbieter bin ich gemäß § 7 Abs.1 TMG für eigene Inhalte '
                'auf dieser Seite nach den allgemeinen Gesetzen verantwortlich. '
                'Nach § 8 bis 10 TMG bin ich als Diensteanbieter jedoch nicht '
                'verpflichtet, übermittelte oder gespeicherte fremde Informationen '
                'zu überwachen oder nach Umständen zu forschen, die auf eine '
                'rechtswidrige Tätigkeit hinweisen.',
          ]),
          const SizedBox(height: 16),
          _section(theme, 'Externe Links', [
            'Diese Seite enthält Verknüpfungen zu externen Websites Dritter, '
                'auf deren Inhalte kein Einfluss besteht. Deshalb kann für diese '
                'fremden Inhalte keine Gewähr übernommen werden. Für die Inhalte '
                'der verlinkten Seiten ist stets der jeweilige Anbieter oder '
                'Betreiber der Seiten verantwortlich.',
          ]),
        ],
      ),
    );
  }

  Widget _buildPrivacyPolicy(BuildContext context, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Datenschutzerklärung', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Stand: Juli 2026',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          _section(theme, '1. Datenschutz auf einen Blick', [
            'Diese Webseite wird auf GitHub Pages gehostet und verarbeitet '
                'nur die technisch notwendigen Daten. Eine aktive Erhebung '
                'personenbezogener Daten findet nicht statt.',
          ]),
          const SizedBox(height: 16),

          _section(theme, '2. Verantwortlicher', [
            'Matthias Struck',
            'Glacisweg 9, 13583 Berlin',
            'E-Mail: MatthiasStruck@gmx.net',
          ]),
          const SizedBox(height: 16),

          _section(theme, '3. Welche Daten werden verarbeitet?', [
            '• Theme-Präferenz (Hell/Dunkel/System): Wird im localStorage '
                'Ihres Browsers gespeichert. Dies ist kein Cookie im rechtlichen '
                'Sinne, da localStorage keine automatische Übertragung an Server '
                'vornimmt.',
            '• Täglicher IT-Witz: Beim Aufruf der Seite wird eine Anfrage an '
                'icanhazdadjoke.com gesendet. Es werden keine personenbezogenen '
                'Daten übermittelt.',
            '• Web-Fonts (Poppins, Lato): Werden lokal von diesem Server '
                'geladen – keine Verbindung zu Google Fonts Servern.',
          ]),
          const SizedBox(height: 16),

          _section(theme, '4. Hosting', [
            'Diese Webseite wird über GitHub Pages bereitgestellt. '
                'Beim Aufruf der Seite überträgt Ihr Browser technische Daten '
                '(IP-Adresse, Browsertyp, Betriebssystem, Referrer-URL, '
                'aufgerufene Seite) an GitHub Inc., 88 Colin P Kelly Jr St, '
                'San Francisco, CA 94107, USA. GitHub verarbeitet diese Daten '
                'zum Zweck des Hostings und zur Bereitstellung der Seiteninhalte.',
            'Weitere Informationen: '
                'https://docs.github.com/de/site-policy/privacy-policies/',
          ]),
          const SizedBox(height: 16),

          _section(theme, '5. Ihre Rechte', [
            'Sie haben gemäß Art. 15–21 DSGVO folgende Rechte:',
            '• Recht auf Auskunft',
            '• Recht auf Berichtigung',
            '• Recht auf Löschung ("Recht auf Vergessenwerden")',
            '• Recht auf Einschränkung der Verarbeitung',
            '• Recht auf Datenübertragbarkeit',
            '• Widerspruchsrecht',
            '',
            'Da keine personenbezogenen Daten aktiv gespeichert werden, '
                'sind diese Rechte faktisch gegenstandslos – sie werden '
                'hiermit dennoch vollumfänglich gewährt.',
          ]),
          const SizedBox(height: 16),

          _section(theme, '6. Änderungen', [
            'Diese Datenschutzerklärung kann bei Bedarf aktualisiert werden. '
                'Der aktuelle Stand ist oben vermerkt.',
          ]),
        ],
      ),
    );
  }

  Widget _section(ThemeData theme, String title, List<String> lines) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        ...lines.map((line) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(line, style: theme.textTheme.bodyMedium),
            )),
      ],
    );
  }
}