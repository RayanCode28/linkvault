import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme.dart';
import '../../shared/widgets/neon_bg.dart';
import '../../shared/widgets/neon_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _page = 0;

  static const _titles = [
    'Stop losing\nyour links.',
    'Save from\nany app.',
    'Your vault,\nyour way.',
  ];

  static const _subs = [
    'Links sent to yourself, screenshots, browser tabs lost forever. Sound familiar?',
    'Share any link directly to LinkVault in 2 taps. Works with YouTube, Instagram, TikTok and more.',
    'Organize into collections. Filter by unread or favorites. Find anything instantly.',
  ];

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarded', true);
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return NeonBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: _page < 2
                    ? TextButton(
                        onPressed: _finish,
                        child: Text('Skip', style: TextStyle(color: AppColors.textSec, fontSize: 14)),
                      )
                    : const SizedBox(height: 48),
              ),
              // Art + text
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildArt(_page),
                      const SizedBox(height: 40),
                      Text(
                        _titles[_page],
                        style: AppTextStyles.onboardingTitle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        _subs[_page],
                        style: AppTextStyles.onboardingSub,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              // Dots + button
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (i) {
                        final active = i == _page;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: active ? 20 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: active ? AppColors.accent : AppColors.border,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    NeonButton(
                      label: _page < 2 ? 'Continue' : 'Get Started',
                      onPressed: () {
                        if (_page < 2) {
                          setState(() => _page++);
                        } else {
                          _finish();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArt(int page) {
    switch (page) {
      case 0:
        return SizedBox(
          height: 180,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 180, height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.accentBorder, width: 1),
                  ),
                ),
                Container(
                  width: 144, height: 144,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.accentBorder, width: 1),
                  ),
                ),
                Container(
                  width: 108, height: 108,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.accentBorder, width: 1),
                  ),
                ),
                Container(
                  width: 72, height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accentDim,
                    boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.2), blurRadius: 20)],
                  ),
                  child: Center(
                    child: Icon(Icons.link_rounded, color: AppColors.accent, size: 34),
                  ),
                ),
              ],
            ),
          ),
        );
      case 1:
        return SizedBox(
          height: 180,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _MiniCard(emoji: '▶', label: 'YouTube video', opacity: 1.0, showDot: true),
              const SizedBox(height: 6),
              _MiniCard(emoji: '📸', label: 'Instagram reel', opacity: 0.7, showDot: false),
              const SizedBox(height: 6),
              _MiniCard(emoji: '🔗', label: 'Reddit thread', opacity: 0.9, showDot: false),
            ],
          ),
        );
      case 2:
      default:
        final chips = [
          ('🎬', 'Watch later'),
          ('📰', 'News'),
          ('🍕', 'Recipes'),
          ('💡', 'Startup'),
        ];
        return SizedBox(
          height: 180,
          child: Center(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: chips.map((c) => Container(
                padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.accentBorder, width: 1),
                ),
                child: Text('${c.$1} ${c.$2}', style: TextStyle(color: AppColors.text, fontSize: 13)),
              )).toList(),
            ),
          ),
        );
    }
  }
}

class _MiniCard extends StatelessWidget {
  final String emoji;
  final String label;
  final double opacity;
  final bool showDot;

  const _MiniCard({
    required this.emoji,
    required this.label,
    required this.opacity,
    required this.showDot,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: AppColors.text, fontSize: 13)),
            if (showDot) ...[
              const SizedBox(width: 8),
              Container(
                width: 7, height: 7,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.dotPulse,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
