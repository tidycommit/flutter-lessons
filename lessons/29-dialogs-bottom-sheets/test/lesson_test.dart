import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_29_dialogs_bottom_sheets/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'Popups Tip';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 29);
    expect(lesson.notesAsset, '29-dialogs-bottom-sheets.md');
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
      expect(appBarBackArrow, findsNothing);
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.byTooltip('Lesson notes'),
        ),
        findsOneWidget,
      );
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
        await tester.tap(find.descendant(of: sheet, matching: find.text(app)));
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
  });
}
