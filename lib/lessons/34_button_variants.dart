import 'package:flutter/material.dart';

import '../widgets/lesson_info_button.dart';

/// The button variants the design system offers.
enum AppButtonVariant { primary, secondary, danger }

/// One shared button; call sites pick a [variant]. Lesson-local: lesson 31
/// has its own, simpler `AppButton`, and neither file imports the other.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed; // null = disabled
  final AppButtonVariant variant;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (Color bg, Color fg) = switch (variant) {
      AppButtonVariant.primary => (scheme.primary, scheme.onPrimary),
      AppButtonVariant.secondary => (
        scheme.secondaryContainer,
        scheme.onSecondaryContainer,
      ),
      AppButtonVariant.danger => (scheme.error, scheme.onError),
    };
    final style = FilledButton.styleFrom(
      backgroundColor: bg,
      foregroundColor: fg,
      minimumSize: const Size(220, 48),
    );
    if (icon == null) {
      return FilledButton(
        onPressed: onPressed,
        style: style,
        child: Text(label),
      );
    }
    return FilledButton.icon(
      onPressed: onPressed,
      style: style,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

/// Lesson 34: One shared button API (variants, not new widgets).
///
/// The snippet's own Scaffold is the pushed lesson route, so the AppBar
/// shows the back arrow to the lesson list automatically.
class Lesson34ButtonVariants extends StatefulWidget {
  const Lesson34ButtonVariants({super.key});

  @override
  State<Lesson34ButtonVariants> createState() => _Lesson34ButtonVariantsState();
}

class _Lesson34ButtonVariantsState extends State<Lesson34ButtonVariants> {
  int _presses = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppButton'),
        actions: const [LessonInfoButton(lessonId: 34)],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Presses: $_presses',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Save',
              icon: Icons.check,
              onPressed: () => setState(() => _presses++),
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'Cancel',
              variant: AppButtonVariant.secondary,
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'Delete',
              icon: Icons.delete,
              variant: AppButtonVariant.danger,
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            const AppButton(label: 'Disabled', onPressed: null),
          ],
        ),
      ),
    );
  }
}
