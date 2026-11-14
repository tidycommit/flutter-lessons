import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:lesson_kit/lesson_kit.dart';

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
