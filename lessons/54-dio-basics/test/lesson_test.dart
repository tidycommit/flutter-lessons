import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_54_dio_basics/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'Dio';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 54);
    expect(lesson.notesAsset, '54-dio-basics.md');
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

  group('54 Dio client basics', () {
    test(
      'the fake client returns the first five titles without a network',
      () async {
        final titles = await PostRepository(buildDio(useNetwork: false))
            .fetchTitles();
        expect(titles, [
          'Fake post 1',
          'Fake post 2',
          'Fake post 3',
          'Fake post 4',
          'Fake post 5',
        ]);
      },
    );

    testWidgets('Use network starts off and Fetch posts shows the fake list', (
      tester,
    ) async {
      await open(tester);
      final toggle = tester.widget<SwitchListTile>(find.byType(SwitchListTile));
      expect(toggle.value, isFalse);
      expect(find.text('Use network'), findsOneWidget);
      expect(find.text('Fake post 1'), findsNothing);

      await tester.tap(find.text('Fetch posts'));
      await tester.pumpAndSettle();
      expect(find.text('Fake post 1'), findsOneWidget);
      expect(find.text('Fake post 2'), findsOneWidget);
      expect(find.text('Fake post 3'), findsOneWidget);
      expect(find.text('Fake post 4'), findsOneWidget);
      expect(find.text('Fake post 5'), findsOneWidget);
      expect(find.text('Fake post 6'), findsNothing);
      expect(find.textContaining('Request failed'), findsNothing);
    });
  });
}
