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
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: '',
    iosBundleId: 'com.reelway.reelway',
  );
  static const _android = FirebaseOptions(apiKey: '', appId: '', messagingSenderId: '', projectId: '');

  /// Null when this build has no Firebase values yet.
  static FirebaseOptions? get current {
    final o = defaultTargetPlatform == TargetPlatform.android ? _android : _ios;
    return o.apiKey.isEmpty || o.appId.isEmpty || o.projectId.isEmpty || o.messagingSenderId.isEmpty ? null : o;
  }
}
