import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 19,
  title: 'SnackBar',
  notesAsset: '19-snack-bar.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: SnackBarLesson());

void main() => runApp(lessonApp);

/// Lesson 19: A Save button that shows a 'Saved!' SnackBar.
class SnackBarLesson extends StatelessWidget {
  const SnackBarLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SnackBar"),
        actions: const [LessonInfoButton(lessonId: 19)],
      ),
      body: Center(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("Saved!")));
            },
            child: const Text("Save"),
          ),
        ),
      ),
    );
  }
}
