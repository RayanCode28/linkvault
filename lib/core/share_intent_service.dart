import 'dart:async';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';
import 'models.dart';

/// Listens for text shared into the app from other apps (Android Share
/// Sheet) and extracts the first valid web URL from it.
class ShareIntentService {
  ShareIntentService._();

  static final _urlRe = RegExp(r'https?://\S+');
  static StreamSubscription? _subscription;

  /// Starts listening. [onUrl] fires both when the app is launched from
  /// the share sheet and when it is already running.
  static void listen(void Function(Uri url) onUrl) {
    void handle(List<SharedFile> files) {
      for (final file in files) {
        final uri = extractUrl(file.value ?? '');
        if (uri != null) {
          onUrl(uri);
          return;
        }
      }
    }

    FlutterSharingIntent.instance.getInitialSharing().then(handle);
    _subscription =
        FlutterSharingIntent.instance.getMediaStream().listen(handle);
  }

  static void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }

  /// Pulls the first http(s) URL out of arbitrary shared text and
  /// validates it through the same gate as manual input.
  static Uri? extractUrl(String text) {
    final match = _urlRe.firstMatch(text);
    if (match == null) return parseWebUrl(text);
    return parseWebUrl(match.group(0)!);
  }
}
