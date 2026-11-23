# DoomNet Android TV — first branding pass

DoomNet is a custom UI build of the **real Hiddify Flutter app**.
VPN, subscriptions and the original connection state machine remain in place.

## First pass

- Russian theme label: **Зелёный градиент** (the stored enum value stays `dark`).
- A deep-green-to-dark home background and green material theme colors.
- Animated DoomNet wordmark in the app bar, version without a chip.
- Existing round connection button now displays a vector power glyph; the original
  Hiddify logo is disabled in the existing painter. The VPN toggle is unchanged.
- Flutter startup overlay lasts three seconds, fading for the final 550 ms.
- Android native startup no longer paints the Hiddify logo. Android 12+ still
  shows its mandatory platform splash before the Flutter overlay.
- Fresh installs default to Russian and the green theme. User-selected settings
  are preserved.
- Android label: DoomNet; application ID: `com.forzeus.doomnet`. It is a separate
  application, so it does not upgrade an already installed official Hiddify.
- Update metadata endpoints now refer to `forzeus/DoomNet`. No signed DoomNet
  release is published by this change.

## Verification still needed

- Requires Flutter 3.38.5 and Dart 3.10.4 from `pubspec.yaml`.
- Regenerate slang translations (`dart run slang`) before the build.
- Run `dart format`, `flutter analyze`, Android release build and remote-control QA.
- Check actual frame times on an Android TV: fluidity cannot be guaranteed without
  running on the target hardware.
- Check start, connect, disconnect, profile add/select, TV focus, reduced-motion,
  Android 12 splash and system back button.
- Launcher icon, full translation audit, automated release/signing and actual
  GitHub Releases updater QA are follow-up work.
- Maintain a stable private signing key outside the repo for install-over updates.

## Credits and license

Based on Hiddify, https://github.com/hiddify/hiddify-app. Keep upstream
license, copyright notices and required attribution when distributing.
