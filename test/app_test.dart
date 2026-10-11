import 'package:flutter/material.dart';
import 'package:flutter_lessons/lessons/lesson.dart';
import 'package:flutter_lessons/lessons/lessons.dart';
import 'package:flutter_lessons/main.dart';
import 'package:flutter_test/flutter_test.dart';

/// The AppBar title each lesson's own snippet uses, by lesson id.
///
/// `null` means the snippet has no AppBar, so the app shows the example under
/// a minimal AppBar with no title (only the back arrow and the info action).
const expectedAppBarTitles = <int, String?>{
  1: null,
  2: null,
  3: 'My page',
  4: null,
  5: null,
  6: null,
  7: null,
  8: null,
  9: null,
  10: null,
  11: null,
  12: null,
  13: null,
  14: null,
  15: null,
  16: null,
  17: null,
  18: null,
  19: null,
  20: null,
  21: 'Home',
  22: 'Fruits',
};

/// Checks the open lesson screen shows exactly one AppBar: the snippet's own
/// (or the untitled one), with a back arrow and the info action, and no
/// generic AppBar carrying the lesson's list title.
void expectLessonAppBar(WidgetTester tester, Lesson lesson) {
  final expected = expectedAppBarTitles[lesson.id];
  final appBars = tester.widgetList<AppBar>(find.byType(AppBar)).toList();
  expect(appBars, hasLength(1), reason: lesson.title);
  final title = appBars.single.title;
  if (expected == null) {
    expect(title, isNull, reason: lesson.title);
  } else {
    expect(title, isA<Text>(), reason: lesson.title);
    expect((title! as Text).data, expected, reason: lesson.title);
  }
  expect(find.widgetWithText(AppBar, lesson.title), findsNothing);
  expect(
    find.descendant(
      of: find.byType(AppBar),
      matching: find.byTooltip('Lesson notes'),
    ),
    findsOneWidget,
    reason: lesson.title,
  );
  expect(
    find.descendant(of: find.byType(AppBar), matching: find.byType(BackButton)),
    findsOneWidget,
    reason: lesson.title,
  );
}

void main() {
  final homeList = find.byType(Scrollable).first;

  Future<void> scrollTo(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(finder, 100, scrollable: homeList);
    await tester.pumpAndSettle();
  }

  test('registry has unique ids, in order, with lesson asset paths', () {
    expect(lessons, hasLength(22));
    for (var i = 0; i < lessons.length; i++) {
      expect(lessons[i].id, i + 1);
      expect(lessons[i].date, isNotNull, reason: lessons[i].title);
      expect(
        lessons[i].markdownPath,
        startsWith('lessons/${lessons[i].number}-'),
      );
    }
  });

  test('AppBar table covers every lesson', () {
    expect(
      expectedAppBarTitles.keys.toList(),
      lessons.map((l) => l.id).toList(),
    );
    for (final lesson in lessons) {
      expect(
        lesson.hasOwnAppBar,
        expectedAppBarTitles[lesson.id] != null,
        reason: 'hasOwnAppBar for ${lesson.title}',
      );
    }
  });

  group("each lesson opens with its snippet's AppBar", () {
    for (final lesson in lessons) {
      final expected = expectedAppBarTitles[lesson.id];
      testWidgets('${lesson.number}: ${expected ?? '(no title)'}', (
        tester,
      ) async {
        await tester.pumpWidget(const FlutterLessonsApp());
        final tile = find.widgetWithText(ListTile, lesson.title);
        await scrollTo(tester, tile);
        await tester.tap(tile);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        expectLessonAppBar(tester, lesson);

        // The info action opens this lesson's notes.
        await tester.tap(find.byTooltip('Lesson notes'));
        await tester.pumpAndSettle();
        expect(
          find.text('Lesson ${lesson.number}: ${lesson.title}'),
          findsOneWidget,
        );
        Navigator.of(tester.element(find.byType(BottomSheet))).pop();
        await tester.pumpAndSettle();

        // The AppBar's back arrow returns to the lesson list.
        await tester.tap(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.byType(BackButton),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Flutter Lessons'), findsOneWidget);
        expect(tile, findsOneWidget);
      });
    }
  });

  testWidgets('03 keeps the snippet AppBar styling', (tester) async {
    await tester.pumpWidget(const FlutterLessonsApp());
    await tester.tap(find.widgetWithText(ListTile, 'Scaffold'));
    await tester.pumpAndSettle();
    final appBar = tester.widget<AppBar>(find.byType(AppBar));
    final context = tester.element(find.byType(AppBar));
    expect(
      appBar.backgroundColor,
      Theme.of(context).colorScheme.primaryContainer,
    );
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
      expectLessonAppBar(tester, lesson);

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
        // Home's own AppBar has the one back arrow, to the lesson list.
        expect(find.byType(BackButton), findsOneWidget);

        await tester.tap(find.text('Open details'));
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Details'), findsOneWidget);
        expect(find.text('Open details'), findsNothing);

        await tester.tap(find.text('Go back'));
        await tester.pumpAndSettle();
        expect(find.text('Details'), findsNothing);
        expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);
        expect(find.widgetWithText(AppBar, title), findsNothing);
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
        expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);
      });
    });

    group('22 Passing data', () {
      const title = 'Passing data to a new screen through its constructor';

      testWidgets('is listed on the home screen', (tester) async {
        await tester.pumpWidget(const FlutterLessonsApp());
        await scrollTo(tester, find.text(title));
        expect(find.text(title), findsOneWidget);
        expect(find.text('Oct 11, 2026'), findsOneWidget);
      });

      testWidgets('lists all three fruits', (tester) async {
        await open(tester, title);
        expect(find.widgetWithText(AppBar, 'Fruits'), findsOneWidget);
        for (final fruit in ['Apple', 'Banana', 'Cherry']) {
          expect(find.widgetWithText(ListTile, fruit), findsOneWidget);
        }
        // Fruits' own AppBar has the one back arrow, to the lesson list.
        expect(find.byType(BackButton), findsOneWidget);
      });

      testWidgets('Banana opens its detail; back returns; Cherry opens', (
        tester,
      ) async {
        await open(tester, title);

        await tester.tap(find.widgetWithText(ListTile, 'Banana'));
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Banana'), findsOneWidget);
        expect(find.text('You picked Banana!'), findsOneWidget);

        await tester.pageBack();
        await tester.pumpAndSettle();
        expect(find.text('You picked Banana!'), findsNothing);
        expect(find.widgetWithText(AppBar, 'Fruits'), findsOneWidget);
        expect(find.widgetWithText(AppBar, title), findsNothing);

        await tester.tap(find.widgetWithText(ListTile, 'Cherry'));
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Cherry'), findsOneWidget);
        expect(find.text('You picked Cherry!'), findsOneWidget);
      });
    });
  });
}
