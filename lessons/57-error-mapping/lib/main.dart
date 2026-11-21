import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 57,
  title: 'Mapping failures to user-visible errors',
  notesAsset: '57-error-mapping.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
///
/// ProviderScope stores every provider's state. It must sit above any
/// widget that uses ref. The default repository uses a fake adapter, so
/// tests and the demo never hit a real network.
const lessonApp = ProviderScope(
  child: LessonApp(lesson: lesson, home: ErrorMappingPage()),
);

void main() => runApp(lessonApp);

enum FailureKind { network, notFound, unknown }

class AppFailure implements Exception {
  const AppFailure(this.kind);
  final FailureKind kind;

  String get userMessage => switch (kind) {
    FailureKind.network => 'No connection. Check your internet and try again.',
    FailureKind.notFound => 'We could not find what you asked for.',
    FailureKind.unknown => 'Something went wrong. Please try again.',
  };
}

AppFailure fromDio(DioException e) {
  if (e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.connectionTimeout) {
    return const AppFailure(FailureKind.network);
  }
  if (e.response?.statusCode == 404) {
    return const AppFailure(FailureKind.notFound);
  }
  return const AppFailure(FailureKind.unknown);
}

class FakeAdapter implements HttpClientAdapter {
  FakeAdapter({required this.airplane});
  final bool airplane;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (airplane) {
      throw DioException(
        requestOptions: options,
        type: DioExceptionType.connectionError,
        error: 'SocketException: Failed host lookup',
      );
    }
    return ResponseBody.fromString(
      '[{"id":1,"title":"Map errors in one place"},'
      '{"id":2,"title":"Show friendly messages"}]',
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class PostsRepository {
  PostsRepository(this._dio);
  final Dio _dio;

  Future<List<String>> fetchTitles() async {
    try {
      final response = await _dio.get<List<dynamic>>('/posts');
      return [
        for (final item in response.data!)
          (item as Map<String, dynamic>)['title'] as String,
      ];
    } on DioException catch (e) {
      throw fromDio(e);
    }
  }
}

class AirplaneNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void set(bool value) => state = value;
}

final airplaneProvider = NotifierProvider<AirplaneNotifier, bool>(
  AirplaneNotifier.new,
);

final repositoryProvider = Provider<PostsRepository>((ref) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
    ..httpClientAdapter = FakeAdapter(airplane: ref.watch(airplaneProvider));
  return PostsRepository(dio);
});

class PostsNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() => ref.watch(repositoryProvider).fetchTitles();
}

final postsProvider = AsyncNotifierProvider<PostsNotifier, List<String>>(
  PostsNotifier.new,
);

class ErrorMappingPage extends ConsumerWidget {
  const ErrorMappingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postsProvider);
    final airplane = ref.watch(airplaneProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error mapping'),
        actions: const [LessonInfoButton(lessonId: 57)],
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Airplane mode'),
            value: airplane,
            onChanged: (v) => ref.read(airplaneProvider.notifier).set(v),
          ),
          Expanded(
            child: posts.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: ListTile(
                    leading: const Icon(Icons.error_outline),
                    title: Text(
                      e is AppFailure ? e.userMessage : 'Something went wrong.',
                    ),
                    trailing: TextButton(
                      onPressed: () => ref.invalidate(postsProvider),
                      child: const Text('Retry'),
                    ),
                  ),
                ),
              ),
              data: (titles) => ListView(
                children: [for (final t in titles) ListTile(title: Text(t))],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
