import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../shared/l10n.dart';
import 'theme.dart';

/// One-time spotlight tour shown over the real Home UI right after onboarding.
/// Widgets register their position through the [GlobalKey]s below.
class FeatureTour {
  FeatureTour._();

  static const _prefKey = 'tour_done';

  static final GlobalKey fabKey = GlobalKey();
  static final GlobalKey searchKey = GlobalKey();
  static final GlobalKey filtersKey = GlobalKey();
  static final GlobalKey collectionsTabKey = GlobalKey();

  static bool _running = false;

  /// Runs the tour once (gated by a pref). No-op if already seen, already
  /// running, or the targets aren't laid out yet (it retries next launch).
  static Future<void> maybeStart(BuildContext context) async {
    if (_running) return;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_prefKey) == true) return;
    if (!context.mounted) return;
    if (fabKey.currentContext == null ||
        searchKey.currentContext == null ||
        collectionsTabKey.currentContext == null) {
      return;
    }
    _running = true;
    final l = context.l10n;
    TutorialCoachMark(
      textSkip: l.tourSkip,
      skipWidget: _skipChip(l.tourSkip),
      colorShadow: const Color(0xFF010604),
      opacityShadow: 0.9,
      paddingFocus: 8,
      onFinish: () => _finish(prefs),
      onSkip: () {
        _finish(prefs);
        return true;
      },
      targets: [
        _target(
          'add', fabKey, ShapeLightFocus.Circle,
          l.tourAddTitle, l.tourAddBody, ContentAlign.top,
        ),
        _target(
          'search', searchKey, ShapeLightFocus.RRect,
          l.tourSearchTitle, l.tourSearchBody, ContentAlign.bottom,
        ),
        _target(
          'filter', filtersKey, ShapeLightFocus.RRect,
          l.tourFilterTitle, l.tourFilterBody, ContentAlign.bottom,
        ),
        _target(
          'collections', collectionsTabKey, ShapeLightFocus.Circle,
          l.tourCollectionsTitle, l.tourCollectionsBody, ContentAlign.top,
          last: true,
        ),
      ],
    ).show(context: context);
  }

  static Future<void> _finish(SharedPreferences prefs) async {
    _running = false;
    await prefs.setBool(_prefKey, true);
  }

  static TargetFocus _target(
    String id,
    GlobalKey key,
    ShapeLightFocus shape,
    String title,
    String body,
    ContentAlign align, {
    bool last = false,
  }) {
    return TargetFocus(
      identify: id,
      keyTarget: key,
      shape: shape,
      radius: 14,
      contents: [
        TargetContent(
          align: align,
          builder: (context, controller) =>
              _Tip(title: title, body: body, last: last, onNext: controller.next),
        ),
      ],
    );
  }

  static Widget _skipChip(String label) => Container(
        margin: const EdgeInsets.only(top: 6, right: 8),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Text(label, style: const TextStyle(color: AppColors.textSec, fontSize: 13)),
      );
}

class _Tip extends StatelessWidget {
  final String title;
  final String body;
  final bool last;
  final VoidCallback onNext;

  const _Tip({
    required this.title,
    required this.body,
    required this.last,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      constraints: const BoxConstraints(maxWidth: 340),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.elevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accentBorder, width: 1),
        boxShadow: AppShadows.sheet,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.sheetTitle),
          const SizedBox(height: 6),
          Text(body, style: AppTextStyles.sheetDesc),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: onNext,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppShadows.chipActive,
                ),
                child: Text(
                  last ? context.l10n.tourDone : context.l10n.tourNext,
                  style: const TextStyle(
                    color: Color(0xFF020A07),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
