import 'package:flutter/material.dart';
import 'package:flutter_lessons/lessons/lesson.dart';
import 'package:flutter_lessons/lessons/31_design_system_mindset.dart';
import 'package:flutter_lessons/lessons/lessons.dart';
import 'package:flutter_lessons/main.dart';
import 'package:flutter_test/flutter_test.dart';

/// The AppBar title from each lesson's snippet, by lesson id. Titles for
/// 01-10 were supplied by the teacher; 11-20 come from the original
/// snippets; 21-32 from the lesson code.
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
  26: 'Home',
  27: 'Tabs Tip',
  28: 'Drawer Tip',
  29: 'Popups Tip',
  30: 'PopScope Tip',
  31: 'Design system',
  32: 'ThemeData',
};

/// Lessons whose first screen has no back arrow (by design in 25; in 28 the
/// drawer's hamburger takes the leading slot); their AppBar actions carry a
/// "Back to lessons" button instead.
const lessonsWithoutBackArrow = {25, 28};

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
    expect(lessons, hasLength(32));
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

    group('26 BottomNavigationBar', () {
      const title = 'BottomNavigationBar';
      final bar = find.byType(BottomNavigationBar);

      testWidgets('is listed on the home screen', (tester) async {
        await tester.pumpWidget(const FlutterLessonsApp());
        await scrollTo(tester, find.widgetWithText(ListTile, title));
        expect(find.widgetWithText(ListTile, title), findsOneWidget);
        expect(find.text('Oct 15, 2026'), findsOneWidget);
      });

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

        // After switching tabs, one back goes straight to the lesson list.
        await tester.tap(
          find.descendant(of: bar, matching: find.text('Profile')),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byTooltip('Lesson notes'));
        await tester.pumpAndSettle();
        expect(find.text('Lesson 26: $title'), findsOneWidget);
        Navigator.of(tester.element(find.byType(BottomSheet))).pop();
        await tester.pumpAndSettle();
        await tester.pageBack();
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Flutter Lessons'), findsOneWidget);
      });
    });

    group('27 TabBar', () {
      const title = 'Tabs with TabBar, TabBarView, and DefaultTabController';
      final tabBar = find.byType(TabBar);

      testWidgets('is listed on the home screen', (tester) async {
        await tester.pumpWidget(const FlutterLessonsApp());
        await scrollTo(tester, find.text(title));
        expect(find.text(title), findsOneWidget);
        expect(find.text('Oct 16, 2026'), findsOneWidget);
      });

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
            find.descendant(
              of: tabBar,
              matching: find.widgetWithIcon(Tab, icon),
            ),
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
        await tester.fling(
          find.byType(TabBarView),
          const Offset(-400, 0),
          1000,
        );
        await tester.pumpAndSettle();
        expect(selected(), 2);
        expect(find.text('Walking: 50 min'), findsOneWidget);

        // Swiping right goes back to Bike.
        await tester.fling(find.byType(TabBarView), const Offset(400, 0), 1000);
        await tester.pumpAndSettle();
        expect(selected(), 1);
        expect(find.text('Biking: 25 min'), findsOneWidget);

        // No route was pushed: still one AppBar, one back arrow to the list.
        expect(find.byType(AppBar), findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.byType(BackButton),
          ),
          findsOneWidget,
        );

        await tester.tap(find.byTooltip('Lesson notes'));
        await tester.pumpAndSettle();
        expect(find.text('Lesson 27: $title'), findsOneWidget);
        Navigator.of(tester.element(find.byType(BottomSheet))).pop();
        await tester.pumpAndSettle();
        expect(selected(), 1);

        await tester.pageBack();
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Flutter Lessons'), findsOneWidget);
        expect(find.widgetWithText(ListTile, title), findsOneWidget);
      });
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
        expect(
          find.text('Tap the menu icon to open the drawer'),
          findsOneWidget,
        );
        expect(drawer, findsNothing);
        expect(scaffold(tester).isDrawerOpen, isFalse);
      }

      testWidgets('is listed on the home screen', (tester) async {
        await tester.pumpWidget(const FlutterLessonsApp());
        await scrollTo(tester, find.text(title));
        expect(find.text(title), findsOneWidget);
        expect(find.text('Oct 17, 2026'), findsOneWidget);
      });

      testWidgets('the hamburger opens the drawer; Home closes it', (
        tester,
      ) async {
        await open(tester, title);
        expectDrawerTip(tester);
        // The hamburger is the AppBar's leading widget, so no back arrow;
        // the way back is the "Back to lessons" action.
        expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.byType(DrawerButton),
          ),
          findsOneWidget,
        );
        expect(appBarBackArrow, findsNothing);
        expect(find.byTooltip('Back to lessons'), findsOneWidget);

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

      testWidgets('info, Back to lessons and system back work', (tester) async {
        await open(tester, title);
        await tester.tap(find.byTooltip('Lesson notes'));
        await tester.pumpAndSettle();
        expect(find.text('Lesson 28: $title'), findsOneWidget);
        Navigator.of(tester.element(find.byType(BottomSheet))).pop();
        await tester.pumpAndSettle();

        await tester.tap(find.byTooltip('Back to lessons'));
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Flutter Lessons'), findsOneWidget);
        expect(find.widgetWithText(ListTile, title), findsOneWidget);

        // System back: first closes an open drawer, then leaves the lesson.
        await tester.tap(find.widgetWithText(ListTile, title));
        await tester.pumpAndSettle();
        await openDrawer(tester);
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expectDrawerTip(tester);
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Flutter Lessons'), findsOneWidget);
      });
    });

    group('29 Dialogs and bottom sheets', () {
      const title = 'showDialog and showModalBottomSheet as routes';
      final dialog = find.byType(AlertDialog);
      final sheet = find.byType(BottomSheet);
      final appBarBackArrow = find.descendant(
        of: find.byType(AppBar),
        matching: find.byType(BackButton),
      );

      Future<void> openDialog(WidgetTester tester) async {
        await tester.tap(find.widgetWithText(ElevatedButton, 'Delete photo'));
        await tester.pumpAndSettle();
        expect(dialog, findsOneWidget);
        expect(
          find.descendant(of: dialog, matching: find.text('Delete photo?')),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: dialog,
            matching: find.text('This cannot be undone.'),
          ),
          findsOneWidget,
        );
        for (final label in ['Cancel', 'Delete']) {
          expect(
            find.descendant(
              of: dialog,
              matching: find.widgetWithText(TextButton, label),
            ),
            findsOneWidget,
          );
        }
      }

      Future<void> openSheet(WidgetTester tester) async {
        await tester.tap(find.widgetWithText(ElevatedButton, 'Share'));
        await tester.pumpAndSettle();
        expect(sheet, findsOneWidget);
        for (final (icon, label) in [
          (Icons.email, 'Email'),
          (Icons.message, 'Messages'),
        ]) {
          final row = find.descendant(
            of: sheet,
            matching: find.widgetWithText(ListTile, label),
          );
          expect(row, findsOneWidget);
          expect(
            find.descendant(of: row, matching: find.byIcon(icon)),
            findsOneWidget,
          );
        }
      }

      void expectMessage(String message) {
        expect(find.text(message), findsOneWidget);
        expect(dialog, findsNothing);
        expect(sheet, findsNothing);
        // Still the lesson screen: the popup route is gone, nothing else.
        expect(find.widgetWithText(AppBar, 'Popups Tip'), findsOneWidget);
      }

      testWidgets('is listed on the home screen', (tester) async {
        await tester.pumpWidget(const FlutterLessonsApp());
        await scrollTo(tester, find.text(title));
        expect(find.text(title), findsOneWidget);
        expect(find.text('Oct 18, 2026'), findsOneWidget);
      });

      testWidgets("opens on Popups Tip with the snippet's AppBar", (
        tester,
      ) async {
        await open(tester, title);
        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect((appBar.title! as Text).data, 'Popups Tip');
        expect(appBar.backgroundColor, isNull);
        expect(appBar.foregroundColor, isNull);
        expect(find.text('Nothing chosen yet'), findsOneWidget);
        expect(
          find.widgetWithText(ElevatedButton, 'Delete photo'),
          findsOneWidget,
        );
        expect(find.widgetWithText(ElevatedButton, 'Share'), findsOneWidget);
        // The pushed lesson screen has the back arrow to the list, and the
        // info action in the AppBar.
        expect(appBarBackArrow, findsOneWidget);
        expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.byTooltip('Lesson notes'),
          ),
          findsOneWidget,
        );
        expect(find.byTooltip('Back to lessons'), findsNothing);
      });

      testWidgets('Delete photo, then Delete: Photo deleted', (tester) async {
        await open(tester, title);
        await openDialog(tester);
        await tester.tap(find.widgetWithText(TextButton, 'Delete'));
        await tester.pumpAndSettle();
        expectMessage('Photo deleted');
      });

      testWidgets('Delete photo, then Cancel: Kept the photo', (tester) async {
        await open(tester, title);
        await openDialog(tester);
        await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
        await tester.pumpAndSettle();
        expectMessage('Kept the photo');
      });

      testWidgets('tapping outside the dialog returns null: Kept the photo', (
        tester,
      ) async {
        await open(tester, title);
        await openDialog(tester);
        // The barrier covers the whole screen; tap a corner, away from the
        // dialog.
        await tester.tapAt(const Offset(10, 300));
        await tester.pumpAndSettle();
        expectMessage('Kept the photo');
      });

      testWidgets('system back closes the dialog only: Kept the photo', (
        tester,
      ) async {
        await open(tester, title);
        await openDialog(tester);
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expectMessage('Kept the photo');
      });

      for (final app in ['Email', 'Messages']) {
        testWidgets('Share, then $app: Shared with $app', (tester) async {
          await open(tester, title);
          await openSheet(tester);
          await tester.tap(
            find.descendant(of: sheet, matching: find.text(app)),
          );
          await tester.pumpAndSettle();
          expectMessage('Shared with $app');
        });
      }

      testWidgets('dismissing the sheet leaves the text unchanged', (
        tester,
      ) async {
        await open(tester, title);

        // Swipe it down.
        await openSheet(tester);
        await tester.drag(sheet, const Offset(0, 400));
        await tester.pumpAndSettle();
        expectMessage('Nothing chosen yet');

        // Tap the dimmed area above it.
        await openSheet(tester);
        await tester.tapAt(const Offset(400, 100));
        await tester.pumpAndSettle();
        expectMessage('Nothing chosen yet');

        // System back.
        await openSheet(tester);
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expectMessage('Nothing chosen yet');

        // After a choice, dismissing still leaves the last message.
        await openSheet(tester);
        await tester.tap(
          find.descendant(of: sheet, matching: find.text('Email')),
        );
        await tester.pumpAndSettle();
        await openSheet(tester);
        await tester.drag(sheet, const Offset(0, 400));
        await tester.pumpAndSettle();
        expectMessage('Shared with Email');
      });

      testWidgets('info opens the notes; back returns to the list', (
        tester,
      ) async {
        await open(tester, title);
        await openDialog(tester);
        await tester.tap(find.widgetWithText(TextButton, 'Delete'));
        await tester.pumpAndSettle();

        await tester.tap(find.byTooltip('Lesson notes'));
        await tester.pumpAndSettle();
        expect(find.text('Lesson 29: $title'), findsOneWidget);
        Navigator.of(tester.element(find.byType(BottomSheet))).pop();
        await tester.pumpAndSettle();
        expectMessage('Photo deleted');

        // Popups were popped on their own, so one back reaches the list.
        await tester.pageBack();
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Flutter Lessons'), findsOneWidget);
        expect(find.widgetWithText(ListTile, title), findsOneWidget);

        // System back from the lesson screen also returns to the list.
        await tester.tap(find.widgetWithText(ListTile, title));
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Popups Tip'), findsOneWidget);
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Flutter Lessons'), findsOneWidget);
      });
    });

    group('30 PopScope', () {
      const title = 'PopScope for handling back';
      const note = 'Buy milk and eggs';
      final dialog = find.byType(AlertDialog);
      final appBarBackArrow = find.descendant(
        of: find.byType(AppBar),
        matching: find.byType(BackButton),
      );

      void expectNewNote() {
        expect(find.widgetWithText(AppBar, 'New Note'), findsOneWidget);
        expect(find.widgetWithText(AppBar, 'PopScope Tip'), findsNothing);
        expect(find.byType(TextField), findsOneWidget);
      }

      Future<void> openNote(WidgetTester tester) async {
        await open(tester, title);
        await tester.tap(find.widgetWithText(ElevatedButton, 'Write a note'));
        await tester.pumpAndSettle();
        expectNewNote();
      }

      void expectPopScopeTip() {
        expect(find.widgetWithText(AppBar, 'PopScope Tip'), findsOneWidget);
        expect(find.text('Write a note'), findsOneWidget);
        expect(find.widgetWithText(AppBar, 'New Note'), findsNothing);
        expect(dialog, findsNothing);
      }

      void expectDiscardDialog() {
        expect(dialog, findsOneWidget);
        expect(
          find.descendant(of: dialog, matching: find.text('Discard note?')),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: dialog,
            matching: find.text('Your note will be lost.'),
          ),
          findsOneWidget,
        );
        for (final label in ['Keep editing', 'Discard']) {
          expect(
            find.descendant(
              of: dialog,
              matching: find.widgetWithText(TextButton, label),
            ),
            findsOneWidget,
          );
        }
        // The pop was blocked: New Note is still underneath the dialog.
        expect(find.widgetWithText(AppBar, 'New Note'), findsOneWidget);
      }

      String fieldText(WidgetTester tester) =>
          tester.widget<TextField>(find.byType(TextField)).controller!.text;

      // The two ways back the snippet guards: the AppBar back arrow, and
      // system / browser back (which goes through the app's navigator).
      final backs = <String, Future<void> Function(WidgetTester)>{
        'the back arrow': (tester) async {
          await tester.tap(appBarBackArrow);
          await tester.pumpAndSettle();
        },
        'system back': (tester) async {
          await tester.binding.handlePopRoute();
          await tester.pumpAndSettle();
        },
      };

      testWidgets('is listed on the home screen', (tester) async {
        await tester.pumpWidget(const FlutterLessonsApp());
        await scrollTo(tester, find.text(title));
        expect(find.text(title), findsOneWidget);
        expect(find.text('Oct 19, 2026'), findsOneWidget);
      });

      testWidgets("opens on PopScope Tip with the snippet's AppBar", (
        tester,
      ) async {
        await open(tester, title);
        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect((appBar.title! as Text).data, 'PopScope Tip');
        expect(appBar.backgroundColor, isNull);
        expect(appBar.foregroundColor, isNull);
        expect(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.byTooltip('Lesson notes'),
          ),
          findsOneWidget,
        );
        expect(appBarBackArrow, findsOneWidget);
        expect(find.byTooltip('Back to lessons'), findsNothing);
        expect(
          find.widgetWithText(ElevatedButton, 'Write a note'),
          findsOneWidget,
        );
      });

      testWidgets('Write a note opens New Note with its hint', (tester) async {
        await openNote(tester);
        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect((appBar.title! as Text).data, 'New Note');
        expect(appBar.actions, isNull);
        expect(appBarBackArrow, findsOneWidget);
        expect(find.text('Type something...'), findsOneWidget);
        expect(fieldText(tester), isEmpty);
      });

      for (final MapEntry(key: how, value: back) in backs.entries) {
        testWidgets('empty note: $how returns to PopScope Tip at once', (
          tester,
        ) async {
          await openNote(tester);
          await back(tester);
          expectPopScopeTip();
        });

        testWidgets('typed note: $how shows Discard note?', (tester) async {
          await openNote(tester);
          await tester.enterText(find.byType(TextField), note);
          await tester.pump();
          await back(tester);
          expectDiscardDialog();
          expect(fieldText(tester), note);
        });

        testWidgets('typed note: $how, Keep editing keeps the text', (
          tester,
        ) async {
          await openNote(tester);
          await tester.enterText(find.byType(TextField), note);
          await tester.pump();
          await back(tester);
          expectDiscardDialog();

          await tester.tap(find.widgetWithText(TextButton, 'Keep editing'));
          await tester.pumpAndSettle();
          expect(dialog, findsNothing);
          expectNewNote();
          expect(find.text(note), findsOneWidget);
          expect(fieldText(tester), note);

          // Still guarded: going back again asks again.
          await back(tester);
          expectDiscardDialog();
        });

        testWidgets('typed note: $how, Discard returns to PopScope Tip', (
          tester,
        ) async {
          await openNote(tester);
          await tester.enterText(find.byType(TextField), note);
          await tester.pump();
          await back(tester);
          expectDiscardDialog();

          await tester.tap(find.widgetWithText(TextButton, 'Discard'));
          await tester.pumpAndSettle();
          // Only the note was popped, not the lesson.
          expectPopScopeTip();
          expect(find.text(note), findsNothing);

          // A fresh note starts empty.
          await tester.tap(find.widgetWithText(ElevatedButton, 'Write a note'));
          await tester.pumpAndSettle();
          expectNewNote();
          expect(fieldText(tester), isEmpty);
        });
      }

      testWidgets('system back with the dialog open closes only the dialog', (
        tester,
      ) async {
        await openNote(tester);
        await tester.enterText(find.byType(TextField), note);
        await tester.pump();
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expectDiscardDialog();

        // Back pops the dialog route (null result), not New Note.
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(dialog, findsNothing);
        expectNewNote();
        expect(fieldText(tester), note);
      });

      testWidgets('clearing the note lets back through again', (tester) async {
        await openNote(tester);
        await tester.enterText(find.byType(TextField), note);
        await tester.pump();
        await tester.enterText(find.byType(TextField), '');
        await tester.pump();
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expectPopScopeTip();
      });

      testWidgets('info opens the notes; back returns to the list', (
        tester,
      ) async {
        await open(tester, title);
        await tester.tap(find.byTooltip('Lesson notes'));
        await tester.pumpAndSettle();
        expect(find.text('Lesson 30: $title'), findsOneWidget);
        Navigator.of(tester.element(find.byType(BottomSheet))).pop();
        await tester.pumpAndSettle();
        expectPopScopeTip();

        // After a guarded note was discarded, the lesson screen's own back
        // arrow still leads straight to the list.
        await tester.tap(find.widgetWithText(ElevatedButton, 'Write a note'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), note);
        await tester.pump();
        await tester.pageBack();
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(TextButton, 'Discard'));
        await tester.pumpAndSettle();
        expectPopScopeTip();
        await tester.pageBack();
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Flutter Lessons'), findsOneWidget);
        expect(find.widgetWithText(ListTile, title), findsOneWidget);

        // System back from PopScope Tip also returns to the list.
        await tester.tap(find.widgetWithText(ListTile, title));
        await tester.pumpAndSettle();
        expectPopScopeTip();
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Flutter Lessons'), findsOneWidget);
      });
    });

    group('31 Design-system mindset', () {
      const title = 'Design-system mindset';
      final appButtons = find.byType(AppButton);

      Future<void> scrollToButton(WidgetTester tester, Finder finder) async {
        await tester.scrollUntilVisible(
          finder,
          100,
          scrollable: find.byType(Scrollable).last,
        );
        await tester.pumpAndSettle();
      }

      testWidgets('is listed on the home screen', (tester) async {
        await tester.pumpWidget(const FlutterLessonsApp());
        await scrollTo(tester, find.text(title));
        expect(find.text(title), findsOneWidget);
        expect(find.text('Oct 20, 2026'), findsOneWidget);
      });

      testWidgets("opens on Design system with the snippet's AppBar", (
        tester,
      ) async {
        await open(tester, title);
        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect((appBar.title! as Text).data, 'Design system');
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
          findsOneWidget,
        );
        expect(find.text('Presses: 0'), findsOneWidget);
        expect(find.text('Inconsistent'), findsOneWidget);
      });

      testWidgets('Inconsistent: three hand-styled buttons that differ', (
        tester,
      ) async {
        await open(tester, title);
        final save = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'Save').first,
        );
        expect(save.style?.backgroundColor?.resolve({}), Colors.orange);
        expect(save.style?.foregroundColor?.resolve({}), Colors.white);
        expect(find.widgetWithText(TextButton, 'SUBMIT'), findsOneWidget);
        final cont = tester.widget<OutlinedButton>(
          find.widgetWithText(OutlinedButton, 'Continue'),
        );
        expect(cont.style?.shape?.resolve({}), isA<StadiumBorder>());
        expect(cont.style?.minimumSize?.resolve({}), const Size(240, 56));
      });

      testWidgets('Consistent: three AppButtons with one shared style', (
        tester,
      ) async {
        await open(tester, title);
        await scrollToButton(tester, find.text('Consistent'));
        await scrollToButton(
          tester,
          find.widgetWithText(AppButton, 'Continue'),
        );
        expect(appButtons, findsNWidgets(3));
        expect(tester.widgetList<AppButton>(appButtons).map((b) => b.label), [
          'Save',
          'Submit',
          'Continue',
        ]);
        final sizes = <Size>[];
        for (final element in appButtons.evaluate()) {
          final button = tester.widget<ElevatedButton>(
            find.descendant(
              of: find.byWidget(element.widget),
              matching: find.byType(ElevatedButton),
            ),
          );
          expect(button.style?.minimumSize?.resolve({}), const Size(160, 48));
          final shape = button.style?.shape?.resolve({});
          expect(shape, isA<RoundedRectangleBorder>());
          expect(
            (shape! as RoundedRectangleBorder).borderRadius,
            BorderRadius.circular(8),
          );
          sizes.add(tester.getSize(find.byWidget(element.widget)));
        }
        // All three share the height and at least the shared minimum width.
        expect(sizes.map((s) => s.height).toSet(), {48});
        expect(sizes.every((s) => s.width >= 160), isTrue);
      });

      testWidgets('every button counts a press', (tester) async {
        await open(tester, title);
        final buttons = [
          find.widgetWithText(ElevatedButton, 'Save').first,
          find.widgetWithText(TextButton, 'SUBMIT'),
          find.widgetWithText(OutlinedButton, 'Continue'),
          find.widgetWithText(AppButton, 'Save'),
          find.widgetWithText(AppButton, 'Submit'),
          find.widgetWithText(AppButton, 'Continue'),
        ];
        for (var i = 0; i < buttons.length; i++) {
          await scrollToButton(tester, buttons[i]);
          await tester.tap(buttons[i]);
          await tester.pump();
          await scrollToButton(tester, find.text('Presses: ${i + 1}'));
          expect(find.text('Presses: ${i + 1}'), findsOneWidget);
        }
      });

      testWidgets('info opens the notes; back returns to the list', (
        tester,
      ) async {
        await open(tester, title);
        await tester.tap(find.byTooltip('Lesson notes'));
        await tester.pumpAndSettle();
        expect(find.text('Lesson 31: $title'), findsOneWidget);
        Navigator.of(tester.element(find.byType(BottomSheet))).pop();
        await tester.pumpAndSettle();

        await tester.pageBack();
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Flutter Lessons'), findsOneWidget);

        await tester.tap(find.widgetWithText(ListTile, title));
        await tester.pumpAndSettle();
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Flutter Lessons'), findsOneWidget);
      });
    });

    group('32 ThemeData', () {
      const title = 'ThemeData as the source of truth';
      final switchTile = find.widgetWithText(SwitchListTile, 'Dark mode');

      ThemeData themeAt(WidgetTester tester, Finder finder) =>
          Theme.of(tester.element(finder));

      testWidgets('is listed on the home screen', (tester) async {
        await tester.pumpWidget(const FlutterLessonsApp());
        await scrollTo(tester, find.text(title));
        expect(find.text(title), findsOneWidget);
        expect(find.text('Oct 21, 2026'), findsOneWidget);
      });

      testWidgets("opens on ThemeData with the snippet's AppBar", (
        tester,
      ) async {
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
          findsOneWidget,
        );
        // The snippet's own MaterialApp is nested inside the app's.
        expect(find.byType(MaterialApp), findsNWidgets(2));
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

      testWidgets('the back arrow returns to the lesson list', (tester) async {
        await open(tester, title);
        // Also after toggling dark mode: the arrow pops the outer route.
        await tester.tap(switchTile);
        await tester.pumpAndSettle();
        await tester.tap(
          find.descendant(
            of: find.byType(AppBar),
            matching: find.byType(BackButton),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Flutter Lessons'), findsOneWidget);
        expect(find.widgetWithText(ListTile, title), findsOneWidget);
        expect(find.byType(MaterialApp), findsOneWidget);
        // The app's own theme is untouched by the lesson's switch.
        expect(
          themeAt(tester, find.text('Flutter Lessons')).brightness,
          Brightness.light,
        );
      });

      testWidgets('system back returns to the lesson list', (tester) async {
        await open(tester, title);
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Flutter Lessons'), findsOneWidget);
        expect(find.byType(MaterialApp), findsOneWidget);
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

        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Flutter Lessons'), findsOneWidget);
      });
    });
  });
}
