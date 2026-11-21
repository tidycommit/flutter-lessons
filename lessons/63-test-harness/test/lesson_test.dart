import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_63_test_harness/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'Test harness';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 63);
    expect(lesson.notesAsset, '63-test-harness.md');
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

  group('63 Test harness mindset', () {
    testWidgets(
      'starts on /notes with the few-notes set and the bindings card',
      (tester) async {
        await open(tester);
        expect(
          find.textContaining('repo: fake in-memory notes'),
          findsOneWidget,
        );
        expect(find.textContaining('flags: showCount = on'), findsOneWidget);
        expect(find.textContaining('initial route: /notes'), findsOneWidget);
        expect(find.text('2 notes'), findsOneWidget);
        expect(find.text('Buy milk'), findsOneWidget);
        expect(find.text('Call mom'), findsOneWidget);
        expect(find.text('Plan trip'), findsNothing);
      },
    );

    testWidgets('Many notes and Few notes swap the fake data set', (
      tester,
    ) async {
      await open(tester);
      await tester.tap(find.text('Many notes'));
      await tester.pumpAndSettle();
      expect(find.text('6 notes'), findsOneWidget);
      expect(find.text('Read chapter 3'), findsOneWidget);
      expect(find.text('Pay rent'), findsOneWidget);
      expect(find.text('Water plants'), findsOneWidget);
      expect(find.text('Plan trip'), findsOneWidget);

      await tester.tap(find.text('Few notes'));
      await tester.pumpAndSettle();
      expect(find.text('2 notes'), findsOneWidget);
      expect(find.text('Plan trip'), findsNothing);
      expect(find.text('Buy milk'), findsOneWidget);
    });
  });
}
