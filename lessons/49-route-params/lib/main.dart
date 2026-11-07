import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:lesson_kit/lesson_kit.dart';

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
