import 'package:flutter/widgets.dart';
import '../l10n/app_localizations.dart';

export '../l10n/app_localizations.dart';

/// Shorthand: `context.l10n.addLink` instead of `AppLocalizations.of(context).addLink`.
extension AppL10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
