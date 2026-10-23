import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 1,
  title: 'Hello app',
  notesAsset: '01-hello-app.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: HelloAppLesson());

void main() => runApp(lessonApp);

/// Lesson 01: The smallest useful screen: an AppBar and some centered text.
class HelloAppLesson extends StatelessWidget {
  const HelloAppLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello'),
        actions: const [LessonInfoButton(lessonId: 1)],
      ),
      body: const Center(
        child: Text('Hello, world!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
