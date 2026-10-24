# Lesson 35: Shared TextField and input masks

**Date:** Oct 24, 2026

This is lesson 5 of the design-system series: shared text fields and input masks.

Yesterday every screen got one shared button. Today forms get the same treatment: one `AppTextField` wrapper owns the label, the error text, the border and the spacing, so every form in the app looks and behaves alike. Pages just pass in a controller, a label and, when needed, an error message.

Masks like `###-###-####` belong in a `TextInputFormatter`, not in the page. A formatter sees every edit before it lands, so it can strip non-digits, cap the length at 10, and put dashes after the 3rd and 6th digit. The controller holds what is displayed (with dashes); when you save, you usually strip it back to digits.

## Key points

- Wrap `TextField` (or `TextFormField`) once; pages pass `controller`, `label` and `errorText`.
- Put masks in a `TextInputFormatter`. For simple cases, the built-in `FilteringTextInputFormatter.digitsOnly` and `LengthLimitingTextInputFormatter` already exist; a custom formatter handles groups and dashes.
- Keep mask logic out of the page widget, so every screen formats input the same way.
- The controller stores the displayed text; clean it (digits only) before saving.

No new packages today (no `flutter pub add` needed): `TextInputFormatter` comes from `package:flutter/services.dart`.

## Code

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MaterialApp(home: TextFieldMaskDemo()));

/// Mask logic lives here, not in the page: digits only, max 10, dashes at 3 and 6.
class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final capped = digits.length > 10 ? digits.substring(0, 10) : digits;
    final buffer = StringBuffer();
    for (var i = 0; i < capped.length; i++) {
      if (i == 3 || i == 6) buffer.write('-');
      buffer.write(capped[i]);
    }
    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

/// The one text field every form uses.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.errorText,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String? errorText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

class TextFieldMaskDemo extends StatefulWidget {
  const TextFieldMaskDemo({super.key});

  @override
  State<TextFieldMaskDemo> createState() => _TextFieldMaskDemoState();
}

class _TextFieldMaskDemoState extends State<TextFieldMaskDemo> {
  final _name = TextEditingController();
  final _phone = TextEditingController();

  String get _phoneDigits => _phone.text.replaceAll('-', '');

  String? get _phoneError {
    final count = _phoneDigits.length;
    return (count == 0 || count == 10) ? null : 'Enter all 10 digits';
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppTextField')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppTextField(controller: _name, label: 'Name'),
          AppTextField(
            controller: _phone,
            label: 'Phone',
            errorText: _phoneError,
            keyboardType: TextInputType.phone,
            inputFormatters: [PhoneNumberFormatter()],
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Text('Controller text: ${_phone.text}'),
          const SizedBox(height: 8),
          Text('Digits only: $_phoneDigits'),
        ],
      ),
    );
  }
}
```

## On screen

The AppBar reads "AppTextField". Below it are two outlined fields built from the same wrapper: "Name" (plain text) and "Phone". As you type digits into Phone, dashes appear on their own, so typing 5551234 shows "555-123-4"; letters are ignored and input stops at 10 digits ("555-123-4567"). While the number is partly typed, the Phone field turns red with "Enter all 10 digits" under it, and the error disappears once all 10 digits are in (or the field is empty). Under the fields, "Controller text: 555-123-4" shows exactly what the controller stores, and "Digits only: 5551234" shows the cleaned value you'd actually save.

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `Lesson35TextFieldMasks`.
- `TextFieldMaskDemo` is renamed `Lesson35TextFieldMasks`. `AppTextField` and `PhoneNumberFormatter` keep their names, because they are the idea being taught.
- The AppBar keeps `title: const Text('AppTextField')` with default styling, and gets `actions: const [LessonInfoButton(lessonId: 35)]`, the button that opens these notes.
- `dart format` puts the `formatEditUpdate` parameters on separate lines and a doc comment is added to the page; the code is otherwise unchanged.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 35,
  title: 'Shared TextField and input masks',
  notesAsset: '35-text-field-masks.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: Lesson35TextFieldMasks());

void main() => runApp(lessonApp);

/// Mask logic lives here, not in the page: digits only, max 10, dashes at 3 and 6.
class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final capped = digits.length > 10 ? digits.substring(0, 10) : digits;
    final buffer = StringBuffer();
    for (var i = 0; i < capped.length; i++) {
      if (i == 3 || i == 6) buffer.write('-');
      buffer.write(capped[i]);
    }
    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

/// The one text field every form uses.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.errorText,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String? errorText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

/// Lesson 35: Shared TextField and input masks.
///
/// The snippet's own Scaffold is the app's home screen, exactly as written.
class Lesson35TextFieldMasks extends StatefulWidget {
  const Lesson35TextFieldMasks({super.key});

  @override
  State<Lesson35TextFieldMasks> createState() => _Lesson35TextFieldMasksState();
}

class _Lesson35TextFieldMasksState extends State<Lesson35TextFieldMasks> {
  final _name = TextEditingController();
  final _phone = TextEditingController();

  String get _phoneDigits => _phone.text.replaceAll('-', '');

  String? get _phoneError {
    final count = _phoneDigits.length;
    return (count == 0 || count == 10) ? null : 'Enter all 10 digits';
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppTextField'),
        actions: const [LessonInfoButton(lessonId: 35)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppTextField(controller: _name, label: 'Name'),
          AppTextField(
            controller: _phone,
            label: 'Phone',
            errorText: _phoneError,
            keyboardType: TextInputType.phone,
            inputFormatters: [PhoneNumberFormatter()],
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Text('Controller text: ${_phone.text}'),
          const SizedBox(height: 8),
          Text('Digits only: $_phoneDigits'),
        ],
      ),
    );
  }
}
```
