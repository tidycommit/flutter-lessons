import 'package:flutter/material.dart';

import 'lesson_info.dart';

/// The app every lesson runs in: a `MaterialApp` with the series' indigo
/// theme whose `home` is the lesson's own screen.
///
/// A lesson whose snippet builds its own `MaterialApp` (for example to set
/// `routes` or `themeMode`) skips this and wraps that app in a
/// [LessonScope] instead.
class LessonApp extends StatelessWidget {
  const LessonApp({super.key, required this.lesson, required this.home});

  final LessonInfo lesson;

  /// The lesson's first screen: a Scaffold with the snippet's AppBar.
  final Widget home;

  /// The theme shared by the lessons.
  static ThemeData get theme => ThemeData(colorSchemeSeed: Colors.indigo);

  @override
  Widget build(BuildContext context) {
    return LessonScope(
      lesson: lesson,
      child: MaterialApp(
        title: lesson.heading,
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: home,
      ),
    );
  }
}
