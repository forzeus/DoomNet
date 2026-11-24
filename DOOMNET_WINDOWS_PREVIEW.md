# DoomNet for Windows — first x64 preview

Baseline: signed Android TV 5.9.22. This is an isolated Windows preview branch, not a published release.

## Build and contents
- Windows 10/11 x64 Flutter runner, with the existing upstream Windows VPN core.
- DoomNet.exe, DoomNet window title and metadata; original copyright retained.
- Windows app and tray icons generated from the existing HD D logo during Windows CI only.
- Responsive title and normal desktop navigation rail mouse/keyboard feedback.
- Portable ZIP, with data in doomnet_portable_data when writable. Extract the whole ZIP to a dedicated folder before launching. Do not copy just the EXE.
- No installer or Authenticode signing in this preview. Do not bypass antivirus or SmartScreen.
- URL handler registration disabled for the preview to avoid overriding existing app associations.

## Test scope and limitations
Test on a clean Windows test environment without Hiddify or another active VPN. The upstream core still has its original helper executable names and shared Windows service identity; coexistence has not been verified. No change to the VPN core or service logic. Avoid entering sensitive credentials into unverified builds.

Check startup, resizing, taskbar and tray, keyboard and mouse, importing a subscription from clipboard, connecting/disconnecting, system proxy restoration and exit. Test TUN and elevated service behavior separately. Installer, independent service identity, update asset selection and code signing remain later work. Do not publish Windows-only versions as the latest Android TV release.

Local build: generate icons with Python/Pillow, run make windows-prepare with CHANNEL=prod and then the portable flutter build command in .github/workflows/doomnet-windows-preview.yml. This preview requires the normal Flutter/Visual Studio C++ Windows toolchain.
