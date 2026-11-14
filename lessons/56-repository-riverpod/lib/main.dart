import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 56,
  title: 'Repository with Riverpod',
  notesAsset: '56-repository-riverpod.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
///
/// ProviderScope stores every provider's state. It must sit above any
/// widget that uses ref. The default repository uses a fake adapter, so
/// tests and the demo never hit a real network.
const lessonApp = ProviderScope(
  child: LessonApp(lesson: lesson, home: RepositoryPage()),
);

void main() => runApp(lessonApp);

class Post {
  const Post({required this.id, required this.title});
  final int id;
  final String title;

  factory Post.fromJson(Map<String, dynamic> json) =>
      Post(id: json['id'] as int, title: json['title'] as String);
}

class PostsRepository {
  PostsRepository(this._dio);
  final Dio _dio;

  Future<List<Post>> fetchPosts() async {
    final response = await _dio.get<List<dynamic>>('/posts');
    return [
      for (final item in response.data!)
        Post.fromJson(item as Map<String, dynamic>),
    ];
  }
}

/// Fake network so the demo works offline.
class FakeAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return ResponseBody.fromString(
      '[{"id":1,"title":"Layers keep code tidy"},'
      '{"id":2,"title":"Repositories hide Dio"},'
      '{"id":3,"title":"Providers can be faked"}]',
      200,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

final postsRepositoryProvider = Provider<PostsRepository>((ref) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
    ..httpClientAdapter = FakeAdapter();
  return PostsRepository(dio);
});

class PostsNotifier extends AsyncNotifier<List<Post>> {
  @override
  Future<List<Post>> build() => ref.read(postsRepositoryProvider).fetchPosts();
}

final postsProvider = AsyncNotifierProvider<PostsNotifier, List<Post>>(
  PostsNotifier.new,
);

class RepositoryPage extends ConsumerWidget {
  const RepositoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Repository'),
        actions: const [LessonInfoButton(lessonId: 56)],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(postsProvider);
          await ref.read(postsProvider.future);
        },
        child: posts.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (list) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              for (final p in list)
                ListTile(
                  leading: CircleAvatar(child: Text('${p.id}')),
                  title: Text(p.title),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
