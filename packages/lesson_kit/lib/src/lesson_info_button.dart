import 'package:flutter/material.dart';

import 'lesson_info.dart';
import 'lesson_notes.dart';

/// The info action every lesson screen puts in its AppBar's `actions`.
///
/// Tapping it opens the lesson's notes in a bottom sheet, so the
/// explanation can be read next to the running example.
class LessonInfoButton extends StatelessWidget {
  const LessonInfoButton({super.key, required this.lessonId});

  /// The lesson's number. It must match the [LessonInfo] of the running
  /// project; the check catches a button copied from another lesson.
  final int lessonId;

  @override
  Widget build(BuildContext context) {
    final lesson = LessonScope.of(context);
    assert(
      lesson.id == lessonId,
      'LessonInfoButton(lessonId: $lessonId) in lesson ${lesson.id}.',
    );
    return IconButton(
      icon: const Icon(Icons.info_outline),
      tooltip: 'Lesson notes',
      onPressed: () => showLessonNotes(context, lesson),
    );
  }
}

/// Shows [lesson]'s notes in a draggable bottom sheet.
Future<void> showLessonNotes(BuildContext context, LessonInfo lesson) {
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
