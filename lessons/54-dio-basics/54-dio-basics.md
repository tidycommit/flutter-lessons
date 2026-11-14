# Lesson 54: Dio client basics

**Date:** Nov 12, 2026

Dio is a friendly HTTP client. You build one shared `Dio` with a `baseUrl`, timeouts and headers, and then every call is short: `dio.get('/posts')` returns a `Response`, and the decoded JSON is in `response.data`. Keeping one instance means your settings live in a single place instead of being scattered across widgets.

The widget never touches `Dio` itself. It asks a small `PostRepository`, which wraps the call in `try/catch` and returns plain titles. That keeps screens simple and previews lesson 56. To keep the demo working offline, a tiny interceptor answers with fake data unless the "Use network" switch is on (it defaults to off). Run `flutter pub add dio` first.

## Key points

- Construct one shared `Dio` with `BaseOptions` for `baseUrl`, timeouts, and headers. Read JSON from `response.data`.
- The widget calls a `PostRepository`, not `Dio` directly. The repository wraps `dio.get` in `try/catch`.
- "Use network" defaults to off. An interceptor returns fake titles so the demo works offline.

Add the package in this folder before pasting the snippet:

```sh
flutter pub add dio
```

## Code

The tip's snippet, verbatim:

```dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: DioPage()));

Dio buildDio({required bool useNetwork}) {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
    headers: {'Accept': 'application/json'},
  ));
  if (!useNetwork) {
    // Fake data so the demo works offline.
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      handler.resolve(Response(
        requestOptions: options,
        statusCode: 200,
        data: [
          for (var i = 1; i <= 8; i++) {'id': i, 'title': 'Fake post $i'},
        ],
      ));
    }));
  }
  return dio;
}

class PostRepository {
  PostRepository(this._dio);
  final Dio _dio;

  Future<List<String>> fetchTitles() async {
    final response = await _dio.get('/posts');
    final items = response.data as List;
    return [for (final item in items.take(5)) item['title'] as String];
  }
}

class DioPage extends StatefulWidget {
  const DioPage({super.key});

  @override
  State<DioPage> createState() => _DioPageState();
}

class _DioPageState extends State<DioPage> {
  bool _useNetwork = false;
  bool _loading = false;
  String? _error;
  List<String> _titles = const [];

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = PostRepository(buildDio(useNetwork: _useNetwork));
      final titles = await repo.fetchTitles();
      setState(() => _titles = titles);
    } on DioException catch (e) {
      setState(() => _error = 'Request failed: ${e.message}');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dio')),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Use network'),
            value: _useNetwork,
            onChanged: (v) => setState(() => _useNetwork = v),
          ),
          FilledButton(
            onPressed: _loading ? null : _fetch,
            child: const Text('Fetch posts'),
          ),
          if (_loading) const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
          if (_error != null) Text(_error!),
          Expanded(
            child: ListView(
              children: [for (final t in _titles) ListTile(title: Text(t))],
            ),
          ),
        ],
      ),
    );
  }
}
```

## On screen

An app bar titled "Dio". Below it a "Use network" switch (off), then a "Fetch posts" button and an empty list. Tapping the button shows a spinner briefly, then five rows: Fake post 1 to Fake post 5. Turning the switch on and fetching loads the first five real titles from JSONPlaceholder. If the request fails, a "Request failed: ..." line appears instead.

## How it is adapted in this app

- This lesson is its own Flutter project. The snippet's `MaterialApp` is this project's `LessonApp` from the shared `lesson_kit` package, which also supplies the theme and lets the info button find these notes. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` uses `DioPage` as home.
- `DioPage`'s AppBar keeps `title: const Text('Dio')` and gets `actions: const [LessonInfoButton(lessonId: 54)]`. `buildDio`, `PostRepository`, and `DioPage` keep the snippet's names and behavior, including the "Use network" switch defaulting to off.
- Tests and the default demo never turn that switch on, so they never hit a real network. The fake interceptor still returns eight posts, and the repository still keeps the first five titles.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 54,
  title: 'Dio client basics',
  notesAsset: '54-dio-basics.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: DioPage());

void main() => runApp(lessonApp);

Dio buildDio({required bool useNetwork}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {'Accept': 'application/json'},
    ),
  );
  if (!useNetwork) {
    // Fake data so the demo works offline.
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: [
                for (var i = 1; i <= 8; i++) {'id': i, 'title': 'Fake post $i'},
              ],
            ),
          );
        },
      ),
    );
  }
  return dio;
}

class PostRepository {
  PostRepository(this._dio);
  final Dio _dio;

  Future<List<String>> fetchTitles() async {
    final response = await _dio.get('/posts');
    final items = response.data as List;
    return [for (final item in items.take(5)) item['title'] as String];
  }
}

class DioPage extends StatefulWidget {
  const DioPage({super.key});

  @override
  State<DioPage> createState() => _DioPageState();
}

class _DioPageState extends State<DioPage> {
  bool _useNetwork = false;
  bool _loading = false;
  String? _error;
  List<String> _titles = const [];

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = PostRepository(buildDio(useNetwork: _useNetwork));
      final titles = await repo.fetchTitles();
      setState(() => _titles = titles);
    } on DioException catch (e) {
      setState(() => _error = 'Request failed: ${e.message}');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dio'),
        actions: const [LessonInfoButton(lessonId: 54)],
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Use network'),
            value: _useNetwork,
            onChanged: (v) => setState(() => _useNetwork = v),
          ),
          FilledButton(
            onPressed: _loading ? null : _fetch,
            child: const Text('Fetch posts'),
          ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          if (_error != null) Text(_error!),
          Expanded(
            child: ListView(
              children: [for (final t in _titles) ListTile(title: Text(t))],
            ),
          ),
        ],
      ),
    );
  }
}
```
