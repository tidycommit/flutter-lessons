import 'package:flutter/widgets.dart';

/// What a lesson project tells the shared pieces about itself.
@immutable
class LessonInfo {
  const LessonInfo({
    required this.id,
    required this.title,
    required this.notesAsset,
  });

  /// Lesson number, e.g. `34`.
  final int id;

  /// Short title, the same as in the notes heading `# Lesson NN: <title>`.
  final String title;

  /// Asset path of the lesson notes, e.g. `34-button-variants.md`. The file
  /// sits in the project folder and is listed under `flutter: assets:`.
  final String notesAsset;

  /// Two-digit lesson number, e.g. `07`.
  String get number => id.toString().padLeft(2, '0');

  /// The first line of the notes: `Lesson 07: SafeArea`.
  String get heading => 'Lesson $number: $title';
}

/// Makes the running lesson's [LessonInfo] available below it, so a
/// [LessonInfoButton] anywhere in the tree can open the right notes.
class LessonScope extends InheritedWidget {
  const LessonScope({super.key, required this.lesson, required super.child});

  final LessonInfo lesson;

  /// The nearest lesson above [context].
  static LessonInfo of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LessonScope>();
    assert(scope != null, 'No LessonScope above this widget.');
    return scope!.lesson;
  }

  @override
  bool updateShouldNotify(LessonScope oldWidget) => lesson != oldWidget.lesson;
}
