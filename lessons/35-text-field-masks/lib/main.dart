import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:lesson_kit/lesson_kit.dart';

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
