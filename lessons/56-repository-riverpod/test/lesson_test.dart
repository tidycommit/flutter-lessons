import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_56_repository_riverpod/main.dart';
import 'package:lesson_kit/lesson_kit.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'Repository';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 56);
    expect(lesson.notesAsset, '56-repository-riverpod.md');
  });

  test('the notes start with the lesson heading', () {
    final firstLine = File(lesson.notesAsset).readAsLinesSync().first;
    expect(firstLine, '# ${lesson.heading}');
  });

  testWidgets("opens with its snippet's AppBar and the info button", (
    tester,
  ) async {
    await open(tester);
    expect(tester.takeException(), isNull);
    final appBar = tester.widget<AppBar>(find.byType(AppBar));
    expect((appBar.title! as Text).data, expectedAppBarTitle);
    // All snippets use default AppBar styling.
    expect(appBar.backgroundColor, isNull);
    expect(appBar.foregroundColor, isNull);
    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.byTooltip('Lesson notes'),
      ),
      findsOneWidget,
    );
    // The lesson is the app's first screen, so there is nothing to go
    // back to.
    expect(find.byType(BackButton), findsNothing);
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('the info button shows the lesson notes', (tester) async {
    await open(tester);
    await tester.tap(find.byTooltip('Lesson notes'));
    await tester.pumpAndSettle();
    expect(find.text(lesson.heading), findsOneWidget);
    Navigator.of(tester.element(find.byType(BottomSheet))).pop();
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsNothing);
    expect(find.widgetWithText(AppBar, expectedAppBarTitle), findsOneWidget);
  });

  group('56 Repository with Riverpod', () {
    testWidgets('a ProviderScope sits above the lesson screen', (tester) async {
      await open(tester);
      expect(
        find.ancestor(
          of: find.byType(RepositoryPage),
          matching: find.byType(ProviderScope),
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows a spinner, then the three fake posts', (tester) async {
      await tester.pumpWidget(lessonApp);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Layers keep code tidy'), findsNothing);

      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();
      expect(find.text('Layers keep code tidy'), findsOneWidget);
      expect(find.text('Repositories hide Dio'), findsOneWidget);
      expect(find.text('Providers can be faked'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('pull-to-refresh reloads the same posts', (tester) async {
      await open(tester);
      expect(find.text('Layers keep code tidy'), findsOneWidget);

      await tester.fling(find.byType(ListView), const Offset(0, 300), 1000);
      await tester.pump();
      expect(find.byType(RefreshProgressIndicator), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();
      expect(find.text('Layers keep code tidy'), findsOneWidget);
      expect(find.text('Repositories hide Dio'), findsOneWidget);
      expect(find.text('Providers can be faked'), findsOneWidget);
    });

    testWidgets('an override can replace the repository', (tester) async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
        ..httpClientAdapter = _ImmediateAdapter(
          '[{"id":9,"title":"Overridden post"}]',
        );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            postsRepositoryProvider.overrideWithValue(PostsRepository(dio)),
          ],
          child: const LessonApp(lesson: lesson, home: RepositoryPage()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Overridden post'), findsOneWidget);
      expect(find.text('9'), findsOneWidget);
      expect(find.text('Layers keep code tidy'), findsNothing);
    });
  });
}

class _ImmediateAdapter implements HttpClientAdapter {
  _ImmediateAdapter(this.body);

  final String body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      body,
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
