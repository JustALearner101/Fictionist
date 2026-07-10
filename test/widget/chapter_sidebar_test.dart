import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fictionist/presentation/features/manuscript/widget/chapter_sidebar.dart';
import 'package:fictionist/domain/manuscript/manuscript_chapter.dart';

void main() {
  final testChapters = [
    ManuscriptChapter(id: '1', title: 'Chapter One', content: 'hello world', createdAt: DateTime.now(), updatedAt: DateTime.now()),
    ManuscriptChapter(id: '2', title: 'Chapter Two', content: 'foo bar baz qux', createdAt: DateTime.now(), updatedAt: DateTime.now()),
  ];

  testWidgets('renders chapter list with titles and word counts', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ChapterSidebar(
              chapters: testChapters,
              selectedChapterId: '1',
              onChapterSelected: (_) {},
              onChapterDeleted: (_, __) {},
              onReorder: (_, __) {},
            ),
          ),
        ),
      ),
    );
    expect(find.text('Chapter One'), findsOneWidget);
    expect(find.text('Chapter Two'), findsOneWidget);
    expect(find.text('2 words'), findsOneWidget);
    expect(find.text('4 words'), findsOneWidget);
  });

  testWidgets('collapses to icon-only numbered mode', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ChapterSidebar(
              chapters: testChapters,
              selectedChapterId: null,
              onChapterSelected: (_) {},
              onChapterDeleted: (_, __) {},
              onReorder: (_, __) {},
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('Chapter One'), findsNothing);
  });
}
