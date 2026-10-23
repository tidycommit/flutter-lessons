import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_25_push_replacement/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'Login';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 25);
    expect(lesson.notesAsset, '25-push-replacement.md');
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

  group('25 pushReplacement and pushAndRemoveUntil', () {
    const title =
        'Leaving screens behind with pushReplacement and pushAndRemoveUntil';
    final backArrow = find.descendant(
      of: find.byType(AppBar),
      matching: find.byType(BackButton),
    );

    testWidgets('log in replaces Login; log out clears back to Login', (
      tester,
    ) async {
      await open(tester, title);
      expect(find.widgetWithText(AppBar, 'Login'), findsOneWidget);
      expect(backArrow, findsNothing);

      // pushReplacement: Home takes Login's place, no back arrow.
      await tester.tap(find.widgetWithText(ElevatedButton, 'Log in'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);
      expect(find.widgetWithText(AppBar, 'Login'), findsNothing);
      expect(find.text('Welcome! You are logged in.'), findsOneWidget);
      expect(backArrow, findsNothing);
      expect(find.byTooltip('Lesson notes'), findsOneWidget);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Open Settings'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, 'Settings'), findsOneWidget);
      expect(backArrow, findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);

      // pushAndRemoveUntil: Login alone, no back arrow.
      await tester.tap(find.widgetWithText(ElevatedButton, 'Open Settings'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Log out'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, 'Login'), findsOneWidget);
      expect(find.widgetWithText(AppBar, 'Home'), findsNothing);
      expect(find.widgetWithText(AppBar, 'Settings'), findsNothing);
      expect(backArrow, findsNothing);
      expect(tester.takeException(), isNull);

      // The info action still opens the notes.
      await tester.tap(find.byTooltip('Lesson notes'));
      await tester.pumpAndSettle();
      expect(find.text('Lesson 25: $title'), findsOneWidget);
      Navigator.of(tester.element(find.byType(BottomSheet))).pop();
    });

    testWidgets('system back leaves Settings for Home, not Login', (
      tester,
    ) async {
      await open(tester, title);
      await tester.tap(find.widgetWithText(ElevatedButton, 'Log in'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Open Settings'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, 'Settings'), findsOneWidget);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);
      expect(find.widgetWithText(AppBar, 'Login'), findsNothing);
      expect(backArrow, findsNothing);
    });
  });
}
