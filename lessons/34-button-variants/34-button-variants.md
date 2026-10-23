# Lesson 34: Shared button with variants

**Date:** Oct 23, 2026

This is lesson 4 of the design-system series: one shared button API (variants, not new widgets).

Instead of `PrimaryButton`, `SecondaryButton` and `DangerButton`, a design system ships one `AppButton` with a `variant`. Call sites just pick a variant; the styling lives in one `switch` inside `AppButton`.

`onPressed: null` still disables every variant: `FilledButton` greys itself out on its own. Icons are an optional `IconData?`, so "Save" with a checkmark and a plain "Cancel" are the same widget.

## Key points

- Use an `enum` for the variants.
- A `switch` inside the button maps each variant to its colors.
- `onPressed: null` means disabled, for every variant.
- The icon is optional (`IconData?`), not a separate widget.

No new packages today (no `flutter pub add` needed).

## Code

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: ButtonVariantsDemo()));

enum AppButtonVariant { primary, secondary, danger }

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
      AppButtonVariant.secondary =>
        (scheme.secondaryContainer, scheme.onSecondaryContainer),
      AppButtonVariant.danger => (scheme.error, scheme.onError),
    };
    final style = FilledButton.styleFrom(
      backgroundColor: bg,
      foregroundColor: fg,
      minimumSize: const Size(220, 48),
    );
    if (icon == null) {
      return FilledButton(onPressed: onPressed, style: style, child: Text(label));
    }
    return FilledButton.icon(
      onPressed: onPressed,
      style: style,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

class ButtonVariantsDemo extends StatefulWidget {
  const ButtonVariantsDemo({super.key});

  @override
  State<ButtonVariantsDemo> createState() => _ButtonVariantsDemoState();
}

class _ButtonVariantsDemoState extends State<ButtonVariantsDemo> {
  int _presses = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppButton')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Presses: $_presses',
                style: Theme.of(context).textTheme.headlineSmall),
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
```

## On screen

An AppBar titled "AppButton" above a centered "Presses: 0" and four pill buttons of the same size. "Save" (primary, with a checkmark) adds one to the counter. "Cancel" (light secondary) and "Delete" (red, with a trash icon) do nothing. "Disabled" is greyed out and can't be tapped.

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `Lesson34ButtonVariants`.
- `ButtonVariantsDemo` is renamed `Lesson34ButtonVariants`. `AppButton` and `AppButtonVariant` keep their names, because they are the idea being taught. Lesson 31 also has an `AppButton`; each lives only in its own lesson file and neither file imports the other, so they don't clash.
- The AppBar keeps `title: const Text('AppButton')` with default styling, and gets `actions: const [LessonInfoButton(lessonId: 34)]`, the button that opens these notes.
- `dart format` re-wraps a few long lines and two doc comments are added; the code is otherwise unchanged.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 34,
  title: 'Shared button with variants',
  notesAsset: '34-button-variants.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: Lesson34ButtonVariants());

void main() => runApp(lessonApp);

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
/// The snippet's own Scaffold is the app's home screen, exactly as written.
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
```
