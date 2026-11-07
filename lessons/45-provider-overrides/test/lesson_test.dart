import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_45_provider_overrides/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'Overrides';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 45);
    expect(lesson.notesAsset, '45-provider-overrides.md');
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

  group('45 Provider overrides', () {
    testWidgets('fake A is the start, fake B replaces the list', (
      tester,
    ) async {
      await open(tester);
      expect(find.text('Using: FakeTodoRepository'), findsOneWidget);
      expect(find.text('Buy milk'), findsOneWidget);
      expect(find.text('Walk the dog'), findsOneWidget);
      expect(find.text('Read a chapter'), findsOneWidget);
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Use fake A'),
            )
            .onPressed,
        isNull,
      );

      await tester.tap(find.text('Use fake B'));
      await tester.pumpAndSettle();
      expect(find.text('Using: AltFakeTodoRepository'), findsOneWidget);
      expect(find.text('Fix login bug'), findsOneWidget);
      expect(find.text('Write tests'), findsOneWidget);
      expect(find.text('Ship release'), findsOneWidget);
      expect(find.text('Buy milk'), findsNothing);
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Use fake B'),
            )
            .onPressed,
        isNull,
      );

      await tester.tap(find.text('Use fake A'));
      await tester.pumpAndSettle();
      expect(find.text('Buy milk'), findsOneWidget);
      expect(find.text('Fix login bug'), findsNothing);
    });

    test('reading todos without an override fails loudly', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final value = await runZonedGuarded(() async {
        final value = container.read(todosProvider);
        await Future<void>.delayed(Duration.zero);
        return value;
      }, (error, stackTrace) {});
      expect(value, isNotNull);
      expect(value!.hasError, isTrue);
      expect('${value.error}', contains('Override me'));
    });

    test('an override supplies the fake list', () async {
      final container = ProviderContainer(
        overrides: [
          todoRepositoryProvider.overrideWithValue(FakeTodoRepository()),
        ],
      );
      addTearDown(container.dispose);
      expect(await container.read(todosProvider.future), [
        'Buy milk',
        'Walk the dog',
        'Read a chapter',
      ]);
    });
  });
}
