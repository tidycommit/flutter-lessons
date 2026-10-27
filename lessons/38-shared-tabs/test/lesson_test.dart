import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_38_shared_tabs/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'AppTabs';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 38);
    expect(lesson.notesAsset, '38-shared-tabs.md');
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

  group('38 Shared tabs pattern', () {
    const labels = ['Overview', 'Details', 'Settings'];

    Finder tab(String label) =>
        find.descendant(of: find.byType(TabBar), matching: find.text(label));

    int selectedIndex(WidgetTester tester) =>
        DefaultTabController.of(tester.element(find.byType(TabBar))).index;

    void expectContent(String label) {
      for (final other in labels) {
        expect(
          find.text('$other content'),
          other == label ? findsOneWidget : findsNothing,
        );
      }
    }

    testWidgets('one AppTabs shows the three tabs in order', (tester) async {
      await open(tester);
      expect(find.byType(AppTabs), findsOneWidget);
      final appTabs = tester.widget<AppTabs>(find.byType(AppTabs));
      expect(appTabs.labels, labels);
      expect(appTabs.children, hasLength(3));
      final tabs = tester.widgetList<Tab>(find.byType(Tab));
      expect([for (final t in tabs) t.text], labels);
      // The TabBar sits right under the AppBar, above the pages.
      expect(
        tester.getTopLeft(find.byType(TabBar)).dy,
        tester.getBottomLeft(find.byType(AppBar)).dy,
      );
      expect(
        find.ancestor(
          of: find.byType(TabBarView),
          matching: find.byType(AppTabs),
        ),
        findsOneWidget,
      );
      expect(
        DefaultTabController.of(tester.element(tab('Overview'))).length,
        3,
      );
    });

    testWidgets('Overview is selected and its content shows at start', (
      tester,
    ) async {
      await open(tester);
      expect(selectedIndex(tester), 0);
      expectContent('Overview');
      final text = tester.widget<Text>(find.text('Overview content'));
      final theme = Theme.of(tester.element(find.text('Overview content')));
      expect(text.style, theme.textTheme.headlineSmall);
      // The content is centered in the page area.
      expect(
        tester.getCenter(find.text('Overview content')).dx,
        tester.getCenter(find.byType(TabBarView)).dx,
      );
      expect(
        tester.getCenter(find.text('Overview content')).dy,
        moreOrLessEquals(tester.getCenter(find.byType(TabBarView)).dy),
      );
    });

    testWidgets('tapping Details, then Settings, switches the content', (
      tester,
    ) async {
      await open(tester);
      await tester.tap(tab('Details'));
      await tester.pumpAndSettle();
      expect(selectedIndex(tester), 1);
      expectContent('Details');
      await tester.tap(tab('Settings'));
      await tester.pumpAndSettle();
      expect(selectedIndex(tester), 2);
      expectContent('Settings');
      await tester.tap(tab('Overview'));
      await tester.pumpAndSettle();
      expect(selectedIndex(tester), 0);
      expectContent('Overview');
    });

    testWidgets('swiping the page moves between tabs', (tester) async {
      await open(tester);
      await tester.fling(find.byType(TabBarView), const Offset(-400, 0), 1000);
      await tester.pumpAndSettle();
      expect(selectedIndex(tester), 1);
      expectContent('Details');
      await tester.fling(find.byType(TabBarView), const Offset(400, 0), 1000);
      await tester.pumpAndSettle();
      expect(selectedIndex(tester), 0);
      expectContent('Overview');
    });

    testWidgets('the info button still opens the notes from another tab', (
      tester,
    ) async {
      await open(tester);
      await tester.tap(tab('Settings'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Lesson notes'));
      await tester.pumpAndSettle();
      expect(find.text(lesson.heading), findsOneWidget);
    });

    test('the assert fires when labels and children differ', () {
      expect(
        () => AppTabs(labels: const ['A', 'B'], children: const [Text('a')]),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            'Each tab label needs exactly one page.',
          ),
        ),
      );
      expect(
        () => AppTabs(labels: const ['A'], children: const []),
        throwsAssertionError,
      );
    });

    testWidgets('AppTabs works for any matching pair of lists', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTabs(
              labels: const ['One', 'Two'],
              children: const [Text('first'), Text('second')],
            ),
          ),
        ),
      );
      expect(find.byType(Tab), findsNWidgets(2));
      expect(find.text('first'), findsOneWidget);
      await tester.tap(find.text('Two'));
      await tester.pumpAndSettle();
      expect(find.text('second'), findsOneWidget);
      expect(find.text('first'), findsNothing);
    });
  });
}
