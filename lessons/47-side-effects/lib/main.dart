import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 47,
  title: 'Side effects outside build',
  notesAsset: '47-side-effects.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
///
/// ProviderScope stores every provider's state. It must sit above any
/// widget that uses ref.
const lessonApp = ProviderScope(
  child: LessonApp(lesson: lesson, home: Lesson47SideEffects()),
);

void main() => runApp(lessonApp);

class ForceError extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}

class LoadStatus extends AsyncNotifier<String> {
  @override
  Future<String> build() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (ref.read(forceErrorProvider)) {
      throw 'Network down';
    }
    return 'Loaded OK';
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      if (ref.read(forceErrorProvider)) {
        throw 'Network down';
      }
      return 'Loaded OK';
    });
  }
}

final forceErrorProvider = NotifierProvider<ForceError, bool>(ForceError.new);
final loadStatusProvider = AsyncNotifierProvider<LoadStatus, String>(
  LoadStatus.new,
);

class Lesson47SideEffects extends ConsumerWidget {
  const Lesson47SideEffects({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Side effect beside build — not inside the tree construction.
    ref.listen<AsyncValue<String>>(loadStatusProvider, (prev, next) {
      next.whenOrNull(
        error: (err, _) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Error: $err')));
        },
      );
    });

    final status = ref.watch(loadStatusProvider);
    final forceError = ref.watch(forceErrorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Side effects'),
        actions: const [LessonInfoButton(lessonId: 47)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Force error'),
            value: forceError,
            onChanged: (v) => ref.read(forceErrorProvider.notifier).set(v),
          ),
          const SizedBox(height: 8),
          status.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text(
              'Failed: $e',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            data: (v) =>
                Text(v, style: Theme.of(context).textTheme.displaySmall),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => ref.read(loadStatusProvider.notifier).reload(),
            icon: const Icon(Icons.refresh),
            label: const Text('Reload'),
          ),
          const SizedBox(height: 16),
          // WRONG — never do this (left as a comment so it won't compile):
          // if (status.hasError) {
          //   showDialog(context: context, builder: ...); // side effect in build!
          // }
          Text(
            'Wrong (don’t): calling showDialog or showSnackBar '
            'directly inside build when status.hasError.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
