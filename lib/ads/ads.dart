/// Ads entry point.
///
/// On Android and iOS this uses Google AdMob (google_mobile_ads). On the web
/// preview nothing is shown.
library;

export 'ads_stub.dart' if (dart.library.io) 'ads_mobile.dart';
