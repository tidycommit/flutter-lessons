import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_62_programmatic_vs_sdui/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'SDUI';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 62);
    expect(lesson.notesAsset, '62-programmatic-vs-sdui.md');
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

  group('62 Programmatic UI vs server-driven UI', () {
    testWidgets('SDUI and Programmatic both show the same text and button', (
      tester,
    ) async {
      await open(tester);
      final button = tester.widget<SegmentedButton<bool>>(
        find.byType(SegmentedButton<bool>),
      );
      expect(button.selected, {true});
      expect(find.text('Hello from JSON'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Tap'), findsOneWidget);

      await tester.tap(
        find.descendant(
          of: find.byType(SegmentedButton<bool>),
          matching: find.text('Programmatic'),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<SegmentedButton<bool>>(find.byType(SegmentedButton<bool>))
            .selected,
        {false},
      );
      expect(find.text('Hello from JSON'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Tap'), findsOneWidget);

      await tester.tap(
        find.descendant(
          of: find.byType(SegmentedButton<bool>),
          matching: find.text('SDUI'),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<SegmentedButton<bool>>(find.byType(SegmentedButton<bool>))
            .selected,
        {true},
      );
      expect(find.text('Hello from JSON'), findsOneWidget);
    });

    test('inflate maps the whitelist and ignores unknown types', () {
      final built = inflate({
        'type': 'column',
        'children': [
          {'type': 'text', 'value': 'Hello from JSON'},
          {'type': 'button', 'value': 'Tap'},
          {'type': 'mystery', 'value': 'nope'},
        ],
      });
      expect(built, isA<Column>());
      final children = (built as Column).children;
      expect(children, hasLength(3));
      expect(children[0], isA<Text>());
      expect((children[0] as Text).data, 'Hello from JSON');
      expect(children[1], isA<FilledButton>());
      expect(children[2], isA<SizedBox>());
    });
  });
}
