import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lesson_kit/lesson_kit.dart';

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
