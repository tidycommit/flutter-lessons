import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_47_side_effects/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'Side effects';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 47);
    expect(lesson.notesAsset, '47-side-effects.md');
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

  group('47 Side effects outside build', () {
    testWidgets('a ProviderScope sits above the lesson screen', (tester) async {
      await open(tester);
      expect(
        find.ancestor(
          of: find.byType(Lesson47SideEffects),
          matching: find.byType(ProviderScope),
        ),
        findsOneWidget,
      );
    });

    testWidgets('reload shows the error once in the body and a SnackBar', (
      tester,
    ) async {
      await open(tester);
      expect(find.text('Loaded OK'), findsOneWidget);
      expect(find.text('Reload'), findsOneWidget);
      expect(find.textContaining('showDialog'), findsOneWidget);
      expect(find.text('Error: Network down'), findsNothing);

      await tester.tap(find.byType(Switch));
      await tester.pump();
      await tester.tap(find.text('Reload'));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump();
      expect(find.text('Failed: Network down'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Error: Network down'), findsOneWidget);

      // Another frame does not add a second SnackBar for the same error.
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);

      await tester.tap(find.byType(Switch));
      await tester.pump();
      await tester.tap(find.text('Reload'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump();
      expect(find.text('Loaded OK'), findsOneWidget);
      // Success does not enqueue another SnackBar. The error one is still
      // the only one, until its own timer removes it.
      expect(find.byType(SnackBar), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
      expect(find.text('Loaded OK'), findsOneWidget);
      expect(find.byType(SnackBar), findsNothing);
    });
  });
}
