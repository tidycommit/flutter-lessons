import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_30_popscope/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'PopScope Tip';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 30);
    expect(lesson.notesAsset, '30-popscope.md');
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
      expect(appBarBackArrow, findsNothing);
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
  });
}
