import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 10,
  title: 'ElevatedButton',
  notesAsset: '10-elevated-button.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: ElevatedButtonLesson());

void main() => runApp(lessonApp);

/// Lesson 10: An enabled ElevatedButton that counts presses and a disabled one.
class ElevatedButtonLesson extends StatefulWidget {
  const ElevatedButtonLesson({super.key});

  @override
  State<ElevatedButtonLesson> createState() => _ElevatedButtonLessonState();
}

class _ElevatedButtonLessonState extends State<ElevatedButtonLesson> {
  int _presses = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ElevatedButton'),
        actions: const [LessonInfoButton(lessonId: 10)],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => setState(() => _presses++),
              child: const Text('Tap me'),
            ),
            const SizedBox(height: 12),
            Text('Pressed $_presses times'),
            const SizedBox(height: 24),
            const ElevatedButton(onPressed: null, child: Text('Disabled')),
          ],
        ),
      ),
    );
  }
}
