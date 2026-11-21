# Lesson 57: Mapping failures to user-visible errors

**Date:** Nov 15, 2026

When a request fails, Dio throws a `DioException` full of technical detail that you never want to show a user. The fix is one small app type, `AppFailure`, with a `userMessage` written in plain words, plus one central function `fromDio` that turns any `DioException` into it. The repository catches the Dio error and throws the `AppFailure` instead, so everything above it only ever sees friendly errors.

The notifier needs no extra code: when the repository throws, the provider becomes `AsyncValue.error` holding the `AppFailure`. The widget shows `failure.userMessage` in an alert-style card with a Retry button that calls `ref.invalidate(postsProvider)`. The "Airplane mode" switch on a fake client forces a failure so you can try it. Run `flutter pub add dio flutter_riverpod` first (both were added in earlier lessons).

## Key points

- Catch `DioException` in the repository and throw `AppFailure` from a central `fromDio` helper (`network`, `notFound`, or `unknown`), each with a `userMessage` in plain words.
- The notifier needs no extra code: a thrown `AppFailure` becomes `AsyncValue.error`. The widget shows `failure.userMessage`, never a raw exception string.
- Retry calls `ref.invalidate(postsProvider)`. The "Airplane mode" switch on the fake client forces a connection error so you can try it.

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

enum FailureKind { network, notFound, unknown }

class AppFailure implements Exception {
  const AppFailure(this.kind);
  final FailureKind kind;

  String get userMessage => switch (kind) {
        FailureKind.network =>
          'No connection. Check your internet and try again.',
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
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<List<int>>? requestStream, Future<void>? cancelFuture) async {
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

final airplaneProvider =
    NotifierProvider<AirplaneNotifier, bool>(AirplaneNotifier.new);

final repositoryProvider = Provider<PostsRepository>((ref) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
    ..httpClientAdapter = FakeAdapter(airplane: ref.watch(airplaneProvider));
  return PostsRepository(dio);
});

class PostsNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() =>
      ref.watch(repositoryProvider).fetchTitles();
}

final postsProvider =
    AsyncNotifierProvider<PostsNotifier, List<String>>(PostsNotifier.new);

void main() => runApp(
      const ProviderScope(
        child: MaterialApp(home: ErrorMappingPage()),
      ),
    );

class ErrorMappingPage extends ConsumerWidget {
  const ErrorMappingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postsProvider);
    final airplane = ref.watch(airplaneProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Error mapping')),
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
                    title: Text(e is AppFailure
                        ? e.userMessage
                        : 'Something went wrong.'),
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
```

## On screen

An app bar titled "Error mapping" and an "Airplane mode" switch, off at first. After a brief spinner, two list rows appear: "Map errors in one place" and "Show friendly messages". Turn the switch on and the list reloads, then is replaced by a pinkish error card with an alert icon, the sentence "No connection. Check your internet and try again." and a Retry button. Retry while the switch is still on shows the same card; turn the switch off (or tap Retry after) and the two rows return. No raw exception text ever appears.

## How it is adapted in this app

- This lesson is its own Flutter project. The snippet's `MaterialApp` is this project's `LessonApp` from the shared `lesson_kit` package, wrapped in the same `ProviderScope` the snippet uses, so providers work and the info button can find these notes. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` uses `ErrorMappingPage` as home.
- `ErrorMappingPage`'s AppBar keeps `title: const Text('Error mapping')` and gets `actions: const [LessonInfoButton(lessonId: 57)]`. `AppFailure`, `fromDio`, `FakeAdapter`, `PostsRepository`, `AirplaneNotifier`, `PostsNotifier`, and the providers keep the snippet's names and behavior. The default repository still uses `FakeAdapter`, so the demo and the tests never hit a real network.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
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
```
