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
import '../../core/theme.dart';
import '../../shared/widgets/neon_bg.dart';

const _playStoreUrl =
    'https://play.google.com/store/apps/details?id=com.rayancode98.linkvault';
const _feedbackEmail = 'bryanagarcia28414@gmail.com';

/// Imported backups are capped to protect against oversized files.
const _maxImportBytes = 5 * 1024 * 1024;

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
      _toast('Nothing to export yet');
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
      _toast('Export failed');
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
      final picked = result?.files.firstOrNull;
      if (picked == null) return;
      if (picked.size > _maxImportBytes) {
        _toast('File too large (max 5 MB)');
        return;
      }
      final bytes = picked.bytes ??
          (picked.path != null ? await File(picked.path!).readAsBytes() : null);
      if (bytes == null) {
        _toast('Could not read file');
        return;
      }
      final imported = await provider.importJson(utf8.decode(bytes));
      _toast(
          'Imported ${imported.links} links, ${imported.collections} collections');
    } on FormatException {
      _toast('Not a valid LinkVault backup');
    } on Exception {
      _toast('Import failed');
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _toast('Could not open link');
    }
  }

  Future<void> _sendFeedback() async {
    final uri = Uri(
      scheme: 'mailto',
      path: _feedbackEmail,
      query: 'subject=LinkVault feedback',
    );
    if (!await launchUrl(uri)) {
      _toast('No email app found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return NeonBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text('Settings', style: AppTextStyles.screenTitle),
              ),
              // Pro banner
              GestureDetector(
                onTap: () => context.push('/paywall'),
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
                        child: const Icon(Icons.link_rounded, color: Color(0xFF020A07), size: 18),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Upgrade to Pro', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700, fontSize: 14)),
                            Text('Unlimited collections & more', style: TextStyle(color: AppColors.textSec, fontSize: 12)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.accent, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sectionGap),
              const _SettingsSection(
                title: 'APPEARANCE',
                items: [
                  _SettingsRow(emoji: '🌙', label: 'Theme', value: 'Dark'),
                  _SettingsRow(emoji: '🌐', label: 'Language', value: 'English'),
                ],
              ),
              const SizedBox(height: AppSpacing.sectionGap),
              _SettingsSection(
                title: 'DATA',
                items: [
                  _SettingsRow(emoji: '📤', label: 'Export links', onTap: _exportLinks),
                  _SettingsRow(emoji: '📥', label: 'Import links', onTap: _importLinks),
                  _SettingsRow(
                    emoji: '☁️',
                    label: 'Cloud backup',
                    proBadge: true,
                    onTap: () => context.push('/paywall'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sectionGap),
              _SettingsSection(
                title: 'ABOUT',
                items: [
                  _SettingsRow(
                    emoji: '⭐',
                    label: 'Rate LinkVault',
                    onTap: () => _openUrl(_playStoreUrl),
                  ),
                  _SettingsRow(emoji: '💬', label: 'Send feedback', onTap: _sendFeedback),
                  _SettingsRow(emoji: '🔖', label: 'Version', value: _version),
                ],
              ),
            ],
          ),
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
