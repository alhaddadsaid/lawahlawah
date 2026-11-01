/// Partner unlock: ad-free viewing on websites that agreed to it.
///
/// A website that signs with Reelway allows Reelway to hide its ads and skip
/// its "watch ads to unlock" step inside Reelway. The partner builds nothing:
/// Reelway applies the rules recorded here, on that site only, and only while
/// the agreement is in force. Every other site is browsed as it is, with only
/// the pop-up protection. See docs/PARTNERS.md.
library;

enum AgreementStatus {
  /// Talks under way: no rules run.
  negotiating,

  /// Contract signed: rules run from the start date to the end date.
  signed,

  /// Contract ended or suspended: no rules run.
  ended,

  /// Reelway's own test page, never a real partner. Runs only in development
  /// and test builds.
  test,
}

class PartnerAgreement {
  const PartnerAgreement({
    required this.id,
    required this.siteName,
    required this.domains,
    required this.status,
    this.contractReference,
    this.validFrom,
    this.validUntil,
    this.allowsHidingAds = false,
    this.allowsSkippingAdGate = false,
    this.hideSelectors = const [],
    this.unlockScript,
  });

  final String id;
  final String siteName;

  /// Hosts covered (exact host or subdomain).
  final List<String> domains;
  final AgreementStatus status;

  /// Where the signed contract is kept (not in this repository).
  final String? contractReference;

  /// First and last day, as 'YYYY-MM-DD'. No end date: open-ended.
  final String? validFrom;
  final String? validUntil;

  /// What the contract allows. A rule runs only when its permission is true.
  final bool allowsHidingAds;
  final bool allowsSkippingAdGate;

  /// CSS selectors of the site's ad slots, hidden when [allowsHidingAds].
  final List<String> hideSelectors;

  /// JavaScript, written for the site and agreed with the partner, that skips
  /// its ad gate. Runs when the page is ready and again when it changes, so
  /// it must be safe to run many times. Needs [allowsSkippingAdGate].
  final String? unlockScript;

  bool covers(Uri url) {
    final h = url.host.toLowerCase();
    return domains.any((d) => h == d || h.endsWith('.$d'));
  }

  /// Whether the rules may run on [now]'s date. A signed agreement needs a
  /// contract reference and a start date.
  bool isInForce(DateTime now, {required bool testBuild}) {
    switch (status) {
      case AgreementStatus.test:
        return testBuild;
      case AgreementStatus.negotiating:
      case AgreementStatus.ended:
        return false;
      case AgreementStatus.signed:
        final ref = contractReference;
        final from = DateTime.tryParse(validFrom ?? '');
        final until = DateTime.tryParse(validUntil ?? '');
        if (ref == null || ref.trim().isEmpty || from == null) return false;
        final day = DateTime(now.year, now.month, now.day);
        return !day.isBefore(from) && (until == null || !day.isAfter(until));
    }
  }
}
