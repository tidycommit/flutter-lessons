# Lesson 58: GraphQL-style POST (query in the body)

**Date:** Nov 16, 2026

Many GraphQL APIs are just a normal `POST` to one endpoint, such as `/graphql`, with a JSON body that holds a `query` string and a `variables` map. You don't need a special Flutter package for a first lesson: Dio sends the body and you read the answer from a plain map.

The answer has two possible keys: `data` when things worked and `errors` when they didn't. The big catch is that a GraphQL server often replies with HTTP 200 even when the query failed, so you must check for `errors` yourself and treat it as a failure. Run `flutter pub add dio` first (added in lesson 54). The demo uses a fake adapter, so it works offline; a real app would point `baseUrl` at its own server.

## Key points

- One endpoint, one POST, body is `{query, variables}`.
- Treat a non-empty `errors` array as failure even on HTTP 200.
- Keep query strings in constants (or `.graphql` assets later).

This lesson needs `dio`. Each lesson is its own project, so if it is not already in this folder's `pubspec.yaml`, add it:

```sh
flutter pub add dio
```

## Code

The tip's snippet, verbatim:

```dart
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

const heroQuery = r'''
query Hero($id: ID!) {
  hero(id: $id) { name }
}
''';

class FakeGraphQlAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<List<int>>? requestStream, Future<void>? cancelFuture) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final body = options.data as Map<String, dynamic>;
    final id = (body['variables'] as Map<String, dynamic>)['id'];
    final result = id == '1'
        ? {
            'data': {
              'hero': {'name': 'Nebula'},
            },
          }
        : {
            'errors': [
              {'message': 'Hero not found'},
            ],
          };
    return ResponseBody.fromString(
      jsonEncode(result),
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Future<String> fetchHeroName(Dio dio, String id) async {
  final response = await dio.post<Map<String, dynamic>>(
    '/graphql',
    data: {
      'query': heroQuery,
      'variables': {'id': id},
    },
  );
  final json = response.data!;
  final errors = json['errors'] as List<dynamic>?;
  if (errors != null && errors.isNotEmpty) {
    throw Exception((errors.first as Map<String, dynamic>)['message']);
  }
  final hero = (json['data'] as Map<String, dynamic>)['hero']
      as Map<String, dynamic>;
  return hero['name'] as String;
}

void main() => runApp(const MaterialApp(home: GraphQlPage()));

class GraphQlPage extends StatefulWidget {
  const GraphQlPage({super.key});

  @override
  State<GraphQlPage> createState() => _GraphQlPageState();
}

class _GraphQlPageState extends State<GraphQlPage> {
  final _dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
    ..httpClientAdapter = FakeGraphQlAdapter();
  String _text = 'Tap a button to run the query.';
  bool _loading = false;

  Future<void> _run(String id) async {
    setState(() => _loading = true);
    try {
      final name = await fetchHeroName(_dio, id);
      setState(() => _text = 'Hero: $name');
    } catch (e) {
      setState(() => _text = 'Error: ${e.toString().replaceFirst('Exception: ', '')}');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GraphQL POST')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              onPressed: _loading ? null : () => _run('1'),
              child: const Text('Fetch hero 1'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _loading ? null : () => _run('99'),
              child: const Text('Fetch hero 99'),
            ),
            const SizedBox(height: 24),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else
              Text(_text, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
```

## On screen

An app bar titled "GraphQL POST". Below it, a filled "Fetch hero 1" button and an outlined "Fetch hero 99" button, then a line of text that starts as "Tap a button to run the query." Tapping "Fetch hero 1" shows a spinner for a moment, then "Hero: Nebula". Tapping "Fetch hero 99" gets an HTTP 200 reply that contains an `errors` list, so the text becomes "Error: Hero not found".

## How it is adapted in this app

- This lesson is its own Flutter project. The snippet's `MaterialApp` is this project's `LessonApp` from the shared `lesson_kit` package, so the info button can find these notes. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` uses `GraphQlPage` as home.
- `GraphQlPage`'s AppBar keeps `title: const Text('GraphQL POST')` and gets `actions: const [LessonInfoButton(lessonId: 58)]`. `heroQuery`, `FakeGraphQlAdapter`, `fetchHeroName`, and `GraphQlPage` keep the snippet's names and behavior. The client still uses `FakeGraphQlAdapter`, so the demo and the tests never hit a real network.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 58,
  title: 'GraphQL-style POST (query in the body)',
  notesAsset: '58-graphql-post.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
///
/// The Dio client uses a fake adapter, so the demo and the tests never
/// hit a real network.
const lessonApp = LessonApp(lesson: lesson, home: GraphQlPage());

void main() => runApp(lessonApp);

const heroQuery = r'''
query Hero($id: ID!) {
  hero(id: $id) { name }
}
''';

class FakeGraphQlAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final body = options.data as Map<String, dynamic>;
    final id = (body['variables'] as Map<String, dynamic>)['id'];
    final result = id == '1'
        ? {
            'data': {
              'hero': {'name': 'Nebula'},
            },
          }
        : {
            'errors': [
              {'message': 'Hero not found'},
            ],
          };
    return ResponseBody.fromString(
      jsonEncode(result),
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Future<String> fetchHeroName(Dio dio, String id) async {
  final response = await dio.post<Map<String, dynamic>>(
    '/graphql',
    data: {
      'query': heroQuery,
      'variables': {'id': id},
    },
  );
  final json = response.data!;
  final errors = json['errors'] as List<dynamic>?;
  if (errors != null && errors.isNotEmpty) {
    throw Exception((errors.first as Map<String, dynamic>)['message']);
  }
  final hero =
      (json['data'] as Map<String, dynamic>)['hero'] as Map<String, dynamic>;
  return hero['name'] as String;
}

class GraphQlPage extends StatefulWidget {
  const GraphQlPage({super.key});

  @override
  State<GraphQlPage> createState() => _GraphQlPageState();
}

class _GraphQlPageState extends State<GraphQlPage> {
  final _dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
    ..httpClientAdapter = FakeGraphQlAdapter();
  String _text = 'Tap a button to run the query.';
  bool _loading = false;

  Future<void> _run(String id) async {
    setState(() => _loading = true);
    try {
      final name = await fetchHeroName(_dio, id);
      setState(() => _text = 'Hero: $name');
    } catch (e) {
      setState(
        () => _text = 'Error: ${e.toString().replaceFirst('Exception: ', '')}',
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GraphQL POST'),
        actions: const [LessonInfoButton(lessonId: 58)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              onPressed: _loading ? null : () => _run('1'),
              child: const Text('Fetch hero 1'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _loading ? null : () => _run('99'),
              child: const Text('Fetch hero 99'),
            ),
            const SizedBox(height: 24),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else
              Text(_text, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
```
