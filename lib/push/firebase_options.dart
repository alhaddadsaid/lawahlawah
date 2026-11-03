import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Firebase project "Reelway" (push notifications only). These values are
/// public app identifiers from the Firebase console (Project settings > Your
/// apps), not secrets, so they live in the code instead of the platform
/// files. While a value is empty, push stays off and the app works as before.
///
/// iPhone app com.reelway.reelway and Android app com.reelbrow.videobrowser.
abstract final class ReelwayFirebase {
  static const _ios = FirebaseOptions(
    apiKey: 'AIzaSyAeOcdQFDAF4Hj_WPNYozBj6RA9kfxm70Y',
    appId: '1:190481629744:ios:680cee0bb6b1cca2bde3f5',
    messagingSenderId: '190481629744',
    projectId: 'reelway-1d51c',
    iosBundleId: 'com.reelway.reelway',
  );

  /// The ReelBro test app (com.reelway.reelbro) is its own iOS app in the
  /// same Firebase project. Its builds are marked by REELWAY_TEST_PARTNER.
  static const _iosReelbro = FirebaseOptions(
    apiKey: 'AIzaSyAeOcdQFDAF4Hj_WPNYozBj6RA9kfxm70Y',
    appId: '1:190481629744:ios:2c081053a51188c2bde3f5',
    messagingSenderId: '190481629744',
    projectId: 'reelway-1d51c',
    iosBundleId: 'com.reelway.reelbro',
  );
  static const _android = FirebaseOptions(
    apiKey: 'AIzaSyActY075_NfUobseDiM-UXEZ3k--gzqkdo',
    appId: '1:190481629744:android:1e4a40aab117cb71bde3f5',
    messagingSenderId: '190481629744',
    projectId: 'reelway-1d51c',
  );

  /// Null when this build has no Firebase values yet.
  static FirebaseOptions? get current {
    final o = defaultTargetPlatform == TargetPlatform.android
        ? _android
        : const bool.fromEnvironment('REELWAY_TEST_PARTNER')
        ? _iosReelbro
        : _ios;
    return o.apiKey.isEmpty || o.appId.isEmpty || o.projectId.isEmpty || o.messagingSenderId.isEmpty ? null : o;
  }
}
