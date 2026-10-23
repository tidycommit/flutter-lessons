# Lesson 15: Card with ListTile

**Date:** Oct 4, 2026

`Card` is a Material surface with rounded corners and a subtle elevation, used to group related information. It has no layout of its own; it simply wraps one child.

Putting a `ListTile` inside a `Card` is a quick way to build a contact or summary card: the tile handles the icon, title and subtitle layout, and the card gives it a background and edge. Change the look with `elevation`, `color`, `margin` and `shape`.

## Key points

- A `Card` takes a single `child`.
- `ListTile` inside a `Card` gives tidy spacing for free.
- Wrap the card content in `InkWell` or use `ListTile.onTap` to make it tappable.

## Code

Original snippet as taught. The teacher gave the AppBar title 'Cards' and this body:

```dart
Padding(
  padding: const EdgeInsets.all(16),
  child: Card(
    child: ListTile(
      leading: Icon(Icons.person),
      title: Text('Ada Lovelace'),
      subtitle: Text('Mathematician'),
    ),
  ),
)
```

## How it is adapted in this app

- This lesson is its own Flutter project. `main()` is `void main() => runApp(lessonApp);`, and `lessonApp` is a `LessonApp` from the shared `lesson_kit` package: a `MaterialApp` with the shared theme and the lesson heading as its title, whose `home` is `CardLesson`.
- The snippet's `Scaffold` is returned from the `build` method of `CardLesson`, a `StatelessWidget`.
- The AppBar titled Cards and the body above are put together in that `Scaffold`.
- The AppBar gets `actions: const [LessonInfoButton(lessonId: 15)]`, the button that opens these notes.
- `const` is added where the analyzer asks for it, and the code is run through `dart format`. Nothing else changes.

## Example

This is the runnable example in `lib/main.dart`. Run it with `flutter run` in this folder:

```dart
/// This lesson, as the info button and the notes heading see it.
const lesson = LessonInfo(
  id: 15,
  title: 'Card with ListTile',
  notesAsset: '15-card.md',
);

/// The whole lesson app; `main` runs it and the tests pump it.
const lessonApp = LessonApp(lesson: lesson, home: CardLesson());

void main() => runApp(lessonApp);

/// Lesson 15: A Card holding a ListTile with a person icon, name and role.
class CardLesson extends StatelessWidget {
  const CardLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cards'),
        actions: const [LessonInfoButton(lessonId: 15)],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text('Ada Lovelace'),
            subtitle: Text('Mathematician'),
          ),
        ),
      ),
    );
  }
}
```
