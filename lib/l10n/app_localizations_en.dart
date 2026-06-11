// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get languageName => 'English';

  @override
  String get onboardingTitle1 => 'Stop losing\nyour links.';

  @override
  String get onboardingTitle2 => 'Save from\nany app.';

  @override
  String get onboardingTitle3 => 'Your vault,\nyour way.';

  @override
  String get onboardingSub1 =>
      'Links sent to yourself, screenshots, browser tabs lost forever. Sound familiar?';

  @override
  String get onboardingSub2 =>
      'Share any link directly to LinkVault in 2 taps. Works with YouTube, Instagram, TikTok and more.';

  @override
  String get onboardingSub3 =>
      'Organize into collections. Filter by unread or favorites. Find anything instantly.';

  @override
  String get skip => 'Skip';

  @override
  String get continueLabel => 'Continue';

  @override
  String get getStarted => 'Get Started';

  @override
  String get searchHint => 'Search links...';

  @override
  String get emptyNoLinks => 'No links saved yet';

  @override
  String get emptyNoMatch => 'No links match this filter';

  @override
  String get emptyHint => 'Tap + to add a link, or share one from any app';

  @override
  String get filterAll => 'All';

  @override
  String get filterUnread => 'Unread';

  @override
  String get filterRead => 'Read';

  @override
  String get filterSaved => '♥ Saved';

  @override
  String get addLink => 'Add link';

  @override
  String get urlInvalid => 'Enter a valid web address (http/https)';

  @override
  String get paste => 'Paste';

  @override
  String get collectionSection => 'COLLECTION';

  @override
  String get saveLink => 'Save link';

  @override
  String get savingLink => 'Saving...';

  @override
  String linkSaved(String domain) {
    return 'Link saved · $domain';
  }

  @override
  String get noCollection => 'No collection';

  @override
  String get collectionsTitle => 'Collections';

  @override
  String get rename => 'Rename';

  @override
  String get delete => 'Delete';

  @override
  String get deleteCollectionNote => 'Links inside are kept and unfiled';

  @override
  String linkCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count links',
      one: '1 link',
    );
    return '$_temp0';
  }

  @override
  String get newCollection => 'New collection';

  @override
  String get editCollection => 'Edit collection';

  @override
  String freeUsage(int used, int limit) {
    return 'Free: $used/$limit used';
  }

  @override
  String freeUsageLocked(int used, int limit) {
    return 'Free: $used/$limit used · Unlock more with Pro';
  }

  @override
  String get collectionNameHint => 'Name';

  @override
  String get collectionNameError => 'Give it a name';

  @override
  String get iconSection => 'ICON';

  @override
  String get createCollection => 'Create collection';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get collectionNotFound => 'Collection not found';

  @override
  String get noLinksYet => 'No links yet';

  @override
  String get startTyping => 'Start typing...';

  @override
  String noResults(String query) {
    return 'No results for \"$query\"';
  }

  @override
  String get deleteLinkTitle => 'Delete link?';

  @override
  String get deleteLinkBody => 'This cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get readBadge => 'Read';

  @override
  String get unreadBadge => 'Unread';

  @override
  String get savedBadge => '♥ Saved';

  @override
  String get share => 'Share';

  @override
  String get favorite => 'Favorite';

  @override
  String get edit => 'Edit';

  @override
  String get open => 'Open';

  @override
  String get editLink => 'Edit link';

  @override
  String get titleHint => 'Title';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get upgradeToPro => 'Upgrade to Pro';

  @override
  String get upgradeSub => 'Unlimited collections & more';

  @override
  String get sectionAppearance => 'APPEARANCE';

  @override
  String get theme => 'Theme';

  @override
  String get themeDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'Automatic (system)';

  @override
  String get sectionData => 'DATA';

  @override
  String get exportLinks => 'Export links';

  @override
  String get importLinks => 'Import links';

  @override
  String get cloudBackup => 'Cloud backup';

  @override
  String get sectionAbout => 'ABOUT';

  @override
  String get rateApp => 'Rate LinkVault';

  @override
  String get sendFeedback => 'Send feedback';

  @override
  String get version => 'Version';

  @override
  String get nothingToExport => 'Nothing to export yet';

  @override
  String get exportFailed => 'Export failed';

  @override
  String get fileTooLarge => 'File too large (max 5 MB)';

  @override
  String get fileReadError => 'Could not read file';

  @override
  String importSuccess(int links, int collections) {
    return 'Imported $links links, $collections collections';
  }

  @override
  String get importInvalid => 'Not a valid LinkVault backup';

  @override
  String get importFailed => 'Import failed';

  @override
  String get openLinkError => 'Could not open link';

  @override
  String get noEmailApp => 'No email app found';

  @override
  String get paywallHeadline => 'You save a lot.\nNever lose any of it.';

  @override
  String get paywallSub => 'Upgrade to LinkVault Pro';

  @override
  String get featCollections => 'Unlimited collections';

  @override
  String get featCollectionsSub => 'Organize without limits';

  @override
  String get featCloud => 'Cloud backup';

  @override
  String get featCloudSub => 'Your links, safe forever';

  @override
  String get featNoAds => 'No ads, ever';

  @override
  String get featNoAdsSub => 'Pure, distraction-free saving';

  @override
  String get featSupport => 'Priority support';

  @override
  String get featSupportSub => 'We\'ve got your back';

  @override
  String get monthly => 'MONTHLY';

  @override
  String get yearly => 'YEARLY';

  @override
  String get perMonth => 'per month';

  @override
  String get perYear => 'per year';

  @override
  String get startFreeTrial => 'Start Free Trial';

  @override
  String get trialNote =>
      '3-day free trial · Cancel anytime · Restore purchases';

  @override
  String get navLinks => 'Links';

  @override
  String get navCollections => 'Collections';

  @override
  String get navSearch => 'Search';

  @override
  String get navSettings => 'Settings';
}
