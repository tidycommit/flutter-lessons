# Lesson 56: Repository with Riverpod

**Date:** Nov 14, 2026

Big apps keep layers apart: **Widget → provider/notifier → repository → Dio**. The repository is the only place that knows about Dio and JSON; it turns raw maps into a small `Post` model. The notifier (an `AsyncNotifier`) calls the repository and exposes loading, error and data. Widgets only `watch` the notifier and draw whatever state it has.

The nice payoff is swapping parts. Because `postsRepositoryProvider` is its own provider, you can override it in `ProviderScope` with a fake and the whole screen keeps working with no network. Pull-to-refresh is just `ref.invalidate(postsProvider)`, which makes the notifier load again. Run `flutter pub add dio flutter_riverpod` first (both were added in earlier lessons).

## Key points

- Layers stay apart: widget → notifier → repository → Dio. The repository maps JSON to a `Post` model.
- `postsProvider` is an `AsyncNotifier`. The page only `watch`es it and uses `AsyncValue.when`.
- Override `postsRepositoryProvider` in `ProviderScope` to fake the data. Pull-to-refresh calls `ref.invalidate(postsProvider)`.

This lesson needs `dio` and `flutter_riverpod`. Each lesson is its own project, so if they are not already in this folder's `pubspec.yaml`, add them:

```sh
flutter pub add dio flutter_riverpod
```

## Code

The tip's snippet, verbatim:

```dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<List<int>>? requestStream, Future<void>? cancelFuture) async {
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

final postsProvider =
    AsyncNotifierProvider<PostsNotifier, List<Post>>(PostsNotifier.new);

void main() => runApp(
      const ProviderScope(
        child: MaterialApp(home: RepositoryPage()),
      ),
    );

class RepositoryPage extends ConsumerWidget {
  const RepositoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Repository')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(postsProvider);
          await ref.read(postsProvider.future);
        },
        child: posts.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (list) => ListView(
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
```

## On screen

An app bar titled "Repository". For about half a second a spinner shows in the middle, then a list of three posts appears, each with a numbered circle (1, 2, 3) and a title: "Layers keep code tidy", "Repositories hide Dio", "Providers can be faked". Pulling the list down shows the refresh spinner, the spinner reloads the data, and the same three posts return.

## How it is adapted in this app

- This lesson is its own Flutter project. The snippet's `MaterialApp` is this project's `LessonApp` from the shared `lesson_kit` package, wrapped in the same `ProviderScope` the snippet uses, so providers work and the info button can find these notes. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` uses `RepositoryPage` as home.
- `RepositoryPage`'s AppBar keeps `title: const Text('Repository')` and gets `actions: const [LessonInfoButton(lessonId: 56)]`. `Post`, `PostsRepository`, `FakeAdapter`, `PostsNotifier`, and the two providers keep the snippet's names and behavior. The default repository still uses `FakeAdapter`, so the demo and the tests never hit a real network.
- The list uses `physics: const AlwaysScrollableScrollPhysics()` so pull-to-refresh works even when the three posts are shorter than the screen. That is the only behavior change from the snippet.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
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
```
