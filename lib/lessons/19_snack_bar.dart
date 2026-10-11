import 'package:flutter/material.dart';

import '../widgets/lesson_info_button.dart';

/// Lesson 19: A Save button that shows a 'Saved!' SnackBar.
class SnackBarLesson extends StatelessWidget {
  const SnackBarLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SnackBar"),
        actions: const [LessonInfoButton(lessonId: 19)],
      ),
      body: Center(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("Saved!")));
            },
            child: const Text("Save"),
          ),
        ),
      ),
    );
  }
}
