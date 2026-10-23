import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_22_passing_data/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'Fruits';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 22);
    expect(lesson.notesAsset, '22-passing-data.md');
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

  group('22 Passing data', () {
    const title = 'Passing data to a new screen through its constructor';

    testWidgets('lists all three fruits', (tester) async {
      await open(tester, title);
      expect(find.widgetWithText(AppBar, 'Fruits'), findsOneWidget);
      for (final fruit in ['Apple', 'Banana', 'Cherry']) {
        expect(find.widgetWithText(ListTile, fruit), findsOneWidget);
      }
      expect(find.byType(BackButton), findsNothing);
    });

    testWidgets('Banana opens its detail; back returns; Cherry opens', (
      tester,
    ) async {
      await open(tester, title);

      await tester.tap(find.widgetWithText(ListTile, 'Banana'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, 'Banana'), findsOneWidget);
      expect(find.text('You picked Banana!'), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('You picked Banana!'), findsNothing);
      expect(find.widgetWithText(AppBar, 'Fruits'), findsOneWidget);
      expect(find.widgetWithText(AppBar, title), findsNothing);

      await tester.tap(find.widgetWithText(ListTile, 'Cherry'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, 'Cherry'), findsOneWidget);
      expect(find.text('You picked Cherry!'), findsOneWidget);
    });
  });
}
