import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_41_riverpod_counter/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'Riverpod counter';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 41);
    expect(lesson.notesAsset, '41-riverpod-counter.md');
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

  group('41 From setState to Riverpod', () {
    testWidgets('a ProviderScope sits above the lesson screen', (tester) async {
      await open(tester);
      expect(
        find.ancestor(
          of: find.byType(Lesson41RiverpodCounter),
          matching: find.byType(ProviderScope),
        ),
        findsOneWidget,
      );
      expect(find.byType(Lesson41RiverpodCounter), findsOneWidget);
    });

    testWidgets('starts at 0 and the FAB increments the provider', (
      tester,
    ) async {
      await open(tester);
      expect(find.text('0'), findsOneWidget);
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      expect(find.text('1'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.add));
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(find.text('3'), findsOneWidget);
      final container = ProviderScope.containerOf(
        tester.element(find.byType(Lesson41RiverpodCounter)),
      );
      expect(container.read(counterProvider), 3);
    });

    test('Counter starts at 0 and increments', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(counterProvider), 0);
      container.read(counterProvider.notifier).increment();
      expect(container.read(counterProvider), 1);
    });

    testWidgets('each app run gets a fresh count', (tester) async {
      await open(tester);
      expect(find.text('0'), findsOneWidget);
    });
  });
}
