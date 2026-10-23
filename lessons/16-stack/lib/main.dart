import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 16,
  title: 'Stack and Positioned',
  notesAsset: '16-stack.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: StackLesson());

void main() => runApp(lessonApp);

/// Lesson 16: A blue box with a red 'NEW' badge that hangs over its corner.
class StackLesson extends StatelessWidget {
  const StackLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stack'),
        actions: const [LessonInfoButton(lessonId: 16)],
      ),
      body: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(width: 200, height: 200, color: Colors.blue),
            Positioned(
              top: -12,
              right: -12,
              child: Container(
                padding: const EdgeInsets.all(6),
                color: Colors.red,
                child: const Text('NEW', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
