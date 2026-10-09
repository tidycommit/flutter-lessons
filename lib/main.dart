import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const FlutterLessonsApp());
}

/// Root widget of the lessons app.
class FlutterLessonsApp extends StatelessWidget {
  const FlutterLessonsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Lessons',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const HomeScreen(),
    );
  }
}
