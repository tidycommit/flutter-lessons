import 'package:flutter/material.dart';

import '../widgets/lesson_info_button.dart';

/// Lesson 21: Moving between screens with Navigator.push and Navigator.pop.
class Lesson21Home extends StatelessWidget {
  const Lesson21Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: const [LessonInfoButton(lessonId: 21)],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Pushes onto the app's navigator; Details' back arrow
            // returns here.
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const Lesson21Details(),
              ),
            );
          },
          child: const Text('Open details'),
        ),
      ),
    );
  }
}

class Lesson21Details extends StatelessWidget {
  const Lesson21Details({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Go back'),
        ),
      ),
    );
  }
}
