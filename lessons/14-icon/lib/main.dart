import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(id: 14, title: 'Icon', notesAsset: '14-icon.md');

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: IconLesson());

void main() => runApp(lessonApp);

/// Lesson 14: A large red heart icon.
class IconLesson extends StatelessWidget {
  const IconLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Icons'),
        actions: const [LessonInfoButton(lessonId: 14)],
      ),
      body: const Center(
        child: Icon(Icons.favorite, size: 64, color: Colors.red),
      ),
    );
  }
}
