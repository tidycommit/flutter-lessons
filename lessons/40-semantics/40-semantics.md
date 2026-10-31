# Lesson 40: Semantics and accessibility basics

**Date:** Oct 29, 2026

This is lesson 10 of the design-system series, and the last one: semantics and accessibility.

Some people use your app without looking at it. On iPhone, VoiceOver reads the screen out loud, and on Android, TalkBack does the same. They can only read what Flutter tells them, and Flutter builds that from "semantics": a label for each thing, plus what kind of thing it is (a button, an image, a selected item). Built-in widgets like `IconButton`, `ElevatedButton`, and `Checkbox` already fill this in. A bare `GestureDetector` wrapped around an `Icon` doesn't, so a screen reader may say nothing useful about it, and it won't even say "button".

The easy fixes are to use real buttons, and give icon buttons a `tooltip`, which doubles as the spoken label. For your own custom widgets, like a star rating built from icons, wrap them in `Semantics(label: ..., button: true, child: ...)` so each piece says what it is and what tapping it does. In this demo, the "Bad" heart is a silent `GestureDetector`, the "Good" heart is an `IconButton` with a tooltip, and the stars use `Semantics` so each one announces itself as a button. A short note under each one shows what the screen reader would say. On a real phone you can turn on VoiceOver or TalkBack in the system settings to hear the difference for yourself. No new packages are needed.

## Key points

- Built-in widgets such as `IconButton`, `ElevatedButton` and `Checkbox` already tell screen readers what they are; a bare `GestureDetector` around an `Icon` does not.
- Prefer real buttons, and give icon buttons a `tooltip`: it doubles as the spoken label.
- Wrap custom widgets in `Semantics(label: ..., button: true, child: ...)` so each piece says what it is and what tapping it does.
- Use `container: true` with a `label` and `value` to describe a group (here, the whole star rating).
- Check the result with VoiceOver (iOS) or TalkBack (Android) when you can.

No new packages today (no `flutter pub add` needed): `Semantics`, `IconButton` and `InkWell` are all in `package:flutter/material.dart`.

## Code

The tip's snippet, verbatim:

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: SemanticsDemo()));

class SemanticsDemo extends StatefulWidget {
  const SemanticsDemo({super.key});

  @override
  State<SemanticsDemo> createState() => _SemanticsDemoState();
}

class _SemanticsDemoState extends State<SemanticsDemo> {
  bool _badLiked = false;
  bool _goodLiked = false;
  int _rating = 3;

  @override
  Widget build(BuildContext context) {
    final heading = Theme.of(context).textTheme.titleMedium;
    return Scaffold(
      appBar: AppBar(title: const Text('Semantics')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Bad: no label', style: heading),
          Row(
            children: [
              // Tappable, but a screen reader gets no label and no "button".
              GestureDetector(
                onTap: () => setState(() => _badLiked = !_badLiked),
                child: Icon(
                  _badLiked ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Screen reader hears: nothing useful, '
                    'and no "button".'),
              ),
            ],
          ),
          const Divider(height: 32),
          Text('Good: labeled', style: heading),
          Row(
            children: [
              IconButton(
                tooltip:
                    _goodLiked ? 'Remove from favorites' : 'Add to favorites',
                iconSize: 32,
                onPressed: () => setState(() => _goodLiked = !_goodLiked),
                icon: Icon(
                  _goodLiked ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Hears: "Add to favorites, button."'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          StarRating(
            rating: _rating,
            onChanged: (value) => setState(() => _rating = value),
          ),
          const SizedBox(height: 8),
          Text('Hears: "Rating, $_rating out of 5 stars." '
              'Each star: "Rate 4 stars, button."'),
        ],
      ),
    );
  }
}

/// A custom widget made from icons, so it needs its own semantics.
class StarRating extends StatelessWidget {
  const StarRating({super.key, required this.rating, required this.onChanged});

  final int rating;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'Rating',
      value: '$rating out of 5 stars',
      child: Row(
        children: [
          for (var i = 1; i <= 5; i++)
            Semantics(
              button: true,
              selected: i <= rating,
              label: 'Rate $i ${i == 1 ? 'star' : 'stars'}',
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => onChanged(i),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    i <= rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 36,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
```

## On screen

The AppBar reads "Semantics". Under a "Bad: no label" heading sits an outlined red heart next to the note "Screen reader hears: nothing useful, and no "button"." Tapping the heart fills it in, but with no ripple. A thin divider follows, then a "Good: labeled" heading with another outlined red heart, this time a real button, next to "Hears: "Add to favorites, button."" Tapping it shows a round ripple and fills the heart, and long-pressing it shows an "Add to favorites" tooltip. Below that is a row of five stars with the first three filled in amber, and under it the line "Hears: "Rating, 3 out of 5 stars." Each star: "Rate 4 stars, button."" Tapping any star fills the stars up to that one, and the number in the note changes to match.

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `Lesson40Semantics`.
- `SemanticsDemo` is renamed `Lesson40Semantics` (its state class follows). `StarRating` keeps its name, because it is the idea being taught.
- The AppBar keeps `title: const Text('Semantics')` with default styling, and gets `actions: const [LessonInfoButton(lessonId: 40)]`, the button that opens these notes.
- The snippet compiles as written, so the code is otherwise unchanged (only `dart format` line wrapping).

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 40,
  title: 'Semantics and accessibility basics',
  notesAsset: '40-semantics.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: Lesson40Semantics());

void main() => runApp(lessonApp);

class Lesson40Semantics extends StatefulWidget {
  const Lesson40Semantics({super.key});

  @override
  State<Lesson40Semantics> createState() => _Lesson40SemanticsState();
}

class _Lesson40SemanticsState extends State<Lesson40Semantics> {
  bool _badLiked = false;
  bool _goodLiked = false;
  int _rating = 3;

  @override
  Widget build(BuildContext context) {
    final heading = Theme.of(context).textTheme.titleMedium;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semantics'),
        actions: const [LessonInfoButton(lessonId: 40)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Bad: no label', style: heading),
          Row(
            children: [
              // Tappable, but a screen reader gets no label and no "button".
              GestureDetector(
                onTap: () => setState(() => _badLiked = !_badLiked),
                child: Icon(
                  _badLiked ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Screen reader hears: nothing useful, '
                  'and no "button".',
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          Text('Good: labeled', style: heading),
          Row(
            children: [
              IconButton(
                tooltip: _goodLiked
                    ? 'Remove from favorites'
                    : 'Add to favorites',
                iconSize: 32,
                onPressed: () => setState(() => _goodLiked = !_goodLiked),
                icon: Icon(
                  _goodLiked ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(child: Text('Hears: "Add to favorites, button."')),
            ],
          ),
          const SizedBox(height: 16),
          StarRating(
            rating: _rating,
            onChanged: (value) => setState(() => _rating = value),
          ),
          const SizedBox(height: 8),
          Text(
            'Hears: "Rating, $_rating out of 5 stars." '
            'Each star: "Rate 4 stars, button."',
          ),
        ],
      ),
    );
  }
}

/// A custom widget made from icons, so it needs its own semantics.
class StarRating extends StatelessWidget {
  const StarRating({super.key, required this.rating, required this.onChanged});

  final int rating;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'Rating',
      value: '$rating out of 5 stars',
      child: Row(
        children: [
          for (var i = 1; i <= 5; i++)
            Semantics(
              button: true,
              selected: i <= rating,
              label: 'Rate $i ${i == 1 ? 'star' : 'stars'}',
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => onChanged(i),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    i <= rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 36,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
```
