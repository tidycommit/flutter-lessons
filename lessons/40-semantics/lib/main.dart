import 'package:flutter/material.dart';

import 'package:lesson_kit/lesson_kit.dart';

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
