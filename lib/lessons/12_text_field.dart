import 'package:flutter/material.dart';

/// Lesson 12: A TextField with a label and outline border that greets the user.
class TextFieldLesson extends StatefulWidget {
  const TextFieldLesson({super.key});

  @override
  State<TextFieldLesson> createState() => _TextFieldLessonState();
}

class _TextFieldLessonState extends State<TextFieldLesson> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = _controller.text.trim();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Your name',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Text(name.isEmpty ? 'Type your name above.' : 'Hello, $name!'),
        ],
      ),
    );
  }
}
