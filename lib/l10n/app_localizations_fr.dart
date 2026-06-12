// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get languageName => 'Français';

  @override
  String get onboardingTitle1 => 'Arrêtez de perdre\nvos liens.';

  @override
  String get onboardingTitle2 => 'Enregistrez depuis\nn\'importe quelle app.';

  @override
  String get onboardingTitle3 => 'Votre coffre,\nà votre façon.';

  @override
  String get onboardingSub1 =>
      'Liens envoyés à soi-même, captures d\'écran, onglets perdus à jamais. Ça vous parle ?';

  @override
  String get onboardingSub2 =>
      'Partagez n\'importe quel lien vers LinkVault en 2 gestes. Compatible YouTube, Instagram, TikTok et plus.';

  @override
  String get onboardingSub3 =>
      'Organisez en collections. Filtrez par non lus ou favoris. Retrouvez tout instantanément.';

  @override
  String get skip => 'Passer';

  @override
  String get continueLabel => 'Continuer';

  @override
  String get getStarted => 'Commencer';

  @override
  String get searchHint => 'Rechercher des liens...';

  @override
  String get emptyNoLinks => 'Aucun lien enregistré pour l\'instant';

  @override
  String get emptyNoMatch => 'Aucun lien ne correspond à ce filtre';

  @override
  String get emptyHint =>
      'Touchez + pour ajouter un lien, ou partagez-en un depuis n\'importe quelle app';

  @override
  String get filterAll => 'Tous';

  @override
  String get filterUnread => 'Non lus';

  @override
  String get filterRead => 'Lus';

  @override
  String get filterSaved => 'Favoris';

  @override
  String get addLink => 'Ajouter un lien';

  @override
  String get urlInvalid => 'Saisissez une adresse web valide (http/https)';

  @override
  String get paste => 'Coller';

  @override
  String get collectionSection => 'COLLECTION';

  @override
  String get saveLink => 'Enregistrer le lien';

  @override
  String get savingLink => 'Enregistrement...';

  @override
  String linkSaved(String domain) {
    return 'Lien enregistré · $domain';
  }

  @override
  String get noCollection => 'Sans collection';

  @override
  String get collectionsTitle => 'Collections';

  @override
  String get rename => 'Renommer';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteCollectionNote => 'Les liens sont conservés sans collection';

  @override
  String linkCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count liens',
      one: '1 lien',
    );
    return '$_temp0';
  }

  @override
  String get newCollection => 'Nouvelle collection';

  @override
  String get editCollection => 'Modifier la collection';

  @override
  String freeUsage(int used, int limit) {
    return 'Gratuit : $used/$limit utilisées';
  }

  @override
  String freeUsageLocked(int used, int limit) {
    return 'Gratuit : $used/$limit utilisées · Débloquez-en plus avec Pro';
  }

  @override
  String get collectionNameHint => 'Nom';

  @override
  String get collectionNameError => 'Donnez-lui un nom';

  @override
  String get iconSection => 'ICÔNE';

  @override
  String get createCollection => 'Créer la collection';

  @override
  String get saveChanges => 'Enregistrer';

  @override
  String get collectionNotFound => 'Collection introuvable';

  @override
  String get noLinksYet => 'Aucun lien pour l\'instant';

  @override
  String get uncategorized => 'Sans catégorie';

  @override
  String get collectionsEmptyTitle => 'Créez votre première collection';

  @override
  String get collectionsEmptyHint => 'Créez-en une pour organiser vos liens';

  @override
  String get startTyping => 'Commencez à écrire...';

  @override
  String noResults(String query) {
    return 'Aucun résultat pour \"$query\"';
  }

  @override
  String get deleteLinkTitle => 'Supprimer le lien ?';

  @override
  String get deleteLinkBody => 'Cette action est irréversible.';

  @override
  String get deleteLinkChoiceBody =>
      'Ce lien est dans une collection. Que voulez-vous faire ?';

  @override
  String get removeFromCollection => 'Retirer de la collection';

  @override
  String get deletePermanently => 'Supprimer définitivement';

  @override
  String get cancel => 'Annuler';

  @override
  String get readBadge => 'Lu';

  @override
  String get unreadBadge => 'Non lu';

  @override
  String get savedBadge => '♥ Favori';

  @override
  String get share => 'Partager';

  @override
  String get favorite => 'Favori';

  @override
  String get edit => 'Modifier';

  @override
  String get open => 'Ouvrir';

  @override
  String get editLink => 'Modifier le lien';

  @override
  String get titleHint => 'Titre';

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get upgradeToPro => 'Passez à Pro';

  @override
  String get upgradeSub => 'Collections illimitées et plus';

  @override
  String get sectionAppearance => 'APPARENCE';

  @override
  String get theme => 'Thème';

  @override
  String get themeDark => 'Sombre';

  @override
  String get language => 'Langue';

  @override
  String get languageSystem => 'Automatique (système)';

  @override
  String get sectionData => 'DONNÉES';

  @override
  String get exportLinks => 'Exporter les liens';

  @override
  String get importLinks => 'Importer des liens';

  @override
  String get cloudBackup => 'Sauvegarde cloud';

  @override
  String get sectionAbout => 'À PROPOS';

  @override
  String get rateApp => 'Noter LinkVault';

  @override
  String get sendFeedback => 'Envoyer un avis';

  @override
  String get version => 'Version';

  @override
  String get nothingToExport => 'Rien à exporter pour l\'instant';

  @override
  String get exportFailed => 'Échec de l\'exportation';

  @override
  String get fileTooLarge => 'Fichier trop volumineux (max 5 Mo)';

  @override
  String get fileReadError => 'Impossible de lire le fichier';

  @override
  String importSuccess(int links, int collections) {
    return '$links liens et $collections collections importés';
  }

  @override
  String get importInvalid => 'Ce n\'est pas une sauvegarde LinkVault valide';

  @override
  String get importFailed => 'Échec de l\'importation';

  @override
  String get openLinkError => 'Impossible d\'ouvrir le lien';

  @override
  String get noEmailApp => 'Aucune app de messagerie trouvée';

  @override
  String get paywallHeadline =>
      'Vous enregistrez beaucoup.\nN\'en perdez rien.';

  @override
  String get paywallSub => 'Passez à LinkVault Pro';

  @override
  String get featCollections => 'Collections illimitées';

  @override
  String get featCollectionsSub => 'Organisez sans limites';

  @override
  String get featCloud => 'Sauvegarde cloud';

  @override
  String get featCloudSub => 'Vos liens, en sécurité pour toujours';

  @override
  String get featNoAds => 'Aucune pub, jamais';

  @override
  String get featNoAdsSub => 'Enregistrez sans distraction';

  @override
  String get featSupport => 'Support prioritaire';

  @override
  String get featSupportSub => 'On s\'occupe de vous';

  @override
  String get monthly => 'MENSUEL';

  @override
  String get yearly => 'ANNUEL';

  @override
  String get perMonth => 'par mois';

  @override
  String get perYear => 'par an';

  @override
  String get lifetime => 'À VIE';

  @override
  String get oneTimePayment => 'paiement unique';

  @override
  String get unlockPro => 'Débloquer Pro';

  @override
  String get restorePurchases => 'Restaurer les achats';

  @override
  String get purchaseSuccess => 'Bienvenue dans Pro ! 🎉';

  @override
  String get purchaseFailed => 'L\'achat a échoué. Veuillez réessayer.';

  @override
  String get restoreSuccess => 'Pro restauré';

  @override
  String get restoreNothing => 'Aucun achat précédent trouvé';

  @override
  String get purchasesUnavailable =>
      'Les achats sont indisponibles pour le moment';

  @override
  String get proActive => 'Vous êtes membre Pro';

  @override
  String get proActiveSub => 'Toutes les fonctionnalités débloquées';

  @override
  String get navLinks => 'Liens';

  @override
  String get navCollections => 'Collections';

  @override
  String get navSearch => 'Recherche';

  @override
  String get navSettings => 'Réglages';
}
