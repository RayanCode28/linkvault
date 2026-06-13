// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get languageName => 'Português';

  @override
  String get onboardingTitle1 => 'Pare de perder\nseus links.';

  @override
  String get onboardingTitle2 => 'Salve de\nqualquer app.';

  @override
  String get onboardingTitle3 => 'Seu cofre,\ndo seu jeito.';

  @override
  String get onboardingSub1 =>
      'Links enviados para si mesmo, capturas de tela, abas perdidas para sempre. Soa familiar?';

  @override
  String get onboardingSub2 =>
      'Compartilhe qualquer link com o LinkVault em 2 toques. Funciona com YouTube, Instagram, TikTok e mais.';

  @override
  String get onboardingSub3 =>
      'Organize em coleções. Filtre por não lidos ou favoritos. Encontre tudo na hora.';

  @override
  String get skip => 'Pular';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get getStarted => 'Começar';

  @override
  String get onboardingTitle4 => 'Desbloqueie tudo com o Pro';

  @override
  String get onboardingSub4 =>
      'Coleções ilimitadas, sem anúncios e backup na nuvem. Faça upgrade quando quiser.';

  @override
  String get continueFree => 'Continuar grátis';

  @override
  String get tourSkip => 'Pular';

  @override
  String get tourNext => 'Próximo';

  @override
  String get tourDone => 'Entendi!';

  @override
  String get tourAddTitle => 'Salve um link';

  @override
  String get tourAddBody =>
      'Toque em + para adicionar qualquer link, ou compartilhe de outro app.';

  @override
  String get tourSearchTitle => 'Encontre tudo';

  @override
  String get tourSearchBody => 'Busque seus links por título, site ou texto.';

  @override
  String get tourFilterTitle => 'Filtre rápido';

  @override
  String get tourFilterBody =>
      'Alterne entre Todos, Não lidos, Lidos e Favoritos.';

  @override
  String get tourCollectionsTitle => 'Organize';

  @override
  String get tourCollectionsBody => 'Agrupe seus links em coleções aqui.';

  @override
  String get searchHint => 'Buscar links...';

  @override
  String get emptyNoLinks => 'Nenhum link salvo ainda';

  @override
  String get emptyNoMatch => 'Nenhum link corresponde a este filtro';

  @override
  String get emptyHint =>
      'Toque em + para adicionar um link, ou compartilhe de qualquer app';

  @override
  String get filterAll => 'Todos';

  @override
  String get filterUnread => 'Não lidos';

  @override
  String get filterRead => 'Lidos';

  @override
  String get filterSaved => 'Favoritos';

  @override
  String get addLink => 'Adicionar link';

  @override
  String get urlInvalid => 'Insira um endereço web válido (http/https)';

  @override
  String get paste => 'Colar';

  @override
  String get collectionSection => 'COLEÇÃO';

  @override
  String get saveLink => 'Salvar link';

  @override
  String get savingLink => 'Salvando...';

  @override
  String linkSaved(String domain) {
    return 'Link salvo · $domain';
  }

  @override
  String get noCollection => 'Sem coleção';

  @override
  String get selectCollectionHint => 'Escolha uma coleção';

  @override
  String get collectionRequired =>
      'Escolha uma coleção para manter seus links organizados';

  @override
  String get collectionsTitle => 'Coleções';

  @override
  String get myCollections => 'Minhas coleções';

  @override
  String get rename => 'Renomear';

  @override
  String get delete => 'Excluir';

  @override
  String get deleteCollectionNote => 'Os links são mantidos sem coleção';

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
  String get newCollection => 'Nova coleção';

  @override
  String get editCollection => 'Editar coleção';

  @override
  String freeUsage(int used, int limit) {
    return 'Grátis: $used/$limit usadas';
  }

  @override
  String freeUsageLocked(int used, int limit) {
    return 'Grátis: $used/$limit usadas · Desbloqueie mais com o Pro';
  }

  @override
  String get collectionNameHint => 'Nome';

  @override
  String get collectionNameError => 'Dê um nome';

  @override
  String get iconSection => 'ÍCONE';

  @override
  String get createCollection => 'Criar coleção';

  @override
  String get saveChanges => 'Salvar alterações';

  @override
  String get collectionNotFound => 'Coleção não encontrada';

  @override
  String get noLinksYet => 'Nenhum link ainda';

  @override
  String get uncategorized => 'Sem categoria';

  @override
  String get collectionsEmptyTitle => 'Crie sua primeira coleção';

  @override
  String get collectionsEmptyHint => 'Crie uma para organizar seus links';

  @override
  String get startTyping => 'Comece a digitar...';

  @override
  String noResults(String query) {
    return 'Sem resultados para \"$query\"';
  }

  @override
  String get deleteLinkTitle => 'Excluir link?';

  @override
  String get deleteLinkBody => 'Isso não pode ser desfeito.';

  @override
  String get deleteLinkChoiceBody =>
      'Este link está em uma coleção. O que deseja fazer?';

  @override
  String get removeFromCollection => 'Remover da coleção';

  @override
  String get deletePermanently => 'Excluir definitivamente';

  @override
  String get cancel => 'Cancelar';

  @override
  String get readBadge => 'Lido';

  @override
  String get unreadBadge => 'Não lido';

  @override
  String get savedBadge => '♥ Favorito';

  @override
  String get share => 'Compartilhar';

  @override
  String get favorite => 'Favorito';

  @override
  String get edit => 'Editar';

  @override
  String get open => 'Abrir';

  @override
  String get editLink => 'Editar link';

  @override
  String get titleHint => 'Título';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get upgradeToPro => 'Mude para o Pro';

  @override
  String get upgradeSub => 'Coleções ilimitadas e mais';

  @override
  String get sectionAppearance => 'APARÊNCIA';

  @override
  String get theme => 'Tema';

  @override
  String get themeDark => 'Escuro';

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Automático (sistema)';

  @override
  String get sectionData => 'DADOS';

  @override
  String get exportLinks => 'Exportar links';

  @override
  String get importLinks => 'Importar links';

  @override
  String get cloudBackup => 'Backup na nuvem';

  @override
  String get sectionAbout => 'SOBRE';

  @override
  String get rateApp => 'Avalie o LinkVault';

  @override
  String get sendFeedback => 'Enviar feedback';

  @override
  String get version => 'Versão';

  @override
  String get nothingToExport => 'Nada para exportar ainda';

  @override
  String get exportFailed => 'Falha na exportação';

  @override
  String get exportSaved => 'Backup salvo';

  @override
  String get fileTooLarge => 'Arquivo muito grande (máx 5 MB)';

  @override
  String get fileReadError => 'Não foi possível ler o arquivo';

  @override
  String importSuccess(int links, int collections) {
    return 'Importados $links links, $collections coleções';
  }

  @override
  String get importInvalid => 'Não é um backup válido do LinkVault';

  @override
  String get importFailed => 'Falha na importação';

  @override
  String get openLinkError => 'Não foi possível abrir o link';

  @override
  String get noEmailApp => 'Nenhum app de e-mail encontrado';

  @override
  String get paywallHeadline => 'Você salva muito.\nNão perca nada.';

  @override
  String get paywallSub => 'Mude para o LinkVault Pro';

  @override
  String get featCollections => 'Coleções ilimitadas';

  @override
  String get featCollectionsSub => 'Organize sem limites';

  @override
  String get featCloud => 'Backup na nuvem';

  @override
  String get featCloudSub => 'Seus links, seguros para sempre';

  @override
  String get featNoAds => 'Sem anúncios, nunca';

  @override
  String get featNoAdsSub => 'Salve sem distrações';

  @override
  String get featSupport => 'Suporte prioritário';

  @override
  String get featSupportSub => 'Estamos com você';

  @override
  String get monthly => 'MENSAL';

  @override
  String get yearly => 'ANUAL';

  @override
  String get perMonth => 'por mês';

  @override
  String get perYear => 'por ano';

  @override
  String get lifetime => 'VITALÍCIO';

  @override
  String get oneTimePayment => 'pagamento único';

  @override
  String get unlockPro => 'Desbloquear o Pro';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get purchaseSuccess => 'Bem-vindo ao Pro! 🎉';

  @override
  String get purchaseFailed => 'A compra falhou. Tente novamente.';

  @override
  String get restoreSuccess => 'Pro restaurado';

  @override
  String get restoreNothing => 'Nenhuma compra anterior encontrada';

  @override
  String get purchasesUnavailable =>
      'As compras não estão disponíveis no momento';

  @override
  String get proActive => 'Você já é membro Pro';

  @override
  String get proActiveSub => 'Todos os recursos desbloqueados';

  @override
  String get navLinks => 'Links';

  @override
  String get navCollections => 'Coleções';

  @override
  String get navSearch => 'Buscar';

  @override
  String get navSettings => 'Configurações';
}
