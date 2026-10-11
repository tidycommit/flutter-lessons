import 'package:flutter/material.dart';

import '../widgets/lesson_info_button.dart';

/// Lesson 03: A Scaffold with an AppBar, a body and a bottom bar.
class ScaffoldLesson extends StatelessWidget {
  const ScaffoldLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My page'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: const [LessonInfoButton(lessonId: 3)],
      ),
      body: const Center(child: Text('The body fills the space in between.')),
      bottomNavigationBar: const BottomAppBar(
        child: Center(child: Text('Bottom app bar')),
      ),
    );
  }
}
