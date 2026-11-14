# Lesson 55: Dio interceptors

**Date:** Nov 13, 2026

An interceptor sits between your code and the network and can watch or change every request and response in one place. A logging interceptor writes one line per request, and a retry interceptor tries again when something fails for a short-lived reason, like a dropped connection. Your pages never know either exists; they just call `dio.get`.

Retries need a clear limit, otherwise a broken server makes you loop forever. Here we allow at most 2 retries and count them in `options.extra`. The demo uses a fake adapter that fails the first attempt and succeeds the second, and the log list on screen shows you exactly what happened. In a real app, log only in debug mode. Run `flutter pub add dio` first (already added in lesson 54).

## Key points

- Add an `InterceptorsWrapper` with `onRequest`, `onResponse`, and `onError` so every call is observed in one place.
- Retries need a clear limit (here, at most 2) stored on `options.extra`, or a broken server loops forever.
- A fake adapter fails the first attempt and succeeds the second. The on-screen log shows both. In a real app, log only in debug mode.

This lesson reuses `dio`. Each lesson is its own project, so if it is not already in this folder's `pubspec.yaml`, add it:

```sh
flutter pub add dio
```

## Code

The tip's snippet, verbatim:

```dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: InterceptorsPage()));

/// Fake network: first call fails, later calls succeed.
class FlakyAdapter implements HttpClientAdapter {
  int calls = 0;

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<List<int>>? requestStream, Future<void>? cancelFuture) async {
    calls++;
    if (calls == 1) {
      throw DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          message: 'Fake network drop');
    }
    return ResponseBody.fromString('["Hello","World"]', 200,
        headers: {
          Headers.contentTypeHeader: ['application/json'],
        });
  }

  @override
  void close({bool force = false}) {}
}

Dio buildDio(List<String> log) {
  const maxRetries = 2;
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
  dio.httpClientAdapter = FlakyAdapter();
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      log.add('-> ${options.method} ${options.path}');
      handler.next(options);
    },
    onResponse: (response, handler) {
      log.add('<- ${response.statusCode} OK');
      handler.next(response);
    },
    onError: (error, handler) async {
      final tries = (error.requestOptions.extra['retries'] as int?) ?? 0;
      log.add('!! ${error.message ?? error.type.name}');
      if (tries < maxRetries) {
        error.requestOptions.extra['retries'] = tries + 1;
        log.add('retry ${tries + 1} of $maxRetries');
        try {
          handler.resolve(await dio.fetch(error.requestOptions));
        } on DioException catch (e) {
          handler.next(e);
        }
      } else {
        handler.next(error);
      }
    },
  ));
  return dio;
}

class InterceptorsPage extends StatefulWidget {
  const InterceptorsPage({super.key});

  @override
  State<InterceptorsPage> createState() => _InterceptorsPageState();
}

class _InterceptorsPageState extends State<InterceptorsPage> {
  final List<String> _log = [];
  String _result = '';

  Future<void> _send() async {
    setState(() {
      _log.clear();
      _result = '';
    });
    final dio = buildDio(_log);
    try {
      final response = await dio.get('/hello');
      _result = 'Result: ${response.data}';
    } on DioException {
      _result = 'Gave up';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interceptors')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
                onPressed: _send, child: const Text('Send request')),
          ),
          Text(_result),
          Expanded(
            child: ListView(
              children: [for (final line in _log) ListTile(dense: true, title: Text(line))],
            ),
          ),
        ],
      ),
    );
  }
}
```

## On screen

An app bar titled "Interceptors" with a "Send request" button under it and an empty log. Tapping the button fills the log with: "-> GET /hello", "!! Fake network drop", "retry 1 of 2", "-> GET /hello", "<- 200 OK", and a line "Result: [Hello, World]" appears above the log. The failed first attempt and the successful second one are both visible, and the page code never mentions retries.

## How it is adapted in this app

- This lesson is its own Flutter project. The snippet's `MaterialApp` is this project's `LessonApp` from the shared `lesson_kit` package, which also supplies the theme and lets the info button find these notes. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` uses `InterceptorsPage` as home.
- `InterceptorsPage`'s AppBar keeps `title: const Text('Interceptors')` and gets `actions: const [LessonInfoButton(lessonId: 55)]`. `FlakyAdapter`, `buildDio`, and the on-screen log keep the snippet's behavior. The adapter never talks to a real host, so tests stay offline.
- The retry limit stays at 2, and the log still records the failed first attempt and the successful second one. In a real app you would log only in debug mode, as the tip says.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 55,
  title: 'Dio interceptors',
  notesAsset: '55-dio-interceptors.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: InterceptorsPage());

void main() => runApp(lessonApp);

/// Fake network: first call fails, later calls succeed.
class FlakyAdapter implements HttpClientAdapter {
  int calls = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    calls++;
    if (calls == 1) {
      throw DioException(
        requestOptions: options,
        type: DioExceptionType.connectionError,
        message: 'Fake network drop',
      );
    }
    return ResponseBody.fromString(
      '["Hello","World"]',
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Dio buildDio(List<String> log) {
  const maxRetries = 2;
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
  dio.httpClientAdapter = FlakyAdapter();
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        log.add('-> ${options.method} ${options.path}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        log.add('<- ${response.statusCode} OK');
        handler.next(response);
      },
      onError: (error, handler) async {
        final tries = (error.requestOptions.extra['retries'] as int?) ?? 0;
        log.add('!! ${error.message ?? error.type.name}');
        if (tries < maxRetries) {
          error.requestOptions.extra['retries'] = tries + 1;
          log.add('retry ${tries + 1} of $maxRetries');
          try {
            handler.resolve(await dio.fetch(error.requestOptions));
          } on DioException catch (e) {
            handler.next(e);
          }
        } else {
          handler.next(error);
        }
      },
    ),
  );
  return dio;
}

class InterceptorsPage extends StatefulWidget {
  const InterceptorsPage({super.key});

  @override
  State<InterceptorsPage> createState() => _InterceptorsPageState();
}

class _InterceptorsPageState extends State<InterceptorsPage> {
  final List<String> _log = [];
  String _result = '';

  Future<void> _send() async {
    setState(() {
      _log.clear();
      _result = '';
    });
    final dio = buildDio(_log);
    try {
      final response = await dio.get('/hello');
      _result = 'Result: ${response.data}';
    } on DioException {
      _result = 'Gave up';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interceptors'),
        actions: const [LessonInfoButton(lessonId: 55)],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: _send,
              child: const Text('Send request'),
            ),
          ),
          Text(_result),
          Expanded(
            child: ListView(
              children: [
                for (final line in _log)
                  ListTile(dense: true, title: Text(line)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```
