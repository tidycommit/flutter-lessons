import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_32_theme_data/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'ThemeData';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 32);
    expect(lesson.notesAsset, '32-theme-data.md');
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

  group('32 ThemeData', () {
    const title = 'ThemeData as the source of truth';
    final switchTile = find.widgetWithText(SwitchListTile, 'Dark mode');

    ThemeData themeAt(WidgetTester tester, Finder finder) =>
        Theme.of(tester.element(finder));

    testWidgets("opens on ThemeData with the snippet's AppBar", (tester) async {
      await open(tester, title);
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect((appBar.title! as Text).data, 'ThemeData');
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
      // The snippet's own MaterialApp is the app.
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('starts light; the card shows every themed piece', (
      tester,
    ) async {
      await open(tester, title);
      expect(tester.widget<SwitchListTile>(switchTile).value, isFalse);
      for (final text in [
        'Order summary',
        'Every color here comes from Theme.of(context).',
        'Primary color',
      ]) {
        expect(
          find.descendant(of: find.byType(Card), matching: find.text(text)),
          findsOneWidget,
        );
      }
      expect(find.widgetWithText(ElevatedButton, 'Checkout'), findsOneWidget);
      final theme = themeAt(tester, find.text('Order summary'));
      expect(theme.brightness, Brightness.light);
      // "Primary color" reads the theme's primary, not a hardcoded color.
      final label = tester.widget<Text>(find.text('Primary color'));
      expect(label.style?.color, theme.colorScheme.primary);
      expect(
        tester.widget<Text>(find.text('Order summary')).style,
        theme.textTheme.titleLarge,
      );
      await tester.tap(find.text('Checkout'));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Dark mode restyles the whole demo, and back to light', (
      tester,
    ) async {
      await open(tester, title);
      final lightPrimary = themeAt(
        tester,
        find.text('Primary color'),
      ).colorScheme.primary;

      await tester.tap(switchTile);
      await tester.pumpAndSettle();
      expect(tester.widget<SwitchListTile>(switchTile).value, isTrue);
      final dark = themeAt(tester, find.text('Order summary'));
      expect(dark.brightness, Brightness.dark);
      expect(
        tester.widget<Text>(find.text('Primary color')).style?.color,
        dark.colorScheme.primary,
      );
      expect(dark.colorScheme.primary, isNot(lightPrimary));
      // The AppBar, Card and button read the same dark theme.
      for (final finder in [
        find.byType(AppBar),
        find.byType(Card),
        find.byType(ElevatedButton),
      ]) {
        expect(themeAt(tester, finder).brightness, Brightness.dark);
      }

      await tester.tap(switchTile);
      await tester.pumpAndSettle();
      expect(
        themeAt(tester, find.text('Order summary')).brightness,
        Brightness.light,
      );
    });

    testWidgets('notes open inside the demo; back closes them first', (
      tester,
    ) async {
      await open(tester, title);
      await tester.tap(find.byTooltip('Lesson notes'));
      await tester.pumpAndSettle();
      expect(find.text('Lesson 32: $title'), findsOneWidget);

      // System back closes the notes sheet, not the lesson.
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(BottomSheet), findsNothing);
      expect(find.widgetWithText(AppBar, 'ThemeData'), findsOneWidget);
    });
  });
}
