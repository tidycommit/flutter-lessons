# Lesson 53: Deep links from URLs

**Date:** Nov 11, 2026

A deep link is just a URL that matches a route path. On a real phone the operating system hands your app the URL (for example `myapp://fruit/pear?color=green`), and go_router maps it to a screen using the very same path definitions you already use for in-app navigation. Query parameters still work, and a path that matches nothing can show a friendly error page through `errorBuilder` instead of crashing.

To keep this lesson simple we simulate the OS: a text field holds a URL, and the "Open link" button parses it and calls `context.go(uri.toString())`. Try `/fruit/pear?color=green`, then try a bad path like `/nope`. This builds on go_router from lesson 48; if you skipped it, run `flutter pub add go_router`.

## Key points

- The same path definitions serve in-app navigation and incoming URLs. Query parameters still work.
- A text field and "Open link" simulate the OS delivering a URL by calling `context.go`.
- Unknown paths use `errorBuilder` instead of crashing.

This lesson reuses `go_router`. Each lesson is its own project, so if it is not already in this folder's `pubspec.yaml`, add it:

```sh
flutter pub add go_router
```

## Code

The tip's snippet, verbatim:

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(MaterialApp.router(routerConfig: router));

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LinkBox()),
    GoRoute(
      path: '/fruit/:name',
      builder: (context, state) => FruitPage(
        name: state.pathParameters['name'] ?? '',
        color: state.uri.queryParameters['color'],
      ),
    ),
  ],
  // Unknown paths land here instead of crashing.
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Deep links')),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('No screen for ${state.uri.path}'),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => context.go('/'),
            child: const Text('Back home'),
          ),
        ],
      ),
    ),
  ),
);

class LinkBox extends StatefulWidget {
  const LinkBox({super.key});

  @override
  State<LinkBox> createState() => _LinkBoxState();
}

class _LinkBoxState extends State<LinkBox> {
  final _controller = TextEditingController(text: '/fruit/pear?color=green');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deep links')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Incoming link'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              // The OS would deliver this URL; we simulate it.
              onPressed: () =>
                  context.go(Uri.parse(_controller.text).toString()),
              child: const Text('Open link'),
            ),
          ],
        ),
      ),
    );
  }
}

class FruitPage extends StatelessWidget {
  const FruitPage({super.key, required this.name, this.color});

  final String name;
  final String? color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deep links')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Fruit: $name', style: const TextStyle(fontSize: 24)),
            Text('Color: ${color ?? 'No color given'}'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => context.go('/'),
              child: const Text('Back home'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## On screen

The app opens on a screen with a purple "Deep links" AppBar, a text field labelled "Incoming link" prefilled with `/fruit/pear?color=green`, and an "Open link" button. Tapping the button jumps to the fruit page: same AppBar, "Fruit: pear", "Color: green" and a "Back home" button. If you edit the link to something unknown like `/nope` and tap "Open link", the error page shows "No screen for /nope" with a "Back home" button. "Back home" always returns to the first screen.

## How it is adapted in this app

- This lesson is its own Flutter project, and it keeps the snippet's `MaterialApp.router`. `Lesson53DeepLinks` returns that nested router. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonScope` from the shared `lesson_kit` package around that widget, so the info button can find these notes. It does not use `LessonApp`, because the snippet's router is the app.
- The router is created when the lesson mounts and disposed with it. The routes, the `/fruit/:name` path and query parameters, and the `errorBuilder` are the snippet's. `debugShowCheckedModeBanner` is false.
- `LinkBox` is the first screen. Its AppBar keeps `title: const Text('Deep links')` and gets `actions: const [LessonInfoButton(lessonId: 53)]`. `FruitPage` and the error page keep the snippet's AppBars and do not need the info button. "Open link" still parses the field and calls `context.go`, and "Back home" still calls `context.go('/')`.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 53,
  title: 'Deep links from URLs',
  notesAsset: '53-deep-links.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonScope(lesson: lesson, child: Lesson53DeepLinks());

void main() => runApp(lessonApp);

/// Lesson 53: deep links from URLs.
///
/// The project owns a nested `MaterialApp.router`, so the snippet's paths
/// stay inside this lesson. A [LessonScope] around it (see `main.dart`) lets
/// the info button find the notes. Each mount builds its own [GoRouter] so
/// a test can open the app more than once.
class Lesson53DeepLinks extends StatefulWidget {
  const Lesson53DeepLinks({super.key});

  @override
  State<Lesson53DeepLinks> createState() => _Lesson53DeepLinksState();
}

class _Lesson53DeepLinksState extends State<Lesson53DeepLinks> {
  late final GoRouter _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LinkBox()),
      GoRoute(
        path: '/fruit/:name',
        builder: (context, state) => FruitPage(
          name: state.pathParameters['name'] ?? '',
          color: state.uri.queryParameters['color'],
        ),
      ),
    ],
    // Unknown paths land here instead of crashing.
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Deep links')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('No screen for ${state.uri.path}'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => context.go('/'),
              child: const Text('Back home'),
            ),
          ],
        ),
      ),
    ),
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

class LinkBox extends StatefulWidget {
  const LinkBox({super.key});

  @override
  State<LinkBox> createState() => _LinkBoxState();
}

class _LinkBoxState extends State<LinkBox> {
  final _controller = TextEditingController(text: '/fruit/pear?color=green');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deep links'),
        actions: const [LessonInfoButton(lessonId: 53)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Incoming link'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              // The OS would deliver this URL; we simulate it.
              onPressed: () =>
                  context.go(Uri.parse(_controller.text).toString()),
              child: const Text('Open link'),
            ),
          ],
        ),
      ),
    );
  }
}

class FruitPage extends StatelessWidget {
  const FruitPage({super.key, required this.name, this.color});

  final String name;
  final String? color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deep links')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Fruit: $name', style: const TextStyle(fontSize: 24)),
            Text('Color: ${color ?? 'No color given'}'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => context.go('/'),
              child: const Text('Back home'),
            ),
          ],
        ),
      ),
    );
  }
}
```
