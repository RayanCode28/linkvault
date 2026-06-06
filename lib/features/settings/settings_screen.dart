import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../shared/widgets/neon_bg.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Upgrade to Pro', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700, fontSize: 14)),
                            Text('Unlimited collections & more', style: TextStyle(color: AppColors.textSec, fontSize: 12)),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, color: AppColors.accent, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sectionGap),
              _SettingsSection(
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
                  _SettingsRow(emoji: '📤', label: 'Export links'),
                  _SettingsRow(emoji: '📥', label: 'Import links'),
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
                  _SettingsRow(emoji: '⭐', label: 'Rate LinkVault'),
                  _SettingsRow(emoji: '💬', label: 'Send feedback'),
                  _SettingsRow(emoji: '🔖', label: 'Version', value: '1.2.0'),
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
              child: Text(label, style: TextStyle(color: AppColors.text, fontSize: 14, fontWeight: FontWeight.w500)),
            ),
            if (proBadge)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: AppRadius.badge,
                ),
                child: Text('PRO', style: AppTextStyles.proBadge),
              )
            else if (value != null)
              Text(value!, style: TextStyle(color: AppColors.textSec, fontSize: 13))
            else
              Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 16),
          ],
        ),
      ),
    );
  }
}
