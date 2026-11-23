# DoomNet Android TV artwork

Two supplied user artworks deliberately serve different surfaces:

- `android/app/src/main/res/drawable-nodpi/doomnet_launcher.webp` —
  glass-green **D without the ring** on a dark square background. Used as the
  Android app/installer icon, round icon, and system app identification.
- `android/app/src/main/res/drawable-nodpi/doomnet_tv_banner.webp` —
  the same glass-green D, laid out in the Android TV launcher banner ratio.
- `assets/images/doomnet_orbit.webp` —
  the **earlier green D with orbit/ring**, PNG-derived with a transparent
  background and WebP-compressed for a smaller Android TV APK. Appears inside
  DoomNet (onboarding, Home header, About) and replaces splash text.

The 3-second Flutter introduction uses a very small scale pulse
(1.000–1.035–1.000) and keeps the original soft fade to the main interface.

The original Hiddify source artwork remains in the repo where required for
source compatibility, licenses or other platforms, but the Android manifest
points to DoomNet's replacement icons instead of those legacy resources.
