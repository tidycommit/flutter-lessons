import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_kit/lesson_kit.dart';

const _lesson = LessonInfo(id: 7, title: 'Demo', notesAsset: 'demo.md');

/// Serves [text] for every asset request, so no real asset is needed.
class _FakeBundle extends CachingAssetBundle {
  _FakeBundle(this.text);
  final String text;

  @override
  Future<ByteData> load(String key) async =>
      ByteData.sublistView(Uint8List.fromList(utf8.encode(text)));
}

Widget _app(String notes) => DefaultAssetBundle(
  bundle: _FakeBundle(notes),
  child: LessonApp(
    lesson: _lesson,
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Demo'),
        actions: const [LessonInfoButton(lessonId: 7)],
      ),
    ),
  ),
);

void main() {
  test('LessonInfo formats the number and heading', () {
    expect(_lesson.number, '07');
    expect(_lesson.heading, 'Lesson 07: Demo');
  });

  testWidgets('LessonApp uses the indigo theme and hides the banner', (
    tester,
  ) async {
    await tester.pumpWidget(_app('# Lesson 07: Demo'));
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.debugShowCheckedModeBanner, isFalse);
    expect(app.title, 'Lesson 07: Demo');
    expect(app.theme!.colorScheme.primary, LessonApp.theme.colorScheme.primary);
  });

  testWidgets('the info button opens and renders the notes', (tester) async {
    await tester.pumpWidget(
      _app('# Lesson 07: Demo\n\nSome **bold** text.\n\n- a point\n'),
    );
    await tester.tap(find.byTooltip('Lesson notes'));
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsOneWidget);
    expect(find.text('Lesson 07: Demo'), findsOneWidget);
    expect(find.textContaining('a point'), findsOneWidget);
  });

  testWidgets('a button from another lesson is caught', (tester) async {
    await tester.pumpWidget(
      const LessonScope(
        lesson: _lesson,
        child: MaterialApp(home: Scaffold(body: LessonInfoButton(lessonId: 8))),
      ),
    );
    expect(tester.takeException(), isAssertionError);
  });
}
