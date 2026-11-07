import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lesson_49_route_params/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'Route params';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 49);
    expect(lesson.notesAsset, '49-route-params.md');
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

  group('49 Path and query parameters', () {
    testWidgets('the list shows each fruit URL', (tester) async {
      await open(tester);
      expect(find.text('/fruit/apple?color=red'), findsOneWidget);
      expect(find.text('/fruit/banana?color=yellow'), findsOneWidget);
      expect(find.text('/fruit/grape?color=purple'), findsOneWidget);
      expect(find.text('mango (no color)'), findsOneWidget);
      expect(find.text('/fruit/mango'), findsOneWidget);
    });

    testWidgets('apple reads the path name and the color query', (
      tester,
    ) async {
      await open(tester);
      await tester.tap(find.text('apple'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, 'apple'), findsOneWidget);
      expect(find.text('Color: red'), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, 'Route params'), findsOneWidget);
    });

    testWidgets('unknown fruit is Not found and Back to list goes home', (
      tester,
    ) async {
      await open(tester);
      await tester.tap(find.text('mango (no color)'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, 'Not found'), findsOneWidget);
      expect(find.text('No fruit called "mango"'), findsOneWidget);

      await tester.tap(find.text('Back to list'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, 'Route params'), findsOneWidget);
      expect(find.text('apple'), findsOneWidget);
    });

    testWidgets('a known fruit with no color query says No color given', (
      tester,
    ) async {
      await open(tester);
      GoRouter.of(tester.element(find.text('banana'))).push('/fruit/banana');
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, 'banana'), findsOneWidget);
      expect(find.text('No color given'), findsOneWidget);
    });
  });
}
