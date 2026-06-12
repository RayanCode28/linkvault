import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/links_provider.dart';
import '../../core/locale_provider.dart';
import '../../core/theme.dart';
import '../../shared/l10n.dart';

const _playStoreUrl =
    'https://play.google.com/store/apps/details?id=com.rayancode98.linkvault';
const _feedbackEmail = 'bryanagarcia28414@gmail.com';

/// Imported backups are capped to protect against oversized files.
const _maxImportBytes = 5 * 1024 * 1024;

/// Native names for the supported app languages (shown untranslated).
const _languageNames = {
  'en': 'English',
  'es': 'Español',
  'pt': 'Português',
  'fr': 'Français',
  'de': 'Deutsch',
};

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      if (mounted) setState(() => _version = info.version);
    });
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _exportLinks() async {
    final provider = context.read<LinksProvider>();
    if (provider.links.isEmpty && provider.collections.isEmpty) {
      _toast(context.l10n.nothingToExport);
      return;
    }
    try {
      final jsonStr = provider.exportJson();
      final dir = await Directory.systemTemp.createTemp('linkvault');
      final stamp = DateTime.now().toIso8601String().split('T').first;
      final file = File(p.join(dir.path, 'linkvault-backup-$stamp.json'));
      await file.writeAsString(jsonStr);
      await SharePlus.instance.share(ShareParams(
        files: [XFile(file.path, mimeType: 'application/json')],
        subject: 'LinkVault backup',
      ));
    } on Exception {
      if (mounted) _toast(context.l10n.exportFailed);
    }
  }

  Future<void> _importLinks() async {
    final provider = context.read<LinksProvider>();
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        withData: true,
      );
      if (!mounted) return;
      final picked = result?.files.firstOrNull;
      if (picked == null) return;
      if (picked.size > _maxImportBytes) {
        _toast(context.l10n.fileTooLarge);
        return;
      }
      final bytes = picked.bytes ??
          (picked.path != null ? await File(picked.path!).readAsBytes() : null);
      if (!mounted) return;
      if (bytes == null) {
        _toast(context.l10n.fileReadError);
        return;
      }
      final imported = await provider.importJson(utf8.decode(bytes));
      if (!mounted) return;
      _toast(context.l10n.importSuccess(imported.links, imported.collections));
    } on FormatException {
      if (mounted) _toast(context.l10n.importInvalid);
    } on Exception {
      if (mounted) _toast(context.l10n.importFailed);
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) _toast(context.l10n.openLinkError);
    }
  }

  void _pickLanguage() {
    final localeProvider = context.read<LocaleProvider>();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.elevated,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheetTop),
      builder: (ctx) {
        final current = localeProvider.locale?.languageCode;
        Widget option(String? code, String label) => ListTile(
              title: Text(label, style: const TextStyle(color: AppColors.text, fontSize: 14)),
              trailing: code == current
                  ? const Icon(Icons.check_rounded, color: AppColors.accent, size: 20)
                  : null,
              onTap: () {
                localeProvider.setLocale(code == null ? null : Locale(code));
                Navigator.pop(ctx);
              },
            );
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              option(null, ctx.l10n.languageSystem),
              for (final entry in _languageNames.entries)
                option(entry.key, entry.value),
            ],
          ),
        );
      },
    );
  }

  Future<void> _sendFeedback() async {
    final uri = Uri(
      scheme: 'mailto',
      path: _feedbackEmail,
      query: 'subject=LinkVault feedback',
    );
    if (!await launchUrl(uri)) {
      if (mounted) _toast(context.l10n.noEmailApp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(context.l10n.settingsTitle, style: AppTextStyles.screenTitle),
              ),
              // Pro banner: upgrade CTA for Free users, active state for Pro.
              Builder(builder: (context) {
                final isPro = context.watch<LinksProvider>().isPro;
                return GestureDetector(
                  onTap: isPro ? null : () => context.push('/paywall'),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.accentDim,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.accentBorder, width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            isPro ? Icons.check_rounded : Icons.link_rounded,
                            color: const Color(0xFF020A07),
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(isPro ? context.l10n.proActive : context.l10n.upgradeToPro,
                                  style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700, fontSize: 14)),
                              Text(isPro ? context.l10n.proActiveSub : context.l10n.upgradeSub,
                                  style: const TextStyle(color: AppColors.textSec, fontSize: 12)),
                            ],
                          ),
                        ),
                        if (!isPro)
                          const Icon(Icons.chevron_right_rounded, color: AppColors.accent, size: 16),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.sectionGap),
              _SettingsSection(
                title: context.l10n.sectionAppearance,
                items: [
                  _SettingsRow(
                    emoji: '🌐',
                    label: context.l10n.language,
                    value: context.watch<LocaleProvider>().locale == null
                        ? '${context.l10n.languageSystem} · ${context.l10n.languageName}'
                        : context.l10n.languageName,
                    onTap: _pickLanguage,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sectionGap),
              _SettingsSection(
                title: context.l10n.sectionData,
                items: [
                  _SettingsRow(emoji: '📤', label: context.l10n.exportLinks, onTap: _exportLinks),
                  _SettingsRow(emoji: '📥', label: context.l10n.importLinks, onTap: _importLinks),
                  _SettingsRow(
                    emoji: '☁️',
                    label: context.l10n.cloudBackup,
                    proBadge: true,
                    onTap: () => context.push('/paywall'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sectionGap),
              _SettingsSection(
                title: context.l10n.sectionAbout,
                items: [
                  _SettingsRow(
                    emoji: '⭐',
                    label: context.l10n.rateApp,
                    onTap: () => _openUrl(_playStoreUrl),
                  ),
                  _SettingsRow(emoji: '💬', label: context.l10n.sendFeedback, onTap: _sendFeedback),
                  _SettingsRow(emoji: '🔖', label: context.l10n.version, value: _version),
                ],
              ),
            ],
          ),
        ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const _SettingsSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title, style: AppTextStyles.sectionHeader),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.settings,
            border: Border.all(color: AppColors.border, width: 1),
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              for (int i = 0; i < items.length; i++) ...[
                items[i],
                if (i < items.length - 1)
                  Divider(height: 1, color: AppColors.border),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final String emoji;
  final String label;
  final String? value;
  final bool proBadge;
  final VoidCallback? onTap;

  const _SettingsRow({
    required this.emoji,
    required this.label,
    this.value,
    this.proBadge = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Text(emoji, style: const TextStyle(fontSize: 18)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: const TextStyle(color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w500)),
            ),
            if (proBadge)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: AppRadius.badge,
                ),
                child: Text('PRO', style: AppTextStyles.proBadge),
              )
            else if (value != null)
              Text(value!, style: const TextStyle(color: AppColors.textSec, fontSize: 13))
            else
              const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 16),
          ],
        ),
      ),
    );
  }
}
