# Lesson 33: Design tokens instead of magic numbers

**Date:** Oct 22, 2026

This is lesson 3 of the design-system series.

A design token is just a named constant for a value your whole app shares, like a spacing size, a corner radius, or the brand color. Instead of typing `EdgeInsets.all(13)` in one place and `EdgeInsets.all(16)` in another, every widget uses `AppTokens.spaceMd`. Tokens are the bridge between a design file and your code: the designer says "medium spacing" and the code says `spaceMd`, so they stay in sync.

The big win is that one change ripples everywhere. Update `radiusMd` from 12 to 16 and every card, field, and button that uses it updates at once. In this demo the "Emphasize brand" button swaps which brand token is used, and the filled card, the outlined card, and the button all change color together, because none of them hard-codes a color. No new packages are needed.

## Key points

- Group tokens in one class with `static const` fields.
- Widgets read tokens, never raw numbers or colors for shared spacing, radius, or color.
- Changing one token updates every widget that uses it.

No new packages today (no `flutter pub add` needed).

## Code

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: TokensDemo()));

abstract final class AppTokens {
  static const double spaceSm = 8;
  static const double spaceMd = 16;
  static const double spaceLg = 24;
  static const double radiusMd = 12;
  static const Color colorBrand = Color(0xFF0B5FFF);
  static const Color colorBrandStrong = Color(0xFF0033AA);
}

class TokensDemo extends StatefulWidget {
  const TokensDemo({super.key});

  @override
  State<TokensDemo> createState() => _TokensDemoState();
}

class _TokensDemoState extends State<TokensDemo> {
  bool _emphasize = false;

  @override
  Widget build(BuildContext context) {
    final brand =
        _emphasize ? AppTokens.colorBrandStrong : AppTokens.colorBrand;
    return Scaffold(
      appBar: AppBar(title: const Text('Tokens')),
      body: Padding(
        padding: const EdgeInsets.all(AppTokens.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(AppTokens.spaceMd),
              decoration: BoxDecoration(
                color: brand,
                borderRadius: BorderRadius.circular(AppTokens.radiusMd),
              ),
              child: const Text(
                'Brand card',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(height: AppTokens.spaceMd),
            Container(
              padding: const EdgeInsets.all(AppTokens.spaceMd),
              decoration: BoxDecoration(
                border: Border.all(color: brand, width: 2),
                borderRadius: BorderRadius.circular(AppTokens.radiusMd),
              ),
              child: Text(
                'Same tokens, outlined',
                style: TextStyle(color: brand, fontSize: 18),
              ),
            ),
            const SizedBox(height: AppTokens.spaceSm),
            const Text('Spacing: 8 / 16 / 24, radius: 12'),
            const SizedBox(height: AppTokens.spaceLg),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: brand),
              onPressed: () => setState(() => _emphasize = !_emphasize),
              child: Text(_emphasize ? 'Use normal brand' : 'Emphasize brand'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## On screen

The AppBar says "Tokens". Below it, with 24-pixel padding all around, is a bright blue "Brand card" with white text and rounded corners, then a white card with a blue outline reading "Same tokens, outlined", then a small line "Spacing: 8 / 16 / 24, radius: 12", and a blue "Emphasize brand" button. Tapping the button turns the card, the outline, its text, and the button a deeper navy all at once, and the label changes to "Use normal brand". Tapping again switches everything back to bright blue.

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `Lesson33Tokens`.
- `TokensDemo` is renamed `Lesson33Tokens`. `AppTokens` keeps its name, because it is the idea being taught; it lives only in this lesson's file.
- The AppBar keeps `title: const Text('Tokens')` with default styling, and gets `actions: const [LessonInfoButton(lessonId: 33)]`, the button that opens these notes.
- `dart format` wraps the `brand` conditional differently; the code is otherwise unchanged.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 33,
  title: 'Design tokens instead of magic numbers',
  notesAsset: '33-design-tokens.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: Lesson33Tokens());

void main() => runApp(lessonApp);

abstract final class AppTokens {
  static const double spaceSm = 8;
  static const double spaceMd = 16;
  static const double spaceLg = 24;
  static const double radiusMd = 12;
  static const Color colorBrand = Color(0xFF0B5FFF);
  static const Color colorBrandStrong = Color(0xFF0033AA);
}

/// Lesson 33: Design tokens instead of magic numbers.
///
/// The snippet's own Scaffold is the app's home screen, exactly as written.
class Lesson33Tokens extends StatefulWidget {
  const Lesson33Tokens({super.key});

  @override
  State<Lesson33Tokens> createState() => _Lesson33TokensState();
}

class _Lesson33TokensState extends State<Lesson33Tokens> {
  bool _emphasize = false;

  @override
  Widget build(BuildContext context) {
    final brand = _emphasize
        ? AppTokens.colorBrandStrong
        : AppTokens.colorBrand;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tokens'),
        actions: const [LessonInfoButton(lessonId: 33)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTokens.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(AppTokens.spaceMd),
              decoration: BoxDecoration(
                color: brand,
                borderRadius: BorderRadius.circular(AppTokens.radiusMd),
              ),
              child: const Text(
                'Brand card',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(height: AppTokens.spaceMd),
            Container(
              padding: const EdgeInsets.all(AppTokens.spaceMd),
              decoration: BoxDecoration(
                border: Border.all(color: brand, width: 2),
                borderRadius: BorderRadius.circular(AppTokens.radiusMd),
              ),
              child: Text(
                'Same tokens, outlined',
                style: TextStyle(color: brand, fontSize: 18),
              ),
            ),
            const SizedBox(height: AppTokens.spaceSm),
            const Text('Spacing: 8 / 16 / 24, radius: 12'),
            const SizedBox(height: AppTokens.spaceLg),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: brand),
              onPressed: () => setState(() => _emphasize = !_emphasize),
              child: Text(_emphasize ? 'Use normal brand' : 'Emphasize brand'),
            ),
          ],
        ),
      ),
    );
  }
}
```
