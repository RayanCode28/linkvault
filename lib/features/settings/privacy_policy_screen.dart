import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../shared/l10n.dart';
import '../../shared/widgets/neon_bg.dart';

/// Full privacy policy shown in-app (Settings → Privacy policy).
///
/// The legal text lives here (keyed by language code) instead of the ARB files
/// to keep the localization catalog small; only the row/title label is in l10n.
/// Falls back to English for any locale we don't translate. The same wording
/// should be hosted at a public URL for the Google Play listing.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final policy = _policy[lang] ?? _policy['en']!;

    return NeonBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textSec),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            context.l10n.privacyPolicy,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Text(
                policy.updated,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 16),
              Text(
                policy.intro,
                style: const TextStyle(
                  color: AppColors.textSec,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              for (final section in policy.sections) ...[
                const SizedBox(height: 20),
                Text(
                  section.$1,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  section.$2,
                  style: const TextStyle(
                    color: AppColors.textSec,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// One localized policy: a header line, an intro paragraph, and titled sections.
class _Policy {
  final String updated;
  final String intro;
  final List<(String, String)> sections;
  const _Policy({required this.updated, required this.intro, required this.sections});
}

const _contactEmail = 'lunasoftapps@gmail.com';

const Map<String, _Policy> _policy = {
  'en': _Policy(
    updated: 'Last updated: 19 June 2026',
    intro:
        'LinkVault respects your privacy. This policy explains what data the app '
        'handles and why. LinkVault is developed by Lunasof Apps.',
    sections: [
      (
        'Data stored on your device',
        'Your saved links, collections, titles and read/favorite status are stored '
            'only on your device in a local database. This data never leaves your '
            'phone unless you turn on Cloud backup or export it yourself.',
      ),
      (
        'Link metadata',
        'When you save a link, LinkVault requests that web page to fetch its title, '
            'description and preview image. As with any web request, the destination '
            'website may see your IP address. We do not send your personal data to '
            'those sites beyond the standard request.',
      ),
      (
        'Cloud backup (Pro)',
        'If you use Cloud backup, you sign in with your Google account through '
            'Firebase Authentication. We store your email and account identifier to '
            'manage the backup, and a copy of your links is saved to Firebase Cloud '
            'Storage in your private account folder. Only you can access it. You can '
            'delete the backup or sign out at any time.',
      ),
      (
        'Purchases',
        'Pro subscriptions are processed by Google Play Billing and managed through '
            'RevenueCat. We receive your subscription status (active or expired) and a '
            'purchase identifier. We never receive or store your payment card details.',
      ),
      (
        'Advertising',
        'The free version shows ads through Google AdMob, which may collect your '
            'advertising identifier and limited usage data to serve and measure ads, '
            'as described in Google’s policies. The Pro version shows no ads.',
      ),
      (
        'Third-party services',
        'LinkVault relies on Google Firebase, Google Play, RevenueCat and Google '
            'AdMob. Their handling of data is governed by their own privacy policies.',
      ),
      (
        'Data retention and deletion',
        'Local data is removed when you uninstall the app or clear its storage. Cloud '
            'backups remain until you delete them from within the app or request '
            'deletion by email.',
      ),
      (
        'Children',
        'LinkVault is not directed to children under 13, and we do not knowingly '
            'collect data from them.',
      ),
      (
        'Your rights',
        'You can export, delete or restore your data at any time from Settings. To '
            'request deletion of any cloud data, contact us at the email below.',
      ),
      (
        'Changes',
        'We may update this policy. Material changes will be reflected here with a '
            'new date.',
      ),
      (
        'Contact',
        'Questions about this policy? Email $_contactEmail.',
      ),
    ],
  ),
  'es': _Policy(
    updated: 'Última actualización: 19 de junio de 2026',
    intro:
        'LinkVault respeta tu privacidad. Esta política explica qué datos maneja la '
        'app y por qué. LinkVault está desarrollada por Lunasof Apps.',
    sections: [
      (
        'Datos guardados en tu dispositivo',
        'Tus enlaces, colecciones, títulos y el estado de leído/favorito se guardan '
            'solo en tu dispositivo, en una base de datos local. Estos datos nunca '
            'salen de tu teléfono salvo que actives el Respaldo en la nube o los '
            'exportes tú mismo.',
      ),
      (
        'Metadatos de los enlaces',
        'Al guardar un enlace, LinkVault solicita esa página web para obtener su '
            'título, descripción e imagen de vista previa. Como en cualquier petición '
            'web, el sitio de destino puede ver tu dirección IP. No enviamos tus datos '
            'personales a esos sitios más allá de la petición estándar.',
      ),
      (
        'Respaldo en la nube (Pro)',
        'Si usas el Respaldo en la nube, inicias sesión con tu cuenta de Google a '
            'través de Firebase Authentication. Guardamos tu correo e identificador de '
            'cuenta para gestionar el respaldo, y una copia de tus enlaces se guarda en '
            'Firebase Cloud Storage en tu carpeta privada. Solo tú puedes acceder a '
            'ella. Puedes borrar el respaldo o cerrar sesión cuando quieras.',
      ),
      (
        'Compras',
        'Las suscripciones Pro se procesan con Google Play Billing y se gestionan a '
            'través de RevenueCat. Recibimos el estado de tu suscripción (activa o '
            'caducada) y un identificador de compra. Nunca recibimos ni guardamos los '
            'datos de tu tarjeta de pago.',
      ),
      (
        'Publicidad',
        'La versión gratuita muestra anuncios mediante Google AdMob, que puede '
            'recopilar tu identificador de publicidad y datos de uso limitados para '
            'mostrar y medir anuncios, según las políticas de Google. La versión Pro no '
            'muestra anuncios.',
      ),
      (
        'Servicios de terceros',
        'LinkVault utiliza Google Firebase, Google Play, RevenueCat y Google AdMob. '
            'El tratamiento de datos por su parte se rige por sus propias políticas de '
            'privacidad.',
      ),
      (
        'Conservación y eliminación de datos',
        'Los datos locales se eliminan al desinstalar la app o borrar su '
            'almacenamiento. Los respaldos en la nube se conservan hasta que los '
            'borras desde la app o solicitas su eliminación por correo.',
      ),
      (
        'Menores',
        'LinkVault no está dirigida a menores de 13 años y no recopilamos sus datos a '
            'sabiendas.',
      ),
      (
        'Tus derechos',
        'Puedes exportar, borrar o restaurar tus datos cuando quieras desde Ajustes. '
            'Para solicitar la eliminación de datos en la nube, escríbenos al correo de '
            'abajo.',
      ),
      (
        'Cambios',
        'Podemos actualizar esta política. Los cambios importantes se reflejarán aquí '
            'con una nueva fecha.',
      ),
      (
        'Contacto',
        '¿Dudas sobre esta política? Escribe a $_contactEmail.',
      ),
    ],
  ),
  'pt': _Policy(
    updated: 'Última atualização: 19 de junho de 2026',
    intro:
        'O LinkVault respeita a sua privacidade. Esta política explica quais dados o '
        'app utiliza e por quê. O LinkVault é desenvolvido pela Lunasof Apps.',
    sections: [
      (
        'Dados guardados no seu dispositivo',
        'Seus links, coleções, títulos e o estado de lido/favorito ficam apenas no '
            'seu dispositivo, em um banco de dados local. Esses dados nunca saem do seu '
            'telefone, a menos que você ative o Backup na nuvem ou os exporte.',
      ),
      (
        'Metadados dos links',
        'Ao salvar um link, o LinkVault solicita aquela página para obter título, '
            'descrição e imagem de pré-visualização. Como em qualquer requisição web, o '
            'site de destino pode ver o seu endereço IP. Não enviamos seus dados '
            'pessoais a esses sites além da requisição padrão.',
      ),
      (
        'Backup na nuvem (Pro)',
        'Se usar o Backup na nuvem, você entra com sua conta Google pelo Firebase '
            'Authentication. Guardamos seu e-mail e identificador de conta para '
            'gerenciar o backup, e uma cópia dos seus links é salva no Firebase Cloud '
            'Storage na sua pasta privada. Só você pode acessá-la. Você pode apagar o '
            'backup ou sair a qualquer momento.',
      ),
      (
        'Compras',
        'As assinaturas Pro são processadas pelo Google Play Billing e gerenciadas '
            'pela RevenueCat. Recebemos o estado da sua assinatura (ativa ou expirada) '
            'e um identificador de compra. Nunca recebemos nem guardamos os dados do '
            'seu cartão de pagamento.',
      ),
      (
        'Publicidade',
        'A versão gratuita exibe anúncios via Google AdMob, que pode coletar seu '
            'identificador de publicidade e dados de uso limitados para exibir e medir '
            'anúncios, conforme as políticas do Google. A versão Pro não exibe '
            'anúncios.',
      ),
      (
        'Serviços de terceiros',
        'O LinkVault usa Google Firebase, Google Play, RevenueCat e Google AdMob. O '
            'tratamento de dados por eles segue suas próprias políticas de privacidade.',
      ),
      (
        'Retenção e exclusão de dados',
        'Os dados locais são removidos ao desinstalar o app ou limpar seu '
            'armazenamento. Os backups na nuvem permanecem até você apagá-los pelo app '
            'ou solicitar a exclusão por e-mail.',
      ),
      (
        'Crianças',
        'O LinkVault não é dirigido a crianças menores de 13 anos e não coletamos '
            'dados delas intencionalmente.',
      ),
      (
        'Seus direitos',
        'Você pode exportar, apagar ou restaurar seus dados a qualquer momento em '
            'Configurações. Para solicitar a exclusão de dados na nuvem, fale conosco '
            'pelo e-mail abaixo.',
      ),
      (
        'Alterações',
        'Podemos atualizar esta política. Mudanças relevantes serão refletidas aqui '
            'com uma nova data.',
      ),
      (
        'Contato',
        'Dúvidas sobre esta política? Escreva para $_contactEmail.',
      ),
    ],
  ),
  'fr': _Policy(
    updated: 'Dernière mise à jour : 19 juin 2026',
    intro:
        'LinkVault respecte votre vie privée. Cette politique explique quelles '
        'données l’application traite et pourquoi. LinkVault est développée par '
        'Lunasof Apps.',
    sections: [
      (
        'Données stockées sur votre appareil',
        'Vos liens, collections, titres et l’état lu/favori sont stockés '
            'uniquement sur votre appareil, dans une base de données locale. Ces '
            'données ne quittent jamais votre téléphone, sauf si vous activez la '
            'sauvegarde dans le cloud ou les exportez vous-même.',
      ),
      (
        'Métadonnées des liens',
        'Lorsque vous enregistrez un lien, LinkVault interroge la page web pour en '
            'récupérer le titre, la description et l’image d’aperçu. Comme '
            'pour toute requête web, le site de destination peut voir votre adresse IP. '
            'Nous n’envoyons pas vos données personnelles à ces sites au-delà de '
            'la requête standard.',
      ),
      (
        'Sauvegarde dans le cloud (Pro)',
        'Si vous utilisez la sauvegarde dans le cloud, vous vous connectez avec votre '
            'compte Google via Firebase Authentication. Nous conservons votre e-mail et '
            'votre identifiant de compte pour gérer la sauvegarde, et une copie de vos '
            'liens est enregistrée dans Firebase Cloud Storage dans votre dossier '
            'privé. Vous seul pouvez y accéder. Vous pouvez supprimer la sauvegarde ou '
            'vous déconnecter à tout moment.',
      ),
      (
        'Achats',
        'Les abonnements Pro sont traités par Google Play Billing et gérés via '
            'RevenueCat. Nous recevons l’état de votre abonnement (actif ou '
            'expiré) et un identifiant d’achat. Nous ne recevons ni ne stockons '
            'jamais les données de votre carte de paiement.',
      ),
      (
        'Publicité',
        'La version gratuite affiche des publicités via Google AdMob, qui peut '
            'collecter votre identifiant publicitaire et des données d’usage '
            'limitées pour diffuser et mesurer les publicités, selon les politiques de '
            'Google. La version Pro n’affiche aucune publicité.',
      ),
      (
        'Services tiers',
        'LinkVault s’appuie sur Google Firebase, Google Play, RevenueCat et '
            'Google AdMob. Leur traitement des données est régi par leurs propres '
            'politiques de confidentialité.',
      ),
      (
        'Conservation et suppression des données',
        'Les données locales sont supprimées lorsque vous désinstallez '
            'l’application ou videz son stockage. Les sauvegardes cloud sont '
            'conservées jusqu’à ce que vous les supprimiez depuis '
            'l’application ou demandiez leur suppression par e-mail.',
      ),
      (
        'Enfants',
        'LinkVault ne s’adresse pas aux enfants de moins de 13 ans et nous ne '
            'collectons pas sciemment leurs données.',
      ),
      (
        'Vos droits',
        'Vous pouvez exporter, supprimer ou restaurer vos données à tout moment '
            'depuis les Réglages. Pour demander la suppression de données cloud, '
            'contactez-nous à l’e-mail ci-dessous.',
      ),
      (
        'Modifications',
        'Nous pouvons mettre à jour cette politique. Les changements importants y '
            'seront indiqués avec une nouvelle date.',
      ),
      (
        'Contact',
        'Des questions sur cette politique ? Écrivez à $_contactEmail.',
      ),
    ],
  ),
  'de': _Policy(
    updated: 'Zuletzt aktualisiert: 19. Juni 2026',
    intro:
        'LinkVault respektiert deine Privatsphäre. Diese Richtlinie erklärt, welche '
        'Daten die App verarbeitet und warum. LinkVault wird von Lunasof Apps '
        'entwickelt.',
    sections: [
      (
        'Auf deinem Gerät gespeicherte Daten',
        'Deine Links, Sammlungen, Titel und der Gelesen-/Favoriten-Status werden nur '
            'auf deinem Gerät in einer lokalen Datenbank gespeichert. Diese Daten '
            'verlassen dein Telefon nur, wenn du das Cloud-Backup aktivierst oder sie '
            'selbst exportierst.',
      ),
      (
        'Link-Metadaten',
        'Wenn du einen Link speicherst, ruft LinkVault die Webseite ab, um Titel, '
            'Beschreibung und Vorschaubild zu holen. Wie bei jeder Web-Anfrage kann die '
            'Zielwebseite deine IP-Adresse sehen. Wir senden deine persönlichen Daten '
            'über die Standardanfrage hinaus nicht an diese Seiten.',
      ),
      (
        'Cloud-Backup (Pro)',
        'Wenn du das Cloud-Backup nutzt, meldest du dich mit deinem Google-Konto über '
            'Firebase Authentication an. Wir speichern deine E-Mail und Konto-Kennung, '
            'um das Backup zu verwalten, und eine Kopie deiner Links wird in Firebase '
            'Cloud Storage in deinem privaten Ordner gespeichert. Nur du hast Zugriff '
            'darauf. Du kannst das Backup jederzeit löschen oder dich abmelden.',
      ),
      (
        'Käufe',
        'Pro-Abos werden über Google Play Billing abgewickelt und über RevenueCat '
            'verwaltet. Wir erhalten deinen Abo-Status (aktiv oder abgelaufen) und eine '
            'Kauf-Kennung. Wir erhalten und speichern niemals deine '
            'Zahlungskartendaten.',
      ),
      (
        'Werbung',
        'Die kostenlose Version zeigt Werbung über Google AdMob, das deine '
            'Werbe-Kennung und begrenzte Nutzungsdaten erfassen kann, um Werbung '
            'auszuliefern und zu messen, gemäß den Richtlinien von Google. Die '
            'Pro-Version zeigt keine Werbung.',
      ),
      (
        'Dienste von Drittanbietern',
        'LinkVault nutzt Google Firebase, Google Play, RevenueCat und Google AdMob. '
            'Deren Umgang mit Daten unterliegt ihren eigenen Datenschutzrichtlinien.',
      ),
      (
        'Aufbewahrung und Löschung von Daten',
        'Lokale Daten werden entfernt, wenn du die App deinstallierst oder ihren '
            'Speicher leerst. Cloud-Backups bleiben bestehen, bis du sie in der App '
            'löschst oder die Löschung per E-Mail anforderst.',
      ),
      (
        'Kinder',
        'LinkVault richtet sich nicht an Kinder unter 13 Jahren, und wir erfassen '
            'wissentlich keine Daten von ihnen.',
      ),
      (
        'Deine Rechte',
        'Du kannst deine Daten jederzeit in den Einstellungen exportieren, löschen '
            'oder wiederherstellen. Um die Löschung von Cloud-Daten anzufordern, '
            'kontaktiere uns unter der unten stehenden E-Mail.',
      ),
      (
        'Änderungen',
        'Wir können diese Richtlinie aktualisieren. Wesentliche Änderungen werden hier '
            'mit einem neuen Datum vermerkt.',
      ),
      (
        'Kontakt',
        'Fragen zu dieser Richtlinie? Schreib an $_contactEmail.',
      ),
    ],
  ),
};
