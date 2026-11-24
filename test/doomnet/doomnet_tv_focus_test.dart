import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hiddify/doomnet/doomnet_tv_focus.dart';
import 'package:hiddify/doomnet/doomnet_tv_remote.dart';

void main() {
  testWidgets('right enters page, OK activates, left restores sidebar', (tester) async {
    final rail = FocusScopeNode();
    final content = FocusScopeNode();
    final home = FocusNode();
    final logs = FocusNode();
    final action = FocusNode();
    final offstage = FocusNode();
    for (final node in [rail, content, home, logs, action, offstage]) {
      addTearDown(node.dispose);
    }
    var count = 0;
    await tester.pumpWidget(MaterialApp(home: DoomNetTvRemoteBridge(
      child: Scaffold(body: DoomNetTvFocusZones(
        rail: rail, content: content,
        child: Row(children: [
          SizedBox(width: 200, child: FocusScope(node: rail, child: Column(children: [
            ElevatedButton(focusNode: home, autofocus: true, onPressed: () {}, child: const Text('Home')),
            ElevatedButton(focusNode: logs, onPressed: () {}, child: const Text('Logs')),
          ]))),
          Expanded(child: FocusScope(node: content, child: Column(children: [
            Offstage(offstage: true, child: ElevatedButton(focusNode: offstage, onPressed: () => count += 100, child: const Text('Hidden'))),
            ElevatedButton(focusNode: action, onPressed: () => count++, child: const Text('Action')),
          ]))),
        ]),
      )),
    )));
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(DoomNetTvRemoteBridge));
    expect(home.hasPrimaryFocus, isTrue);
    DoomNetTvRemoteBridge.handleAndroidKey(context, 20);
    await tester.pumpAndSettle();
    expect(logs.hasPrimaryFocus, isTrue);
    DoomNetTvRemoteBridge.handleAndroidKey(context, 22);
    await tester.pumpAndSettle();
    expect(action.hasPrimaryFocus, isTrue);
    DoomNetTvRemoteBridge.handleAndroidKey(context, 23);
    await tester.pumpAndSettle();
    expect(count, 1);
    DoomNetTvRemoteBridge.handleAndroidKey(context, 21);
    await tester.pumpAndSettle();
    expect(logs.hasPrimaryFocus, isTrue);
  });
}
