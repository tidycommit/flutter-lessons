import 'package:flutter/material.dart';

import '../lessons/lesson.dart';
import '../widgets/lesson_info_button.dart';

/// The route pushed when a lesson is tapped on the home screen.
///
/// There is no shared, titled AppBar here. A lesson whose snippet has its
/// own Scaffold and AppBar ([Lesson.hasOwnAppBar]) is shown as-is: its
/// Scaffold is the pushed route, so its AppBar gets the back arrow
/// automatically, and it adds a [LessonInfoButton] to its own `actions`.
///
/// A lesson whose snippet has no AppBar is shown unchanged under a minimal
/// AppBar with no title: just the back arrow and the info action.
class LessonScreen extends StatelessWidget {
  const LessonScreen({super.key, required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final example = Builder(builder: lesson.builder);
    if (lesson.hasOwnAppBar) return example;
    return Scaffold(
      appBar: AppBar(actions: [LessonInfoButton(lessonId: lesson.id)]),
      body: example,
    );
  }
}
