import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/backup_service.dart';
import '../../core/links_provider.dart';
import '../../core/theme.dart';
import '../../shared/l10n.dart';
import '../../shared/widgets/neon_button.dart';

/// Opens the Pro cloud backup sheet (Google Sign-In + backup/restore).
Future<void> showCloudBackupSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.elevated,
    shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheetTop),
    builder: (_) => const CloudBackupSheet(),
  );
}

class CloudBackupSheet extends StatefulWidget {
  const CloudBackupSheet({super.key});

  @override
  State<CloudBackupSheet> createState() => _CloudBackupSheetState();
}

class _CloudBackupSheetState extends State<CloudBackupSheet> {
  bool _busy = false;
  String? _email = BackupService.userEmail;
  DateTime? _lastBackup;

  @override
  void initState() {
    super.initState();
    if (BackupService.isSignedIn) _loadLastBackup();
  }

  Future<void> _loadLastBackup() async {
    final time = await BackupService.lastBackupTime();
    if (mounted) setState(() => _lastBackup = time);
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _signIn() async {
    setState(() => _busy = true);
    try {
      final user = await BackupService.signIn();
      if (!mounted) return;
      setState(() {
        _busy = false;
        _email = user?.email;
      });
      if (user != null) _loadLastBackup();
    } on Exception {
      if (!mounted) return;
      setState(() => _busy = false);
      _toast(context.l10n.signInFailed);
    }
  }

  Future<void> _signOut() async {
    await BackupService.signOut();
    if (!mounted) return;
    setState(() {
      _email = null;
      _lastBackup = null;
    });
  }

  Future<void> _backup() async {
    final provider = context.read<LinksProvider>();
    setState(() => _busy = true);
    try {
      await BackupService.upload(provider.exportJson());
      if (!mounted) return;
      _toast(context.l10n.backupComplete);
      await _loadLastBackup();
    } on Exception {
      if (mounted) _toast(context.l10n.backupFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore() async {
    final provider = context.read<LinksProvider>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.elevated,
        title: Text(ctx.l10n.restoreConfirmTitle,
            style: const TextStyle(color: AppColors.text, fontSize: 16)),
        content: Text(ctx.l10n.restoreConfirmBody,
            style: const TextStyle(color: AppColors.textSec, fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(ctx.l10n.cancel,
                style: const TextStyle(color: AppColors.textSec)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(ctx.l10n.restoreNow,
                style: const TextStyle(color: AppColors.accent)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _busy = true);
    try {
      final json = await BackupService.download();
      if (!mounted) return;
      if (json == null) {
        setState(() => _busy = false);
        _toast(context.l10n.noBackupFound);
        return;
      }
      final result = await provider.importJson(json);
      if (!mounted) return;
      _toast(context.l10n.importSuccess(result.links, result.collections));
    } on FormatException {
      if (mounted) _toast(context.l10n.importInvalid);
    } on Exception {
      if (mounted) _toast(context.l10n.backupFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _lastBackupLabel() {
    final time = _lastBackup;
    if (time == null) return context.l10n.neverBackedUp;
    final locale = Localizations.localeOf(context).toString();
    final formatted =
        DateFormat.yMMMd(locale).add_jm().format(time.toLocal());
    return context.l10n.lastBackupAt(formatted);
  }

  @override
  Widget build(BuildContext context) {
    final signedIn = _email != null;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
          bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('☁️', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Text(context.l10n.cloudBackup,
                    style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 17,
                        fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 14),
            if (!signedIn) ...[
              Text(context.l10n.cloudBackupDesc,
                  style: const TextStyle(
                      color: AppColors.textSec, fontSize: 13, height: 1.4)),
              const SizedBox(height: 20),
              _busy
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child:
                            CircularProgressIndicator(color: AppColors.accent),
                      ),
                    )
                  : NeonButton(
                      label: context.l10n.signInWithGoogle,
                      onPressed: _signIn,
                    ),
            ] else ...[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.account_circle_rounded,
                        color: AppColors.accent, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_email!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: AppColors.text,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Text(_lastBackupLabel(),
                              style: const TextStyle(
                                  color: AppColors.textSec, fontSize: 11.5)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (_busy)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: CircularProgressIndicator(color: AppColors.accent),
                  ),
                )
              else ...[
                NeonButton(label: context.l10n.backupNow, onPressed: _backup),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: _restore,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    side: const BorderSide(color: AppColors.accent),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(context.l10n.restoreNow),
                ),
              ],
              const SizedBox(height: 6),
              TextButton(
                onPressed: _busy ? null : _signOut,
                child: Text(context.l10n.signOut,
                    style: const TextStyle(
                        color: AppColors.textSec, fontSize: 12.5)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
