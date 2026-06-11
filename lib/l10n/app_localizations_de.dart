// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get languageName => 'Deutsch';

  @override
  String get onboardingTitle1 => 'Verliere nie wieder\ndeine Links.';

  @override
  String get onboardingTitle2 => 'Speichern aus\njeder App.';

  @override
  String get onboardingTitle3 => 'Dein Tresor,\ndeine Regeln.';

  @override
  String get onboardingSub1 =>
      'Links an dich selbst, Screenshots, für immer verlorene Tabs. Kommt dir bekannt vor?';

  @override
  String get onboardingSub2 =>
      'Teile jeden Link mit 2 Tipps direkt an LinkVault. Funktioniert mit YouTube, Instagram, TikTok und mehr.';

  @override
  String get onboardingSub3 =>
      'Organisiere in Sammlungen. Filtere nach Ungelesen oder Favoriten. Finde alles sofort.';

  @override
  String get skip => 'Überspringen';

  @override
  String get continueLabel => 'Weiter';

  @override
  String get getStarted => 'Loslegen';

  @override
  String get searchHint => 'Links suchen...';

  @override
  String get emptyNoLinks => 'Noch keine Links gespeichert';

  @override
  String get emptyNoMatch => 'Keine Links entsprechen diesem Filter';

  @override
  String get emptyHint =>
      'Tippe auf +, um einen Link hinzuzufügen, oder teile einen aus einer beliebigen App';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterUnread => 'Ungelesen';

  @override
  String get filterRead => 'Gelesen';

  @override
  String get filterSaved => '♥ Favoriten';

  @override
  String get addLink => 'Link hinzufügen';

  @override
  String get urlInvalid => 'Gib eine gültige Webadresse ein (http/https)';

  @override
  String get paste => 'Einfügen';

  @override
  String get collectionSection => 'SAMMLUNG';

  @override
  String get saveLink => 'Link speichern';

  @override
  String get savingLink => 'Speichern...';

  @override
  String linkSaved(String domain) {
    return 'Link gespeichert · $domain';
  }

  @override
  String get noCollection => 'Keine Sammlung';

  @override
  String get collectionsTitle => 'Sammlungen';

  @override
  String get rename => 'Umbenennen';

  @override
  String get delete => 'Löschen';

  @override
  String get deleteCollectionNote =>
      'Enthaltene Links bleiben erhalten, ohne Sammlung';

  @override
  String linkCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Links',
      one: '1 Link',
    );
    return '$_temp0';
  }

  @override
  String get newCollection => 'Neue Sammlung';

  @override
  String get editCollection => 'Sammlung bearbeiten';

  @override
  String freeUsage(int used, int limit) {
    return 'Gratis: $used/$limit belegt';
  }

  @override
  String freeUsageLocked(int used, int limit) {
    return 'Gratis: $used/$limit belegt · Mehr mit Pro freischalten';
  }

  @override
  String get collectionNameHint => 'Name';

  @override
  String get collectionNameError => 'Gib ihr einen Namen';

  @override
  String get iconSection => 'SYMBOL';

  @override
  String get createCollection => 'Sammlung erstellen';

  @override
  String get saveChanges => 'Änderungen speichern';

  @override
  String get collectionNotFound => 'Sammlung nicht gefunden';

  @override
  String get noLinksYet => 'Noch keine Links';

  @override
  String get startTyping => 'Tippe etwas ein...';

  @override
  String noResults(String query) {
    return 'Keine Ergebnisse für \"$query\"';
  }

  @override
  String get deleteLinkTitle => 'Link löschen?';

  @override
  String get deleteLinkBody => 'Das kann nicht rückgängig gemacht werden.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get readBadge => 'Gelesen';

  @override
  String get unreadBadge => 'Ungelesen';

  @override
  String get savedBadge => '♥ Favorit';

  @override
  String get share => 'Teilen';

  @override
  String get favorite => 'Favorit';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get open => 'Öffnen';

  @override
  String get editLink => 'Link bearbeiten';

  @override
  String get titleHint => 'Titel';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get upgradeToPro => 'Auf Pro upgraden';

  @override
  String get upgradeSub => 'Unbegrenzte Sammlungen & mehr';

  @override
  String get sectionAppearance => 'DARSTELLUNG';

  @override
  String get theme => 'Design';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get language => 'Sprache';

  @override
  String get languageSystem => 'Automatisch (System)';

  @override
  String get sectionData => 'DATEN';

  @override
  String get exportLinks => 'Links exportieren';

  @override
  String get importLinks => 'Links importieren';

  @override
  String get cloudBackup => 'Cloud-Backup';

  @override
  String get sectionAbout => 'ÜBER';

  @override
  String get rateApp => 'LinkVault bewerten';

  @override
  String get sendFeedback => 'Feedback senden';

  @override
  String get version => 'Version';

  @override
  String get nothingToExport => 'Noch nichts zu exportieren';

  @override
  String get exportFailed => 'Export fehlgeschlagen';

  @override
  String get fileTooLarge => 'Datei zu groß (max. 5 MB)';

  @override
  String get fileReadError => 'Datei konnte nicht gelesen werden';

  @override
  String importSuccess(int links, int collections) {
    return '$links Links und $collections Sammlungen importiert';
  }

  @override
  String get importInvalid => 'Kein gültiges LinkVault-Backup';

  @override
  String get importFailed => 'Import fehlgeschlagen';

  @override
  String get openLinkError => 'Link konnte nicht geöffnet werden';

  @override
  String get noEmailApp => 'Keine E-Mail-App gefunden';

  @override
  String get paywallHeadline => 'Du speicherst viel.\nVerliere nichts davon.';

  @override
  String get paywallSub => 'Upgrade auf LinkVault Pro';

  @override
  String get featCollections => 'Unbegrenzte Sammlungen';

  @override
  String get featCollectionsSub => 'Organisiere ohne Limits';

  @override
  String get featCloud => 'Cloud-Backup';

  @override
  String get featCloudSub => 'Deine Links, für immer sicher';

  @override
  String get featNoAds => 'Nie Werbung';

  @override
  String get featNoAdsSub => 'Speichern ohne Ablenkung';

  @override
  String get featSupport => 'Priorisierter Support';

  @override
  String get featSupportSub => 'Wir sind für dich da';

  @override
  String get monthly => 'MONATLICH';

  @override
  String get yearly => 'JÄHRLICH';

  @override
  String get perMonth => 'pro Monat';

  @override
  String get perYear => 'pro Jahr';

  @override
  String get startFreeTrial => 'Gratis testen';

  @override
  String get trialNote =>
      '3 Tage gratis testen · Jederzeit kündbar · Käufe wiederherstellen';

  @override
  String get navLinks => 'Links';

  @override
  String get navCollections => 'Sammlungen';

  @override
  String get navSearch => 'Suche';

  @override
  String get navSettings => 'Einstellungen';
}
