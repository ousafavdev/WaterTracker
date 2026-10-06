import 'package:dewaterk4n/data/bottle_store.dart';
import 'package:dewaterk4n/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> settle(WidgetTester tester, String label) async {
  for (var i = 0; i < 40; i++) {
    await tester.pump(const Duration(milliseconds: 100));
    if (!tester.binding.hasScheduledFrame) {
      return;
    }
  }
  debugDumpApp();
  fail('animation did not settle at $label');
}

void main() {
  testWidgets('empty app lets you add, edit, copy, and delete a bottle', (
    tester,
  ) async {
    String? clipboard;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        switch (call.method) {
          case 'Clipboard.setData':
            final arguments = call.arguments as Map<Object?, Object?>;
            clipboard = arguments['text'] as String?;
          case 'Clipboard.getData':
            return <String, dynamic>{'text': clipboard};
        }
        return null;
      },
    );

    await tester.pumpWidget(DewaterApp(store: BottleStore()));
    await settle(tester, 'boot');

    expect(find.text('Nothing logged yet'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.byKey(const Key('add-bottle')));
    await settle(tester, 'open-add');
    await tester.enterText(find.byKey(const Key('bottle-name')), 'Office');
    await tester.tap(find.byKey(const Key('save-bottle')));
    await settle(tester, 'save');

    expect(find.text('Office'), findsOneWidget);
    expect(find.text('Nothing logged yet'), findsNothing);

    await tester.tap(find.byKey(const Key('copy-button')));
    await settle(tester, 'copy');
    final copied = await Clipboard.getData(Clipboard.kTextPlain);
    expect(copied?.text, contains('Office'));
    expect(copied?.text, contains('Bottles used: 1'));

    await tester.tap(find.byTooltip('Edit'));
    await settle(tester, 'open-edit');
    await tester.enterText(find.byKey(const Key('bottle-name')), 'Gym');
    await tester.tap(find.byKey(const Key('save-bottle')));
    await settle(tester, 'edit-save');
    expect(find.text('Gym'), findsOneWidget);

    await tester.tap(find.byKey(const Key('nav-history')));
    await settle(tester, 'history');
    expect(find.text('History'), findsWidgets);
    await tester.tap(find.byIcon(Icons.expand_more_rounded));
    await settle(tester, 'expand');
    expect(find.text('Gym'), findsOneWidget);

    await tester.tap(find.byKey(const Key('nav-stats')));
    await settle(tester, 'stats');
    expect(find.textContaining('Daily graph'), findsWidgets);
    expect(find.text('Weekly summary'), findsOneWidget);
    expect(find.textContaining('across the week'), findsOneWidget);

    await tester.tap(find.byKey(const Key('nav-today')));
    await settle(tester, 'back-today');
    await tester.tap(find.byTooltip('Delete'));
    await settle(tester, 'confirm');
    await tester.tap(find.byKey(const Key('confirm-delete')));
    await settle(tester, 'deleted');

    expect(find.text('Nothing logged yet'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
  });
}
