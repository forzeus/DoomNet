import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hiddify/core/model/constants.dart';
import 'package:hiddify/doomnet/doomnet_intro_gate.dart';

void main() {
  test('DoomNet channel uses the same handle in browser and Telegram app', () {
    expect(Constants.telegramChannelUrl, 'https://t.me/DoomNetClient');
    expect(Constants.telegramChannelHandle, '@DoomNetClient');
    expect(Uri.parse(Constants.telegramChannelAppUrl).queryParameters['domain'], 'DoomNetClient');
  });

  testWidgets('splash animates only the HD logo, fades and restores controls after three seconds', (tester) async {
    var pressed = 0;
    final node = FocusNode();
    addTearDown(node.dispose);
    await tester.pumpWidget(MaterialApp(
      home: DoomNetIntroGate(
        child: Scaffold(
          body: Center(
            child: TextButton(
              focusNode: node,
              autofocus: true,
              onPressed: () => pressed++,
              child: const Text('Ready'),
            ),
          ),
        ),
      ),
    ));
    await tester.pump();
    final splash = find.byKey(const ValueKey('doomnet-splash'));
    final background = find.byKey(const ValueKey('doomnet-splash-background'));
    final pulse = find.byKey(const ValueKey('doomnet-splash-pulse'));
    final bounds = tester.getRect(background);
    expect(node.canRequestFocus, isFalse);
    await tester.tap(find.text('Ready'), warnIfMissed: false);
    expect(pressed, 0);
    await tester.pump(const Duration(milliseconds: 1500));
    expect(tester.widget<Transform>(pulse).transform.storage[0], closeTo(1.035, .001));
    expect(tester.getRect(background), bounds);
    expect(tester.widget<FadeTransition>(splash).opacity.value, 1);
    final image = tester.widget<Image>(find.descendant(of: pulse, matching: find.byType(Image)));
    expect(image.image, const AssetImage('assets/images/doomnet_orbit_hd.png'));
    expect(image.filterQuality, FilterQuality.high);

    await tester.pump(const Duration(milliseconds: 1200));
    expect(tester.widget<FadeTransition>(splash).opacity.value, inExclusiveRange(0, 1));
    expect(node.canRequestFocus, isFalse);
    // Flutter's interpolation simulation may still be running at exactly
    // its duration (opacity already zero). Advance one display frame past
    // the 3-second boundary so AnimationStatus.completed can remove the gate.
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 16));
    await tester.pump();
    expect(splash, findsNothing);
    expect(node.canRequestFocus, isTrue);
    await tester.tap(find.text('Ready'));
    await tester.pump();
    expect(pressed, 1);
  });
}
