import 'package:flutter/material.dart';

import '../lessons/lesson.dart';

/// The route pushed when a lesson is tapped on the home screen.
///
/// There is no shared AppBar here: every lesson's example returns its own
/// Scaffold with the AppBar from its snippet, plus a `LessonInfoButton` in
/// the AppBar's `actions`. Because that Scaffold is the pushed route, its
/// AppBar shows the back arrow to the lesson list automatically.
class LessonScreen extends StatelessWidget {
  const LessonScreen({super.key, required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) => Builder(builder: lesson.builder);
}
