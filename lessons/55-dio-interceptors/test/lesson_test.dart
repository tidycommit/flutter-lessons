import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_55_dio_interceptors/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'Interceptors';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 55);
    expect(lesson.notesAsset, '55-dio-interceptors.md');
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

  group('55 Dio interceptors', () {
    test(
      'buildDio retries the flaky adapter and returns Hello, World',
      () async {
        final log = <String>[];
        final response = await buildDio(log).get('/hello');
        expect(response.data, ['Hello', 'World']);
        expect(log, [
          '-> GET /hello',
          '!! Fake network drop',
          'retry 1 of 2',
          '-> GET /hello',
          '<- 200 OK',
        ]);
      },
    );

    testWidgets('Send request shows the retry log and the result', (
      tester,
    ) async {
      await open(tester);
      expect(find.text('Send request'), findsOneWidget);
      expect(find.text('-> GET /hello'), findsNothing);

      await tester.tap(find.text('Send request'));
      await tester.pumpAndSettle();
      expect(find.text('-> GET /hello'), findsNWidgets(2));
      expect(find.text('!! Fake network drop'), findsOneWidget);
      expect(find.text('retry 1 of 2'), findsOneWidget);
      expect(find.text('<- 200 OK'), findsOneWidget);
      expect(find.text('Result: [Hello, World]'), findsOneWidget);
    });
  });
}
