import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lesson_kit/lesson_kit.dart';

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
