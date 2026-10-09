import 'package:flutter/material.dart';

import '../lessons/lesson.dart';
import 'simple_markdown.dart';

/// Loads a lesson's markdown asset and renders it.
class LessonNotes extends StatefulWidget {
  const LessonNotes({super.key, required this.lesson, this.scrollController});

  final Lesson lesson;
  final ScrollController? scrollController;

  @override
  State<LessonNotes> createState() => _LessonNotesState();
}

class _LessonNotesState extends State<LessonNotes> {
  late final Future<String> _text;

  @override
  void initState() {
    super.initState();
    _text = DefaultAssetBundle.of(context)
        .loadString(widget.lesson.markdownPath);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _text,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Could not load ${widget.lesson.markdownPath}.'),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          controller: widget.scrollController,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          child: SimpleMarkdown(data: snapshot.data!),
        );
      },
    );
  }
}
