import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// Common advertising networks. Also used to ignore ad videos when the
/// browser looks for the video a page is playing.
const adNetworkHosts = [
  'doubleclick.net',
  'googlesyndication.com',
  'googleadservices.com',
  'popads.net',
  'popcash.net',
  'adsterra.com',
  'exoclick.com',
  'onclickads.net',
  'clickadu.com',
];

/// Conservative browser request rules for common advertising networks. These
/// do not promise removal of first-party video ads (including YouTube ads).
List<ContentBlocker> browserAdRules() => [
  for (final host in adNetworkHosts)
    ContentBlocker(
      trigger: ContentBlockerTrigger(urlFilter: '^https?://([^/]*\\.)?${RegExp.escape(host)}[/:]'),
      action: ContentBlockerAction(type: ContentBlockerActionType.BLOCK),
    ),
];
