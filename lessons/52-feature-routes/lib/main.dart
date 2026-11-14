import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:lesson_kit/lesson_kit.dart';

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
