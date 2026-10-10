import 'package:flutter/material.dart';
import 'package:flutter_lessons/lessons/lessons.dart';
import 'package:flutter_lessons/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final homeList = find.byType(Scrollable).first;

  Future<void> scrollTo(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(finder, 100, scrollable: homeList);
    await tester.pumpAndSettle();
  }

  test('registry has unique ids, in order, with lesson asset paths', () {
    expect(lessons, hasLength(21));
    for (var i = 0; i < lessons.length; i++) {
      expect(lessons[i].id, i + 1);
      expect(lessons[i].date, isNotNull, reason: lessons[i].title);
      expect(
        lessons[i].markdownPath,
        startsWith('lessons/${lessons[i].number}-'),
      );
    }
  });

  testWidgets('home screen lists every lesson title', (tester) async {
    await tester.pumpWidget(const FlutterLessonsApp());
    expect(find.text('Flutter Lessons'), findsOneWidget);
    for (final lesson in lessons) {
      final title = find.text(lesson.title);
      await scrollTo(tester, title);
      expect(title, findsOneWidget);
      expect(
        find.descendant(
          of: find.ancestor(of: title, matching: find.byType(ListTile)),
          matching: find.text(lesson.formattedDate),
        ),
        findsOneWidget,
      );
    }
  });

  testWidgets('every lesson opens, shows its notes and navigates back', (
    tester,
  ) async {
    await tester.pumpWidget(const FlutterLessonsApp());

    for (final lesson in lessons) {
      final tile = find.widgetWithText(ListTile, lesson.title);
      await scrollTo(tester, tile);
      await tester.tap(tile);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull, reason: lesson.title);
      expect(find.widgetWithText(AppBar, lesson.title), findsOneWidget);

      // The lesson text opens in a bottom sheet next to the example.
      await tester.tap(find.byTooltip('Lesson notes'));
      await tester.pumpAndSettle();
      expect(
        find.text('Lesson ${lesson.number}: ${lesson.title}'),
        findsOneWidget,
        reason: lesson.markdownPath,
      );
      Navigator.of(tester.element(find.byType(BottomSheet))).pop();
      await tester.pumpAndSettle();
      expect(find.byType(BottomSheet), findsNothing);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('Flutter Lessons'), findsOneWidget);
      expect(tester.takeException(), isNull, reason: lesson.title);
    }
  });

  group('interactive examples', () {
    Future<void> open(WidgetTester tester, String title) async {
      await tester.pumpWidget(const FlutterLessonsApp());
      final tile = find.widgetWithText(ListTile, title);
      await scrollTo(tester, tile);
      await tester.tap(tile);
      await tester.pumpAndSettle();
    }

    testWidgets('02 counter increments', (tester) async {
      await open(tester, 'StatefulWidget counter');
      expect(find.text('0'), findsOneWidget);
      await tester.tap(find.text('Increment'));
      await tester.pump();
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('11 FAB adds items', (tester) async {
      await open(tester, 'FloatingActionButton');
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      expect(find.text('Items added: 1'), findsOneWidget);
    });

    testWidgets('12 TextField greets by name', (tester) async {
      await open(tester, 'TextField and InputDecoration');
      expect(find.text('Your name'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Sam');
      await tester.pump();
      expect(find.text('Hello, Sam!'), findsOneWidget);
    });

    testWidgets('13 ListView shows three fruits', (tester) async {
      await open(tester, 'ListView of ListTiles');
      for (final fruit in ['Apples', 'Bananas', 'Cherries']) {
        expect(find.text(fruit), findsOneWidget);
      }
    });

    testWidgets('16 Stack shows the NEW badge', (tester) async {
      await open(tester, 'Stack and Positioned');
      expect(find.text('NEW'), findsOneWidget);
      final stack = tester.widget<Stack>(
        find.ancestor(of: find.text('NEW'), matching: find.byType(Stack)).first,
      );
      expect(stack.clipBehavior, Clip.none);
    });

    testWidgets('18 Dark mode switch toggles', (tester) async {
      await open(tester, 'SwitchListTile');
      expect(find.text('Off'), findsOneWidget);
      await tester.tap(find.text('Dark mode'));
      await tester.pumpAndSettle();
      expect(find.text('On'), findsOneWidget);
    });

    testWidgets('19 Save shows a SnackBar', (tester) async {
      await open(tester, 'SnackBar');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('Saved!'), findsOneWidget);
      // Let the SnackBar time out so no timers are left pending.
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      expect(find.text('Saved!'), findsNothing);
    });

    testWidgets('20 CircleAvatar uses placeholder initials', (tester) async {
      await open(tester, 'CircleAvatar');
      final avatar = tester.widget<CircleAvatar>(
        find.ancestor(of: find.text('AB'), matching: find.byType(CircleAvatar)),
      );
      expect(avatar.radius, 48);
      expect(avatar.backgroundColor, Colors.teal);
    });

    group('21 Navigator push and pop', () {
      const title =
          'Moving between screens with Navigator.push and Navigator.pop';

      testWidgets('is listed on the home screen', (tester) async {
        await tester.pumpWidget(const FlutterLessonsApp());
        await scrollTo(tester, find.text(title));
        expect(find.text(title), findsOneWidget);
        expect(find.text('Oct 10, 2026'), findsOneWidget);
      });

      testWidgets('Open details shows Details, Go back returns', (
        tester,
      ) async {
        await open(tester, title);
        expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);
        // Only the lesson screen's back arrow, not a second nested one.
        expect(find.byType(BackButton), findsOneWidget);

        await tester.tap(find.text('Open details'));
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Details'), findsOneWidget);
        expect(find.text('Open details'), findsNothing);

        await tester.tap(find.text('Go back'));
        await tester.pumpAndSettle();
        expect(find.text('Details'), findsNothing);
        expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);
        expect(find.widgetWithText(AppBar, title), findsOneWidget);
      });

      testWidgets('the Details back arrow returns to Home', (tester) async {
        await open(tester, title);
        await tester.tap(find.text('Open details'));
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Details'), findsOneWidget);

        await tester.pageBack();
        await tester.pumpAndSettle();
        expect(find.text('Details'), findsNothing);
        expect(find.text('Open details'), findsOneWidget);
        expect(find.widgetWithText(AppBar, title), findsOneWidget);
      });
    });
  });
}
