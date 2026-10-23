import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_34_button_variants/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'AppButton';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 34);
    expect(lesson.notesAsset, '34-button-variants.md');
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

  group('34 Button variants', () {
    const title = 'Shared button with variants';
    final appButtons = find.byType(AppButton);

    Finder button(String label) => find.ancestor(
      of: find.text(label),
      matching: find.byType(FilledButton),
    );

    ButtonStyle styleOf(WidgetTester tester, String label) =>
        tester.widget<FilledButton>(button(label)).style!;

    testWidgets("opens on AppButton with the snippet's AppBar", (tester) async {
      await open(tester, title);
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect((appBar.title! as Text).data, 'AppButton');
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
    });

    testWidgets('four AppButtons, one widget type, picked by variant', (
      tester,
    ) async {
      await open(tester, title);
      expect(appButtons, findsNWidgets(4));
      final buttons = tester.widgetList<AppButton>(appButtons).toList();
      expect(buttons.map((b) => b.label), [
        'Save',
        'Cancel',
        'Delete',
        'Disabled',
      ]);
      expect(buttons.map((b) => b.variant), [
        AppButtonVariant.primary,
        AppButtonVariant.secondary,
        AppButtonVariant.danger,
        AppButtonVariant.primary,
      ]);
      // Optional icon: Save and Delete have one, Cancel and Disabled don't.
      expect(buttons.map((b) => b.icon), [
        Icons.check,
        null,
        Icons.delete,
        null,
      ]);
      expect(
        find.descendant(of: button('Save'), matching: find.byIcon(Icons.check)),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: button('Delete'),
          matching: find.byIcon(Icons.delete),
        ),
        findsOneWidget,
      );
      for (final label in ['Cancel', 'Disabled']) {
        expect(
          find.descendant(of: button(label), matching: find.byType(Icon)),
          findsNothing,
        );
      }
      // Same size for every variant.
      final sizes = [
        for (final label in ['Save', 'Cancel', 'Delete', 'Disabled'])
          tester.getSize(button(label)),
      ];
      expect(sizes.toSet(), hasLength(1));
      expect(sizes.first.width, greaterThanOrEqualTo(220));
      expect(sizes.first.height, greaterThanOrEqualTo(48));
    });

    testWidgets('the switch maps each variant to its scheme colors', (
      tester,
    ) async {
      await open(tester, title);
      final scheme = Theme.of(tester.element(button('Save'))).colorScheme;
      final expected = {
        'Save': (scheme.primary, scheme.onPrimary),
        'Cancel': (scheme.secondaryContainer, scheme.onSecondaryContainer),
        'Delete': (scheme.error, scheme.onError),
      };
      for (final MapEntry(key: label, value: (bg, fg)) in expected.entries) {
        final style = styleOf(tester, label);
        expect(style.backgroundColor?.resolve({}), bg, reason: label);
        expect(style.foregroundColor?.resolve({}), fg, reason: label);
        expect(style.minimumSize?.resolve({}), const Size(220, 48));
      }
      // The three enabled variants really look different.
      expect(expected.values.map((c) => c.$1).toSet(), hasLength(3));
    });

    testWidgets('Disabled is greyed out and untappable', (tester) async {
      await open(tester, title);
      final disabled = tester.widget<FilledButton>(button('Disabled'));
      expect(disabled.onPressed, isNull);
      expect(disabled.enabled, isFalse);
      final style = styleOf(tester, 'Disabled');
      final scheme = Theme.of(tester.element(button('Save'))).colorScheme;
      expect(
        style.backgroundColor?.resolve({WidgetState.disabled}),
        isNot(scheme.primary),
      );
      await tester.tap(button('Disabled'), warnIfMissed: false);
      await tester.pump();
      expect(find.text('Presses: 0'), findsOneWidget);
    });

    testWidgets('Save counts; Cancel and Delete do nothing', (tester) async {
      await open(tester, title);
      await tester.tap(button('Save'));
      await tester.pump();
      expect(find.text('Presses: 1'), findsOneWidget);
      await tester.tap(button('Save'));
      await tester.pump();
      expect(find.text('Presses: 2'), findsOneWidget);

      for (final label in ['Cancel', 'Delete']) {
        expect(tester.widget<FilledButton>(button(label)).enabled, isTrue);
        await tester.tap(button(label));
        await tester.pumpAndSettle();
        expect(find.text('Presses: 2'), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });
  });
}
