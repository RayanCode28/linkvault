import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme.dart';
import '../../shared/l10n.dart';
import '../../shared/widgets/neon_bg.dart';
import '../../shared/widgets/neon_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _pages = 4;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<String> _titles(BuildContext c) => [
        c.l10n.onboardingTitle1,
        c.l10n.onboardingTitle2,
        c.l10n.onboardingTitle3,
        c.l10n.onboardingTitle4,
      ];
  List<String> _subs(BuildContext c) => [
        c.l10n.onboardingSub1,
        c.l10n.onboardingSub2,
        c.l10n.onboardingSub3,
        c.l10n.onboardingSub4,
      ];

  Future<void> _finish({bool toPaywall = false}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarded', true);
    if (!mounted) return;
    context.go('/');
    // Open the paywall on top of Home so its close button returns there.
    if (toPaywall) context.push('/paywall');
  }

  void _next() {
    if (_page < _pages - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NeonBg(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Skip
              Align(
                alignment: Alignment.topRight,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _page < _pages - 1 ? 1 : 0,
                  child: TextButton(
                    onPressed: _page < _pages - 1 ? _finish : null,
                    child: Text(context.l10n.skip,
                        style: const TextStyle(color: AppColors.textSec, fontSize: 14)),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (ctx, i) => LayoutBuilder(
                    builder: (ctx, constraints) => SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _OnboardingArt(page: i),
                              const SizedBox(height: 40),
                              Text(_titles(context)[i],
                                  style: AppTextStyles.onboardingTitle,
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 14),
                              Text(_subs(context)[i],
                                  style: AppTextStyles.onboardingSub,
                                  textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_pages, (i) {
                        final active = i == _page;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: active ? 22 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: active ? AppColors.accent : AppColors.border,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 22),
                    if (_page < _pages - 1)
                      NeonButton(label: context.l10n.continueLabel, onPressed: _next)
                    else ...[
                      NeonButton(
                        label: context.l10n.unlockPro,
                        onPressed: () => _finish(toPaywall: true),
                      ),
                      TextButton(
                        onPressed: () => _finish(),
                        child: Text(
                          context.l10n.continueFree,
                          style: const TextStyle(color: AppColors.textSec, fontSize: 14),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Code-drawn hero art for each onboarding page (no image assets).
class _OnboardingArt extends StatelessWidget {
  final int page;
  const _OnboardingArt({required this.page});

  @override
  Widget build(BuildContext context) {
    switch (page) {
      case 0:
        return _haloIcon(Icons.bookmark_added_rounded);
      case 1:
        return _shareInflow();
      case 2:
        return _collectionGrid();
      case 3:
      default:
        return const _ProComparison();
    }
  }

  // Page 1 — "never lose a link": a glowing saved icon inside concentric halos.
  Widget _haloIcon(IconData icon) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            for (final d in const [196.0, 156.0, 116.0])
              Container(
                width: d,
                height: d,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.12), width: 1),
                ),
              ),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentDim,
                boxShadow: [
                  BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.28),
                      blurRadius: 28),
                ],
              ),
              child: Icon(icon, color: AppColors.accent, size: 36),
            ),
          ],
        ),
      ),
    );
  }

  // Page 2 — "save from any app": source apps flowing into LinkVault.
  Widget _shareInflow() {
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SourceChip(emoji: '▶️'),
              SizedBox(width: 10),
              _SourceChip(emoji: '📸'),
              SizedBox(width: 10),
              _SourceChip(emoji: '🛒'),
              SizedBox(width: 10),
              _SourceChip(emoji: '📰'),
            ],
          ),
          const SizedBox(height: 10),
          Icon(Icons.keyboard_double_arrow_down_rounded,
              color: AppColors.accent.withValues(alpha: 0.7), size: 26),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
            decoration: BoxDecoration(
              color: AppColors.accentDim,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.accentBorder, width: 1),
              boxShadow: [
                BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.18), blurRadius: 18),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.link_rounded, color: AppColors.accent, size: 22),
                SizedBox(width: 8),
                Text('LinkVault',
                    style: TextStyle(
                        color: AppColors.text,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Page 3 — "organize": a tidy grid of collection chips.
  Widget _collectionGrid() {
    const chips = [
      ('🎬', 'Watch later'),
      ('📰', 'News'),
      ('🍕', 'Recipes'),
      ('💡', 'Ideas'),
      ('✈️', 'Travel'),
      ('🎧', 'Music'),
    ];
    return SizedBox(
      height: 200,
      child: Center(
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            for (final c in chips)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 13),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.accentBorder, width: 1),
                ),
                child: Text('${c.$1}  ${c.$2}',
                    style: const TextStyle(color: AppColors.text, fontSize: 13)),
              ),
          ],
        ),
      ),
    );
  }
}

class _SourceChip extends StatelessWidget {
  final String emoji;
  const _SourceChip({required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 20))),
    );
  }
}

/// Page 4 — Free vs Pro comparison table to nudge towards the subscription.
class _ProComparison extends StatelessWidget {
  const _ProComparison();

  static const _cross = Icon(Icons.close_rounded, color: AppColors.textMuted, size: 18);
  static const _check = Icon(Icons.check_rounded, color: AppColors.accent, size: 18);

  Widget _cell(Widget child) => SizedBox(width: 48, child: Center(child: child));

  Widget _row(String label, Widget free, {bool last = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: last
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border, width: 1))),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.text, fontSize: 12.5)),
          ),
          _cell(free),
          _cell(_check),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accentBorder, width: 1),
        boxShadow: [
          BoxShadow(color: AppColors.accent.withValues(alpha: 0.12), blurRadius: 22),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 14),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
            ),
            child: Row(
              children: [
                const Expanded(child: SizedBox()),
                _cell(const Text('Free',
                    style: TextStyle(color: AppColors.textSec, fontSize: 12, fontWeight: FontWeight.w600))),
                _cell(const Text('Pro',
                    style: TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w800))),
              ],
            ),
          ),
          _row(context.l10n.featCollections,
              const Text('3', style: TextStyle(color: AppColors.textMuted, fontSize: 13, fontWeight: FontWeight.w700))),
          _row(context.l10n.featNoAds, _cross),
          _row(context.l10n.featCloud, _cross),
          _row(context.l10n.featSupport, _cross, last: true),
        ],
      ),
    );
  }
}
