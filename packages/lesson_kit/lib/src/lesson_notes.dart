import 'package:flutter/material.dart';

import 'lesson_info.dart';
import 'simple_markdown.dart';

/// Loads a lesson's markdown asset and renders it.
class LessonNotes extends StatefulWidget {
  const LessonNotes({super.key, required this.lesson, this.scrollController});

  final LessonInfo lesson;
  final ScrollController? scrollController;

  @override
  State<LessonNotes> createState() => _LessonNotesState();
}

class _LessonNotesState extends State<LessonNotes> {
  Future<String>? _text;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // cache: false keeps each load in the current zone. The files are small,
    // and a cached Future from an earlier widget test would never complete
    // in a later test's fake-async zone.
    _text ??= DefaultAssetBundle.of(context)
        .loadString(widget.lesson.notesAsset, cache: false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _text,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Could not load ${widget.lesson.notesAsset}.'),
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
