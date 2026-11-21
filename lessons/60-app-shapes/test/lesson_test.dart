import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_60_app_shapes/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'App shapes';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 60);
    expect(lesson.notesAsset, '60-app-shapes.md');
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

  group('60 Package vs app vs add-to-app module', () {
    testWidgets('lists the three app shapes as cards', (tester) async {
      await open(tester);
      expect(find.text('Package'), findsOneWidget);
      expect(
        find.text('Reusable library: UI + logic, no main().'),
        findsOneWidget,
      );
      expect(find.text('App'), findsOneWidget);
      expect(
        find.text('Has main(), hosts packages, sets theme and router.'),
        findsOneWidget,
      );
      expect(find.text('Module (add-to-app)'), findsOneWidget);
      expect(
        find.text('Flutter compiled into an existing native app.'),
        findsOneWidget,
      );
    });

    testWidgets('tapping a card opens its detail bullets, then pops back', (
      tester,
    ) async {
      await open(tester);
      await tester.tap(find.text('Package'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, 'Package'), findsOneWidget);
      expect(find.byType(BackButton), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.byTooltip('Lesson notes'),
        ),
        findsNothing,
      );
      expect(find.text('No main() of its own'), findsOneWidget);
      expect(
        find.text('Reusable UI and logic other apps can depend on'),
        findsOneWidget,
      );
      expect(find.text('Tested on its own'), findsOneWidget);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, expectedAppBarTitle), findsOneWidget);
      expect(find.byType(BackButton), findsNothing);
    });
  });
}
