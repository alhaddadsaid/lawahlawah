import 'dart:io';

import 'package:reelway/sources/page_source.dart';

/// Read-only live verification. No website scripts or ad endpoints are run.
Future<void> main(List<String> args) async {
  final source = Uri.parse(args.isEmpty ? 'https://narto-drama.com/detail/watch/el-dragon-indomable/1' : args.single);
  final page = await PageSource().read(source);
  final episodes = page.series.expand((s) => s.episodes).toList();
  stdout.writeln('Title: ${page.title}');
  stdout.writeln('Titles: ${page.titles.length}; playable episodes: ${episodes.length}');
  if (episodes.isEmpty && page.titles.isEmpty) exitCode = 1;
}
