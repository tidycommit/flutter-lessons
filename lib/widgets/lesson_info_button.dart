import 'package:flutter/material.dart';

import '../lessons/lesson.dart';
import '../lessons/lessons.dart';
import 'lesson_notes.dart';

/// The info action every lesson screen puts in its AppBar's `actions`.
///
/// Tapping it opens the lesson's markdown text in a bottom sheet, so the
/// explanation can be read next to the running example.
class LessonInfoButton extends StatelessWidget {
  const LessonInfoButton({super.key, required this.lessonId});

  /// The `id` of the lesson in the registry (`lib/lessons/lessons.dart`).
  final int lessonId;

  Lesson get _lesson => lessons.firstWhere((l) => l.id == lessonId);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.info_outline),
      tooltip: 'Lesson notes',
      onPressed: () => showLessonNotes(context, _lesson),
    );
  }
}

/// Shows [lesson]'s markdown text in a draggable bottom sheet.
Future<void> showLessonNotes(BuildContext context, Lesson lesson) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      builder: (_, controller) =>
          LessonNotes(lesson: lesson, scrollController: controller),
    ),
  );
}
