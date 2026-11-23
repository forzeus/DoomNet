import 'package:flutter/material.dart';
import 'package:hiddify/core/app_info/app_info_provider.dart';
import 'package:hiddify/core/localization/translations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// DoomNet TV navigation rail footer. Keep the version visible without a card.
class SidebarVersionLabel extends ConsumerWidget {
  const SidebarVersionLabel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // PackageInfo loads asynchronously on Android TV. Do not crash the
    // navigation rail while that tiny bit of metadata is still loading.
    final version = ref.watch(appInfoProvider).valueOrNull?.presentVersion;
    if (version == null) return const SizedBox.shrink();
    final t = ref.watch(translationsProvider).requireValue;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      child: Text(
        '${t.common.version} $version',
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
