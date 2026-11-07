import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_43_consumer/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'Consumer';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 43);
    expect(lesson.notesAsset, '43-consumer.md');
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

  group('43 Consumer for local rebuilds', () {
    testWidgets('a ProviderScope sits above the lesson screen', (tester) async {
      await open(tester);
      expect(
        find.ancestor(
          of: find.byType(Lesson43Consumer),
          matching: find.byType(ProviderScope),
        ),
        findsOneWidget,
      );
    });

    testWidgets('the header stays and the count increments', (tester) async {
      final logs = <String>[];
      final previous = debugPrint;
      debugPrint = (message, {wrapWidth}) {
        if (message != null) logs.add(message);
      };

      await open(tester);
      expect(find.text('Static header'), findsOneWidget);
      expect(
        find.text('Passed as child, so it is not rebuilt'),
        findsOneWidget,
      );
      expect(find.text('Count: 0'), findsOneWidget);
      expect(logs.where((m) => m.contains('StaticHeader build')), [
        'StaticHeader build',
      ]);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.add));
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(find.text('Count: 3'), findsOneWidget);
      expect(find.text('Static header'), findsOneWidget);
      // The header was passed as child, so taps do not rebuild it.
      expect(logs.where((m) => m.contains('StaticHeader build')), [
        'StaticHeader build',
      ]);
      debugPrint = previous;
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
