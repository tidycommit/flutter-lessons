import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 5,
  title: 'Padding and SizedBox',
  notesAsset: '05-padding-sizedbox.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: PaddingSizedBoxLesson());

void main() => runApp(lessonApp);

/// Lesson 05: Spacing with Padding around content and SizedBox between items.
class PaddingSizedBoxLesson extends StatelessWidget {
  const PaddingSizedBoxLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Padding'),
        actions: const [LessonInfoButton(lessonId: 5)],
      ),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('First line, 24 px from the edges'),
            SizedBox(height: 8),
            Text('Second line, 8 px below'),
            SizedBox(height: 32),
            Text('Third line, 32 px below'),
            SizedBox(height: 24),
            SizedBox(
              width: 200,
              height: 48,
              child: ColoredBox(
                color: Colors.amber,
                child: Center(child: Text('SizedBox 200 x 48')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
