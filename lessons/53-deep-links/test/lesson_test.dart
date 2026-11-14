import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_53_deep_links/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'Deep links';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 53);
    expect(lesson.notesAsset, '53-deep-links.md');
  });

  test('the notes start with the lesson heading', () {
    final firstLine = File(lesson.notesAsset).readAsLinesSync().first;
    expect(firstLine, '# ${lesson.heading}');
  });

  testWidgets("opens with its snippet's AppBar and the info button", (
    tester,
  ) async {
    await open(tester);
    expect(tester.takeException(), isNull);
    final appBar = tester.widget<AppBar>(find.byType(AppBar));
    expect((appBar.title! as Text).data, expectedAppBarTitle);
    // All snippets use default AppBar styling.
    expect(appBar.backgroundColor, isNull);
    expect(appBar.foregroundColor, isNull);
    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.byTooltip('Lesson notes'),
      ),
      findsOneWidget,
    );
    // The lesson is the app's first screen, so there is nothing to go
    // back to.
    expect(find.byType(BackButton), findsNothing);
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('the info button shows the lesson notes', (tester) async {
    await open(tester);
    await tester.tap(find.byTooltip('Lesson notes'));
    await tester.pumpAndSettle();
    expect(find.text(lesson.heading), findsOneWidget);
    Navigator.of(tester.element(find.byType(BottomSheet))).pop();
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsNothing);
    expect(find.widgetWithText(AppBar, expectedAppBarTitle), findsOneWidget);
  });

  group('53 Deep links from URLs', () {
    testWidgets('the field starts with the pear link', (tester) async {
      await open(tester);
      expect(find.text('Incoming link'), findsOneWidget);
      expect(find.text('/fruit/pear?color=green'), findsOneWidget);
      expect(find.text('Open link'), findsOneWidget);
    });

    testWidgets('Open link shows the fruit page, then Back home returns', (
      tester,
    ) async {
      await open(tester);
      await tester.tap(find.text('Open link'));
      await tester.pumpAndSettle();
      expect(find.text('Fruit: pear'), findsOneWidget);
      expect(find.text('Color: green'), findsOneWidget);
      expect(find.widgetWithText(AppBar, 'Deep links'), findsOneWidget);

      await tester.tap(find.text('Back home'));
      await tester.pumpAndSettle();
      expect(find.text('/fruit/pear?color=green'), findsOneWidget);
      expect(find.text('Fruit: pear'), findsNothing);
    });

    testWidgets('an unknown path shows the error page', (tester) async {
      await open(tester);
      await tester.enterText(find.byType(TextField), '/nope');
      await tester.tap(find.text('Open link'));
      await tester.pumpAndSettle();
      expect(find.text('No screen for /nope'), findsOneWidget);
      expect(find.text('Back home'), findsOneWidget);

      await tester.tap(find.text('Back home'));
      await tester.pumpAndSettle();
      expect(find.text('Open link'), findsOneWidget);
    });
  });
}
