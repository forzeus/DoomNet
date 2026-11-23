# DoomNet — онлайн-обновления без флешки

## Что уже есть в исходниках

Hiddify содержит рабочий GitHub updater: `AppUpdateNotifier` проверяет релизы,
`AppUpdater` определяет ABI Android, скачивает подходящий APK, сверяет SHA-256
и открывает системный установщик Android. На этом форке:

- ручная проверка: **О программе → Проверить обновления**;
- автоматическая проверка: **после запуска приложения**;
- GitHub API: `https://api.github.com/repos/forzeus/DoomNet/releases`;
- для ARM32: `DoomNet-Android-arm32.apk`;
- для ARM64: `DoomNet-Android-arm64.apk`;
- для x86_64: `DoomNet-Android-x86_64.apk`;
- резервная сборка: `DoomNet-Android-universal.apk`;
- теги: `doomnet-v5.9.16`, `doomnet-v5.9.17` и т.д.

Для запуска установки на Android TV пользователь подтверждает запрос установки
и может один раз разрешить DoomNet установку приложений из этого источника.
Автоматическая установка без подтверждения обычной ТВ-прошивкой не гарантируется.

## Один раз настроить постоянную подпись

Все будущие APK должны быть подписаны **одним и тем же keystore**. Ни в коем случае
не публикуйте keystore и его пароли в репозитории или открытом чате.

Для создания ключа на своём ПК (Java `keytool`):

```bash
keytool -genkeypair -v -keystore doomnet-release.jks -alias doomnet -keyalg RSA -keysize 3072 -validity 10000
```

Сохраните резервную копию `doomnet-release.jks` и паролей в надёжном месте.
Base64 для секретного поля `ANDROID_SIGNING_KEY`:
- Linux/macOS: `base64 -w 0 doomnet-release.jks` (на macOS `base64 < doomnet-release.jks | tr -d '\\n'`);
- PowerShell: `[Convert]::ToBase64String([IO.File]::ReadAllBytes("doomnet-release.jks"))`.

На GitHub в **Settings → Secrets and variables → Actions → New repository secret**:
1. `ANDROID_SIGNING_KEY` — base64 содержимое keystore;
2. `ANDROID_SIGNING_STORE_PASSWORD` — пароль хранилища;
3. `ANDROID_SIGNING_KEY_PASSWORD` — пароль ключа;
4. `ANDROID_SIGNING_KEY_ALIAS` — `doomnet`.

Не публикуйте свои пароли и keystore в Issues/PR/логах.

## Как выпустить первый постоянный APK

1. Проверьте код через CI и слейте рабочую ветку в `main`. GitHub показывает
   ручной workflow `DoomNet Android TV signed release` после появления его
   конфигурации в основной ветке.
2. Откройте GitHub → Actions → DoomNet Android TV signed release → Run workflow.
3. После успешной сборки GitHub опубликует релиз и четыре подписанных APK.
4. Для Tuvio Android 11 используйте `DoomNet-Android-arm32.apk`.
5. **Первый раз** может потребоваться удалить старую Preview-сборку: она
   подписана временным ключом GitHub runner, а Android не допускает обновление
   APK с другой подписью. Перед удалением сохраните URL/экспорт подписки.
6. Начиная с постоянной версии обновления скачиваются внутри DoomNet, без
   флешки: интерфейс предложит установку поверх старой версии.

## Следующие обновления

Поднимайте и `version`, и число после `+` в `pubspec.yaml`, например
`5.9.17+50917`. Публикуйте новую версию через тот же Actions workflow.
Нельзя менять keystore, package id `com.forzeus.doomnet` или уменьшать
`versionCode` — иначе установка поверх предыдущей версии не сработает.

## Проверки перед первым реальным релизом

- Сборка зелёная, включая `flutter analyze` и тесты updater.
- Тег/релиз не является Draft или Prerelease (если Beta Updates выключены).
- У файлов релиза в GitHub API есть поле `digest` вида `sha256:...`.
  Без него updater не устанавливает файл и сообщает об ошибке.
- Сначала вручную проверьте `О программе → Проверить обновления` на ТВ.
- Затем выпустите более новую версию и проверьте обновление поверх установленной
  стабильной версии без потери VPN-подписки.
- Если ТВ блокирует установку из неизвестных источников, разрешите её для
  DoomNet в настройках Android, затем повторите установку.
