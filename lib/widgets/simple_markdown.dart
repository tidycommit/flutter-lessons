import 'package:flutter/material.dart';

/// A tiny markdown renderer, enough for the lesson files: `#`/`##`/`###`
/// headings, `-` bullets, fenced code blocks, paragraphs, and inline
/// `code` and **bold** spans. Anything else is shown as plain text.
class SimpleMarkdown extends StatelessWidget {
  const SimpleMarkdown({super.key, required this.data});

  final String data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final children = <Widget>[];
    final paragraph = <String>[];
    final code = <String>[];
    var inCode = false;

    void flushParagraph() {
      if (paragraph.isEmpty) return;
      children.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text.rich(_inline(paragraph.join(' '), theme)),
        ),
      );
      paragraph.clear();
    }

    for (final line in data.split('\n')) {
      if (line.trimLeft().startsWith('```')) {
        if (inCode) {
          children.add(_codeBlock(code.join('\n'), theme));
          code.clear();
        } else {
          flushParagraph();
        }
        inCode = !inCode;
        continue;
      }
      if (inCode) {
        code.add(line);
        continue;
      }
      final trimmed = line.trim();
      if (trimmed.isEmpty) {
        flushParagraph();
      } else if (trimmed.startsWith('#')) {
        flushParagraph();
        final level = trimmed.indexOf(' ');
        final text = trimmed.substring(level + 1);
        final style = switch (level) {
          1 => theme.textTheme.headlineSmall,
          2 => theme.textTheme.titleLarge,
          _ => theme.textTheme.titleMedium,
        };
        children.add(
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text(text, style: style),
          ),
        );
      } else if (trimmed.startsWith('- ')) {
        flushParagraph();
        children.add(
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 4),
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: '•  '),
                  _inline(trimmed.substring(2), theme),
                ],
              ),
            ),
          ),
        );
      } else {
        paragraph.add(trimmed);
      }
    }
    if (inCode) children.add(_codeBlock(code.join('\n'), theme));
    flushParagraph();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  Widget _codeBlock(String source, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          source,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
        ),
      ),
    );
  }

  /// Splits text on backticks and `**` markers into styled spans.
  TextSpan _inline(String text, ThemeData theme) {
    final spans = <InlineSpan>[];
    final pattern = RegExp(r'`([^`]+)`|\*\*([^*]+)\*\*');
    var start = 0;
    for (final match in pattern.allMatches(text)) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }
      if (match.group(1) != null) {
        spans.add(
          TextSpan(
            text: match.group(1),
            style: TextStyle(
              fontFamily: 'monospace',
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            ),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: match.group(2),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      }
      start = match.end;
    }
    if (start < text.length) spans.add(TextSpan(text: text.substring(start)));
    return TextSpan(children: spans);
  }
}
