# Lesson 48: go_router paths

**Date:** Nov 6, 2026

Navigator 1.0 pushes widgets onto a stack by hand. `go_router` flips that: you declare path strings that map to page builders, then navigate with those paths. Wrap the app in `MaterialApp.router(routerConfig: router)` and build one `GoRouter` whose `routes` list holds `GoRoute` entries. From a widget you call `context.push('/details')` to add a page, `context.go('/details')` to replace the stack with that location, or `context.pop()` to go back. Paths stay readable in logs and deep links, and screens stop needing constructor plumbing just to open the next page.

Today's demo is the smallest useful router: `/` is Home with AppBar "go_router" and a filled button that `push`es `/details`. Details shows a short message and a back arrow that calls `context.pop()`. First time this series needs a new package — run `flutter pub add go_router` before you paste the snippet.

## Key points

- One `GoRouter` maps path strings to builders, and `MaterialApp.router(routerConfig: router)` uses it.
- `context.push` adds a page. `context.go` replaces the stack. `context.pop` goes back.
- The router is nested in this lesson so `/` and `/details` stay inside it.

Add the package in this folder before pasting the snippet:

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

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/details',
      builder: (context, state) => const DetailsScreen(),
    ),
  ],
);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('go_router')),
      body: Center(
        child: FilledButton(
          onPressed: () => context.push('/details'),
          child: const Text('Open details'),
        ),
      ),
    );
  }
}

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: const Center(
        child: Text('You pushed /details'),
      ),
    );
  }
}
```

## On screen

Home opens first. The AppBar reads "go_router", and the body is a centered purple "Open details" button on a white background. Tap it: the stack pushes Details — AppBar title "Details" with a back arrow, body text "You pushed /details". Tap the back arrow (or the system back gesture) and `context.pop()` returns you to Home. Using `context.go('/details')` instead would replace Home rather than stacking on top of it. The mockup shows the Home screen ready to open Details.

## How it is adapted in this app

- This lesson is its own Flutter project, and it keeps the snippet's `MaterialApp.router`. `Lesson48GoRouterBasics` returns that nested router. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonScope` from the shared `lesson_kit` package around that widget, so the info button can find these notes. It does not use `LessonApp`, because the snippet's router is the app.
- `HomeScreen` is renamed `Lesson48Home` and `DetailsScreen` is renamed `Lesson48Details`. The paths stay `/` and `/details`. Home still calls `context.push('/details')`, and Details still calls `context.pop()`.
- The router is created when the lesson mounts and disposed with it. A single global `GoRouter` would keep its stack the next time the app is pumped, so the first screen would not reliably be `/`. The routes themselves are the snippet's routes. `debugShowCheckedModeBanner` is false, and the theme is the plain `MaterialApp` theme, as the snippet has no `ThemeData`.
- Home's AppBar keeps `title: const Text('go_router')` and gets `actions: const [LessonInfoButton(lessonId: 48)]`. Home is the first route, so it has no back arrow. This project is the whole app, so there is no outer lessons list to pop; Details returns to Home with `context.pop()`, and system or browser back does the same.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 48,
  title: 'go_router paths',
  notesAsset: '48-go-router-basics.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonScope(lesson: lesson, child: Lesson48GoRouterBasics());

void main() => runApp(lessonApp);

/// Lesson 48: go_router paths and `GoRoute`.
///
/// The project owns a nested `MaterialApp.router`, so the snippet's paths
/// stay inside this lesson. A [LessonScope] around it (see `main.dart`) lets
/// the info button find the notes. Each mount builds its own [GoRouter] so
/// a test can open the app more than once.
class Lesson48GoRouterBasics extends StatefulWidget {
  const Lesson48GoRouterBasics({super.key});

  @override
  State<Lesson48GoRouterBasics> createState() => _Lesson48GoRouterBasicsState();
}

class _Lesson48GoRouterBasicsState extends State<Lesson48GoRouterBasics> {
  late final GoRouter _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const Lesson48Home()),
      GoRoute(
        path: '/details',
        builder: (context, state) => const Lesson48Details(),
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

class Lesson48Home extends StatelessWidget {
  const Lesson48Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('go_router'),
        actions: const [LessonInfoButton(lessonId: 48)],
      ),
      body: Center(
        child: FilledButton(
          onPressed: () => context.push('/details'),
          child: const Text('Open details'),
        ),
      ),
    );
  }
}

class Lesson48Details extends StatelessWidget {
  const Lesson48Details({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: const Center(child: Text('You pushed /details')),
    );
  }
}
```
