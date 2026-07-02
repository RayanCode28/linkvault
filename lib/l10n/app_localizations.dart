import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt')
  ];

  /// No description provided for @languageName.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageName;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Stop losing\nyour links.'**
  String get onboardingTitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Save from\nany app.'**
  String get onboardingTitle2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Your vault,\nyour way.'**
  String get onboardingTitle3;

  /// No description provided for @onboardingSub1.
  ///
  /// In en, this message translates to:
  /// **'Links sent to yourself, screenshots, browser tabs lost forever. Sound familiar?'**
  String get onboardingSub1;

  /// No description provided for @onboardingSub2.
  ///
  /// In en, this message translates to:
  /// **'Share any link directly to LinkVault in 2 taps. Works with YouTube, Instagram, TikTok and more.'**
  String get onboardingSub2;

  /// No description provided for @onboardingSub3.
  ///
  /// In en, this message translates to:
  /// **'Organize into collections. Filter by unread or favorites. Find anything instantly.'**
  String get onboardingSub3;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @onboardingTitle4.
  ///
  /// In en, this message translates to:
  /// **'Unlock everything with Pro'**
  String get onboardingTitle4;

  /// No description provided for @onboardingSub4.
  ///
  /// In en, this message translates to:
  /// **'Unlimited collections, no ads and cloud backup. Upgrade whenever you like.'**
  String get onboardingSub4;

  /// No description provided for @continueFree.
  ///
  /// In en, this message translates to:
  /// **'Continue for free'**
  String get continueFree;

  /// No description provided for @tourSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get tourSkip;

  /// No description provided for @tourNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get tourNext;

  /// No description provided for @tourDone.
  ///
  /// In en, this message translates to:
  /// **'Got it!'**
  String get tourDone;

  /// No description provided for @tourAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Save a link'**
  String get tourAddTitle;

  /// No description provided for @tourAddBody.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add any link, or share one from another app.'**
  String get tourAddBody;

  /// No description provided for @tourSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Find anything'**
  String get tourSearchTitle;

  /// No description provided for @tourSearchBody.
  ///
  /// In en, this message translates to:
  /// **'Search your links by title, site or text.'**
  String get tourSearchBody;

  /// No description provided for @tourFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter fast'**
  String get tourFilterTitle;

  /// No description provided for @tourFilterBody.
  ///
  /// In en, this message translates to:
  /// **'Switch between All, Unread, Read and Favorites.'**
  String get tourFilterBody;

  /// No description provided for @tourCollectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Organize'**
  String get tourCollectionsTitle;

  /// No description provided for @tourCollectionsBody.
  ///
  /// In en, this message translates to:
  /// **'Group your links into collections from here.'**
  String get tourCollectionsBody;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search links...'**
  String get searchHint;

  /// No description provided for @emptyNoLinks.
  ///
  /// In en, this message translates to:
  /// **'No links saved yet'**
  String get emptyNoLinks;

  /// No description provided for @emptyNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No links match this filter'**
  String get emptyNoMatch;

  /// No description provided for @emptyHint.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add a link, or share one from any app'**
  String get emptyHint;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get filterUnread;

  /// No description provided for @filterRead.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get filterRead;

  /// No description provided for @filterSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get filterSaved;

  /// No description provided for @addLink.
  ///
  /// In en, this message translates to:
  /// **'Add link'**
  String get addLink;

  /// No description provided for @urlInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid web address (http/https)'**
  String get urlInvalid;

  /// No description provided for @paste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get paste;

  /// No description provided for @collectionSection.
  ///
  /// In en, this message translates to:
  /// **'COLLECTION'**
  String get collectionSection;

  /// No description provided for @saveLink.
  ///
  /// In en, this message translates to:
  /// **'Save link'**
  String get saveLink;

  /// No description provided for @savingLink.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get savingLink;

  /// No description provided for @linkSaved.
  ///
  /// In en, this message translates to:
  /// **'Link saved · {domain}'**
  String linkSaved(String domain);

  /// No description provided for @noCollection.
  ///
  /// In en, this message translates to:
  /// **'No collection'**
  String get noCollection;

  /// No description provided for @selectCollectionHint.
  ///
  /// In en, this message translates to:
  /// **'Choose a collection'**
  String get selectCollectionHint;

  /// No description provided for @collectionRequired.
  ///
  /// In en, this message translates to:
  /// **'Pick a collection to keep your links organized'**
  String get collectionRequired;

  /// No description provided for @collectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get collectionsTitle;

  /// No description provided for @myCollections.
  ///
  /// In en, this message translates to:
  /// **'My collections'**
  String get myCollections;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteCollectionNote.
  ///
  /// In en, this message translates to:
  /// **'Links inside are kept and unfiled'**
  String get deleteCollectionNote;

  /// No description provided for @linkCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 link} other{{count} links}}'**
  String linkCount(int count);

  /// No description provided for @newCollection.
  ///
  /// In en, this message translates to:
  /// **'New collection'**
  String get newCollection;

  /// No description provided for @editCollection.
  ///
  /// In en, this message translates to:
  /// **'Edit collection'**
  String get editCollection;

  /// No description provided for @freeUsage.
  ///
  /// In en, this message translates to:
  /// **'Free: {used}/{limit} used'**
  String freeUsage(int used, int limit);

  /// No description provided for @freeUsageLocked.
  ///
  /// In en, this message translates to:
  /// **'Free: {used}/{limit} used · Unlock more with Pro'**
  String freeUsageLocked(int used, int limit);

  /// No description provided for @collectionNameHint.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get collectionNameHint;

  /// No description provided for @collectionNameError.
  ///
  /// In en, this message translates to:
  /// **'Give it a name'**
  String get collectionNameError;

  /// No description provided for @iconSection.
  ///
  /// In en, this message translates to:
  /// **'ICON'**
  String get iconSection;

  /// No description provided for @createCollection.
  ///
  /// In en, this message translates to:
  /// **'Create collection'**
  String get createCollection;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @collectionNotFound.
  ///
  /// In en, this message translates to:
  /// **'Collection not found'**
  String get collectionNotFound;

  /// No description provided for @noLinksYet.
  ///
  /// In en, this message translates to:
  /// **'No links yet'**
  String get noLinksYet;

  /// No description provided for @uncategorized.
  ///
  /// In en, this message translates to:
  /// **'Uncategorized'**
  String get uncategorized;

  /// No description provided for @collectionsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your first collection'**
  String get collectionsEmptyTitle;

  /// No description provided for @collectionsEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Create one to organize your links'**
  String get collectionsEmptyHint;

  /// No description provided for @startTyping.
  ///
  /// In en, this message translates to:
  /// **'Start typing...'**
  String get startTyping;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results for \"{query}\"'**
  String noResults(String query);

  /// No description provided for @deleteLinkTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete link?'**
  String get deleteLinkTitle;

  /// No description provided for @deleteLinkBody.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get deleteLinkBody;

  /// No description provided for @deleteLinkChoiceBody.
  ///
  /// In en, this message translates to:
  /// **'This link is in a collection. What would you like to do?'**
  String get deleteLinkChoiceBody;

  /// No description provided for @removeFromCollection.
  ///
  /// In en, this message translates to:
  /// **'Remove from collection'**
  String get removeFromCollection;

  /// No description provided for @deletePermanently.
  ///
  /// In en, this message translates to:
  /// **'Delete permanently'**
  String get deletePermanently;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @readBadge.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get readBadge;

  /// No description provided for @unreadBadge.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get unreadBadge;

  /// No description provided for @savedBadge.
  ///
  /// In en, this message translates to:
  /// **'♥ Saved'**
  String get savedBadge;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @editLink.
  ///
  /// In en, this message translates to:
  /// **'Edit link'**
  String get editLink;

  /// No description provided for @titleHint.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleHint;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @upgradeToPro.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro'**
  String get upgradeToPro;

  /// No description provided for @upgradeSub.
  ///
  /// In en, this message translates to:
  /// **'Unlimited collections & more'**
  String get upgradeSub;

  /// No description provided for @sectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'APPEARANCE'**
  String get sectionAppearance;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'Automatic (system)'**
  String get languageSystem;

  /// No description provided for @sectionData.
  ///
  /// In en, this message translates to:
  /// **'DATA'**
  String get sectionData;

  /// No description provided for @exportLinks.
  ///
  /// In en, this message translates to:
  /// **'Export links'**
  String get exportLinks;

  /// No description provided for @importLinks.
  ///
  /// In en, this message translates to:
  /// **'Import links'**
  String get importLinks;

  /// No description provided for @cloudBackup.
  ///
  /// In en, this message translates to:
  /// **'Cloud backup'**
  String get cloudBackup;

  /// No description provided for @cloudBackupDesc.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google to back up your links to the cloud and restore them on any device.'**
  String get cloudBackupDesc;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @backupNow.
  ///
  /// In en, this message translates to:
  /// **'Back up now'**
  String get backupNow;

  /// No description provided for @restoreNow.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restoreNow;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @signOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get signOutConfirmTitle;

  /// No description provided for @signOutConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ll need to sign in again to back up or restore.'**
  String get signOutConfirmBody;

  /// No description provided for @backupComplete.
  ///
  /// In en, this message translates to:
  /// **'Backup complete'**
  String get backupComplete;

  /// No description provided for @backupFailed.
  ///
  /// In en, this message translates to:
  /// **'Backup failed. Please try again.'**
  String get backupFailed;

  /// No description provided for @restoreConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore backup?'**
  String get restoreConfirmTitle;

  /// No description provided for @restoreConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Your cloud backup will be merged into this device.'**
  String get restoreConfirmBody;

  /// No description provided for @noBackupFound.
  ///
  /// In en, this message translates to:
  /// **'No backup found'**
  String get noBackupFound;

  /// No description provided for @neverBackedUp.
  ///
  /// In en, this message translates to:
  /// **'No backups yet'**
  String get neverBackedUp;

  /// No description provided for @signInFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed'**
  String get signInFailed;

  /// No description provided for @lastBackupAt.
  ///
  /// In en, this message translates to:
  /// **'Last backup: {date}'**
  String lastBackupAt(String date);

  /// No description provided for @sectionAbout.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get sectionAbout;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate LinkVault'**
  String get rateApp;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get sendFeedback;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @nothingToExport.
  ///
  /// In en, this message translates to:
  /// **'Nothing to export yet'**
  String get nothingToExport;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed'**
  String get exportFailed;

  /// No description provided for @exportSaved.
  ///
  /// In en, this message translates to:
  /// **'Backup saved'**
  String get exportSaved;

  /// No description provided for @fileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'File too large (max 5 MB)'**
  String get fileTooLarge;

  /// No description provided for @fileReadError.
  ///
  /// In en, this message translates to:
  /// **'Could not read file'**
  String get fileReadError;

  /// No description provided for @importSuccess.
  ///
  /// In en, this message translates to:
  /// **'Imported {links} links, {collections} collections'**
  String importSuccess(int links, int collections);

  /// No description provided for @importInvalid.
  ///
  /// In en, this message translates to:
  /// **'Not a valid LinkVault backup'**
  String get importInvalid;

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed'**
  String get importFailed;

  /// No description provided for @openLinkError.
  ///
  /// In en, this message translates to:
  /// **'Could not open link'**
  String get openLinkError;

  /// No description provided for @noEmailApp.
  ///
  /// In en, this message translates to:
  /// **'No email app found'**
  String get noEmailApp;

  /// No description provided for @paywallHeadline.
  ///
  /// In en, this message translates to:
  /// **'You save a lot.\nNever lose any of it.'**
  String get paywallHeadline;

  /// No description provided for @paywallSub.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to LinkVault Pro'**
  String get paywallSub;

  /// No description provided for @featCollections.
  ///
  /// In en, this message translates to:
  /// **'Unlimited collections'**
  String get featCollections;

  /// No description provided for @featCollectionsSub.
  ///
  /// In en, this message translates to:
  /// **'Organize without limits'**
  String get featCollectionsSub;

  /// No description provided for @featCloud.
  ///
  /// In en, this message translates to:
  /// **'Cloud backup'**
  String get featCloud;

  /// No description provided for @featCloudSub.
  ///
  /// In en, this message translates to:
  /// **'Your links, safe forever'**
  String get featCloudSub;

  /// No description provided for @featNoAds.
  ///
  /// In en, this message translates to:
  /// **'No ads, ever'**
  String get featNoAds;

  /// No description provided for @featNoAdsSub.
  ///
  /// In en, this message translates to:
  /// **'Pure, distraction-free saving'**
  String get featNoAdsSub;

  /// No description provided for @featSupport.
  ///
  /// In en, this message translates to:
  /// **'Priority support'**
  String get featSupport;

  /// No description provided for @featSupportSub.
  ///
  /// In en, this message translates to:
  /// **'We\'ve got your back'**
  String get featSupportSub;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'MONTHLY'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'YEARLY'**
  String get yearly;

  /// No description provided for @perMonth.
  ///
  /// In en, this message translates to:
  /// **'per month'**
  String get perMonth;

  /// No description provided for @perYear.
  ///
  /// In en, this message translates to:
  /// **'per year'**
  String get perYear;

  /// No description provided for @lifetime.
  ///
  /// In en, this message translates to:
  /// **'LIFETIME'**
  String get lifetime;

  /// No description provided for @oneTimePayment.
  ///
  /// In en, this message translates to:
  /// **'one-time payment'**
  String get oneTimePayment;

  /// No description provided for @unlockPro.
  ///
  /// In en, this message translates to:
  /// **'Unlock Pro'**
  String get unlockPro;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get restorePurchases;

  /// No description provided for @manageSubscription.
  ///
  /// In en, this message translates to:
  /// **'Manage subscription'**
  String get manageSubscription;

  /// No description provided for @purchaseSuccess.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Pro! 🎉'**
  String get purchaseSuccess;

  /// No description provided for @purchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed. Please try again.'**
  String get purchaseFailed;

  /// No description provided for @restoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Pro restored'**
  String get restoreSuccess;

  /// No description provided for @restoreNothing.
  ///
  /// In en, this message translates to:
  /// **'No previous purchases found'**
  String get restoreNothing;

  /// No description provided for @purchasesUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Purchases are unavailable right now'**
  String get purchasesUnavailable;

  /// No description provided for @proActive.
  ///
  /// In en, this message translates to:
  /// **'You\'re a Pro member'**
  String get proActive;

  /// No description provided for @proActiveSub.
  ///
  /// In en, this message translates to:
  /// **'All features unlocked'**
  String get proActiveSub;

  /// No description provided for @navLinks.
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get navLinks;

  /// No description provided for @navCollections.
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get navCollections;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'fr', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
