# Android TV acceptance — follow-up to 5.9.19

User report (Tuvio Android 11): sidebar navigation works, but Right loses visible focus, OK sometimes activates an unknown target, Left fails to return to the sidebar, and response is occasionally laggy.

- Verify Home, Profiles, Settings, Logs, About: visible focus, Right enters page, Left at boundary returns to sidebar, OK activates only focused control.
- Verify nested pages, lists, dialogs, initial language/region setup, VPN power button, and update dialog.
- Verify retained focus after route change, hidden controls never receive focus, no repeated OK activation.
- Splash: higher-resolution transparent orbit logo, gentle pulse.
- Launcher activity icon and banner: orbit D; application/installer icon remains square dark D (launchers may choose application icon).
- Home notice: «Для открытия всех стран в вашей подписке, нажмите Подключиться.»
- Healthy idle/connected button captions: «Подключиться» / «Отключиться». Keep pending/error/degraded states informative.
- VPN logic and production signing unchanged. Real-device test remains required.
