import 'package:flutter/material.dart';

import '../widgets/lesson_info_button.dart';

/// Lesson 11: A Scaffold with a FloatingActionButton.
class FloatingActionButtonLesson extends StatelessWidget {
  const FloatingActionButtonLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAB Tip'),
        actions: const [LessonInfoButton(lessonId: 11)],
      ),
      body: const Center(child: Text('Tap the + button')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
