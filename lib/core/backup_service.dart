import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Web OAuth client ID from google-services.json (client_type 3). Required so
/// Google Sign-In returns an idToken that Firebase Auth can consume on Android.
const _webClientId =
    '166112005833-10a3m3e7nfli0n1qqsrgl2bcvst9b4nf.apps.googleusercontent.com';

/// Download cap, matching the import limit in LinksProvider (5 MB).
const _maxBackupBytes = 5 * 1024 * 1024;

/// Pro cloud backup: Google Sign-In + a single JSON blob per user stored at
/// `users/{uid}/backup.json` in Cloud Storage. Local SQLite stays the source
/// of truth — the cloud is only a copy, so failures here never block the app.
class BackupService {
  BackupService._();

  static bool _gsiReady = false;

  static FirebaseAuth get _auth => FirebaseAuth.instance;

  static User? get currentUser => _auth.currentUser;
  static String? get userEmail => _auth.currentUser?.email;
  static bool get isSignedIn => _auth.currentUser != null;

  static Future<void> _ensureGsi() async {
    if (_gsiReady) return;
    await GoogleSignIn.instance.initialize(serverClientId: _webClientId);
    _gsiReady = true;
  }

  /// Interactive Google Sign-In bridged into Firebase Auth. Returns the
  /// signed-in user, or null if the user cancelled. Throws on real failures.
  static Future<User?> signIn() async {
    await _ensureGsi();
    final GoogleSignInAccount account;
    try {
      account = await GoogleSignIn.instance.authenticate();
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    }
    final credential = GoogleAuthProvider.credential(
      idToken: account.authentication.idToken,
    );
    final result = await _auth.signInWithCredential(credential);
    return result.user;
  }

  static Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await _auth.signOut();
  }

  static Reference _backupRef(String uid) =>
      FirebaseStorage.instance.ref('users/$uid/backup.json');

  /// Uploads the export JSON as the user's single backup blob.
  static Future<void> upload(String json) async {
    final uid = currentUser?.uid;
    if (uid == null) throw StateError('Not signed in');
    final bytes = Uint8List.fromList(utf8.encode(json));
    await _backupRef(uid).putData(
      bytes,
      SettableMetadata(contentType: 'application/json'),
    );
  }

  /// Downloads the user's backup JSON, or null if there is no backup yet.
  static Future<String?> download() async {
    final uid = currentUser?.uid;
    if (uid == null) throw StateError('Not signed in');
    try {
      final bytes = await _backupRef(uid).getData(_maxBackupBytes);
      return bytes == null ? null : utf8.decode(bytes);
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') return null;
      rethrow;
    }
  }

  /// When the last backup was uploaded, or null if there is none.
  static Future<DateTime?> lastBackupTime() async {
    final uid = currentUser?.uid;
    if (uid == null) return null;
    try {
      return (await _backupRef(uid).getMetadata()).updated;
    } on FirebaseException {
      return null;
    }
  }
}
