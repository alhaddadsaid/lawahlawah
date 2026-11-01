# Reelway

A streaming-focused mobile **web browser** for iOS and Android, built with Flutter.
It looks like a premium movie/TV app but is a real browser: you add websites, browse
them with pop-up and redirect protection, and keep your library, history and progress
in one clean interface.

Reelway does **not** host, upload or redistribute video. Website catalogue integrations
are switched on only when the site's permission and content rights are documented.

| Home | Detail | Library | History | Settings |
|---|---|---|---|---|
| ![](docs/screenshots/01-home.png) | ![](docs/screenshots/07-detail.png) | ![](docs/screenshots/04-library.png) | ![](docs/screenshots/05-history.png) | ![](docs/screenshots/06-settings.png) |

_Screens show invented sample titles (debug builds only)._

## Status
Phase 1 (UI/UX) done; phase 2 (browser engine) written, with the decision logic unit-tested
and the WebView wiring awaiting device testing. See [docs/ROADMAP.md](docs/ROADMAP.md).

## Run it
```bash
flutter pub get
flutter run            # on a connected iPhone/Android device or emulator
flutter test           # 48 unit + widget tests
flutter analyze
```
Requirements: Flutter stable (3.38+), Xcode for iOS, Android Studio/SDK for Android.

CI (GitHub Actions) runs format, analyze and tests, builds a debug Android APK (downloadable
from the run's artifacts) and an unsigned iOS build on every push.

## Docs
- [Architecture](docs/ARCHITECTURE.md): modules, browser engine, adapters, security
- [Design system](docs/DESIGN_SYSTEM.md): colours, type, components
- [Roadmap and status](docs/ROADMAP.md): phases, what's tested, known limits
- [Compliance checklist](docs/COMPLIANCE_CHECKLIST.md): run before every release
- [FlutterFlow workflow](docs/FLUTTERFLOW.md)
