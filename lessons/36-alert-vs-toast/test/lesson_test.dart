import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_36_alert_vs_toast/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'Feedback';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 36);
    expect(lesson.notesAsset, '36-alert-vs-toast.md');
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

  group('36 Alert for errors, Toast for success', () {
    const errorText = 'Could not save. Check your connection.';
    final errorButton = find.widgetWithText(FilledButton, 'Simulate error');
    final successButton = find.widgetWithText(FilledButton, 'Simulate success');

    testWidgets('starts with two buttons and no feedback', (tester) async {
      await open(tester);
      expect(errorButton, findsOneWidget);
      expect(successButton, findsOneWidget);
      expect(find.byType(AppAlert), findsNothing);
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('an error shows a banner at the top of the body', (
      tester,
    ) async {
      await open(tester);
      await tester.tap(errorButton);
      await tester.pumpAndSettle();
      final alert = find.byType(AppAlert);
      expect(alert, findsOneWidget);
      expect(
        find.descendant(of: alert, matching: find.text(errorText)),
        findsOneWidget,
      );
      expect(
        find.descendant(of: alert, matching: find.byIcon(Icons.error_outline)),
        findsOneWidget,
      );
      expect(
        find.descendant(of: alert, matching: find.byTooltip('Dismiss')),
        findsOneWidget,
      );
      // The banner sits above the buttons, and the error is not a SnackBar.
      expect(
        tester.getBottomLeft(alert).dy,
        lessThan(tester.getTopLeft(errorButton).dy),
      );
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('the banner uses the error colors', (tester) async {
      await open(tester);
      await tester.tap(errorButton);
      await tester.pumpAndSettle();
      final colors = Theme.of(tester.element(find.byType(AppAlert)))
          .colorScheme;
      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(AppAlert),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, colors.errorContainer);
      expect((decoration.border! as Border).top.color, colors.error);
      final icon = tester.widget<Icon>(find.byIcon(Icons.error_outline));
      expect(icon.color, colors.error);
      final text = tester.widget<Text>(find.text(errorText));
      expect(text.style!.color, colors.onErrorContainer);
    });

    testWidgets('the banner stays until the close icon is tapped', (
      tester,
    ) async {
      await open(tester);
      await tester.tap(errorButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 30));
      await tester.pumpAndSettle();
      expect(find.text(errorText), findsOneWidget);
      // Tapping the error button again keeps a single banner.
      await tester.tap(errorButton);
      await tester.pumpAndSettle();
      expect(find.byType(AppAlert), findsOneWidget);
      await tester.tap(find.byTooltip('Dismiss'));
      await tester.pumpAndSettle();
      expect(find.byType(AppAlert), findsNothing);
      expect(find.text(errorText), findsNothing);
    });

    testWidgets('a success shows a short green SnackBar', (tester) async {
      await open(tester);
      await tester.tap(successButton);
      await tester.pump();
      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect((snackBar.content as Text).data, 'Saved!');
      expect(snackBar.backgroundColor, Colors.green);
      expect(snackBar.duration, const Duration(seconds: 2));
      expect(snackBar.action, isNull);
      await tester.pumpAndSettle();
      expect(find.text('Saved!'), findsOneWidget);
      expect(find.byType(AppAlert), findsNothing);
    });

    testWidgets('the SnackBar goes away on its own', (tester) async {
      await open(tester);
      await tester.tap(successButton);
      await tester.pumpAndSettle();
      expect(find.text('Saved!'), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      expect(find.text('Saved!'), findsNothing);
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('repeated successes replace the SnackBar', (tester) async {
      await open(tester);
      await tester.tap(successButton);
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(successButton);
      await tester.pumpAndSettle();
      expect(find.text('Saved!'), findsOneWidget);
      // Nothing queued behind it: once it times out, no second toast follows.
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('a success leaves the banner and buttons usable', (
      tester,
    ) async {
      await open(tester);
      await tester.tap(errorButton);
      await tester.pumpAndSettle();
      await tester.tap(successButton);
      await tester.pumpAndSettle();
      expect(find.text('Saved!'), findsOneWidget);
      expect(find.text(errorText), findsOneWidget);
      // The toast does not block the page: the close icon still works
      // while it is showing.
      await tester.tap(find.byTooltip('Dismiss'));
      await tester.pumpAndSettle();
      expect(find.byType(AppAlert), findsNothing);
      expect(find.text('Saved!'), findsOneWidget);
      await tester.tap(errorButton);
      await tester.pumpAndSettle();
      expect(find.byType(AppAlert), findsOneWidget);
    });
  });
}
