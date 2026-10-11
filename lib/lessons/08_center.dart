import 'package:flutter/material.dart';

import '../widgets/lesson_info_button.dart';

/// Lesson 08: Text centered in the available space.
class CenterLesson extends StatelessWidget {
  const CenterLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Center'),
        actions: const [LessonInfoButton(lessonId: 8)],
      ),
      body: const Center(child: Text('Hello, Flutter!')),
    );
  }
}
