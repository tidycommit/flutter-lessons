import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_51_auth_redirect/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'Auth redirect';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 51);
    expect(lesson.notesAsset, '51-auth-redirect.md');
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

  group('51 Redirects and guards', () {
    testWidgets('starts signed out on the login screen', (tester) async {
      await open(tester);
      expect(find.text('Please log in'), findsOneWidget);
      expect(find.text('Log in'), findsOneWidget);
      expect(find.text('Home'), findsNothing);
      expect(find.text('Open secret'), findsNothing);
    });

    testWidgets('log in reaches Home, then Secret, then log out', (
      tester,
    ) async {
      await open(tester);
      await tester.tap(find.text('Log in'));
      await tester.pumpAndSettle();
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Open secret'), findsOneWidget);
      expect(find.byIcon(Icons.logout), findsOneWidget);
      expect(find.text('Please log in'), findsNothing);

      await tester.tap(find.text('Open secret'));
      await tester.pumpAndSettle();
      expect(find.text('Secret'), findsOneWidget);
      expect(find.text('Back home'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();
      expect(find.text('Please log in'), findsOneWidget);
      expect(find.text('Secret'), findsNothing);
    });

    testWidgets('logging in again returns to Secret from the from parameter', (
      tester,
    ) async {
      await open(tester);
      await tester.tap(find.text('Log in'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open secret'));
      await tester.pumpAndSettle();
      expect(find.text('Secret'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Log in'));
      await tester.pumpAndSettle();
      expect(find.text('Secret'), findsOneWidget);
      expect(find.text('Back home'), findsOneWidget);
      expect(find.text('Open secret'), findsNothing);
    });
  });
}
