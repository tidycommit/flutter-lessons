import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 11,
  title: 'FloatingActionButton',
  notesAsset: '11-floating-action-button.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: FloatingActionButtonLesson());

void main() => runApp(lessonApp);

/// Lesson 11: A Scaffold with a FloatingActionButton.
class FloatingActionButtonLesson extends StatelessWidget {
  const FloatingActionButtonLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAB Tip'),
        actions: const [LessonInfoButton(lessonId: 11)],
      ),
      body: const Center(child: Text('Tap the + button')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
