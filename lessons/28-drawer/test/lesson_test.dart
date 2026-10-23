import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_28_drawer/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'Drawer Tip';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 28);
    expect(lesson.notesAsset, '28-drawer.md');
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

  group('28 Drawer', () {
    const title = 'A Drawer menu that navigates';
    final drawer = find.byType(Drawer);
    final appBarBackArrow = find.descendant(
      of: find.byType(AppBar),
      matching: find.byType(BackButton),
    );

    ScaffoldState scaffold(WidgetTester tester) =>
        tester.firstState<ScaffoldState>(find.byType(Scaffold));

    Future<void> openDrawer(WidgetTester tester) async {
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();
      expect(drawer, findsOneWidget);
      expect(scaffold(tester).isDrawerOpen, isTrue);
    }

    void expectDrawerTip(WidgetTester tester) {
      expect(find.widgetWithText(AppBar, 'Drawer Tip'), findsOneWidget);
      expect(find.text('Tap the menu icon to open the drawer'), findsOneWidget);
      expect(drawer, findsNothing);
      expect(scaffold(tester).isDrawerOpen, isFalse);
    }

    testWidgets('the hamburger opens the drawer; Home closes it', (
      tester,
    ) async {
      await open(tester, title);
      expectDrawerTip(tester);
      // The hamburger is the AppBar's leading widget, so no back arrow.
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.byType(DrawerButton),
        ),
        findsOneWidget,
      );
      expect(appBarBackArrow, findsNothing);

      await openDrawer(tester);
      expect(
        find.descendant(of: drawer, matching: find.byType(DrawerHeader)),
        findsOneWidget,
      );
      expect(
        find.descendant(of: drawer, matching: find.text('Menu')),
        findsOneWidget,
      );
      for (final (icon, label) in [
        (Icons.home, 'Home'),
        (Icons.settings, 'Settings'),
        (Icons.info_outline, 'About'),
      ]) {
        final row = find.descendant(
          of: drawer,
          matching: find.widgetWithText(ListTile, label),
        );
        expect(row, findsOneWidget);
        expect(
          find.descendant(of: row, matching: find.byIcon(icon)),
          findsOneWidget,
        );
      }

      // Home only closes the drawer.
      await tester.tap(
        find.descendant(of: drawer, matching: find.text('Home')),
      );
      await tester.pumpAndSettle();
      expectDrawerTip(tester);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('swiping in from the left edge opens the drawer', (
      tester,
    ) async {
      await open(tester, title);
      await tester.dragFrom(const Offset(5, 300), const Offset(300, 0));
      await tester.pumpAndSettle();
      expect(scaffold(tester).isDrawerOpen, isTrue);
    });

    for (final page in ['Settings', 'About']) {
      testWidgets('$page closes the drawer, opens $page; back returns', (
        tester,
      ) async {
        await open(tester, title);
        await openDrawer(tester);

        await tester.tap(
          find.descendant(of: drawer, matching: find.text(page)),
        );
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, page), findsOneWidget);
        expect(find.text('This is the $page page'), findsOneWidget);
        expect(appBarBackArrow, findsOneWidget);
        expect(drawer, findsNothing);

        // The back arrow returns to Drawer Tip with the drawer closed.
        await tester.pageBack();
        await tester.pumpAndSettle();
        expectDrawerTip(tester);
        expect(find.text('This is the $page page'), findsNothing);
      });
    }

    testWidgets('the info action opens the lesson notes', (tester) async {
      await open(tester, title);
      await tester.tap(find.byTooltip('Lesson notes'));
      await tester.pumpAndSettle();
      expect(find.text('Lesson 28: $title'), findsOneWidget);
      Navigator.of(tester.element(find.byType(BottomSheet))).pop();
    });
  });
}
