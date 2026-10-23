import 'package:flutter/material.dart';

import '../widgets/lesson_info_button.dart';

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
/// The snippet's own Scaffold is the pushed lesson route, so the AppBar
/// shows the back arrow to the lesson list automatically.
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
