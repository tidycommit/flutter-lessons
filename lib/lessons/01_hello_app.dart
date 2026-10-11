import 'package:flutter/material.dart';

import '../widgets/lesson_info_button.dart';

/// Lesson 01: The smallest useful screen: an AppBar and some centered text.
class HelloAppLesson extends StatelessWidget {
  const HelloAppLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello'),
        actions: const [LessonInfoButton(lessonId: 1)],
      ),
      body: const Center(
        child: Text('Hello, world!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
