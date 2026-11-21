import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

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
