import 'package:flutter/material.dart';

import '../widgets/lesson_info_button.dart';

/// Lesson 16: A blue box with a red 'NEW' badge that hangs over its corner.
class StackLesson extends StatelessWidget {
  const StackLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stack'),
        actions: const [LessonInfoButton(lessonId: 16)],
      ),
      body: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(width: 200, height: 200, color: Colors.blue),
            Positioned(
              top: -12,
              right: -12,
              child: Container(
                padding: const EdgeInsets.all(6),
                color: Colors.red,
                child: const Text('NEW', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
