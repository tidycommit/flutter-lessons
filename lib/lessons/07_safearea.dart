import 'package:flutter/material.dart';

import '../widgets/lesson_info_button.dart';

/// Lesson 07: A screen whose body is wrapped in SafeArea.
class SafeAreaLesson extends StatelessWidget {
  const SafeAreaLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello'),
        actions: const [LessonInfoButton(lessonId: 7)],
      ),
      body: SafeArea(
        child: Container(
          color: Colors.orange,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(24),
          child: const Text(
            'This box stays clear of notches, status bars and the home '
            'indicator.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
