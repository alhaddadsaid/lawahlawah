import '../../browser/popup_protection.dart';

enum SubtitleSize { small, medium, large }

class UserSettings {
  const UserSettings({
    this.protectionLevel = ProtectionLevel.balanced,
    this.httpsUpgrade = true,
    this.warnOnHttp = true,
    this.blockThirdPartyCookies = false,
    this.blockWebsiteAds = true,
    this.openVideosInReelway = true,
    this.autoplayNext = true,
    this.preferredPlaybackSpeed = 1.0,
    this.subtitlesEnabled = true,
    this.subtitleSize = SubtitleSize.medium,
    this.personalizedAds = false,
    this.saveHistory = true,
    this.allowedPopupSites = const {},
  });

  final ProtectionLevel protectionLevel;
  final bool httpsUpgrade;
  final bool warnOnHttp;
  final bool blockThirdPartyCookies;
  final bool blockWebsiteAds;

  /// Move a website's video or series straight into Reelway's own screens.
  final bool openVideosInReelway;
  final bool autoplayNext;
  final double preferredPlaybackSpeed;
  final bool subtitlesEnabled;
  final SubtitleSize subtitleSize;

  /// Off until the user consents through the consent form (phase 6).
  final bool personalizedAds;
  final bool saveHistory;
  final Set<String> allowedPopupSites;

  UserSettings copyWith({
    ProtectionLevel? protectionLevel,
    bool? httpsUpgrade,
    bool? warnOnHttp,
    bool? blockThirdPartyCookies,
    bool? blockWebsiteAds,
    bool? openVideosInReelway,
    bool? autoplayNext,
    double? preferredPlaybackSpeed,
    bool? subtitlesEnabled,
    SubtitleSize? subtitleSize,
    bool? personalizedAds,
    bool? saveHistory,
    Set<String>? allowedPopupSites,
  }) => UserSettings(
    protectionLevel: protectionLevel ?? this.protectionLevel,
    httpsUpgrade: httpsUpgrade ?? this.httpsUpgrade,
    warnOnHttp: warnOnHttp ?? this.warnOnHttp,
    blockThirdPartyCookies: blockThirdPartyCookies ?? this.blockThirdPartyCookies,
    blockWebsiteAds: blockWebsiteAds ?? this.blockWebsiteAds,
    openVideosInReelway: openVideosInReelway ?? this.openVideosInReelway,
    autoplayNext: autoplayNext ?? this.autoplayNext,
    preferredPlaybackSpeed: preferredPlaybackSpeed ?? this.preferredPlaybackSpeed,
    subtitlesEnabled: subtitlesEnabled ?? this.subtitlesEnabled,
    subtitleSize: subtitleSize ?? this.subtitleSize,
    personalizedAds: personalizedAds ?? this.personalizedAds,
    saveHistory: saveHistory ?? this.saveHistory,
    allowedPopupSites: allowedPopupSites ?? this.allowedPopupSites,
  );

  Map<String, dynamic> toJson() => {
    'protectionLevel': protectionLevel.name,
    'httpsUpgrade': httpsUpgrade,
    'warnOnHttp': warnOnHttp,
    'blockThirdPartyCookies': blockThirdPartyCookies,
    'blockWebsiteAds': blockWebsiteAds,
    'openVideosInReelway': openVideosInReelway,
    'autoplayNext': autoplayNext,
    'preferredPlaybackSpeed': preferredPlaybackSpeed,
    'subtitlesEnabled': subtitlesEnabled,
    'subtitleSize': subtitleSize.name,
    'personalizedAds': personalizedAds,
    'saveHistory': saveHistory,
    'allowedPopupSites': allowedPopupSites.toList(),
  };

  factory UserSettings.fromJson(Map<String, dynamic> j) {
    const d = UserSettings();
    T pick<T>(String k, T fallback) => j[k] is T ? j[k] as T : fallback;
    return UserSettings(
      protectionLevel: ProtectionLevel.values.asNameMap()[j['protectionLevel']] ?? d.protectionLevel,
      httpsUpgrade: pick('httpsUpgrade', d.httpsUpgrade),
      warnOnHttp: pick('warnOnHttp', d.warnOnHttp),
      blockThirdPartyCookies: pick('blockThirdPartyCookies', d.blockThirdPartyCookies),
      blockWebsiteAds: pick('blockWebsiteAds', d.blockWebsiteAds),
      openVideosInReelway: pick('openVideosInReelway', d.openVideosInReelway),
      autoplayNext: pick('autoplayNext', d.autoplayNext),
      preferredPlaybackSpeed: (j['preferredPlaybackSpeed'] as num?)?.toDouble() ?? d.preferredPlaybackSpeed,
      subtitlesEnabled: pick('subtitlesEnabled', d.subtitlesEnabled),
      subtitleSize: SubtitleSize.values.asNameMap()[j['subtitleSize']] ?? d.subtitleSize,
      personalizedAds: pick('personalizedAds', d.personalizedAds),
      saveHistory: pick('saveHistory', d.saveHistory),
      allowedPopupSites: ((j['allowedPopupSites'] as List?) ?? const []).cast<String>().toSet(),
    );
  }
}
