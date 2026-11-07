# Lesson 49: Path and query parameters

**Date:** Nov 7, 2026

Yesterday every route was a fixed string. Real apps need to say *which* thing to open, and go_router lets the URL carry that data. Put a colon in the path, like `path: '/fruit/:name'`, and whatever sits in that slot arrives in the builder as `state.pathParameters['name']`. Extra, optional details ride in the query string after a `?`, so `context.push('/fruit/apple?color=red')` also hands you `state.uri.queryParameters['color']`. No constructor plumbing, and the same URL works from a button, a deep link, or the browser bar.

URLs come from outside your code, so treat them like user input. A path parameter can be a name you don't know, and a query parameter can be missing completely. Today's demo checks both: an unknown fruit shows a friendly "not found" screen, and a missing color just says "No color given". It reuses go_router from lesson 48, so if you skipped that one, run `flutter pub add go_router` first.

## Key points

- `path: '/fruit/:name'` puts the fruit name in `state.pathParameters['name']`.
- `?color=red` arrives as `state.uri.queryParameters['color']`.
- An unknown name shows Not found. Back to list calls `context.go('/')`.
- A missing color query shows "No color given".

This lesson reuses `go_router`. Each lesson is its own project, so if it is not already in this folder's `pubspec.yaml`, add it:

```sh
flutter pub add go_router
```

## Code

The tip's snippet, verbatim:

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MaterialApp.router(routerConfig: router));
}

const Map<String, String> fruitColors = {
  'apple': 'red',
  'banana': 'yellow',
  'grape': 'purple',
};

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const FruitListScreen(),
    ),
    GoRoute(
      path: '/fruit/:name',
      builder: (context, state) {
        final name = state.pathParameters['name']!;
        final color = state.uri.queryParameters['color'];
        if (!fruitColors.containsKey(name)) {
          return NotFoundScreen(name: name);
        }
        return FruitDetailScreen(name: name, color: color);
      },
    ),
  ],
);

class FruitListScreen extends StatelessWidget {
  const FruitListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Route params')),
      body: ListView(
        children: [
          for (final entry in fruitColors.entries)
            ListTile(
              leading: const Icon(Icons.eco),
              title: Text(entry.key),
              subtitle: Text('/fruit/${entry.key}?color=${entry.value}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () =>
                  context.push('/fruit/${entry.key}?color=${entry.value}'),
            ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('mango (no color)'),
            subtitle: const Text('/fruit/mango'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/fruit/mango'),
          ),
        ],
      ),
    );
  }
}

class FruitDetailScreen extends StatelessWidget {
  const FruitDetailScreen({super.key, required this.name, this.color});

  final String name;
  final String? color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(name, style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 8),
            Text(color == null ? 'No color given' : 'Color: $color'),
          ],
        ),
      ),
    );
  }
}

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Not found')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('No fruit called "$name"'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go('/'),
              child: const Text('Back to list'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## On screen

The first screen has the AppBar "Route params" over a list of four rows. Each row has a leaf icon, a fruit name, a small grey subtitle with the exact URL it opens (like `/fruit/apple?color=red`), and a chevron on the right. The last row is "mango (no color)" with a question-mark icon and the subtitle `/fruit/mango`. Tap "apple" and a detail screen slides in with the AppBar "apple", a large "apple" in the middle, and "Color: red" underneath. The back arrow returns to the list. Tap "mango" and you land on a "Not found" screen that says `No fruit called "mango"`, with a purple "Back to list" button that calls `context.go('/')`. Open `/fruit/banana` with no query and the detail screen shows "No color given". The mockup shows the list screen.

## How it is adapted in this app

- This lesson is its own Flutter project, and it keeps the snippet's `MaterialApp.router`. `Lesson49RouteParams` returns that nested router, with the same routes: `/` and `/fruit/:name`. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonScope` around that widget, so the info button can find these notes.
- `FruitListScreen` is renamed `Lesson49FruitList`, `FruitDetailScreen` is renamed `Lesson49FruitDetail`, and `NotFoundScreen` is renamed `Lesson49NotFound`. `fruitColors` keeps its name. The detail route still reads `state.pathParameters['name']` and `state.uri.queryParameters['color']`.
- The router is created when the lesson mounts and disposed with it, so each run starts at `/`. `debugShowCheckedModeBanner` is false, and the theme is the plain `MaterialApp` theme.
- The list AppBar keeps `title: const Text('Route params')` and gets `actions: const [LessonInfoButton(lessonId: 49)]`. It is the first route, so it has no back arrow. This project is the whole app, so there is no outer lessons list to pop. Unknown fruit (`mango`) shows Not found, and Back to list calls `context.go('/')`. A known fruit opened with no color query, such as `/fruit/banana`, shows "No color given". The back arrow on a pushed screen returns to the list as well.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 49,
  title: 'Path and query parameters',
  notesAsset: '49-route-params.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonScope(lesson: lesson, child: Lesson49RouteParams());

void main() => runApp(lessonApp);

const Map<String, String> fruitColors = {
  'apple': 'red',
  'banana': 'yellow',
  'grape': 'purple',
};

/// Lesson 49: path and query parameters.
///
/// The project owns a nested `MaterialApp.router` with `/` and
/// `/fruit/:name`. A [LessonScope] around it (see `main.dart`) lets the info
/// button find the notes. Each mount builds its own [GoRouter] so a test can
/// open the app more than once.
class Lesson49RouteParams extends StatefulWidget {
  const Lesson49RouteParams({super.key});

  @override
  State<Lesson49RouteParams> createState() => _Lesson49RouteParamsState();
}

class _Lesson49RouteParamsState extends State<Lesson49RouteParams> {
  late final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Lesson49FruitList(),
      ),
      GoRoute(
        path: '/fruit/:name',
        builder: (context, state) {
          final name = state.pathParameters['name']!;
          final color = state.uri.queryParameters['color'];
          if (!fruitColors.containsKey(name)) {
            return Lesson49NotFound(name: name);
          }
          return Lesson49FruitDetail(name: name, color: color);
        },
      ),
    ],
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}

class Lesson49FruitList extends StatelessWidget {
  const Lesson49FruitList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route params'),
        actions: const [LessonInfoButton(lessonId: 49)],
      ),
      body: ListView(
        children: [
          for (final entry in fruitColors.entries)
            ListTile(
              leading: const Icon(Icons.eco),
              title: Text(entry.key),
              subtitle: Text('/fruit/${entry.key}?color=${entry.value}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () =>
                  context.push('/fruit/${entry.key}?color=${entry.value}'),
            ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('mango (no color)'),
            subtitle: const Text('/fruit/mango'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/fruit/mango'),
          ),
        ],
      ),
    );
  }
}

class Lesson49FruitDetail extends StatelessWidget {
  const Lesson49FruitDetail({super.key, required this.name, this.color});

  final String name;
  final String? color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(name, style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 8),
            Text(color == null ? 'No color given' : 'Color: $color'),
          ],
        ),
      ),
    );
  }
}

class Lesson49NotFound extends StatelessWidget {
  const Lesson49NotFound({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Not found')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('No fruit called "$name"'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go('/'),
              child: const Text('Back to list'),
            ),
          ],
        ),
      ),
    );
  }
}
```
