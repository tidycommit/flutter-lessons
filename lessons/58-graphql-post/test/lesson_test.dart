import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_58_graphql_post/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'GraphQL POST';

Dio fakeDio() =>
    Dio(BaseOptions(baseUrl: 'https://example.test'))
      ..httpClientAdapter = FakeGraphQlAdapter();

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 58);
    expect(lesson.notesAsset, '58-graphql-post.md');
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

  group('58 GraphQL-style POST', () {
    test('treats a GraphQL errors array as failure even on HTTP 200', () async {
      expect(await fetchHeroName(fakeDio(), '1'), 'Nebula');
      expect(
        () => fetchHeroName(fakeDio(), '99'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Hero not found'),
          ),
        ),
      );
    });

    testWidgets('Fetch hero 1 shows Nebula from the fake POST', (tester) async {
      await open(tester);
      expect(find.text('Tap a button to run the query.'), findsOneWidget);

      await tester.tap(find.text('Fetch hero 1'));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      expect(find.text('Hero: Nebula'), findsOneWidget);
    });

    testWidgets('Fetch hero 99 shows the GraphQL error message', (
      tester,
    ) async {
      await open(tester);
      await tester.tap(find.text('Fetch hero 99'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      expect(find.text('Error: Hero not found'), findsOneWidget);
    });
  });
}
