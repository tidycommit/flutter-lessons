import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 12,
  title: 'TextField and InputDecoration',
  notesAsset: '12-text-field.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: TextFieldLesson());

void main() => runApp(lessonApp);

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
