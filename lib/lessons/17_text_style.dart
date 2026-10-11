import 'package:flutter/material.dart';

import '../widgets/lesson_info_button.dart';

/// Lesson 17: Large, bold, deep purple text.
class TextStyleLesson extends StatelessWidget {
  const TextStyleLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Styles'),
        actions: const [LessonInfoButton(lessonId: 17)],
      ),
      body: const Center(
        child: Text(
          'Hello, Flutter!',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }
}
