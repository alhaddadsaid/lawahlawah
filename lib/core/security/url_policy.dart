/// Validates and normalises what the user types into the address bar, and
/// decides which URL schemes the in-app browser may load (spec section 9).
library;

sealed class AddressInput {
  const AddressInput();
}

class AddressUrl extends AddressInput {
  const AddressUrl(this.uri, {this.upgradedToHttps = false});
  final Uri uri;
  final bool upgradedToHttps;
}

class AddressSearch extends AddressInput {
  const AddressSearch(this.query);
  final String query;

  Uri searchUri([String engine = 'https://duckduckgo.com/?q=']) =>
      Uri.parse('$engine${Uri.encodeQueryComponent(query)}');
}

class AddressRejected extends AddressInput {
  const AddressRejected(this.reason);
  final String reason;
}

abstract final class UrlPolicy {
  /// Schemes the WebView may load in-place.
  static const webSchemes = {'https', 'http'};

  /// Schemes that are always refused: they can run script or read local data.
  static const blockedSchemes = {'javascript', 'file', 'data', 'blob', 'content', 'vbscript'};

  /// Schemes handed to the operating system only after the user confirms.
  static const externalSchemes = {'mailto', 'tel', 'sms', 'market', 'itms-apps', 'intent'};

  static final _hostLike = RegExp(r'^([a-z0-9-]+\.)+[a-z]{2,}(:\d+)?(/.*)?$', caseSensitive: false);
  static final _ipLike = RegExp(r'^\d{1,3}(\.\d{1,3}){3}(:\d+)?(/.*)?$');

  /// Turns raw address-bar text into a URL to load, a search, or a rejection.
  /// Bare hosts are upgraded to HTTPS by default.
  static AddressInput parse(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return const AddressRejected('Enter a web address or search term.');
    if (text.length > 4096) return const AddressRejected('That address is too long.');

    final schemeMatch = RegExp(r'^([a-z][a-z0-9+.-]*):', caseSensitive: false).firstMatch(text);
    if (schemeMatch != null) {
      final scheme = schemeMatch.group(1)!.toLowerCase();
      if (blockedSchemes.contains(scheme)) {
        return AddressRejected('"$scheme:" links are blocked for your safety.');
      }
      if (webSchemes.contains(scheme)) {
        final uri = Uri.tryParse(text);
        if (uri == null || uri.host.isEmpty) return const AddressRejected('That web address is not valid.');
        return AddressUrl(uri);
      }
      // "localhost:8080" parses as scheme "localhost"; fall through for host:port.
      if (!RegExp(r'^[a-z0-9.-]+:\d+', caseSensitive: false).hasMatch(text)) {
        return AddressSearch(text);
      }
    }

    if (!text.contains(' ') && (_hostLike.hasMatch(text) || _ipLike.hasMatch(text) || text.startsWith('localhost'))) {
      final uri = Uri.tryParse('https://$text');
      if (uri != null && uri.host.isNotEmpty) return AddressUrl(uri, upgradedToHttps: true);
    }
    return AddressSearch(text);
  }

  /// Classifies a navigation the page itself is attempting.
  static NavigationKind classify(Uri uri) {
    final s = uri.scheme.toLowerCase();
    if (s == 'about') return NavigationKind.web; // about:blank, about:srcdoc
    if (webSchemes.contains(s)) return NavigationKind.web;
    if (externalSchemes.contains(s)) return NavigationKind.external;
    return NavigationKind.blocked;
  }

  static bool isInsecure(Uri uri) => uri.scheme.toLowerCase() == 'http';
}

enum NavigationKind { web, external, blocked }
