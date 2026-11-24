# DoomNet TV: cautious optimization

Baseline: published signed tag `doomnet-v5.9.21` (e3c85f81e62f0a926b49d5873d213e002cc1ad6f).
The owner confirmed the stable version works on the TV.

## First small change
- Splash: separate the static gradient and HD logo into repaint boundaries.
- Apply the existing 3.5% pulse to the logo only, not the full-screen background.
- Drive the existing final 550 ms fade with FadeTransition. Keep the total three-second duration, PNG, input blocking, and focus restoration.
- Telegram channel: https://t.me/DoomNetClient (including app deep link).
- Add splash and link regression tests, and run existing remote, onboarding and update tests.

## Safety limits
Do not modify the VPN core, protocols, connection lifecycle, persistent data, native remote bridge, focus geometry, signing or updater.
Do not remove shared upstream resources or licenses to chase APK size. Existing home map and connection animations already have repaint isolation.
The expected rendering improvement is a smaller animated area during the splash, not a measured launch-speed, memory or APK-size improvement.
Measure on actual Android TV before any deeper changes; reject regressions and release with increasing version codes only.
