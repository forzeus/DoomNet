import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hiddify/doomnet/doomnet_windows_header.dart';

void main() {
  testWidgets('Windows header fits narrow and wide windows', (tester) async {
    for (final width in [140.0, 240.0, 680.0]) {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(width: width, height: 56, child: const DoomNetWindowsHeader()),
      ))));
      await tester.pump(const Duration(milliseconds: 50));
      expect(tester.takeException(), isNull);
      expect(find.byType(Image), findsOneWidget);
      final wordmark = find.text('DoomNet');
      expect(tester.widget<Text>(wordmark).style?.fontWeight, FontWeight.w600);
      final logoCenter = tester.getCenter(find.byType(Image));
      final textCenter = tester.getCenter(wordmark);
      expect(textCenter.dy, closeTo(logoCenter.dy - 2, 0.6));
      expect(find.text(DoomNetWindowsHeader.notice), width >= 420 ? findsOneWidget : findsNothing);
    }
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
