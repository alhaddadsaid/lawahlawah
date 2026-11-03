<?php
// Reelway admin: edits /var/www/reelbrow/config.json, which the app reads at
// every start. Protected by nginx basic auth (/etc/nginx/reelbrow-admin.htpasswd).
// Two stores, set apart: the App Store (iPhone) app reads the top-level keys,
// the Play Store (Android) app reads the "android" block with the same keys.
declare(strict_types=1);

session_start();
const CONFIG = __DIR__ . '/../config.json';
// Push notifications go out with the FCM HTTP v1 API. The service account key
// lives outside the web root and is never in git (see server/README.md).
const PUSH_KEY = '/etc/reelway/fcm-service-account.json';
const PUSH_TOPICS = ['ios' => 'ios-all', 'android' => 'android-all'];
const PUSH_TARGETS = ['announcement' => 'The announcement page', 'url' => 'A website in the browser', 'settings' => 'Settings', 'protection' => 'Pop-up protection'];
const ANN_TARGETS = ['' => 'No button', 'url' => 'Open a website in the browser', 'settings' => 'Open Settings', 'protection' => 'Open Pop-up protection'];

$switches = [
    'ads' => [
        'enabled' => ['All ads', 'Turns every ad off or on. Off also skips the consent and tracking prompts.'],
        'banner' => ['Banners', 'At the bottom of Home, Library and the series screen.'],
        'interstitial' => ['Between episodes', 'Full-screen ad every few episodes.'],
        'appOpen' => ['When the app opens', 'Full-screen ad when people come back to the app.'],
    ],
    'features' => [
        'downloads' => ['Downloads', 'Download button in the player and Downloads in the Library.'],
        'openVideosInReelway' => ['Open videos in Reelway', 'Videos and series move into Reelway by themselves.'],
        'backgroundPlay' => ['Play in background (iPhone)', 'YouTube audio keeps playing when the app is left or the screen locks. iPhone only: stays off on the Play Store.'],
        'playOnTv' => ['Play on TV', 'Chromecast button in the player.'],
        'library' => ['Library', 'Library tab with movies, series and Continue watching. Off: only browser, history and settings show.'],
        'blockWebsiteAds' => ['Block website ads', 'Blocks ad networks on websites. Wins over the setting inside the app. Sites set to "Allowed" below keep their own ads.'],
    ],
];
$units = [
    'banner' => 'Banner',
    'interstitial' => 'Between episodes (interstitial)',
    'appOpen' => 'When the app opens',
];
$numbers = [
    'interstitialEveryEpisodes' => ['Ad every how many episodes', 1, 20, 3],
    'interstitialCooldownSeconds' => ['Minimum seconds between full-screen ads', 0, 900, 90],
    'appOpenCooldownMinutes' => ['Minimum minutes between app open ads', 0, 240, 4],
];

$config = json_decode((string) @file_get_contents(CONFIG), true);
if (!is_array($config)) $config = [];
$stores = ['ios' => 'App Store (iPhone)', 'android' => 'Play Store (Android)'];
$store = (string) ($_POST['store'] ?? $_GET['store'] ?? 'ios');
if (!isset($stores[$store])) $store = 'ios';
/// The settings of one store: top level for iPhone, "android" for Android.
function store_settings(array $config, string $store): array {
    if ($store === 'ios') { unset($config['android']); return $config; }
    return is_array($config['android'] ?? null) ? $config['android'] : [];
}
$settings = store_settings($config, $store);
$saved = false;
$pushed = false;
$error = null;

if (empty($_SESSION['csrf'])) $_SESSION['csrf'] = bin2hex(random_bytes(16));

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!hash_equals($_SESSION['csrf'], (string) ($_POST['csrf'] ?? ''))) {
        $error = 'The page expired. Reload it and try again.';
    } elseif (($_POST['do'] ?? '') === 'push') {
        // A push for an announcement already saved.
        $found = null;
        foreach (($settings['announcements'] ?? []) as $a) if (is_array($a) && ($a['id'] ?? '') === (string) ($_POST['push']['announcement'] ?? '')) $found = $a;
        $built = push_from_form($_POST['push'] ?? [], $found);
        if (is_string($built)) $error = $built;
        elseif (empty($_POST['push_confirm'])) $error = 'Tick the box to confirm you want to send it.';
        else {
            $error = push_send($store, ...$built);
            if ($error === null) $pushed = true;
        }
    } else {
        $next = $settings;
        foreach ($switches as $group => $items) {
            foreach ($items as $key => $_) {
                if ($store === 'android' && $key === 'backgroundPlay') { $next[$group][$key] = false; continue; }
                $next[$group][$key] = isset($_POST[$group][$key]);
            }
        }
        foreach ($numbers as $key => [$label, $min, $max, $default]) {
            $value = filter_var($_POST['ads'][$key] ?? null, FILTER_VALIDATE_INT);
            if ($value === false || $value < $min || $value > $max) {
                $error = "$label must be between $min and $max.";
                break;
            }
            $next['ads'][$key] = $value;
        }
        // Ad unit IDs: main and backup per format. Empty means the app's own.
        foreach (['units', 'backupUnits'] as $group) {
            if ($error !== null) break;
            $ids = [];
            foreach ($units as $format => $label) {
                $id = trim((string) ($_POST['ads'][$group][$format] ?? ''));
                if ($id === '') continue;
                if (!preg_match('~^ca-app-pub-\d{10,20}/\d{6,12}$~', $id)) {
                    $error = "$label: an ad unit ID looks like ca-app-pub-1234567890123456/1234567890 (with a slash, not ~).";
                    break;
                }
                $ids[$format] = $id;
            }
            if ($ids) $next['ads'][$group] = $ids; else unset($next['ads'][$group]);
        }
        if ($error === null) {
            $list = announcements_from_form($_POST['ann'] ?? [], $_POST['new_ann'] ?? []);
            if (is_string($list)) $error = $list; else $next['announcements'] = $list;
        }
        if ($error === null) {
            // Websites: edits to existing rows, removals, and one new site.
            $sites = [];
            foreach (($_POST['sites'] ?? []) as $domain => $row) {
                if (!is_array($row) || isset($row['delete'])) continue;
                $site = site_from_form($row, (string) $domain);
                if (is_string($site)) { $error = $site; break; }
                $sites[(string) $domain] = $site;
            }
            $newUrl = trim((string) ($_POST['new_site']['url'] ?? ''));
            if ($error === null && $newUrl !== '') {
                $parts = parse_url(preg_match('~^https?://~i', $newUrl) ? $newUrl : "https://$newUrl");
                $host = strtolower((string) ($parts['host'] ?? ''));
                if (!preg_match('/^[a-z0-9.-]+\.[a-z]{2,}$/', $host)) {
                    $error = 'That website link is not valid.';
                } else {
                    $domain = site_domain($host);
                    $name = trim((string) ($_POST['new_site']['name'] ?? '')) ?: $domain;
                    $sites[$domain] = ($sites[$domain] ?? []) + [
                        'name' => $name,
                        'url' => 'https://' . $host . ($parts['path'] ?? '/'),
                    ];
                }
            }
            if ($error === null) $next['sites'] = $sites ?: new stdClass();
        }
        if ($error === null) {
            // Put this store's settings back; the other store is untouched.
            if ($store === 'ios') {
                if (isset($config['android'])) $next['android'] = $config['android'];
            } else {
                $next = array_merge($config, ['android' => $next]);
            }
            $json = json_encode($next, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES) . "\n";
            @copy(CONFIG, CONFIG . '.previous');
            $tmp = CONFIG . '.tmp';
            if (file_put_contents($tmp, $json, LOCK_EX) === false || !rename($tmp, CONFIG)) {
                $error = 'Could not save. Check that www-data can write ' . CONFIG . '.';
            } else {
                $config = $next;
                $settings = store_settings($config, $store);
                $saved = true;
                if (!empty($_POST['push_send']) && trim((string) ($_POST['new_ann']['title'] ?? '')) !== '') {
                    $built = push_from_form($_POST['new_push'] ?? [], $next['announcements'][0] ?? null);
                    if (is_string($built)) {
                        $error = 'Saved, but no notification was sent: ' . $built;
                    } else {
                        $sent = push_send($store, ...$built);
                        if ($sent === null) $pushed = true; else $error = 'Saved, but the notification was not sent: ' . $sent;
                    }
                }
            }
        }
    }
}

/// Main domain of a host: reelshort.chartdrama.com -> chartdrama.com.
function site_domain(string $host): string {
    $labels = explode('.', preg_replace('/^www\./', '', $host));
    $two = implode('.', array_slice($labels, -2));
    $countrySeconds = ['co.uk', 'com.br', 'com.tr', 'co.jp', 'com.au', 'com.mx', 'co.id', 'com.ar', 'co.za'];
    return in_array($two, $countrySeconds, true) && count($labels) > 2 ? implode('.', array_slice($labels, -3)) : $two;
}

/// One website row from the form, or an error message.
function site_from_form(array $row, string $domain) {
    $site = [
        'name' => trim((string) ($row['name'] ?? '')) ?: $domain,
        'url' => trim((string) ($row['url'] ?? '')) ?: "https://$domain/",
    ];
    $method = (string) ($row['episodes'] ?? 'auto');
    if (in_array($method, ['links', 'buttons', 'param'], true)) $site['episodes'] = $method;
    $param = trim((string) ($row['param'] ?? ''));
    if ($param !== '') {
        if (!preg_match('/^[A-Za-z0-9_]{1,20}$/', $param)) return "Episode parameter for $domain must be letters or numbers.";
        $site['param'] = $param;
    }
    $path = trim((string) ($row['seriesPath'] ?? ''));
    if ($path !== '') {
        if (@preg_match('~' . str_replace('~', '\~', $path) . '~', '') === false) return "Series address pattern for $domain is not valid.";
        $site['seriesPath'] = $path;
    }
    if (!isset($row['autoOpen'])) $site['autoOpen'] = false;
    // Each store has its own list, so "Allowed" simply means on this store.
    if ((string) ($row['allowAds'] ?? '') === 'all') $site['allowAds'] = 'all';
    if (isset($row['featured'])) $site['featured'] = true;
    return $site;
}

/// One action from the form: ['type' => ..., 'value' => ..., 'label' => ...], null for none, or an error string.
function action_from_form(array $row) {
    $type = (string) ($row['type'] ?? '');
    if ($type === '') return null;
    if (!isset(ANN_TARGETS[$type])) return 'That button action is not valid.';
    $action = ['type' => $type];
    if ($type === 'url') {
        $url = trim((string) ($row['value'] ?? ''));
        if ($url !== '' && !preg_match('~^https?://~i', $url)) $url = "https://$url";
        $parts = parse_url($url);
        if (!$parts || empty($parts['host']) || !preg_match('/^[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/', $parts['host'])) return 'The button website link is not valid.';
        $action['value'] = $url;
    }
    $label = trim((string) ($row['label'] ?? ''));
    if ($label !== '') $action['label'] = mb_substr($label, 0, 40);
    return $action;
}

/// The announcements list from the form: existing rows (in order, minus removed), then a new one on top.
function announcements_from_form($rows, $new) {
    $out = [];
    $make = function (array $row, string $id) {
        $title = trim((string) ($row['title'] ?? ''));
        $body = trim((string) ($row['body'] ?? ''));
        if ($title === '') return 'Every announcement needs a title.';
        if (mb_strlen($title) > 80) return 'A title can be at most 80 characters.';
        if (mb_strlen($body) > 3000) return 'A text can be at most 3000 characters.';
        $a = ['id' => $id, 'title' => $title, 'body' => $body, 'date' => preg_match('/^\d{4}-\d{2}-\d{2}$/', (string) ($row['date'] ?? '')) ? $row['date'] : date('Y-m-d')];
        $action = action_from_form(is_array($row['action'] ?? null) ? $row['action'] : []);
        if (is_string($action)) return $action;
        if ($action) $a['action'] = $action;
        return $a;
    };
    $newTitle = trim((string) ($new['title'] ?? ''));
    if ($newTitle !== '') {
        $a = $make($new, 'n' . time() . bin2hex(random_bytes(2)));
        if (is_string($a)) return $a;
        $out[] = $a;
    }
    if (is_array($rows)) foreach ($rows as $id => $row) {
        if (!is_array($row) || isset($row['delete']) || !preg_match('/^[A-Za-z0-9_-]{1,40}$/', (string) $id)) continue;
        $a = $make($row, (string) $id);
        if (is_string($a)) return $a;
        $out[] = $a;
    }
    return $out;
}


function b64url(string $s): string { return rtrim(strtr(base64_encode($s), '+/', '-_'), '='); }

/// The service account key, or null when it is not on the server yet.
function push_key(): ?array {
    if (!is_readable(PUSH_KEY)) return null;
    $k = json_decode((string) file_get_contents(PUSH_KEY), true);
    return is_array($k) && isset($k['client_email'], $k['private_key'], $k['project_id']) ? $k : null;
}

/// A signed OAuth assertion for the FCM scope (RS256).
function push_jwt(array $key, int $now): ?string {
    $head = b64url(json_encode(['alg' => 'RS256', 'typ' => 'JWT']));
    $claims = b64url(json_encode([
        'iss' => $key['client_email'], 'scope' => 'https://www.googleapis.com/auth/firebase.messaging',
        'aud' => 'https://oauth2.googleapis.com/token', 'iat' => $now, 'exp' => $now + 3000,
    ]));
    $sig = '';
    if (!openssl_sign("$head.$claims", $sig, $key['private_key'], OPENSSL_ALGO_SHA256)) return null;
    return "$head.$claims." . b64url($sig);
}

/// The FCM v1 message for one store's topic. Data values must be strings.
function push_message(string $store, string $title, string $body, array $data): array {
    return ['message' => [
        'topic' => PUSH_TOPICS[$store],
        'notification' => ['title' => $title, 'body' => $body],
        'data' => array_map('strval', $data),
        'android' => ['priority' => 'high'],
        'apns' => ['payload' => ['aps' => ['sound' => 'default']]],
    ]];
}

function http_post(string $url, string $body, array $headers): array {
    $ch = curl_init($url);
    curl_setopt_array($ch, [CURLOPT_POST => true, CURLOPT_POSTFIELDS => $body, CURLOPT_HTTPHEADER => $headers,
        CURLOPT_RETURNTRANSFER => true, CURLOPT_TIMEOUT => 20]);
    $out = (string) curl_exec($ch);
    $code = (int) curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    return [$code, $out];
}

/// Sends the push; returns null on success or an error message.
function push_send(string $store, string $title, string $body, array $data): ?string {
    $key = push_key();
    if ($key === null) return 'Push is not set up on the server yet (service account key missing).';
    $jwt = push_jwt($key, time());
    if ($jwt === null) return 'The service account key could not be used.';
    [$code, $out] = http_post('https://oauth2.googleapis.com/token',
        http_build_query(['grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer', 'assertion' => $jwt]),
        ['Content-Type: application/x-www-form-urlencoded']);
    $token = json_decode($out, true)['access_token'] ?? null;
    if ($code !== 200 || !$token) return 'Google did not accept the key (' . $code . ').';
    [$code, $out] = http_post('https://fcm.googleapis.com/v1/projects/' . rawurlencode($key['project_id']) . '/messages:send',
        json_encode(push_message($store, $title, $body, $data)),
        ['Authorization: Bearer ' . $token, 'Content-Type: application/json']);
    if ($code === 200) return null;
    $msg = json_decode($out, true)['error']['message'] ?? '';
    return 'Sending failed (' . $code . '). ' . mb_substr($msg, 0, 200);
}

/// Title, body and data for a push from the form fields, or an error string.
function push_from_form(array $f, ?array $announcement) {
    $target = (string) ($f['target'] ?? 'announcement');
    if (!isset(PUSH_TARGETS[$target])) return 'That notification target is not valid.';
    $title = trim((string) ($f['title'] ?? ''));
    $body = trim((string) ($f['body'] ?? ''));
    if ($announcement) {
        if ($title === '') $title = (string) $announcement['title'];
        if ($body === '') $body = mb_substr((string) $announcement['body'], 0, 140);
    }
    if ($title === '') return 'The notification needs a title.';
    $data = ['target' => $target];
    if ($target === 'announcement') {
        if (!$announcement) return 'Pick an announcement for the notification to open.';
        $data['id'] = $announcement['id'];
    } elseif ($target === 'url') {
        $url = trim((string) ($f['url'] ?? ''));
        if ($url !== '' && !preg_match('~^https?://~i', $url)) $url = "https://$url";
        $p = parse_url($url);
        if (!$p || empty($p['host']) || !preg_match('/^[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/', $p['host'])) return 'The notification website link is not valid.';
        $data['value'] = $url;
    }
    return [mb_substr($title, 0, 65), mb_substr($body, 0, 178), $data];
}

function on(array $config, string $group, string $key): bool {
    return ($config[$group][$key] ?? true) === true;
}
function h(string $s): string { return htmlspecialchars($s, ENT_QUOTES); }
?>
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="robots" content="noindex">
<title>Reelway admin</title>
<style>
  :root { --bg:#111116; --surface:#191920; --line:#2c2c38; --text:#f4f4f6; --muted:#a3a3b2; --accent:#e85d35; }
  * { box-sizing: border-box; }
  body { margin:0; background:var(--bg); color:var(--text); font-family:-apple-system,system-ui,sans-serif; line-height:1.5; }
  .wrap { max-width: 640px; margin: 0 auto; padding: 24px 16px 60px; }
  h1 { font-size: 24px; margin: 8px 0 4px; }
  .note { color: var(--muted); font-size: 14px; margin: 0 0 24px; }
  h2 { font-size: 13px; text-transform: uppercase; letter-spacing: .06em; color: var(--muted); margin: 28px 0 10px; }
  .card { background: var(--surface); border: 1px solid var(--line); border-radius: 16px; overflow: hidden; }
  .row { display: flex; align-items: center; gap: 16px; padding: 14px 16px; border-top: 1px solid var(--line); }
  .row:first-child { border-top: 0; }
  .row div { flex: 1; }
  .row b { display: block; font-weight: 600; }
  .row small { color: var(--muted); }
  .switch { position: relative; width: 50px; height: 30px; flex: none; }
  .switch input { opacity: 0; width: 0; height: 0; }
  .switch span { position: absolute; inset: 0; background: #3a3a48; border-radius: 30px; transition: .2s; cursor: pointer; }
  .switch span:before { content: ""; position: absolute; width: 24px; height: 24px; left: 3px; top: 3px; background: #fff; border-radius: 50%; transition: .2s; }
  .switch input:checked + span { background: var(--accent); }
  .switch input:checked + span:before { transform: translateX(20px); }
  input[type=number] { width: 90px; padding: 8px 10px; border-radius: 10px; border: 1px solid var(--line); background: #0d0d12; color: var(--text); font-size: 16px; }
  button { margin-top: 24px; width: 100%; padding: 14px; border: 0; border-radius: 14px; background: var(--accent); color: #fff; font-size: 16px; font-weight: 600; cursor: pointer; }
  .msg { padding: 12px 14px; border-radius: 12px; margin-bottom: 16px; }
  .ok { background: rgba(48,164,108,.15); color: #6ee7a8; }
  .err { background: rgba(229,72,77,.15); color: #ff8a8e; }
  .site { margin-bottom: 12px; }
  .field { display: flex; align-items: center; gap: 12px; }
  .field span { width: 120px; flex: none; color: var(--muted); font-size: 14px; }
  .field textarea { flex: 1; min-width: 0; padding: 9px 10px; border-radius: 10px; border: 1px solid var(--line); background: #0d0d12; color: var(--text); font-size: 15px; font-family: inherit; }
  .field input[type=text], .field input[type=url], .field select { flex: 1; min-width: 0; padding: 9px 10px; border-radius: 10px; border: 1px solid var(--line); background: #0d0d12; color: var(--text); font-size: 15px; }
  .del { color: #ff8a8e; font-size: 14px; display: flex; gap: 6px; align-items: center; }
  .adv { display: block; }
  .adv summary { cursor: pointer; color: var(--muted); }
  .adv .field { margin-top: 10px; }
  .tabs { display: flex; gap: 8px; margin: 0 0 8px; }
  .tabs a { flex: 1; text-align: center; padding: 12px 8px; border-radius: 14px; border: 1px solid var(--line); background: var(--surface); color: var(--muted); text-decoration: none; font-weight: 600; font-size: 15px; }
  .tabs a.on { background: var(--accent); border-color: var(--accent); color: #fff; }
</style>
</head>
<body>
<div class="wrap">
  <h1>Reelway admin</h1>
  <nav class="tabs"><?php foreach ($stores as $k => $label): ?><a href="?store=<?= $k ?>" class="<?= $k === $store ? 'on' : '' ?>"><?= h($label) ?></a><?php endforeach; ?></nav>
  <p class="note">You are editing the <b><?= h($stores[$store]) ?></b> app only. Changes reach it when the app opens or comes back to the screen.</p>
  <?php if ($saved): ?><div class="msg ok">Saved for <?= h($stores[$store]) ?>.</div><?php endif; ?>
  <?php if ($pushed): ?><div class="msg ok">Notification sent to everyone on <?= h($stores[$store]) ?> who turned notifications on.</div><?php endif; ?>
  <?php if ($error): ?><div class="msg err"><?= h($error) ?></div><?php endif; ?>
  <form method="post">
    <input type="hidden" name="csrf" value="<?= h($_SESSION['csrf']) ?>">
    <input type="hidden" name="store" value="<?= h($store) ?>">
    <h2>Announcements</h2>
    <p class="note" style="margin:0 0 12px">People see the newest one they have not read when they open the app, and can read all of them later under Settings, News. The newest is on top. Sending a push notification is a separate step below, after you save.</p>
    <?php foreach (($settings['announcements'] ?? []) as $a): if (!is_array($a) || !isset($a['id'])) continue; $i = h((string) $a['id']); $act = is_array($a['action'] ?? null) ? $a['action'] : []; ?>
      <div class="card site">
        <div class="row"><div><b><?= h((string) ($a['title'] ?? '')) ?></b><small><?= h((string) ($a['date'] ?? '')) ?></small></div>
          <label class="del"><input type="checkbox" name="ann[<?= $i ?>][delete]"> Remove</label></div>
        <input type="hidden" name="ann[<?= $i ?>][date]" value="<?= h((string) ($a['date'] ?? '')) ?>">
        <div class="row field"><span>Title</span><input type="text" maxlength="80" name="ann[<?= $i ?>][title]" value="<?= h((string) ($a['title'] ?? '')) ?>"></div>
        <div class="row field"><span>Text</span><textarea rows="5" name="ann[<?= $i ?>][body]"><?= h((string) ($a['body'] ?? '')) ?></textarea></div>
        <div class="row field"><span>Button</span><select name="ann[<?= $i ?>][action][type]">
          <?php foreach (ANN_TARGETS as $v => $label): ?><option value="<?= $v ?>" <?= ($act['type'] ?? '') === $v ? 'selected' : '' ?>><?= h($label) ?></option><?php endforeach; ?></select></div>
        <div class="row field"><span>Website link</span><input type="text" placeholder="https:// (only for a website button)" name="ann[<?= $i ?>][action][value]" value="<?= h((string) ($act['value'] ?? '')) ?>"></div>
        <div class="row field"><span>Button text</span><input type="text" maxlength="40" placeholder="Optional" name="ann[<?= $i ?>][action][label]" value="<?= h((string) ($act['label'] ?? '')) ?>"></div>
      </div>
    <?php endforeach; ?>
    <div class="card site">
      <div class="row"><div><b>New announcement</b><small>Leave the title empty to add nothing. Saved on top of the list.</small></div></div>
      <div class="row field"><span>Title</span><input type="text" maxlength="80" name="new_ann[title]"></div>
      <div class="row field"><span>Text</span><textarea rows="5" name="new_ann[body]"></textarea></div>
      <div class="row field"><span>Button</span><select name="new_ann[action][type]">
        <?php foreach (ANN_TARGETS as $v => $label): ?><option value="<?= $v ?>"><?= h($label) ?></option><?php endforeach; ?></select></div>
      <div class="row field"><span>Website link</span><input type="text" placeholder="https:// (only for a website button)" name="new_ann[action][value]"></div>
      <div class="row field"><span>Button text</span><input type="text" maxlength="40" placeholder="Optional" name="new_ann[action][label]"></div>
      <div class="row field"><span>Notification</span><label class="del" style="color:var(--text)"><input type="checkbox" name="push_send"> Also send as push notification</label></div>
      <div class="row field"><span>Opens</span><select name="new_push[target]">
        <?php foreach (PUSH_TARGETS as $v => $label): ?><option value="<?= $v ?>"><?= h($label) ?></option><?php endforeach; ?></select></div>
      <div class="row field"><span>Website link</span><input type="text" placeholder="Only for a website target" name="new_push[url]"></div>
      <div class="row field"><span>Short text</span><input type="text" maxlength="178" placeholder="Optional. Empty uses the start of the text above." name="new_push[body]"></div>
    </div>
    <h2>Ads</h2>
    <div class="card">
      <?php foreach ($switches['ads'] as $key => [$label, $hint]): ?>
        <label class="row"><div><b><?= h($label) ?></b><small><?= h($hint) ?></small></div>
          <span class="switch"><input type="checkbox" name="ads[<?= h($key) ?>]" <?= on($settings, 'ads', $key) ? 'checked' : '' ?>><span></span></span></label>
      <?php endforeach; ?>
    </div>
    <h2>Ad frequency</h2>
    <div class="card">
      <?php foreach ($numbers as $key => [$label, $min, $max, $default]): ?>
        <label class="row"><div><b><?= h($label) ?></b><small><?= $min ?> to <?= $max ?></small></div>
          <input type="number" name="ads[<?= h($key) ?>]" min="<?= $min ?>" max="<?= $max ?>" value="<?= (int) ($settings['ads'][$key] ?? $default) ?>"></label>
      <?php endforeach; ?>
    </div>
    <h2>Ad units</h2>
    <p class="note" style="margin:0 0 12px">AdMob unit IDs for this store's app. The backup is tried only when the main unit has no ad. Leave empty to use the units built into the app. Test builds always show Google's test ads.</p>
    <div class="card">
      <?php foreach ($units as $format => $label): ?>
        <div class="row field"><span><?= h($label) ?></span><input type="text" placeholder="Main: ca-app-pub-.../..." name="ads[units][<?= $format ?>]" value="<?= h((string) ($settings['ads']['units'][$format] ?? '')) ?>"></div>
        <div class="row field"><span>Backup</span><input type="text" placeholder="Backup (optional)" name="ads[backupUnits][<?= $format ?>]" value="<?= h((string) ($settings['ads']['backupUnits'][$format] ?? '')) ?>"></div>
      <?php endforeach; ?>
    </div>
    <h2>Features</h2>
    <div class="card">
      <?php foreach ($switches['features'] as $key => [$label, $hint]): ?>
        <?php if ($store === 'android' && $key === 'backgroundPlay'): ?>
        <div class="row"><div><b><?= h($label) ?></b><small>Not available on the Play Store (Google Play policy). Always off.</small></div></div>
        <?php continue; endif; ?>
        <label class="row"><div><b><?= h($label) ?></b><small><?= h($hint) ?></small></div>
          <span class="switch"><input type="checkbox" name="features[<?= h($key) ?>]" <?= on($settings, 'features', $key) ? 'checked' : '' ?>><span></span></span></label>
      <?php endforeach; ?>
    </div>
    <h2>Websites</h2>
    <p class="note" style="margin:0 0 12px">Add a site with its link: Reelway detects its episodes automatically. Advanced settings are only for sites that need special handling.</p>
    <?php $sites = is_array($settings['sites'] ?? null) ? $settings['sites'] : []; ?>
    <?php foreach ($sites as $domain => $site): $site = is_array($site) ? $site : []; $d = h((string) $domain); ?>
      <div class="card site">
        <div class="row"><div><b><?= h((string) ($site['name'] ?? $domain)) ?></b><small><?= $d ?></small></div>
          <label class="del"><input type="checkbox" name="sites[<?= $d ?>][delete]"> Remove</label></div>
        <div class="row field"><span>Name</span><input type="text" name="sites[<?= $d ?>][name]" value="<?= h((string) ($site['name'] ?? '')) ?>"></div>
        <div class="row field"><span>Link</span><input type="url" name="sites[<?= $d ?>][url]" value="<?= h((string) ($site['url'] ?? "https://$domain/")) ?>"></div>
        <label class="row"><div><b>Show on start page</b><small>One tap from the app's start page.</small></div>
          <span class="switch"><input type="checkbox" name="sites[<?= $d ?>][featured]" <?= !empty($site['featured']) ? 'checked' : '' ?>><span></span></span></label>
        <label class="row"><div><b>Open videos in Reelway</b><small>Off keeps this site's videos in the browser.</small></div>
          <span class="switch"><input type="checkbox" name="sites[<?= $d ?>][autoOpen]" <?= ($site['autoOpen'] ?? true) ? 'checked' : '' ?>><span></span></span></label>
        <div class="row field"><span>Website's own ads</span><select name="sites[<?= $d ?>][allowAds]">
          <?php $allowed = ($site['allowAds'] ?? '') === 'all' || ($store === 'android' && ($site['allowAds'] ?? '') === 'android'); ?>
          <?php foreach (['' => 'Blocked (pop-up protection on)', 'all' => 'Allowed'] as $v => $label): ?>
            <option value="<?= $v ?>" <?= ($v === 'all') === $allowed ? 'selected' : '' ?>><?= $label ?></option>
          <?php endforeach; ?></select></div>
        <details class="row adv"><summary>Advanced</summary>
          <div class="field"><span>Episodes</span><select name="sites[<?= $d ?>][episodes]">
            <?php foreach (['auto' => 'Automatic', 'links' => 'Episode links', 'buttons' => 'Episode buttons', 'param' => 'Number in the address'] as $v => $label): ?>
              <option value="<?= $v ?>" <?= ($site['episodes'] ?? 'auto') === $v ? 'selected' : '' ?>><?= $label ?></option>
            <?php endforeach; ?></select></div>
          <div class="field"><span>Address parameter</span><input type="text" placeholder="ep" name="sites[<?= $d ?>][param]" value="<?= h((string) ($site['param'] ?? '')) ?>"></div>
          <div class="field"><span>Series addresses</span><input type="text" placeholder="^/detail/watch/" name="sites[<?= $d ?>][seriesPath]" value="<?= h((string) ($site['seriesPath'] ?? '')) ?>"></div>
        </details>
      </div>
    <?php endforeach; ?>
    <div class="card site">
      <div class="row"><div><b>Add a website</b><small>Name and link, for example https://liderdrama.com</small></div></div>
      <div class="row field"><span>Name</span><input type="text" name="new_site[name]" placeholder="LiderDrama"></div>
      <div class="row field"><span>Link</span><input type="text" name="new_site[url]" placeholder="https://"></div>
    </div>
    <button type="submit">Save <?= h($stores[$store]) ?></button>
  </form>
  <h2>Send a push notification</h2>
  <?php $anns = array_values(array_filter($settings['announcements'] ?? [], 'is_array')); ?>
  <?php if (push_key() === null): ?>
    <p class="note">Push is not set up on the server yet. After the Firebase service account key is placed on the server, this section works.</p>
  <?php elseif (!$anns): ?>
    <p class="note">Save an announcement first.</p>
  <?php else: ?>
  <p class="note" style="margin:0 0 12px">Goes to everyone on <?= h($stores[$store]) ?> who turned notifications on. It cannot be taken back, so check the text.</p>
  <form method="post" class="card">
    <input type="hidden" name="csrf" value="<?= h($_SESSION['csrf']) ?>">
    <input type="hidden" name="store" value="<?= h($store) ?>">
    <input type="hidden" name="do" value="push">
    <div class="row field"><span>Announcement</span><select name="push[announcement]">
      <?php foreach ($anns as $a): ?><option value="<?= h((string) $a['id']) ?>"><?= h((string) $a['title']) ?></option><?php endforeach; ?></select></div>
    <div class="row field"><span>Opens</span><select name="push[target]">
      <?php foreach (PUSH_TARGETS as $v => $label): ?><option value="<?= $v ?>"><?= h($label) ?></option><?php endforeach; ?></select></div>
    <div class="row field"><span>Website link</span><input type="text" placeholder="Only for a website target" name="push[url]"></div>
    <div class="row field"><span>Title</span><input type="text" maxlength="65" placeholder="Empty uses the announcement title" name="push[title]"></div>
    <div class="row field"><span>Short text</span><input type="text" maxlength="178" placeholder="Empty uses the start of the announcement text" name="push[body]"></div>
    <label class="row"><div><b>Yes, send it now</b><small>To <?= h($stores[$store]) ?> only.</small></div><input type="checkbox" name="push_confirm"></label>
    <div class="row"><button type="submit" style="margin:0">Send push notification</button></div>
  </form>
  <?php endif; ?>
</div>
</body>
</html>
