/// Shared pieces for the standalone lesson projects in `lessons/`.
///
/// Each lesson's `lib/main.dart` describes itself with a [LessonInfo],
/// wraps its example in a [LessonApp] (or a [LessonScope] when the example
/// builds its own `MaterialApp`), and puts a [LessonInfoButton] in its
/// AppBar's `actions` to open the lesson notes.
library;

export 'src/lesson_app.dart';
export 'src/lesson_info.dart';
export 'src/lesson_info_button.dart';
export 'src/lesson_notes.dart';
export 'src/simple_markdown.dart';
