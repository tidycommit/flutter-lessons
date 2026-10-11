import 'package:flutter/widgets.dart';

/// Metadata for one lesson: where its text lives and how to build its
/// runnable example.
class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.date,
    required this.markdownPath,
    required this.builder,
    this.hasOwnAppBar = false,
  });

  /// Lesson number, shown as a two-digit label (01, 02, ...).
  final int id;

  /// Short title used in the lesson list and the example screen's AppBar.
  final String title;

  /// Day the lesson was written, or null if it was not recorded.
  final DateTime? date;

  /// Asset path of the lesson's markdown file, e.g. `lessons/01-hello-app.md`.
  final String markdownPath;

  /// Builds the runnable example shown on the lesson screen.
  final WidgetBuilder builder;

  /// True when the lesson's snippet has its own Scaffold with an AppBar.
  ///
  /// The example is then used as the whole screen, and its AppBar must add
  /// `LessonInfoButton(lessonId: id)` to its `actions`. When false, the app
  /// shows the example under a minimal AppBar with no title that holds only
  /// the back arrow and the info action.
  final bool hasOwnAppBar;

  /// Two-digit lesson number, e.g. `07`.
  String get number => id.toString().padLeft(2, '0');

  /// Human-readable date such as `Sep 21, 2026`.
  String get formattedDate {
    final d = date;
    if (d == null) return 'Date not recorded';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}
