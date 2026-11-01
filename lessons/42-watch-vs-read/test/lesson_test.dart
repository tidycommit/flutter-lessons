import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_42_watch_vs_read/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'watch vs read';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 42);
    expect(lesson.notesAsset, '42-watch-vs-read.md');
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

  group('42 watch vs read', () {
    testWidgets('a ProviderScope sits above the lesson screen', (tester) async {
      await open(tester);
      expect(
        find.ancestor(
          of: find.byType(Lesson42WatchVsRead),
          matching: find.byType(ProviderScope),
        ),
        findsOneWidget,
      );
    });

    testWidgets('starts with a watched 0 and an empty snapshot', (
      tester,
    ) async {
      await open(tester);
      expect(find.text('Watched value: 0'), findsOneWidget);
      expect(find.text('Read snapshot: -'), findsOneWidget);
      expect(find.text('Read once into a local label'), findsOneWidget);
      expect(find.text('Increment'), findsOneWidget);
    });

    testWidgets('watched value updates, read snapshot stays stale', (
      tester,
    ) async {
      await open(tester);
      final increment = find.text('Increment');
      final readOnce = find.text('Read once into a local label');
      await tester.tap(increment);
      await tester.pump();
      expect(find.text('Watched value: 1'), findsOneWidget);
      expect(find.text('Read snapshot: -'), findsOneWidget);
      await tester.tap(readOnce);
      await tester.pump();
      expect(find.text('Read snapshot: 1'), findsOneWidget);
      await tester.tap(increment);
      await tester.tap(increment);
      await tester.pump();
      // The mockup state: watched 3, snapshot still 1.
      expect(find.text('Watched value: 3'), findsOneWidget);
      expect(find.text('Read snapshot: 1'), findsOneWidget);
      await tester.tap(readOnce);
      await tester.pump();
      expect(find.text('Read snapshot: 3'), findsOneWidget);
    });

    test('Counter starts at 0 and increments', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(counterProvider), 0);
      container.read(counterProvider.notifier).increment();
      expect(container.read(counterProvider), 1);
    });
  });
}
