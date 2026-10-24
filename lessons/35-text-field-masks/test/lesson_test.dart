import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_35_text_field_masks/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'AppTextField';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 35);
    expect(lesson.notesAsset, '35-text-field-masks.md');
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

  group('35 Shared TextField and input masks', () {
    TextEditingValue format(String typed) =>
        PhoneNumberFormatter().formatEditUpdate(
          TextEditingValue.empty,
          TextEditingValue(text: typed),
        );

    test('the formatter keeps digits, caps at 10 and adds dashes', () {
      expect(format('').text, '');
      expect(format('555').text, '555');
      expect(format('5551').text, '555-1');
      expect(format('5551234').text, '555-123-4');
      expect(format('5551234567').text, '555-123-4567');
      expect(format('555123456789').text, '555-123-4567');
      expect(format('(555) 123-45ab67').text, '555-123-4567');
      expect(format('abc').text, '');
    });

    test('the formatter puts the cursor at the end', () {
      final value = format('5551234');
      expect(value.selection, const TextSelection.collapsed(offset: 9));
    });

    final nameField = find.widgetWithText(TextField, 'Name');
    final phoneField = find.widgetWithText(TextField, 'Phone');

    InputDecoration phoneDecoration(WidgetTester tester) =>
        tester.widget<TextField>(phoneField).decoration!;

    testWidgets('both fields come from the one AppTextField wrapper', (
      tester,
    ) async {
      await open(tester);
      expect(find.byType(AppTextField), findsNWidgets(2));
      expect(find.byType(TextField), findsNWidgets(2));
      for (final field in [nameField, phoneField]) {
        expect(
          find.ancestor(of: field, matching: find.byType(AppTextField)),
          findsOneWidget,
        );
        final decoration = tester.widget<TextField>(field).decoration!;
        expect(decoration.border, isA<OutlineInputBorder>());
      }
      final phone = tester.widget<TextField>(phoneField);
      expect(phone.keyboardType, TextInputType.phone);
      expect(phone.inputFormatters!.single, isA<PhoneNumberFormatter>());
      final name = tester.widget<TextField>(nameField);
      expect(name.inputFormatters, isNull);
      expect(phoneDecoration(tester).errorText, isNull);
      expect(find.text('Controller text: '), findsOneWidget);
      expect(find.text('Digits only: '), findsOneWidget);
    });

    testWidgets('typing a partial number shows dashes and the error', (
      tester,
    ) async {
      await open(tester);
      await tester.enterText(nameField, 'Alex');
      await tester.enterText(phoneField, '5551234');
      await tester.pump();
      expect(find.text('Alex'), findsOneWidget);
      expect(find.text('555-123-4'), findsOneWidget);
      expect(find.text('Enter all 10 digits'), findsOneWidget);
      expect(phoneDecoration(tester).errorText, 'Enter all 10 digits');
      expect(find.text('Controller text: 555-123-4'), findsOneWidget);
      expect(find.text('Digits only: 5551234'), findsOneWidget);
    });

    testWidgets('letters are ignored, input stops at 10 digits', (
      tester,
    ) async {
      await open(tester);
      await tester.enterText(phoneField, '555abc1234567999');
      await tester.pump();
      expect(find.text('555-123-4567'), findsOneWidget);
      expect(find.text('Enter all 10 digits'), findsNothing);
      expect(phoneDecoration(tester).errorText, isNull);
      expect(find.text('Controller text: 555-123-4567'), findsOneWidget);
      expect(find.text('Digits only: 5551234567'), findsOneWidget);
    });

    testWidgets('clearing the phone field clears the error', (tester) async {
      await open(tester);
      await tester.enterText(phoneField, '555');
      await tester.pump();
      expect(find.text('Enter all 10 digits'), findsOneWidget);
      await tester.enterText(phoneField, '');
      await tester.pump();
      expect(find.text('Enter all 10 digits'), findsNothing);
      expect(find.text('Controller text: '), findsOneWidget);
    });

    testWidgets('the name field is plain text', (tester) async {
      await open(tester);
      await tester.enterText(nameField, 'Alex 555-12');
      await tester.pump();
      expect(find.text('Alex 555-12'), findsOneWidget);
      expect(find.text('Enter all 10 digits'), findsNothing);
    });
  });
}
