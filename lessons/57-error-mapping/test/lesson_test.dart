import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lesson_57_error_mapping/main.dart';

/// The AppBar title from the lesson's snippet.
const expectedAppBarTitle = 'Error mapping';

void main() {
  /// Starts the lesson app. The unused argument keeps the older tests,
  /// which opened a lesson by its title, readable unchanged.
  Future<void> open(WidgetTester tester, [String? _]) async {
    await tester.pumpWidget(lessonApp);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
  }

  test('lesson info matches the notes file', () {
    expect(lesson.id, 57);
    expect(lesson.notesAsset, '57-error-mapping.md');
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

  group('57 Mapping failures to user-visible errors', () {
    test('fromDio maps DioException types to friendly AppFailure messages', () {
      final options = RequestOptions(path: '/posts');
      expect(
        fromDio(
          DioException(
            requestOptions: options,
            type: DioExceptionType.connectionError,
          ),
        ).userMessage,
        'No connection. Check your internet and try again.',
      );
      expect(
        fromDio(
          DioException(
            requestOptions: options,
            type: DioExceptionType.connectionTimeout,
          ),
        ).kind,
        FailureKind.network,
      );
      expect(
        fromDio(
          DioException(
            requestOptions: options,
            type: DioExceptionType.badResponse,
            response: Response(requestOptions: options, statusCode: 404),
          ),
        ).userMessage,
        'We could not find what you asked for.',
      );
      expect(
        fromDio(
          DioException(
            requestOptions: options,
            type: DioExceptionType.badResponse,
            response: Response(requestOptions: options, statusCode: 500),
          ),
        ).userMessage,
        'Something went wrong. Please try again.',
      );
    });

    testWidgets('shows a spinner, then the two fake titles', (tester) async {
      await tester.pumpWidget(lessonApp);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Map errors in one place'), findsNothing);

      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(find.text('Map errors in one place'), findsOneWidget);
      expect(find.text('Show friendly messages'), findsOneWidget);
    });

    testWidgets(
      'Airplane mode shows the friendly network message, never a raw exception',
      (tester) async {
        await open(tester);
        await tester.tap(find.byType(Switch));
        await tester.pump();
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();

        expect(
          find.text('No connection. Check your internet and try again.'),
          findsOneWidget,
        );
        expect(find.text('Retry'), findsOneWidget);
        expect(find.textContaining('SocketException'), findsNothing);
        expect(find.textContaining('Failed host lookup'), findsNothing);
        expect(find.text('Map errors in one place'), findsNothing);

        await tester.tap(find.text('Retry'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();
        expect(
          find.text('No connection. Check your internet and try again.'),
          findsOneWidget,
        );

        // Watching repositoryProvider reloads automatically when the
        // switch flips, so the titles return without a Retry tap.
        await tester.tap(find.byType(Switch));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();
        expect(find.text('Map errors in one place'), findsOneWidget);
        expect(find.text('Show friendly messages'), findsOneWidget);
        expect(
          find.text('No connection. Check your internet and try again.'),
          findsNothing,
        );
      },
    );
  });
}
