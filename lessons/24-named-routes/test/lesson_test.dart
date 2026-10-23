import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_24_named_routes/main.dart';

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
    expect(lesson.id, 24);
    expect(lesson.notesAsset, '24-named-routes.md');
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

  group('24 Named routes', () {
    const title = 'Named routes with routes and Navigator.pushNamed';

    testWidgets('Settings and About open by name; back returns to Home', (
      tester,
    ) async {
      await open(tester, title);
      expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Settings'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, 'Settings'), findsOneWidget);
      expect(find.text('Settings screen'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);

      await tester.tap(find.widgetWithText(ElevatedButton, 'About'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, 'About'), findsOneWidget);
      expect(find.text('About this app'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);

      // Info action opens the notes.
      await tester.tap(find.byTooltip('Lesson notes'));
      await tester.pumpAndSettle();
      expect(find.text('Lesson 24: $title'), findsOneWidget);
      Navigator.of(tester.element(find.byType(BottomSheet))).pop();
    });

    testWidgets('system back: Settings to Home', (tester) async {
      await open(tester, title);
      await tester.tap(find.widgetWithText(ElevatedButton, 'Settings'));
      await tester.pumpAndSettle();
      expect(find.text('Settings screen'), findsOneWidget);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);
    });
  });
}
