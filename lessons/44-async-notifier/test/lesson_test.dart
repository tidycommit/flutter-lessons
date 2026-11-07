import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_44_async_notifier/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'AsyncNotifier';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 44);
    expect(lesson.notesAsset, '44-async-notifier.md');
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

  group('44 AsyncNotifier loading and error', () {
    testWidgets('a ProviderScope sits above the lesson screen', (tester) async {
      await open(tester);
      expect(
        find.ancestor(
          of: find.byType(Lesson44AsyncNotifier),
          matching: find.byType(ProviderScope),
        ),
        findsOneWidget,
      );
    });

    testWidgets('loads Alpha, Bravo, and Charlie after the spinner', (
      tester,
    ) async {
      await tester.pumpWidget(lessonApp);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Alpha'), findsNothing);
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('Bravo'), findsOneWidget);
      expect(find.text('Charlie'), findsOneWidget);
      expect(find.text('Force error'), findsOneWidget);
      expect(find.text('Applies on the next load'), findsOneWidget);
    });

    testWidgets('force error stays until reload, then Retry recovers', (
      tester,
    ) async {
      await open(tester);
      expect(find.text('Alpha'), findsOneWidget);

      await tester.tap(find.byType(Switch));
      await tester.pump();
      // The switch applies on the next load, not immediately.
      expect(find.text('Alpha'), findsOneWidget);

      await tester.tap(find.byTooltip('Reload'));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.cloud_off), findsOneWidget);
      expect(find.textContaining('Exception: Network down'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      expect(find.text('Alpha'), findsNothing);

      await tester.tap(find.byType(Switch));
      await tester.pump();
      await tester.tap(find.text('Retry'));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('Bravo'), findsOneWidget);
      expect(find.text('Charlie'), findsOneWidget);
    });

    test('failed build does not schedule a retry', () async {
      final container = ProviderContainer(
        retry: (retryCount, error) => null,
        overrides: [forceErrorProvider.overrideWith(ForceError.new)],
      );
      addTearDown(container.dispose);
      container.read(forceErrorProvider.notifier).set(true);
      expect(
        container.read(fakeItemsProvider),
        isA<AsyncLoading<List<String>>>(),
      );
      await container
          .read(fakeItemsProvider.future)
          .then<void>(
            (_) => fail('expected the fake load to fail'),
            onError: (Object error, StackTrace stack) {
              expect(error, isA<Exception>());
              expect('$error', contains('Network down'));
            },
          );
      expect(
        container.read(fakeItemsProvider),
        isA<AsyncError<List<String>>>(),
      );
    });
  });
}
