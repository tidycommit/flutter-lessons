import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_33_design_tokens/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'Tokens';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 33);
    expect(lesson.notesAsset, '33-design-tokens.md');
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

  group('33 Design tokens', () {
    const title = 'Design tokens instead of magic numbers';
    final brandCard = find.ancestor(
      of: find.text('Brand card'),
      matching: find.byType(Container),
    );
    final outlinedCard = find.ancestor(
      of: find.text('Same tokens, outlined'),
      matching: find.byType(Container),
    );
    final button = find.byType(FilledButton);

    BoxDecoration decoration(WidgetTester tester, Finder card) =>
        tester.widget<Container>(card.first).decoration! as BoxDecoration;

    void expectBrand(WidgetTester tester, Color brand) {
      final filled = decoration(tester, brandCard);
      expect(filled.color, brand);
      expect(filled.borderRadius, BorderRadius.circular(AppTokens.radiusMd));
      final outlined = decoration(tester, outlinedCard);
      expect(outlined.color, isNull);
      expect((outlined.border! as Border).top.color, brand);
      expect((outlined.border! as Border).top.width, 2);
      expect(outlined.borderRadius, BorderRadius.circular(AppTokens.radiusMd));
      expect(
        tester.widget<Text>(find.text('Same tokens, outlined')).style?.color,
        brand,
      );
      expect(
        tester.widget<FilledButton>(button).style?.backgroundColor?.resolve({}),
        brand,
      );
    }

    testWidgets("opens on Tokens with the snippet's AppBar", (tester) async {
      await open(tester, title);
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect((appBar.title! as Text).data, 'Tokens');
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
    });

    testWidgets('the tokens have the documented values', (tester) async {
      expect(AppTokens.spaceSm, 8);
      expect(AppTokens.spaceMd, 16);
      expect(AppTokens.spaceLg, 24);
      expect(AppTokens.radiusMd, 12);
      expect(AppTokens.colorBrand, const Color(0xFF0B5FFF));
      expect(AppTokens.colorBrandStrong, const Color(0xFF0033AA));
    });

    testWidgets('the layout is built from the tokens', (tester) async {
      await open(tester, title);
      expect(find.text('Brand card'), findsOneWidget);
      expect(find.text('Same tokens, outlined'), findsOneWidget);
      expect(find.text('Spacing: 8 / 16 / 24, radius: 12'), findsOneWidget);
      expect(
        find.widgetWithText(FilledButton, 'Emphasize brand'),
        findsOneWidget,
      );
      // 24 px around everything, 16 px inside each card.
      final outer = find.ancestor(
        of: find.byType(Column).last,
        matching: find.byType(Padding),
      );
      expect(
        tester.widget<Padding>(outer.first).padding,
        const EdgeInsets.all(AppTokens.spaceLg),
      );
      for (final card in [brandCard, outlinedCard]) {
        expect(
          tester.widget<Container>(card.first).padding,
          const EdgeInsets.all(AppTokens.spaceMd),
        );
      }
      final brandText = tester.widget<Text>(find.text('Brand card'));
      expect(brandText.style?.color, Colors.white);
      expect(brandText.style?.fontSize, 20);
      // Both cards stretch to the same width.
      expect(
        tester.getSize(brandCard.first).width,
        tester.getSize(outlinedCard.first).width,
      );
      expectBrand(tester, AppTokens.colorBrand);
    });

    testWidgets('Emphasize brand restyles everything at once, and back', (
      tester,
    ) async {
      await open(tester, title);
      await tester.tap(find.text('Emphasize brand'));
      await tester.pumpAndSettle();
      expect(find.text('Use normal brand'), findsOneWidget);
      expect(find.text('Emphasize brand'), findsNothing);
      expectBrand(tester, AppTokens.colorBrandStrong);

      await tester.tap(find.text('Use normal brand'));
      await tester.pumpAndSettle();
      expect(find.text('Emphasize brand'), findsOneWidget);
      expectBrand(tester, AppTokens.colorBrand);
    });
  });
}
