import 'package:flutter/material.dart';

import '../widgets/lesson_info_button.dart';

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
