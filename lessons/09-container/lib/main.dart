import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 9,
  title: 'Container',
  notesAsset: '09-container.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: ContainerLesson());

void main() => runApp(lessonApp);

/// Lesson 09: A decorated Container with size, padding, rounded corners and a shadow.
class ContainerLesson extends StatelessWidget {
  const ContainerLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Container'),
        actions: const [LessonInfoButton(lessonId: 9)],
      ),
      body: Center(
        child: Container(
          width: 240,
          height: 140,
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.lightBlue.shade100,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.lightBlue, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Text('Hello!'),
        ),
      ),
    );
  }
}
