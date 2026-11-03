import 'package:flutter_test/flutter_test.dart';
import 'package:reelway/browser/browser_user_agent.dart';

void main() {
  test('Android drops the embedded-view markers and adds Reelway', () {
    const webView =
        'Mozilla/5.0 (Linux; Android 14; Pixel 7; wv) AppleWebKit/537.36 (KHTML, like Gecko) '
        'Version/4.0 Chrome/131.0.6778.135 Mobile Safari/537.36';
    expect(
      BrowserUserAgent.forAndroid(webView),
      'Mozilla/5.0 (Linux; Android 14; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) '
      'Chrome/131.0.6778.135 Mobile Safari/537.36 Reelway/1.0',
    );
    // Already cleaned: unchanged.
    expect(BrowserUserAgent.forAndroid(BrowserUserAgent.forAndroid(webView)), BrowserUserAgent.forAndroid(webView));
  });

  test('iOS ends like other iPhone browsers', () {
    expect(BrowserUserAgent.iosSuffix, endsWith('Safari/604.1'));
  });
}
