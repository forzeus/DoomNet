import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hiddify/doomnet/doomnet_brand.dart';

/// Desktop title adapts to resizable Windows windows without changing TV.
class DoomNetWindowsHeader extends StatelessWidget {
  const DoomNetWindowsHeader({super.key});

  static const notice = 'Для открытия всех стран в вашей подписке, нажмите Подключиться.';

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final compact = constraints.maxWidth < 420;
      return Row(
        children: [
          Image.asset(
            'assets/images/doomnet_orbit_hd.png',
            width: compact ? 28 : 38,
            height: compact ? 28 : 38,
            filterQuality: FilterQuality.medium,
          ),
          const Gap(8),
          Flexible(
            flex: compact ? 1 : 0,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: DoomNetBrand(fontSize: compact ? 20 : 24),
            ),
          ),
          if (!compact) ...[
            const Gap(16),
            Expanded(
              child: Text(
                notice,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ],
      );
    },
  );
}
