import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_52_feature_routes/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'Feature routes';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 52);
    expect(lesson.notesAsset, '52-feature-routes.md');
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

  group('52 Composing feature routes', () {
    testWidgets('Home links to Orders by path, and Back home returns', (
      tester,
    ) async {
      await open(tester);
      expect(find.text('Home feature'), findsOneWidget);
      expect(find.text('See orders'), findsOneWidget);

      await tester.tap(find.text('See orders'));
      await tester.pumpAndSettle();
      expect(find.text('Order #1001'), findsOneWidget);
      expect(find.text('Order #1002'), findsOneWidget);
      expect(find.text('Orders feature'), findsOneWidget);
      expect(find.text('Back home'), findsOneWidget);
      expect(find.widgetWithText(AppBar, 'Feature routes'), findsOneWidget);

      await tester.tap(find.text('Back home'));
      await tester.pumpAndSettle();
      expect(find.text('Home feature'), findsOneWidget);
      expect(find.text('Order #1001'), findsNothing);
    });
  });
}
