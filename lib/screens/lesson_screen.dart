import 'package:flutter/material.dart';

import '../lessons/lesson.dart';
import '../widgets/lesson_notes.dart';

/// Hosts one lesson's runnable example, with the lesson text one tap away.
class LessonScreen extends StatelessWidget {
  const LessonScreen({super.key, required this.lesson});

  final Lesson lesson;

  void _showNotes(BuildContext context) {
    showModalBottomSheet<void>(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Lesson notes',
            onPressed: () => _showNotes(context),
          ),
        ],
      ),
      body: Builder(builder: lesson.builder),
    );
  }
}
