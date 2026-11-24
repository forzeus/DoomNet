# DoomNet Windows x64 — 5.9.23 preview

Both the portable ZIP and per-user Setup.exe use the same tested Windows binaries.
Setup installs into LocalAppData/Programs/DoomNet by default, creates Start menu and optional Desktop shortcuts, and registers uninstall. Russian and English installer languages.
Exit DoomNet fully via the tray before manual installation or upgrades. Setup does not force-kill apps or remove shared VPN services. TUN/service coexistence with Hiddify is not verified; test without Hiddify running. Do not disable antivirus. No Authenticode signing yet.

User profiles remain in doomnet_portable_data beside the executable. The installer does not delete that directory. To migrate from the earlier portable preview, exit both copies and copy that directory to the installed folder only before using the installed copy (keep a backup). Do not copy from one running app to another.

Windows updates use only doomnet-windows-vX.Y.Z tags containing DoomNet-Windows-Setup-x64.exe and DoomNet-Windows-Portable-x64.zip. Existing Android TV clients ignore this tag format. Publish Windows releases with latest=false, never replace an existing release. The installed copy is identified via doomnet-install.ini; portable updates open the release page. Existing SHA-256 download verification remains in place. No automatic publication until the owner tests installation. SHA-256 does not replace Authenticode. First full in-app update needs two published Windows versions and a PC test.

Source attribution and upstream licensing remain. Android TV main and 5.9.22 release untouched.
