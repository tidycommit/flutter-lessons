# Lesson 61: Mini feature skeleton

**Date:** Nov 19, 2026

A feature folder keeps one slice of your app together. Typically it has a data layer (the repository), providers that expose it, presentation (the screens), and a route list. The host app only registers the feature's routes and overrides its dependencies, so it never reaches into the feature's insides.

Today's demo is a tiny Notes feature with an in-memory repository, a list screen, and the go_router path `/notes`. In a real project each piece below would be its own file (`feature_notes/data/notes_repository.dart`, `presentation/notes_list_screen.dart`, `providers.dart`, `routes.dart`); here they sit in one file so you can run it.

Add the packages first (you already have them from earlier lessons): `flutter pub add flutter_riverpod go_router`

## Key points

- A feature folder typically has data (the repository), providers, presentation (the screens), and a route list.
- The host app only registers the feature's routes and overrides its dependencies.
- This demo is an in-memory Notes feature at the go_router path `/notes`.

This lesson needs `flutter_riverpod` and `go_router`. Each lesson is its own project, so if they are not already in this folder's `pubspec.yaml`, add them:

```sh
flutter pub add flutter_riverpod go_router
```

## Code

The tip's snippet, verbatim:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// data/notes_repository.dart
class NotesRepository {
  final List<String> _notes = ['Buy milk', 'Write lesson', 'Call dentist'];
  List<String> all() => List.unmodifiable(_notes);
  void add(String note) => _notes.add(note);
}

// providers.dart
final notesRepositoryProvider =
    Provider<NotesRepository>((ref) => NotesRepository());

class NotesNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => ref.watch(notesRepositoryProvider).all();

  void add(String note) {
    final repo = ref.read(notesRepositoryProvider);
    repo.add(note);
    state = repo.all();
  }
}

final notesProvider =
    NotifierProvider<NotesNotifier, List<String>>(NotesNotifier.new);

// presentation/notes_list_screen.dart
class NotesListScreen extends ConsumerWidget {
  const NotesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Feature skeleton')),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Route: /notes'),
          ),
          for (final n in notes)
            Card(
              child: ListTile(
                leading: const Icon(Icons.note),
                title: Text(n),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            ref.read(notesProvider.notifier).add('Note ${notes.length + 1}'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// routes.dart
class NotesRoutes {
  static List<RouteBase> get routes => [
        GoRoute(
          path: '/notes',
          builder: (context, state) => const NotesListScreen(),
        ),
      ];
}

// host app: only registers routes
final router = GoRouter(
  initialLocation: '/notes',
  routes: [...NotesRoutes.routes],
);

void main() => runApp(
      ProviderScope(child: MaterialApp.router(routerConfig: router)),
    );
```

## On screen

A Material app whose AppBar says "Feature skeleton". Below it is the text "Route: /notes" and three cards, "Buy milk", "Write lesson" and "Call dentist", each with a note icon. Tapping the plus button at the bottom right adds "Note 4", "Note 5" and so on to the list.

## How it is adapted in this app

- This lesson is its own Flutter project. The snippet's `MaterialApp.router` stays, wrapped in `ProviderScope` and `LessonScope` so providers work and the info button can find these notes. `main()` is `void main() => runApp(lessonApp);`. A `Lesson61FeatureSkeleton` widget creates a fresh `GoRouter` on each mount so tests can open the app more than once, the same pattern as lessons 48–53.
- `NotesListScreen`'s AppBar keeps `title: const Text('Feature skeleton')` and gets `actions: const [LessonInfoButton(lessonId: 61)]`. `NotesRepository`, `NotesNotifier`, `NotesListScreen`, `NotesRoutes`, and the providers keep the snippet's names and behavior. The top-level `router` from the snippet is the per-mount `GoRouter` inside `Lesson61FeatureSkeleton`.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 61,
  title: 'Mini feature skeleton',
  notesAsset: '61-feature-skeleton.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
///
/// The project owns a nested `MaterialApp.router`, so the snippet's
/// `/notes` path stays inside this lesson. A [LessonScope] around it lets
/// the info button find the notes. Each mount builds its own [GoRouter] so
/// a test can open the app more than once.
const lessonApp = ProviderScope(
  child: LessonScope(lesson: lesson, child: Lesson61FeatureSkeleton()),
);

void main() => runApp(lessonApp);

// data/notes_repository.dart
class NotesRepository {
  final List<String> _notes = ['Buy milk', 'Write lesson', 'Call dentist'];
  List<String> all() => List.unmodifiable(_notes);
  void add(String note) => _notes.add(note);
}

// providers.dart
final notesRepositoryProvider = Provider<NotesRepository>(
  (ref) => NotesRepository(),
);

class NotesNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => ref.watch(notesRepositoryProvider).all();

  void add(String note) {
    final repo = ref.read(notesRepositoryProvider);
    repo.add(note);
    state = repo.all();
  }
}

final notesProvider = NotifierProvider<NotesNotifier, List<String>>(
  NotesNotifier.new,
);

// presentation/notes_list_screen.dart
class NotesListScreen extends ConsumerWidget {
  const NotesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feature skeleton'),
        actions: const [LessonInfoButton(lessonId: 61)],
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Route: /notes'),
          ),
          for (final n in notes)
            Card(
              child: ListTile(leading: const Icon(Icons.note), title: Text(n)),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            ref.read(notesProvider.notifier).add('Note ${notes.length + 1}'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// routes.dart
class NotesRoutes {
  static List<RouteBase> get routes => [
    GoRoute(
      path: '/notes',
      builder: (context, state) => const NotesListScreen(),
    ),
  ];
}

/// Lesson 61: a Notes feature registered by the host app.
///
/// The host only spreads [NotesRoutes.routes] into a [GoRouter]. A new
/// router is created on each mount so tests can open the app more than once.
class Lesson61FeatureSkeleton extends StatefulWidget {
  const Lesson61FeatureSkeleton({super.key});

  @override
  State<Lesson61FeatureSkeleton> createState() =>
      _Lesson61FeatureSkeletonState();
}

class _Lesson61FeatureSkeletonState extends State<Lesson61FeatureSkeleton> {
  late final GoRouter _router = GoRouter(
    initialLocation: '/notes',
    routes: [...NotesRoutes.routes],
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _router);
  }
}
```
