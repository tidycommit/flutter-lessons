# Lesson 20: CircleAvatar

**Date:** Oct 9, 2026

`CircleAvatar` draws a circle, usually for a user's picture or initials. `radius` sets its size (48 gives a 96 px circle), `backgroundColor` fills it, and `child` is drawn in the middle, often a short `Text`.

For a photo, set `backgroundImage` to an `ImageProvider` such as `NetworkImage` and leave `child` empty, or keep initials as a fallback while the image loads. The initials 'AB' here are just a placeholder.

## Key points

- `radius: 48` means a diameter of 96 logical pixels.
- Keep initials to one or two characters so they fit.
- Use `foregroundImage` to show a photo over fallback initials.

## Example

This is the runnable example in `lib/lessons/20_circle_avatar.dart`:

```dart
class CircleAvatarLesson extends StatelessWidget {
  const CircleAvatarLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircleAvatar(
        radius: 48,
        backgroundColor: Colors.teal,
        // Placeholder initials; swap in a real user's initials or a
        // backgroundImage in an app.
        child: Text('AB', style: TextStyle(fontSize: 32, color: Colors.white)),
      ),
    );
  }
}
```
