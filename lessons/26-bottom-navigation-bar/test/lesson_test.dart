import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_26_bottom_navigation_bar/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'Home';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 26);
    expect(lesson.notesAsset, '26-bottom-navigation-bar.md');
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

  group('26 BottomNavigationBar', () {
    const title = 'BottomNavigationBar';
    final bar = find.byType(BottomNavigationBar);

    testWidgets('tabs swap title and body in place, no route pushed', (
      tester,
    ) async {
      await open(tester, title);
      int currentIndex() =>
          tester.widget<BottomNavigationBar>(bar).currentIndex;

      expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);
      expect(find.text('Home page'), findsOneWidget);
      expect(currentIndex(), 0);
      for (final icon in [Icons.home, Icons.search, Icons.person]) {
        expect(
          find.descendant(of: bar, matching: find.byIcon(icon)),
          findsOneWidget,
        );
      }

      const tabs = {1: 'Search', 2: 'Profile', 0: 'Home'};
      for (final MapEntry(key: index, value: name) in tabs.entries) {
        await tester.tap(find.descendant(of: bar, matching: find.text(name)));
        await tester.pumpAndSettle();
        expect(currentIndex(), index);
        expect(find.widgetWithText(AppBar, name), findsOneWidget);
        expect(find.text('$name page'), findsOneWidget);
        // Still a single lesson screen with one AppBar: nothing pushed.
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byTooltip('Lesson notes'), findsOneWidget);
      }

      await tester.tap(
        find.descendant(of: bar, matching: find.text('Profile')),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Lesson notes'));
      await tester.pumpAndSettle();
      expect(find.text('Lesson 26: $title'), findsOneWidget);
      Navigator.of(tester.element(find.byType(BottomSheet))).pop();
    });
  });
}
