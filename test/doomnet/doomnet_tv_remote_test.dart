import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hiddify/doomnet/doomnet_tv_remote.dart';

void main() {
  testWidgets('native TV D-pad moves focus and OK activates it', (tester) async {
    final first = FocusNode(debugLabel: 'first');
    final second = FocusNode(debugLabel: 'second');
    addTearDown(first.dispose);
    addTearDown(second.dispose);
    var pressed = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: DoomNetTvRemoteBridge(
          child: Scaffold(
            body: Column(
              children: [
                ElevatedButton(
                  focusNode: first,
                  autofocus: true,
                  onPressed: () {},
                  child: const Text('First'),
                ),
                ElevatedButton(
                  focusNode: second,
                  onPressed: () => pressed++,
                  child: const Text('Second'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(first.hasFocus, isTrue);

    final context = tester.element(find.byType(DoomNetTvRemoteBridge));
    expect(DoomNetTvRemoteBridge.handleAndroidKey(context, 20), isTrue);
    await tester.pumpAndSettle();
    expect(second.hasFocus, isTrue, reason: 'Android DPAD_DOWN should move the focus');
    expect(DoomNetTvRemoteBridge.handleAndroidKey(context, 23), isTrue);
    await tester.pump();
    expect(pressed, 1, reason: 'Android DPAD_CENTER should activate the focused button');
  });

  testWidgets('unrelated remote buttons are ignored by DoomNet TV handler', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: DoomNetTvRemoteBridge(child: Scaffold(body: Text('DoomNet')))),
    );
    final context = tester.element(find.byType(DoomNetTvRemoteBridge));
    expect(DoomNetTvRemoteBridge.handleAndroidKey(context, 4), isFalse);
    expect(DoomNetTvRemoteBridge.handleAndroidKey(context, 24), isFalse);
  });
}
