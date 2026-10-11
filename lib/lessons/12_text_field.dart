import 'package:flutter/material.dart';

import '../widgets/lesson_info_button.dart';

/// Lesson 12: A TextField with a label and an outline border.
class TextFieldLesson extends StatelessWidget {
  const TextFieldLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TextField'),
        actions: const [LessonInfoButton(lessonId: 12)],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Your name',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
    );
  }
}
