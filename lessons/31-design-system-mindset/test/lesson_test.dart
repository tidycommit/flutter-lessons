import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_31_design_system_mindset/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'Design system';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 31);
    expect(lesson.notesAsset, '31-design-system-mindset.md');
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

  group('31 Design-system mindset', () {
    const title = 'Design-system mindset';
    final appButtons = find.byType(AppButton);

    Future<void> scrollToButton(WidgetTester tester, Finder finder) async {
      await tester.scrollUntilVisible(
        finder,
        100,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.pumpAndSettle();
    }

    testWidgets("opens on Design system with the snippet's AppBar", (
      tester,
    ) async {
      await open(tester, title);
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect((appBar.title! as Text).data, 'Design system');
      expect(appBar.backgroundColor, isNull);
      expect(appBar.foregroundColor, isNull);
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.byTooltip('Lesson notes'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.byType(BackButton),
        ),
        findsNothing,
      );
      expect(find.text('Presses: 0'), findsOneWidget);
      expect(find.text('Inconsistent'), findsOneWidget);
    });

    testWidgets('Inconsistent: three hand-styled buttons that differ', (
      tester,
    ) async {
      await open(tester, title);
      final save = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Save').first,
      );
      expect(save.style?.backgroundColor?.resolve({}), Colors.orange);
      expect(save.style?.foregroundColor?.resolve({}), Colors.white);
      expect(find.widgetWithText(TextButton, 'SUBMIT'), findsOneWidget);
      final cont = tester.widget<OutlinedButton>(
        find.widgetWithText(OutlinedButton, 'Continue'),
      );
      expect(cont.style?.shape?.resolve({}), isA<StadiumBorder>());
      expect(cont.style?.minimumSize?.resolve({}), const Size(240, 56));
    });

    testWidgets('Consistent: three AppButtons with one shared style', (
      tester,
    ) async {
      await open(tester, title);
      await scrollToButton(tester, find.text('Consistent'));
      await scrollToButton(tester, find.widgetWithText(AppButton, 'Continue'));
      expect(appButtons, findsNWidgets(3));
      expect(tester.widgetList<AppButton>(appButtons).map((b) => b.label), [
        'Save',
        'Submit',
        'Continue',
      ]);
      final sizes = <Size>[];
      for (final element in appButtons.evaluate()) {
        final button = tester.widget<ElevatedButton>(
          find.descendant(
            of: find.byWidget(element.widget),
            matching: find.byType(ElevatedButton),
          ),
        );
        expect(button.style?.minimumSize?.resolve({}), const Size(160, 48));
        final shape = button.style?.shape?.resolve({});
        expect(shape, isA<RoundedRectangleBorder>());
        expect(
          (shape! as RoundedRectangleBorder).borderRadius,
          BorderRadius.circular(8),
        );
        sizes.add(tester.getSize(find.byWidget(element.widget)));
      }
      // All three share the height and at least the shared minimum width.
      expect(sizes.map((s) => s.height).toSet(), {48});
      expect(sizes.every((s) => s.width >= 160), isTrue);
    });

    testWidgets('every button counts a press', (tester) async {
      await open(tester, title);
      final buttons = [
        find.widgetWithText(ElevatedButton, 'Save').first,
        find.widgetWithText(TextButton, 'SUBMIT'),
        find.widgetWithText(OutlinedButton, 'Continue'),
        find.widgetWithText(AppButton, 'Save'),
        find.widgetWithText(AppButton, 'Submit'),
        find.widgetWithText(AppButton, 'Continue'),
      ];
      for (var i = 0; i < buttons.length; i++) {
        await scrollToButton(tester, buttons[i]);
        await tester.tap(buttons[i]);
        await tester.pump();
        await scrollToButton(tester, find.text('Presses: ${i + 1}'));
        expect(find.text('Presses: ${i + 1}'), findsOneWidget);
      }
    });
  });
}
