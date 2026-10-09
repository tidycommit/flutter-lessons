import 'package:flutter/material.dart';

/// Lesson 03: A Scaffold with an AppBar, a body and a bottom bar.
class ScaffoldLesson extends StatelessWidget {
  const ScaffoldLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // The lesson screen already shows a back button.
        automaticallyImplyLeading: false,
        title: const Text('My page'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: const Center(child: Text('The body fills the space in between.')),
      bottomNavigationBar: const BottomAppBar(
        child: Center(child: Text('Bottom app bar')),
      ),
    );
  }
}
