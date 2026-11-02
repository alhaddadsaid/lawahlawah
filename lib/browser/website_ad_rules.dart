import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// Conservative browser request rules for common advertising networks. These
/// do not promise removal of first-party video ads (including YouTube ads).
List<ContentBlocker> browserAdRules() => [
  for (final host in const [
    'doubleclick.net',
    'googlesyndication.com',
    'googleadservices.com',
    'popads.net',
    'popcash.net',
    'adsterra.com',
    'exoclick.com',
    'onclickads.net',
    'clickadu.com',
  ])
    ContentBlocker(
      trigger: ContentBlockerTrigger(urlFilter: '^https?://([^/]*\\.)?${RegExp.escape(host)}[/:]'),
      action: ContentBlockerAction(type: ContentBlockerActionType.BLOCK),
    ),
];
