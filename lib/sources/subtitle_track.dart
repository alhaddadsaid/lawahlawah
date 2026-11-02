class SubtitleTrack {
  const SubtitleTrack({required this.url, required this.language, required this.label, this.isDefault = false});
  final Uri url;
  final String language;
  final String label;
  final bool isDefault;
}
