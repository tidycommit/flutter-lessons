import 'package:flutter/material.dart';
import 'package:flutter_lessons/lessons/lesson.dart';
import 'package:flutter_lessons/lessons/lessons.dart';
import 'package:flutter_lessons/main.dart';
import 'package:flutter_test/flutter_test.dart';

/// The AppBar title from each lesson's snippet, by lesson id. Titles for
/// 01-10 were supplied by the teacher; 11-20 come from the original
/// snippets; 21-25 from the lesson code.
const expectedAppBarTitles = <int, String>{
  1: 'Hello',
  2: 'Counter',
  3: 'My page',
  4: 'Column & Row',
  5: 'Padding',
  6: 'Expanded',
  7: 'Hello',
  8: 'Center',
  9: 'Container',
  10: 'ElevatedButton',
  11: 'FAB Tip',
  12: 'TextField',
  13: 'My List',
  14: 'Icons',
  15: 'Cards',
  16: 'Stack',
  17: 'Text Styles',
  18: 'Settings',
  19: 'SnackBar',
  20: 'Avatar',
  21: 'Home',
  22: 'Fruits',
  23: 'Pick a Color',
  24: 'Home',
  25: 'Login',
};

/// Lessons whose first screen has no back arrow by design; their AppBar
/// actions carry a "Back to lessons" button instead.
const lessonsWithoutBackArrow = {25};

/// Checks the open lesson screen shows exactly one AppBar, the snippet's own:
/// the expected title, default styling, a way back to the lesson list (the
/// back arrow, or the "Back to lessons" action) and the info action.
void expectLessonAppBar(WidgetTester tester, Lesson lesson) {
  final appBars = tester.widgetList<AppBar>(find.byType(AppBar)).toList();
  expect(appBars, hasLength(1), reason: lesson.title);
  final appBar = appBars.single;
  expect(appBar.title, isA<Text>(), reason: lesson.title);
  expect(
    (appBar.title! as Text).data,
    expectedAppBarTitles[lesson.id],
    reason: lesson.title,
  );
  // All snippets use default AppBar styling.
  expect(appBar.backgroundColor, isNull, reason: lesson.title);
  expect(appBar.foregroundColor, isNull, reason: lesson.title);
  expect(
    find.descendant(
      of: find.byType(AppBar),
      matching: find.byTooltip('Lesson notes'),
    ),
    findsOneWidget,
    reason: lesson.title,
  );
  final noBackArrow = lessonsWithoutBackArrow.contains(lesson.id);
  expect(
    find.descendant(of: find.byType(AppBar), matching: find.byType(BackButton)),
    noBackArrow ? findsNothing : findsOneWidget,
    reason: lesson.title,
  );
  expect(
    find.descendant(
      of: find.byType(AppBar),
      matching: find.byTooltip('Back to lessons'),
    ),
    noBackArrow ? findsOneWidget : findsNothing,
    reason: lesson.title,
  );
}

/// Leaves the open lesson for the lesson list the way its AppBar offers.
Future<void> leaveLesson(WidgetTester tester, Lesson lesson) async {
  if (lessonsWithoutBackArrow.contains(lesson.id)) {
    await tester.tap(find.byTooltip('Back to lessons'));
  } else {
    await tester.pageBack();
  }
  await tester.pumpAndSettle();
}

void main() {
  final homeList = find.byType(Scrollable).first;

  Future<void> scrollTo(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(finder, 100, scrollable: homeList);
    await tester.pumpAndSettle();
  }

  test('registry has unique ids, in order, with lesson asset paths', () {
    expect(lessons, hasLength(25));
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
  });

  group("each lesson opens with its snippet's AppBar", () {
    for (final lesson in lessons) {
      testWidgets('${lesson.number}: ${expectedAppBarTitles[lesson.id]}', (
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

        // The AppBar's way back returns to the lesson list.
        await leaveLesson(tester, lesson);
        expect(find.widgetWithText(AppBar, 'Flutter Lessons'), findsOneWidget);
        expect(tile, findsOneWidget);
      });
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

      await leaveLesson(tester, lesson);
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

    testWidgets('07 body is wrapped in SafeArea', (tester) async {
      await open(tester, 'SafeArea');
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.body, isA<SafeArea>());
    });

    testWidgets('08 centers Hello, Flutter!', (tester) async {
      await open(tester, 'Center');
      expect(
        find.descendant(
          of: find.byType(Center),
          matching: find.text('Hello, Flutter!'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('09 Container says Hello!', (tester) async {
      await open(tester, 'Container');
      expect(find.text('Hello!'), findsOneWidget);
    });

    testWidgets('10 Tap me counts taps', (tester) async {
      await open(tester, 'ElevatedButton');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Tap me'));
      await tester.pump();
      expect(find.text('Pressed 1 times'), findsOneWidget);
    });

    testWidgets('11 FAB is shown and its empty onPressed is harmless', (
      tester,
    ) async {
      await open(tester, 'FloatingActionButton');
      expect(find.text('Tap the + button'), findsOneWidget);
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Tap the + button'), findsOneWidget);
    });

    testWidgets('12 TextField has its label and border and accepts text', (
      tester,
    ) async {
      await open(tester, 'TextField and InputDecoration');
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.decoration?.labelText, 'Your name');
      expect(field.decoration?.border, isA<OutlineInputBorder>());
      await tester.enterText(find.byType(TextField), 'Sam');
      await tester.pump();
      expect(find.text('Sam'), findsOneWidget);
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

    testWidgets('18 Dark mode starts on and toggles off', (tester) async {
      await open(tester, 'SwitchListTile');
      bool value() =>
          tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value;
      expect(value(), isTrue);
      await tester.tap(find.text('Dark mode'));
      await tester.pumpAndSettle();
      expect(value(), isFalse);
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

    group('23 Returning a result', () {
      const title =
          'Returning a result with Navigator.pop(context, value) and await';

      testWidgets('is listed on the home screen', (tester) async {
        await tester.pumpWidget(const FlutterLessonsApp());
        await scrollTo(tester, find.text(title));
        expect(find.text(title), findsOneWidget);
        expect(find.text('Oct 12, 2026'), findsOneWidget);
      });

      testWidgets('picking Blue returns it; the back arrow returns nothing', (
        tester,
      ) async {
        await open(tester, title);
        expect(find.widgetWithText(AppBar, 'Pick a Color'), findsOneWidget);
        expect(find.text('Favorite color: none yet'), findsOneWidget);

        await tester.tap(find.text('Choose color'));
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Colors'), findsOneWidget);
        for (final color in ['Red', 'Green', 'Blue']) {
          expect(find.widgetWithText(ListTile, color), findsOneWidget);
        }

        await tester.tap(find.widgetWithText(ListTile, 'Blue'));
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Pick a Color'), findsOneWidget);
        expect(find.text('Favorite color: Blue'), findsOneWidget);

        // Leaving with the back arrow pops with no value: text unchanged.
        await tester.tap(find.text('Choose color'));
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Colors'), findsOneWidget);
        await tester.pageBack();
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Pick a Color'), findsOneWidget);
        expect(find.text('Favorite color: Blue'), findsOneWidget);

        // Info action opens the notes; the back arrow returns to the list.
        await tester.tap(find.byTooltip('Lesson notes'));
        await tester.pumpAndSettle();
        expect(find.text('Lesson 23: $title'), findsOneWidget);
        Navigator.of(tester.element(find.byType(BottomSheet))).pop();
        await tester.pumpAndSettle();
        await tester.pageBack();
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Flutter Lessons'), findsOneWidget);
      });
    });

    group('24 Named routes', () {
      const title = 'Named routes with routes and Navigator.pushNamed';

      testWidgets('is listed on the home screen', (tester) async {
        await tester.pumpWidget(const FlutterLessonsApp());
        await scrollTo(tester, find.text(title));
        expect(find.text(title), findsOneWidget);
        expect(find.text('Oct 13, 2026'), findsOneWidget);
      });

      testWidgets('Settings and About open by name; back returns to Home', (
        tester,
      ) async {
        await open(tester, title);
        expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);

        await tester.tap(find.widgetWithText(ElevatedButton, 'Settings'));
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Settings'), findsOneWidget);
        expect(find.text('Settings screen'), findsOneWidget);
        await tester.pageBack();
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);

        await tester.tap(find.widgetWithText(ElevatedButton, 'About'));
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'About'), findsOneWidget);
        expect(find.text('About this app'), findsOneWidget);
        await tester.pageBack();
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);

        // Info action opens the notes.
        await tester.tap(find.byTooltip('Lesson notes'));
        await tester.pumpAndSettle();
        expect(find.text('Lesson 24: $title'), findsOneWidget);
        Navigator.of(tester.element(find.byType(BottomSheet))).pop();
        await tester.pumpAndSettle();

        // Home's back arrow returns to the lesson list.
        await tester.pageBack();
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Flutter Lessons'), findsOneWidget);
      });

      testWidgets('system back: Settings to Home, then Home to the list', (
        tester,
      ) async {
        await open(tester, title);
        await tester.tap(find.widgetWithText(ElevatedButton, 'Settings'));
        await tester.pumpAndSettle();
        expect(find.text('Settings screen'), findsOneWidget);

        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);

        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Flutter Lessons'), findsOneWidget);
      });
    });

    group('25 pushReplacement and pushAndRemoveUntil', () {
      const title =
          'Leaving screens behind with pushReplacement and pushAndRemoveUntil';
      final backArrow = find.descendant(
        of: find.byType(AppBar),
        matching: find.byType(BackButton),
      );

      testWidgets('is listed on the home screen', (tester) async {
        await tester.pumpWidget(const FlutterLessonsApp());
        await scrollTo(tester, find.text(title));
        expect(find.text(title), findsOneWidget);
        expect(find.text('Oct 14, 2026'), findsOneWidget);
      });

      testWidgets('log in replaces Login; log out clears back to Login', (
        tester,
      ) async {
        await open(tester, title);
        expect(find.widgetWithText(AppBar, 'Login'), findsOneWidget);
        expect(backArrow, findsNothing);

        // pushReplacement: Home takes Login's place, no back arrow.
        await tester.tap(find.widgetWithText(ElevatedButton, 'Log in'));
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);
        expect(find.widgetWithText(AppBar, 'Login'), findsNothing);
        expect(find.text('Welcome! You are logged in.'), findsOneWidget);
        expect(backArrow, findsNothing);
        expect(find.byTooltip('Lesson notes'), findsOneWidget);
        expect(find.byTooltip('Back to lessons'), findsOneWidget);

        // Settings is a normal push, so it has a back arrow to Home.
        await tester.tap(find.widgetWithText(ElevatedButton, 'Open Settings'));
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Settings'), findsOneWidget);
        expect(backArrow, findsOneWidget);
        await tester.pageBack();
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);

        // pushAndRemoveUntil: Login alone, no back arrow.
        await tester.tap(find.widgetWithText(ElevatedButton, 'Open Settings'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(ElevatedButton, 'Log out'));
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Login'), findsOneWidget);
        expect(find.widgetWithText(AppBar, 'Home'), findsNothing);
        expect(find.widgetWithText(AppBar, 'Settings'), findsNothing);
        expect(backArrow, findsNothing);
        expect(tester.takeException(), isNull);

        // The info action still opens the notes.
        await tester.tap(find.byTooltip('Lesson notes'));
        await tester.pumpAndSettle();
        expect(find.text('Lesson 25: $title'), findsOneWidget);
        Navigator.of(tester.element(find.byType(BottomSheet))).pop();
        await tester.pumpAndSettle();

        // The lesson list survived and is still reachable.
        await tester.tap(find.byTooltip('Back to lessons'));
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Flutter Lessons'), findsOneWidget);
        expect(find.widgetWithText(ListTile, title), findsOneWidget);
      });

      testWidgets('Home leads back to the list; system back too', (
        tester,
      ) async {
        await open(tester, title);
        await tester.tap(find.widgetWithText(ElevatedButton, 'Log in'));
        await tester.pumpAndSettle();
        await tester.tap(find.byTooltip('Back to lessons'));
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Flutter Lessons'), findsOneWidget);

        // System back: Settings to Home, then Home to the list.
        final tile = find.widgetWithText(ListTile, title);
        await tester.tap(tile);
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(ElevatedButton, 'Log in'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(ElevatedButton, 'Open Settings'));
        await tester.pumpAndSettle();
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Flutter Lessons'), findsOneWidget);
      });
    });
  });
}
