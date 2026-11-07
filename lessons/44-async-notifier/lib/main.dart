import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 44,
  title: 'AsyncNotifier loading and error',
  notesAsset: '44-async-notifier.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
///
/// ProviderScope stores every provider's state. It must sit above any
/// widget that uses ref. `retry` returns null so a failed load stays on
/// screen instead of retrying itself.
final lessonApp = ProviderScope(
  // Turn off automatic retries so the error state stays visible.
  retry: (retryCount, error) => null,
  child: const LessonApp(lesson: lesson, home: Lesson44AsyncNotifier()),
);

void main() => runApp(lessonApp);

// A simple on/off switch that the fake request checks.
class ForceError extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}

final forceErrorProvider = NotifierProvider<ForceError, bool>(ForceError.new);

class FakeItems extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async {
    // Pretend this is a network call.
    await Future<void>.delayed(const Duration(seconds: 1));
    if (ref.read(forceErrorProvider)) {
      throw Exception('Network down');
    }
    return ['Alpha', 'Bravo', 'Charlie'];
  }
}

final fakeItemsProvider = AsyncNotifierProvider<FakeItems, List<String>>(
  FakeItems.new,
);

class Lesson44AsyncNotifier extends ConsumerWidget {
  const Lesson44AsyncNotifier({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(fakeItemsProvider);
    final forceError = ref.watch(forceErrorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AsyncNotifier'),
        actions: [
          IconButton(
            tooltip: 'Reload',
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(fakeItemsProvider),
          ),
          const LessonInfoButton(lessonId: 44),
        ],
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Force error'),
            subtitle: const Text('Applies on the next load'),
            value: forceError,
            onChanged: (value) =>
                ref.read(forceErrorProvider.notifier).set(value),
          ),
          const Divider(height: 1),
          Expanded(
            // One builder per state: nothing gets ignored.
            child: items.when(
              skipLoadingOnRefresh: false,
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off, size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    Text(
                      'Something went wrong:\n$error',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => ref.invalidate(fakeItemsProvider),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (list) => ListView(
                children: [
                  for (final name in list)
                    ListTile(
                      leading: const Icon(Icons.label_outline),
                      title: Text(name),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
