import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

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
