import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_21_navigator_push_pop/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'Home';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 21);
    expect(lesson.notesAsset, '21-navigator-push-pop.md');
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

  group('21 Navigator push and pop', () {
    const title =
        'Moving between screens with Navigator.push and Navigator.pop';

    testWidgets('Open details shows Details, Go back returns', (tester) async {
      await open(tester, title);
      expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);
      expect(find.byType(BackButton), findsNothing);

      await tester.tap(find.text('Open details'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, 'Details'), findsOneWidget);
      expect(find.text('Open details'), findsNothing);

      await tester.tap(find.text('Go back'));
      await tester.pumpAndSettle();
      expect(find.text('Details'), findsNothing);
      expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);
      expect(find.widgetWithText(AppBar, title), findsNothing);
    });

    testWidgets('the Details back arrow returns to Home', (tester) async {
      await open(tester, title);
      await tester.tap(find.text('Open details'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, 'Details'), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('Details'), findsNothing);
      expect(find.text('Open details'), findsOneWidget);
      expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);
    });
  });
}
