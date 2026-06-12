// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get languageName => 'Español';

  @override
  String get onboardingTitle1 => 'Deja de perder\ntus enlaces.';

  @override
  String get onboardingTitle2 => 'Guarda desde\ncualquier app.';

  @override
  String get onboardingTitle3 => 'Tu bóveda,\na tu manera.';

  @override
  String get onboardingSub1 =>
      'Enlaces que te envías a ti mismo, capturas, pestañas perdidas para siempre. ¿Te suena?';

  @override
  String get onboardingSub2 =>
      'Comparte cualquier enlace a LinkVault en 2 toques. Funciona con YouTube, Instagram, TikTok y más.';

  @override
  String get onboardingSub3 =>
      'Organiza en colecciones. Filtra por no leídos o favoritos. Encuentra todo al instante.';

  @override
  String get skip => 'Omitir';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get getStarted => 'Comenzar';

  @override
  String get searchHint => 'Buscar enlaces...';

  @override
  String get emptyNoLinks => 'Aún no hay enlaces guardados';

  @override
  String get emptyNoMatch => 'Ningún enlace coincide con este filtro';

  @override
  String get emptyHint =>
      'Toca + para agregar un enlace, o comparte uno desde cualquier app';

  @override
  String get filterAll => 'Todos';

  @override
  String get filterUnread => 'No leídos';

  @override
  String get filterRead => 'Leídos';

  @override
  String get filterSaved => '♥ Favoritos';

  @override
  String get addLink => 'Agregar enlace';

  @override
  String get urlInvalid => 'Ingresa una dirección web válida (http/https)';

  @override
  String get paste => 'Pegar';

  @override
  String get collectionSection => 'COLECCIÓN';

  @override
  String get saveLink => 'Guardar enlace';

  @override
  String get savingLink => 'Guardando...';

  @override
  String linkSaved(String domain) {
    return 'Enlace guardado · $domain';
  }

  @override
  String get noCollection => 'Sin colección';

  @override
  String get collectionsTitle => 'Colecciones';

  @override
  String get rename => 'Renombrar';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteCollectionNote => 'Los enlaces se conservan sin colección';

  @override
  String linkCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count enlaces',
      one: '1 enlace',
    );
    return '$_temp0';
  }

  @override
  String get newCollection => 'Nueva colección';

  @override
  String get editCollection => 'Editar colección';

  @override
  String freeUsage(int used, int limit) {
    return 'Gratis: $used/$limit usadas';
  }

  @override
  String freeUsageLocked(int used, int limit) {
    return 'Gratis: $used/$limit usadas · Desbloquea más con Pro';
  }

  @override
  String get collectionNameHint => 'Nombre';

  @override
  String get collectionNameError => 'Ponle un nombre';

  @override
  String get iconSection => 'ICONO';

  @override
  String get createCollection => 'Crear colección';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get collectionNotFound => 'Colección no encontrada';

  @override
  String get noLinksYet => 'Aún no hay enlaces';

  @override
  String get startTyping => 'Empieza a escribir...';

  @override
  String noResults(String query) {
    return 'Sin resultados para \"$query\"';
  }

  @override
  String get deleteLinkTitle => '¿Eliminar enlace?';

  @override
  String get deleteLinkBody => 'Esta acción no se puede deshacer.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get readBadge => 'Leído';

  @override
  String get unreadBadge => 'No leído';

  @override
  String get savedBadge => '♥ Favorito';

  @override
  String get share => 'Compartir';

  @override
  String get favorite => 'Favorito';

  @override
  String get edit => 'Editar';

  @override
  String get open => 'Abrir';

  @override
  String get editLink => 'Editar enlace';

  @override
  String get titleHint => 'Título';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get upgradeToPro => 'Mejora a Pro';

  @override
  String get upgradeSub => 'Colecciones ilimitadas y más';

  @override
  String get sectionAppearance => 'APARIENCIA';

  @override
  String get theme => 'Tema';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Automático (sistema)';

  @override
  String get sectionData => 'DATOS';

  @override
  String get exportLinks => 'Exportar enlaces';

  @override
  String get importLinks => 'Importar enlaces';

  @override
  String get cloudBackup => 'Respaldo en la nube';

  @override
  String get sectionAbout => 'ACERCA DE';

  @override
  String get rateApp => 'Califica LinkVault';

  @override
  String get sendFeedback => 'Enviar comentarios';

  @override
  String get version => 'Versión';

  @override
  String get nothingToExport => 'Aún no hay nada que exportar';

  @override
  String get exportFailed => 'Falló la exportación';

  @override
  String get fileTooLarge => 'Archivo demasiado grande (máx 5 MB)';

  @override
  String get fileReadError => 'No se pudo leer el archivo';

  @override
  String importSuccess(int links, int collections) {
    return 'Importados $links enlaces, $collections colecciones';
  }

  @override
  String get importInvalid => 'No es un respaldo válido de LinkVault';

  @override
  String get importFailed => 'Falló la importación';

  @override
  String get openLinkError => 'No se pudo abrir el enlace';

  @override
  String get noEmailApp => 'No se encontró app de correo';

  @override
  String get paywallHeadline => 'Guardas mucho.\nNo pierdas nada.';

  @override
  String get paywallSub => 'Mejora a LinkVault Pro';

  @override
  String get featCollections => 'Colecciones ilimitadas';

  @override
  String get featCollectionsSub => 'Organiza sin límites';

  @override
  String get featCloud => 'Respaldo en la nube';

  @override
  String get featCloudSub => 'Tus enlaces, seguros para siempre';

  @override
  String get featNoAds => 'Sin anuncios, nunca';

  @override
  String get featNoAdsSub => 'Guarda sin distracciones';

  @override
  String get featSupport => 'Soporte prioritario';

  @override
  String get featSupportSub => 'Te cubrimos la espalda';

  @override
  String get monthly => 'MENSUAL';

  @override
  String get yearly => 'ANUAL';

  @override
  String get perMonth => 'por mes';

  @override
  String get perYear => 'por año';

  @override
  String get lifetime => 'DE POR VIDA';

  @override
  String get oneTimePayment => 'pago único';

  @override
  String get unlockPro => 'Desbloquear Pro';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get purchaseSuccess => '¡Bienvenido a Pro! 🎉';

  @override
  String get purchaseFailed => 'La compra falló. Inténtalo de nuevo.';

  @override
  String get restoreSuccess => 'Pro restaurado';

  @override
  String get restoreNothing => 'No se encontraron compras previas';

  @override
  String get purchasesUnavailable =>
      'Las compras no están disponibles ahora mismo';

  @override
  String get proActive => 'Ya eres miembro Pro';

  @override
  String get proActiveSub => 'Todas las funciones desbloqueadas';

  @override
  String get navLinks => 'Enlaces';

  @override
  String get navCollections => 'Colecciones';

  @override
  String get navSearch => 'Buscar';

  @override
  String get navSettings => 'Ajustes';
}
