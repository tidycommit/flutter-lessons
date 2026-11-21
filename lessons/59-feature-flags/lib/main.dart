import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lesson_kit/lesson_kit.dart';

/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 59,
  title: 'Feature flags in the UI',
  notesAsset: '59-feature-flags.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = ProviderScope(
  child: LessonApp(lesson: lesson, home: FlagsPage()),
);

void main() => runApp(lessonApp);

class FeatureFlags {
  const FeatureFlags({this.newBadge = false});
  final bool newBadge; // safe default: off

  FeatureFlags copyWith({bool? newBadge}) =>
      FeatureFlags(newBadge: newBadge ?? this.newBadge);
}

class FeatureFlagsNotifier extends Notifier<FeatureFlags> {
  @override
  FeatureFlags build() => const FeatureFlags();

  void setNewBadge(bool value) => state = state.copyWith(newBadge: value);
}

final featureFlagsProvider =
    NotifierProvider<FeatureFlagsNotifier, FeatureFlags>(
      FeatureFlagsNotifier.new,
    );

class FlagsPage extends ConsumerWidget {
  const FlagsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flags = ref.watch(featureFlagsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feature flags'),
        actions: const [LessonInfoButton(lessonId: 59)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Enable New Badge'),
            value: flags.newBadge,
            onChanged: (v) =>
                ref.read(featureFlagsProvider.notifier).setNewBadge(v),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              title: const Text('Trail Backpack'),
              subtitle: const Text('\$59.00'),
              trailing: flags.newBadge ? const Chip(label: Text('NEW')) : null,
            ),
          ),
        ],
      ),
    );
  }
}
