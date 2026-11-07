# Lesson 45: Provider overrides

**Date:** Nov 3, 2026

So far each provider has said exactly where its data comes from. In a bigger app that's a problem: you don't want a demo or a test hitting the real server. The fix is to make the provider depend on an abstract interface, here a `TodoRepository` with one method, `fetchTodos()`, and let something higher up decide which real class sits behind it. That "something" is `ProviderScope(overrides: [...])`. Whatever you list there replaces the provider's implementation for everything underneath. Production code overrides it with the real repository, a demo or a test overrides it with a fake, and the UI never knows the difference because it never builds the API client itself.

In today's demo, the default `todoRepositoryProvider` just throws "Override me", so forgetting the override fails loudly instead of silently. Two buttons, "Use fake A" and "Use fake B", pick which fake to inject. The `ProviderScope` gets a `ValueKey` tied to that choice, so switching throws away the old scope and builds a new one with the other override, and the list reloads with different content. No new packages today, since `flutter_riverpod` was added in lesson 41.

## Key points

- Override a provider on the nearest `ProviderScope`.
- The UI and the todos provider depend on the `TodoRepository` interface, not on a concrete client.
- The default provider throws `UnimplementedError('Override me')` so a missing override fails loudly.
- A `ValueKey` on the scope throws the old scope away when the fake changes.

The tip says no new packages are needed because lesson 41 added `flutter_riverpod`. Each lesson here is its own project, so this one adds it to its own `pubspec.yaml` too:

```sh
flutter pub add flutter_riverpod
```

## Code

The tip's snippet, verbatim:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() => runApp(const MaterialApp(home: OverridesLesson()));

// The UI and providers only know about this interface.
abstract class TodoRepository {
  Future<List<String>> fetchTodos();
}

class FakeTodoRepository implements TodoRepository {
  @override
  Future<List<String>> fetchTodos() async =>
      ['Buy milk', 'Walk the dog', 'Read a chapter'];
}

class AltFakeTodoRepository implements TodoRepository {
  @override
  Future<List<String>> fetchTodos() async =>
      ['Fix login bug', 'Write tests', 'Ship release'];
}

// No real default: whoever uses it must override it.
final todoRepositoryProvider = Provider<TodoRepository>(
  (ref) => throw UnimplementedError('Override me'),
);

final todosProvider = FutureProvider<List<String>>(
  (ref) => ref.watch(todoRepositoryProvider).fetchTodos(),
);

class OverridesLesson extends StatefulWidget {
  const OverridesLesson({super.key});

  @override
  State<OverridesLesson> createState() => _OverridesLessonState();
}

class _OverridesLessonState extends State<OverridesLesson> {
  bool useA = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Overrides')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: useA ? null : () => setState(() => useA = true),
                    child: const Text('Use fake A'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: useA ? () => setState(() => useA = false) : null,
                    child: const Text('Use fake B'),
                  ),
                ),
              ],
            ),
          ),
          Text('Using: ${useA ? 'FakeTodoRepository' : 'AltFakeTodoRepository'}'),
          const Divider(),
          Expanded(
            // A new key means a fresh scope with the new override.
            child: ProviderScope(
              key: ValueKey(useA),
              overrides: [
                todoRepositoryProvider.overrideWithValue(
                  useA ? FakeTodoRepository() : AltFakeTodoRepository(),
                ),
              ],
              child: const TodoList(),
            ),
          ),
        ],
      ),
    );
  }
}

class TodoList extends ConsumerWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(todosProvider).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
          data: (todos) => ListView(
            children: [
              for (final todo in todos)
                ListTile(
                  leading: const Icon(Icons.check_box_outline_blank),
                  title: Text(todo),
                ),
            ],
          ),
        );
  }
}
```

## On screen

The AppBar reads "Overrides". Below it sit two buttons side by side, "Use fake A" and "Use fake B"; the one already in use is greyed out, so at the start "Use fake A" is grey and "Use fake B" is purple. Under them a line says "Using: FakeTodoRepository", then a divider and a list of three rows with empty checkbox icons: "Buy milk", "Walk the dog", and "Read a chapter". Tap "Use fake B" and the line changes to "Using: AltFakeTodoRepository" while the list becomes "Fix login bug", "Write tests", and "Ship release"; the buttons swap which one is grey. The mockup shows the starting state with fake A.

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package, whose `home` is `Lesson45ProviderOverrides`. That replaces the snippet's `MaterialApp(home: OverridesLesson())`.
- The `ProviderScope` with `overrides` stays inside the screen, as in the snippet. It is not wrapped around the whole app, because the lesson is the swap between two overrides. Its `key: ValueKey(useA)` is unchanged.
- `OverridesLesson` is renamed `Lesson45ProviderOverrides`. `TodoRepository`, `FakeTodoRepository`, `AltFakeTodoRepository`, `todoRepositoryProvider`, `todosProvider` and `TodoList` keep their names.
- The AppBar keeps `title: const Text('Overrides')` with default styling, and gets `actions: const [LessonInfoButton(lessonId: 45)]`, the button that opens these notes.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 45,
  title: 'Provider overrides',
  notesAsset: '45-provider-overrides.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
///
/// The snippet's `MaterialApp` is this project's [LessonApp]. The
/// `ProviderScope` that injects a repository lives inside the screen, not
/// around the app, because the override is what the lesson swaps.
const lessonApp = LessonApp(lesson: lesson, home: Lesson45ProviderOverrides());

void main() => runApp(lessonApp);

// The UI and providers only know about this interface.
abstract class TodoRepository {
  Future<List<String>> fetchTodos();
}

class FakeTodoRepository implements TodoRepository {
  @override
  Future<List<String>> fetchTodos() async => [
    'Buy milk',
    'Walk the dog',
    'Read a chapter',
  ];
}

class AltFakeTodoRepository implements TodoRepository {
  @override
  Future<List<String>> fetchTodos() async => [
    'Fix login bug',
    'Write tests',
    'Ship release',
  ];
}

// No real default: whoever uses it must override it.
final todoRepositoryProvider = Provider<TodoRepository>(
  (ref) => throw UnimplementedError('Override me'),
);

final todosProvider = FutureProvider<List<String>>(
  (ref) => ref.watch(todoRepositoryProvider).fetchTodos(),
);

class Lesson45ProviderOverrides extends StatefulWidget {
  const Lesson45ProviderOverrides({super.key});

  @override
  State<Lesson45ProviderOverrides> createState() =>
      _Lesson45ProviderOverridesState();
}

class _Lesson45ProviderOverridesState extends State<Lesson45ProviderOverrides> {
  bool useA = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overrides'),
        actions: const [LessonInfoButton(lessonId: 45)],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: useA ? null : () => setState(() => useA = true),
                    child: const Text('Use fake A'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: useA ? () => setState(() => useA = false) : null,
                    child: const Text('Use fake B'),
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Using: ${useA ? 'FakeTodoRepository' : 'AltFakeTodoRepository'}',
          ),
          const Divider(),
          Expanded(
            // A new key means a fresh scope with the new override.
            child: ProviderScope(
              key: ValueKey(useA),
              overrides: [
                todoRepositoryProvider.overrideWithValue(
                  useA ? FakeTodoRepository() : AltFakeTodoRepository(),
                ),
              ],
              child: const TodoList(),
            ),
          ),
        ],
      ),
    );
  }
}

class TodoList extends ConsumerWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(todosProvider)
        .when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
          data: (todos) => ListView(
            children: [
              for (final todo in todos)
                ListTile(
                  leading: const Icon(Icons.check_box_outline_blank),
                  title: Text(todo),
                ),
            ],
          ),
        );
  }
}
```
