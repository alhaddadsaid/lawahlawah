/// A website refused an automatic read. Users may open its check themselves;
/// this exception never attempts to solve, simulate or skip a CAPTCHA.
class SourceVerificationRequired extends FormatException {
  SourceVerificationRequired(this.url) : super('This website blocked the request or requires browser verification.');
  final Uri url;
}

/// Short-lived verification state for exactly one HTTPS origin. Login cookies
/// are deliberately excluded; values never go into preferences, logs or URLs.
class VerifiedSourceSession {
  VerifiedSourceSession({
    required this.origin,
    required String userAgent,
    required Map<String, String> cookies,
    DateTime? createdAt,
  }) : userAgent = userAgent.contains(RegExp(r'[\r\n]')) ? '' : userAgent,
       cookies = Map.unmodifiable(
         Map.fromEntries(
           cookies.entries.where(
             (entry) => allowedCookies.contains(entry.key) && !entry.value.contains(RegExp(r'[;\r\n]')),
           ),
         ),
       ),
       createdAt = createdAt ?? DateTime.now();

  static const allowedCookies = {'cf_clearance', '__cf_bm', 'nd_ck'};
  final Uri origin;
  final String userAgent;
  final Map<String, String> cookies;
  final DateTime createdAt;

  Map<String, String> headersFor(Uri url) {
    if (url.scheme != 'https' ||
        origin.scheme != 'https' ||
        url.origin != origin.origin ||
        DateTime.now().difference(createdAt) > const Duration(minutes: 30)) {
      return const {};
    }
    return {
      if (userAgent.isNotEmpty) 'User-Agent': userAgent,
      if (cookies.isNotEmpty) 'Cookie': cookies.entries.map((entry) => '${entry.key}=${entry.value}').join('; '),
    };
  }
}
