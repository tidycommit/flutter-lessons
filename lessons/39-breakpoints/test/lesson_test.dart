import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_39_breakpoints/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'Breakpoints';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 39);
    expect(lesson.notesAsset, '39-breakpoints.md');
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

  group('39 Layout breakpoints', () {
    test('breakpointFor switches at 600 and 1024', () {
      expect(breakpointFor(320), AppBreakpoint.compact);
      expect(breakpointFor(599), AppBreakpoint.compact);
      expect(breakpointFor(599.9), AppBreakpoint.compact);
      expect(breakpointFor(600), AppBreakpoint.medium);
      expect(breakpointFor(1023), AppBreakpoint.medium);
      expect(breakpointFor(1023.9), AppBreakpoint.medium);
      expect(breakpointFor(1024), AppBreakpoint.expanded);
      expect(breakpointFor(1400), AppBreakpoint.expanded);
    });

    Finder inLayout(Finder matching) =>
        find.descendant(of: find.byType(ResponsiveLayout), matching: matching);

    /// The SizedBox that gives the Nav panel its fixed size.
    SizedBox navBox(WidgetTester tester) => tester.widget<SizedBox>(
      find
          .ancestor(of: find.text('Nav'), matching: find.byType(SizedBox))
          .first,
    );

    double sliderValue(WidgetTester tester) =>
        tester.widget<Slider>(find.byType(Slider)).value;

    testWidgets('starts at 800 px (medium): a Row with a 160 nav', (
      tester,
    ) async {
      await open(tester);
      expect(find.text('Fake width: 800 px (medium)'), findsOneWidget);
      final slider = tester.widget<Slider>(find.byType(Slider));
      expect([slider.min, slider.max, slider.value], [320, 1400, 800]);
      expect(inLayout(find.byType(Row)), findsOneWidget);
      expect(inLayout(find.byType(Column)), findsNothing);
      expect(navBox(tester).width, 160);
      expect(find.text('Content'), findsOneWidget);
      // The pretend screen is fakeWidth x 500, scaled by a FittedBox.
      final screen = tester.widget<SizedBox>(
        find
            .ancestor(
              of: find.byType(ResponsiveLayout),
              matching: find.byType(SizedBox),
            )
            .first,
      );
      expect([screen.width, screen.height], [800, 500]);
      expect(
        find.ancestor(
          of: find.byType(ResponsiveLayout),
          matching: find.byType(FittedBox),
        ),
        findsOneWidget,
      );
    });

    testWidgets('sliding to compact stacks the panels in a Column', (
      tester,
    ) async {
      await open(tester);
      await tester.drag(find.byType(Slider), const Offset(-1000, 0));
      await tester.pumpAndSettle();
      expect(sliderValue(tester), 320);
      expect(find.text('Fake width: 320 px (compact)'), findsOneWidget);
      expect(inLayout(find.byType(Column)), findsOneWidget);
      expect(inLayout(find.byType(Row)), findsNothing);
      expect(navBox(tester).height, 120);
      // Nav is on top, Content underneath.
      expect(
        tester.getCenter(find.text('Nav')).dy,
        lessThan(tester.getCenter(find.text('Content')).dy),
      );
    });

    testWidgets('sliding to expanded shows a Row with a 240 nav', (
      tester,
    ) async {
      await open(tester);
      await tester.drag(find.byType(Slider), const Offset(1000, 0));
      await tester.pumpAndSettle();
      expect(sliderValue(tester), 1400);
      expect(find.text('Fake width: 1400 px (expanded)'), findsOneWidget);
      expect(inLayout(find.byType(Row)), findsOneWidget);
      expect(inLayout(find.byType(Column)), findsNothing);
      expect(navBox(tester).width, 240);
      // Nav on the left, Content on the right.
      expect(
        tester.getCenter(find.text('Nav')).dx,
        lessThan(tester.getCenter(find.text('Content')).dx),
      );
    });

    testWidgets('ResponsiveLayout follows its parent width, not the screen', (
      tester,
    ) async {
      Future<void> pumpAt(double width) => tester.pumpWidget(
        MaterialApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: width,
              height: 400,
              child: const ResponsiveLayout(),
            ),
          ),
        ),
      );
      await pumpAt(500);
      expect(inLayout(find.byType(Column)), findsOneWidget);
      await pumpAt(700);
      expect(inLayout(find.byType(Row)), findsOneWidget);
      expect(navBox(tester).width, 160);
    });

    testWidgets('the info button still opens the notes after sliding', (
      tester,
    ) async {
      await open(tester);
      await tester.drag(find.byType(Slider), const Offset(-1000, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Lesson notes'));
      await tester.pumpAndSettle();
      expect(find.text(lesson.heading), findsOneWidget);
    });
  });
}
