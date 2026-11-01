# Working with FlutterFlow

This repo is plain Flutter, so FlutterFlow and hand-written code can live together.

## Recommended setup
1. Create the new GitHub repo and push this branch to it as `main`.
2. In FlutterFlow: **Settings → Integrations → GitHub**, connect the new repo.
3. FlutterFlow pushes to the **`flutterflow`** branch and **overwrites it on every push**.
   Never commit hand-written code there.
4. Hand-written code (browser engine, popup protection, adapters, player) lives on `main`.
   Merge `flutterflow` → `main` when you want FlutterFlow's visual changes.

## What to build where
| Build in FlutterFlow | Keep in code (this repo) |
|---|---|
| New marketing/onboarding pages | Browser engine and WebView settings |
| Visual tweaks to simple screens | Popup/redirect protection |
| Firebase/AdMob toggles (phase 6) | Website adapters and permission gate |
| | Video player wrapper |

To use code in FlutterFlow: add it as a **Custom Widget** (e.g. `BrowserView`) or **Custom
Action** (e.g. `UrlPolicy.parse`). FlutterFlow custom code must be self-contained per file,
so expect to copy the needed classes into the custom-code editor.

## Theme
Copy the colours and type scale from `docs/DESIGN_SYSTEM.md` into FlutterFlow Theme
Settings, and add Inter as a custom font.
