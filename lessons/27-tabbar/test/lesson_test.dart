import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_27_tabbar/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'Tabs Tip';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 27);
    expect(lesson.notesAsset, '27-tabbar.md');
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

  group('27 TabBar', () {
    const title = 'Tabs with TabBar, TabBarView, and DefaultTabController';
    final tabBar = find.byType(TabBar);

    testWidgets('tap and swipe switch tabs; info and back work', (
      tester,
    ) async {
      await open(tester, title);
      int selected() =>
          DefaultTabController.of(tester.element(find.byType(TabBarView)))
              .index;

      expect(find.widgetWithText(AppBar, 'Tabs Tip'), findsOneWidget);
      // The TabBar sits in the AppBar's bottom slot.
      expect(
        find.descendant(of: find.byType(AppBar), matching: tabBar),
        findsOneWidget,
      );
      for (final (icon, label) in [
        (Icons.directions_car, 'Car'),
        (Icons.directions_bike, 'Bike'),
        (Icons.directions_walk, 'Walk'),
      ]) {
        expect(
          find.descendant(of: tabBar, matching: find.widgetWithIcon(Tab, icon)),
          findsOneWidget,
        );
        expect(
          find.descendant(of: tabBar, matching: find.text(label)),
          findsOneWidget,
        );
      }
      expect(selected(), 0);
      expect(find.text('Driving: 10 min'), findsOneWidget);

      // Tapping Bike slides to its page.
      await tester.tap(
        find.descendant(of: tabBar, matching: find.text('Bike')),
      );
      await tester.pumpAndSettle();
      expect(selected(), 1);
      expect(find.text('Biking: 25 min'), findsOneWidget);
      expect(find.text('Driving: 10 min'), findsNothing);

      // Swiping left moves on to Walk.
      await tester.fling(find.byType(TabBarView), const Offset(-400, 0), 1000);
      await tester.pumpAndSettle();
      expect(selected(), 2);
      expect(find.text('Walking: 50 min'), findsOneWidget);

      // Swiping right goes back to Bike.
      await tester.fling(find.byType(TabBarView), const Offset(400, 0), 1000);
      await tester.pumpAndSettle();
      expect(selected(), 1);
      expect(find.text('Biking: 25 min'), findsOneWidget);

      expect(find.byType(AppBar), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.byType(BackButton),
        ),
        findsNothing,
      );

      await tester.tap(find.byTooltip('Lesson notes'));
      await tester.pumpAndSettle();
      expect(find.text('Lesson 27: $title'), findsOneWidget);
      Navigator.of(tester.element(find.byType(BottomSheet))).pop();
      await tester.pumpAndSettle();
      expect(selected(), 1);
    });
  });
}
