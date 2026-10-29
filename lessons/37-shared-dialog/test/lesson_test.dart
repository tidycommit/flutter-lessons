import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_37_shared_dialog/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'AppDialog';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 37);
    expect(lesson.notesAsset, '37-shared-dialog.md');
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

  group('37 Shared confirm dialog', () {
    const message = "This removes it from the list. You can't undo this.";
    final deleteItem = find.widgetWithText(OutlinedButton, 'Delete item');
    final cancel = find.widgetWithText(TextButton, 'Cancel');
    final confirm = find.widgetWithText(FilledButton, 'Delete');

    Future<void> openDialog(WidgetTester tester) async {
      await tester.tap(deleteItem);
      await tester.pumpAndSettle();
    }

    void expectItems(List<String> items) {
      expect(find.byType(ListTile), findsNWidgets(items.length));
      for (final item in items) {
        expect(find.widgetWithText(ListTile, item), findsOneWidget);
      }
    }

    testWidgets('starts with three items and a red Delete item button', (
      tester,
    ) async {
      await open(tester);
      expectItems(['Item 1', 'Item 2', 'Item 3']);
      expect(find.byIcon(Icons.check), findsNWidgets(3));
      expect(find.byType(AlertDialog), findsNothing);
      final button = tester.widget<ButtonStyleButton>(deleteItem);
      final colors = Theme.of(tester.element(deleteItem)).colorScheme;
      expect(button.style!.foregroundColor!.resolve({}), colors.error);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('Delete item opens the shared dialog for the last item', (
      tester,
    ) async {
      await open(tester);
      await openDialog(tester);
      final dialog = find.byType(AlertDialog);
      expect(dialog, findsOneWidget);
      expect(
        find.descendant(of: dialog, matching: find.text('Delete Item 3?')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: dialog, matching: find.text(message)),
        findsOneWidget,
      );
      expect(cancel, findsOneWidget);
      expect(confirm, findsOneWidget);
      // Cancel comes first, then the destructive action.
      expect(
        tester.getCenter(cancel).dx,
        lessThan(tester.getCenter(confirm).dx),
      );
      // The dialog is a route on top of the page.
      expect(ModalRoute.of(tester.element(dialog))!.isCurrent, isTrue);
      expect(
        ModalRoute.of(tester.element(find.text('Item 1')))!.isCurrent,
        isFalse,
      );
    });

    testWidgets('the Delete button uses the error colors', (tester) async {
      await open(tester);
      await openDialog(tester);
      final colors = Theme.of(tester.element(confirm)).colorScheme;
      final style = tester.widget<FilledButton>(confirm).style!;
      expect(style.backgroundColor!.resolve({}), colors.error);
      expect(style.foregroundColor!.resolve({}), colors.onError);
    });

    testWidgets('Cancel closes the dialog and keeps the list', (tester) async {
      await open(tester);
      await openDialog(tester);
      await tester.tap(cancel);
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expectItems(['Item 1', 'Item 2', 'Item 3']);
    });

    testWidgets('tapping outside counts as cancel', (tester) async {
      await open(tester);
      await openDialog(tester);
      await tester.tapAt(const Offset(10, 590));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expectItems(['Item 1', 'Item 2', 'Item 3']);
    });

    testWidgets('Delete removes the last item, and the next asks again', (
      tester,
    ) async {
      await open(tester);
      await openDialog(tester);
      await tester.tap(confirm);
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expectItems(['Item 1', 'Item 2']);
      await openDialog(tester);
      expect(find.text('Delete Item 2?'), findsOneWidget);
    });

    testWidgets('deleting every item replaces the button with a message', (
      tester,
    ) async {
      await open(tester);
      for (final item in ['Item 3', 'Item 2', 'Item 1']) {
        await openDialog(tester);
        expect(find.text('Delete $item?'), findsOneWidget);
        await tester.tap(confirm);
        await tester.pumpAndSettle();
      }
      expect(find.byType(ListTile), findsNothing);
      expect(find.text('All items deleted.'), findsOneWidget);
      expect(deleteItem, findsNothing);
    });

    testWidgets('the helper returns true, false, or false for null', (
      tester,
    ) async {
      final results = <bool>[];
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () async => results.add(
                await showAppConfirmDialog(
                  context,
                  title: 'Remove?',
                  message: 'Sure?',
                  confirmLabel: 'Remove',
                ),
              ),
              child: const Text('Ask'),
            ),
          ),
        ),
      );
      Future<void> ask() async {
        await tester.tap(find.text('Ask'));
        await tester.pumpAndSettle();
        expect(find.text('Remove?'), findsOneWidget);
      }

      await ask();
      // A custom confirm label replaces "Delete".
      expect(find.widgetWithText(FilledButton, 'Remove'), findsOneWidget);
      expect(find.text('Delete'), findsNothing);
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();
      await ask();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      await ask();
      // System back pops the route with no value.
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Remove?'), findsNothing);
      expect(results, [true, false, false]);
    });
  });
}
