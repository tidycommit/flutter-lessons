import 'package:flutter/material.dart';

import '../widgets/lesson_info_button.dart';

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
