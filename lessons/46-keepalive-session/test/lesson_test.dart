import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_46_keepalive_session/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'Session';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 46);
    expect(lesson.notesAsset, '46-keepalive-session.md');
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

  group('46 keepAlive shared state', () {
    testWidgets('a ProviderScope sits above the lesson screen', (tester) async {
      await open(tester);
      expect(
        find.ancestor(
          of: find.byType(Lesson46KeepAliveSession),
          matching: find.byType(ProviderScope),
        ),
        findsOneWidget,
      );
    });

    testWidgets('keepAlive remembers Ada after leaving Profile', (
      tester,
    ) async {
      await open(tester);
      expect(find.text('Signed out'), findsNWidgets(2));
      expect(find.text('Session (keepAlive)'), findsOneWidget);
      expect(find.text('Temp session (auto-dispose)'), findsOneWidget);

      await tester.tap(find.text('Log in'));
      await tester.pump();
      expect(find.text('Ada'), findsNWidgets(2));

      await tester.tap(find.text('Other'));
      await tester.pumpAndSettle();
      expect(
        find.text('Nothing here watches the session.\nNow go back to Profile.'),
        findsOneWidget,
      );

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      expect(find.text('Ada'), findsOneWidget);
      expect(find.text('Signed out'), findsOneWidget);

      await tester.tap(find.text('Log out'));
      await tester.pump();
      expect(find.text('Ada'), findsNothing);
      expect(find.text('Signed out'), findsNWidgets(2));
    });

    test('keepAlive survives losing its listener', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final sub = container.listen(sessionProvider, (_, _) {});
      container.read(sessionProvider.notifier).login('Ada');
      sub.close();
      // Disposal is scheduled, not immediate. keepAlive must outlast it.
      await Future<void>.delayed(Duration.zero);
      expect(container.read(sessionProvider), 'Ada');

      final tempSub = container.listen(tempSessionProvider, (_, _) {});
      container.read(tempSessionProvider.notifier).login('Ada');
      tempSub.close();
      await Future<void>.delayed(Duration.zero);
      expect(container.read(tempSessionProvider), isNull);
    });
  });
}
