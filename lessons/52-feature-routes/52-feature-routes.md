# Lesson 52: Composing feature routes

**Date:** Nov 10, 2026

In a big app, putting every route into one giant list gets messy fast. A tidier habit is to let each feature (Home, Orders, Account...) own its own routes. Each feature exposes a small `List<RouteBase> get routes`, and the app's router simply "spreads" them together with `...` into one `GoRouter`. Give each feature a path prefix, like `/orders`, so the paths never clash. A feature should never import another feature's screens; Home just navigates to `'/orders'` by its path string.

Why bother? Each feature can later move into its own package, and the only thing the app needs to know is "add these routes". This builds on go_router from lesson 48; if you skipped it, run `flutter pub add go_router`.

## Key points

- Each feature exposes `List<RouteBase> get routes`. The app router spreads them with `...` into one `GoRouter`.
- Give each feature a path prefix, like `/orders`, so the paths never clash.
- Features navigate to each other by path string and do not import another feature's screens.

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

// The app router only composes the features' route lists.
final GoRouter router = GoRouter(
  routes: [
    ...HomeRoutes.routes,
    ...OrdersRoutes.routes,
  ],
);

// Feature 1: Home
class HomeRoutes {
  static List<RouteBase> get routes => [
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      ];
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feature routes')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Home feature'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => context.go('/orders'), // by path, no import
              child: const Text('See orders'),
            ),
          ],
        ),
      ),
    );
  }
}

// Feature 2: Orders (all paths start with /orders)
class OrdersRoutes {
  static List<RouteBase> get routes => [
        GoRoute(
          path: '/orders',
          builder: (context, state) => const OrdersScreen(),
        ),
      ];
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feature routes')),
      body: Column(
        children: [
          const ListTile(title: Text('Order #1001')),
          const ListTile(title: Text('Order #1002')),
          const Text('Orders feature'),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => context.go('/'),
            child: const Text('Back home'),
          ),
        ],
      ),
    );
  }
}
```

## On screen

The app opens on the Home screen. The purple AppBar says "Feature routes", and in the middle you see the text "Home feature" with a "See orders" button. Tapping "See orders" goes to `/orders`, the Orders screen. It has the same "Feature routes" AppBar, two list rows ("Order #1001" and "Order #1002"), the text "Orders feature" and a "Back home" button. Tapping "Back home" returns to the Home screen.

## How it is adapted in this app

- This lesson is its own Flutter project, and it keeps the snippet's `MaterialApp.router`. `Lesson52FeatureRoutes` returns that nested router. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonScope` from the shared `lesson_kit` package around that widget, so the info button can find these notes. It does not use `LessonApp`, because the snippet's router is the app.
- The router is created when the lesson mounts and disposed with it, and it still spreads `...HomeRoutes.routes` and `...OrdersRoutes.routes`. `HomeRoutes`, `HomeScreen`, `OrdersRoutes`, and `OrdersScreen` keep the snippet's names and live in this lesson's `main.dart`. In a larger app those feature lists would sit in their own files or packages. `debugShowCheckedModeBanner` is false.
- Home is the first screen. Its AppBar keeps `title: const Text('Feature routes')` and gets `actions: const [LessonInfoButton(lessonId: 52)]`. The Orders screen keeps the snippet's AppBar and does not need the info button. Home still goes to `/orders` by path, and Orders still goes home with `context.go('/')`.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 52,
  title: 'Composing feature routes',
  notesAsset: '52-feature-routes.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonScope(lesson: lesson, child: Lesson52FeatureRoutes());

void main() => runApp(lessonApp);

/// Lesson 52: composing feature route lists.
///
/// The project owns a nested `MaterialApp.router`, so the snippet's paths
/// stay inside this lesson. A [LessonScope] around it (see `main.dart`) lets
/// the info button find the notes. Each mount builds its own [GoRouter] so
/// a test can open the app more than once.
class Lesson52FeatureRoutes extends StatefulWidget {
  const Lesson52FeatureRoutes({super.key});

  @override
  State<Lesson52FeatureRoutes> createState() => _Lesson52FeatureRoutesState();
}

class _Lesson52FeatureRoutesState extends State<Lesson52FeatureRoutes> {
  late final GoRouter _router = GoRouter(
    routes: [...HomeRoutes.routes, ...OrdersRoutes.routes],
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

// Feature 1: Home
class HomeRoutes {
  static List<RouteBase> get routes => [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
  ];
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feature routes'),
        actions: const [LessonInfoButton(lessonId: 52)],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Home feature'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => context.go('/orders'), // by path, no import
              child: const Text('See orders'),
            ),
          ],
        ),
      ),
    );
  }
}

// Feature 2: Orders (all paths start with /orders)
class OrdersRoutes {
  static List<RouteBase> get routes => [
    GoRoute(path: '/orders', builder: (context, state) => const OrdersScreen()),
  ];
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feature routes')),
      body: Column(
        children: [
          const ListTile(title: Text('Order #1001')),
          const ListTile(title: Text('Order #1002')),
          const Text('Orders feature'),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => context.go('/'),
            child: const Text('Back home'),
          ),
        ],
      ),
    );
  }
}
```
