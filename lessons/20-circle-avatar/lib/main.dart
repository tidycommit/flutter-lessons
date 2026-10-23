import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 20,
  title: 'CircleAvatar',
  notesAsset: '20-circle-avatar.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: CircleAvatarLesson());

void main() => runApp(lessonApp);

/// Lesson 20: A teal CircleAvatar showing placeholder initials.
class CircleAvatarLesson extends StatelessWidget {
  const CircleAvatarLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Avatar"),
        actions: const [LessonInfoButton(lessonId: 20)],
      ),
      body: const Center(
        child: CircleAvatar(
          radius: 48,
          backgroundColor: Colors.teal,
          // Placeholder initials.
          child: Text(
            "AB",
            style: TextStyle(fontSize: 32, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
