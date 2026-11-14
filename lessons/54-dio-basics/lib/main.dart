import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

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
