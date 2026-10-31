import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_40_semantics/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'Semantics';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 40);
    expect(lesson.notesAsset, '40-semantics.md');
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

  group('40 Semantics and accessibility basics', () {
    testWidgets('the bad heart is a bare GestureDetector with no label', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await open(tester);
      expect(find.text('Bad: no label'), findsOneWidget);
      final badHeart = find
          .descendant(
            of: find.byType(GestureDetector),
            matching: find.byIcon(Icons.favorite_border),
          )
          .first;
      expect(
        find.ancestor(of: badHeart, matching: find.byType(IconButton)),
        findsNothing,
      );
      final data = tester.getSemantics(badHeart).getSemanticsData();
      expect(data.flagsCollection.isButton, isFalse);
      await tester.tap(badHeart);
      await tester.pump();
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      handle.dispose();
    });

    testWidgets('the good heart is an IconButton whose tooltip toggles', (
      tester,
    ) async {
      await open(tester);
      expect(find.byTooltip('Add to favorites'), findsOneWidget);
      expect(find.text('Hears: "Add to favorites, button."'), findsOneWidget);
      await tester.tap(find.byTooltip('Add to favorites'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Remove from favorites'), findsOneWidget);
      expect(find.byTooltip('Add to favorites'), findsNothing);
    });

    testWidgets('the star rating starts at 3 and announces each star', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await open(tester);
      expect(find.byIcon(Icons.star), findsNWidgets(3));
      expect(find.byIcon(Icons.star_border), findsNWidgets(2));
      expect(
        find.text(
          'Hears: "Rating, 3 out of 5 stars." Each star: "Rate 4 stars, button."',
        ),
        findsOneWidget,
      );
      expect(find.bySemanticsLabel('Rate 1 star'), findsOneWidget);
      expect(find.bySemanticsLabel('Rate 4 stars'), findsOneWidget);
      final star4 = tester
          .getSemantics(find.bySemanticsLabel('Rate 4 stars'))
          .getSemanticsData();
      expect(star4.flagsCollection.isButton, isTrue);
      final rating = tester
          .getSemantics(find.bySemanticsLabel('Rating'))
          .getSemanticsData();
      expect(rating.value, '3 out of 5 stars');
      handle.dispose();
    });

    testWidgets('tapping a star changes the rating and the note', (
      tester,
    ) async {
      await open(tester);
      await tester.tap(find.byIcon(Icons.star_border).last);
      await tester.pump();
      expect(find.byIcon(Icons.star), findsNWidgets(5));
      expect(find.textContaining('Rating, 5 out of 5 stars.'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.star).first);
      await tester.pump();
      expect(find.byIcon(Icons.star), findsNWidgets(1));
      expect(find.textContaining('Rating, 1 out of 5 stars.'), findsOneWidget);
    });

    test('StarRating is a plain widget with no asserts', () {
      final rating = StarRating(rating: 2, onChanged: (_) {});
      expect(rating.rating, 2);
    });
  });
}
