import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:fictionist/domain/manuscript/manuscript_chapter.dart';
import 'package:fictionist/domain/use_case/manuscript/manuscript_use_cases.dart';
import 'package:fictionist/domain/use_case/entity/list_entities_use_case.dart';
import 'package:fictionist/presentation/features/project/provider/active_project_provider.dart';
import 'package:fictionist/domain/wikilink/wikilink_engine.dart';
import 'package:fictionist/injection.dart';

import 'snapshot_provider.dart';

part 'manuscript_provider.g.dart';

class ManuscriptState {
  final List<ManuscriptChapter> chapters;
  final String? selectedChapterId;
  final bool isLoading;
  final String? errorMessage;

  const ManuscriptState({
    this.chapters = const [],
    this.selectedChapterId,
    this.isLoading = false,
    this.errorMessage,
  });

  ManuscriptState copyWith({
    List<ManuscriptChapter>? chapters,
    String? selectedChapterId,
    bool? isLoading,
    String? errorMessage,
    bool clearSelectedChapter = false,
  }) {
    return ManuscriptState(
      chapters: chapters ?? this.chapters,
      selectedChapterId:
          clearSelectedChapter ? null : selectedChapterId ?? this.selectedChapterId,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

@Riverpod(keepAlive: true)
class ManuscriptNotifier extends _$ManuscriptNotifier {
  @override
  ManuscriptState build() {
    _loadChapters();
    return const ManuscriptState();
  }

  String? get _projectId =>
      ref.read(activeProjectProvider).valueOrNull?.id;

  Future<void> refreshChapters() => _loadChapters();

  Future<void> _loadChapters() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final useCase = getIt<ListChaptersUseCase>();
    final result = await useCase(projectId: _projectId);
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (chapters) {
        _rebuildWikilinkEngine();
        state = state.copyWith(
          isLoading: false,
          chapters: chapters,
          selectedChapterId: chapters.isNotEmpty
              ? (state.selectedChapterId ?? chapters.first.id)
              : null,
        );
      },
    );
  }

  void _rebuildWikilinkEngine() {
    final listUseCase = getIt<ListEntitiesUseCase>();
    listUseCase(ListEntitiesParams(projectId: _projectId)).then((result) {
      result.fold((_) {}, (entities) {
        getIt<WikilinkEngine>().rebuild(entities);
      });
    });
  }

  Future<void> createChapter(String title) async {
    final useCase = getIt<CreateChapterUseCase>();
    final currentCount = state.chapters.length;
    final result = await useCase(CreateChapterParams(
      title: title,
      sortOrder: currentCount,
      projectId: _projectId,
    ));
    result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
      },
      (chapter) {
        final updated = [...state.chapters, chapter];
        state = state.copyWith(
          chapters: updated,
          selectedChapterId: chapter.id,
        );
      },
    );
  }

  void selectChapter(String id) {
    state = state.copyWith(selectedChapterId: id);
  }

  Future<void> updateChapterContent(String id, String content) async {
    final useCase = getIt<UpdateChapterUseCase>();
    final chapter = state.chapters.firstWhere((c) => c.id == id);

    if (chapter.content.isNotEmpty) {
      unawaited(createSnapshot(
        chapterId: id,
        content: chapter.content,
      ));
    }

    final updatedChapters = state.chapters.map((c) {
      return c.id == id ? c.copyWith(content: content) : c;
    }).toList();
    state = state.copyWith(chapters: updatedChapters);

    final result = await useCase(UpdateChapterParams(
      chapter: chapter.copyWith(content: content),
    ));
    result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
        _loadChapters();
      },
      (_) {},
    );
  }

  Future<void> updateChapterTitle(String id, String title) async {
    if (title.trim().isEmpty) return;
    final useCase = getIt<UpdateChapterUseCase>();
    final chapter = state.chapters.firstWhere((c) => c.id == id);

    final result = await useCase(UpdateChapterParams(
      chapter: chapter.copyWith(title: title.trim()),
    ));
    result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
      },
      (updated) {
        final updatedChapters = state.chapters.map((c) {
          return c.id == id ? updated : c;
        }).toList();
        state = state.copyWith(chapters: updatedChapters);
      },
    );
  }

  Future<void> deleteChapter(String id) async {
    final useCase = getIt<DeleteChapterUseCase>();
    final result = await useCase(id);
    result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
      },
      (_) {
        final updated = state.chapters.where((c) => c.id != id).toList();
        final newSelectedId = state.selectedChapterId == id
            ? (updated.isNotEmpty ? updated.first.id : null)
            : state.selectedChapterId;
        state = state.copyWith(
          chapters: updated,
          selectedChapterId: newSelectedId,
        );
      },
    );
  }

  Future<void> reorderChapters(int oldIndex, int newIndex) async {
    if (oldIndex == newIndex) return;
    final chapters = [...state.chapters];
    final item = chapters.removeAt(oldIndex);
    chapters.insert(newIndex, item);

    state = state.copyWith(chapters: chapters);

    final useCase = getIt<ReorderChaptersUseCase>();
    final result = await useCase(ReorderChaptersParams(
      chapterIdsInOrder: chapters.map((c) => c.id).toList(),
    ));
    result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
        _loadChapters();
      },
      (_) {},
    );
  }

  Future<void> updateChapterSynopsis(String id, String? synopsis) async {
    final useCase = getIt<UpdateChapterUseCase>();
    final chapter = state.chapters.firstWhere((c) => c.id == id);

    final updatedChapters = state.chapters.map((c) {
      return c.id == id ? c.copyWith(synopsis: synopsis) : c;
    }).toList();
    state = state.copyWith(chapters: updatedChapters);

    final result = await useCase(UpdateChapterParams(
      chapter: chapter.copyWith(synopsis: synopsis),
    ));
    result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
        _loadChapters();
      },
      (_) {},
    );
  }

  Future<void> updateChapterStatus(String id, ChapterStatus status) async {
    final useCase = getIt<UpdateChapterUseCase>();
    final chapter = state.chapters.firstWhere((c) => c.id == id);

    final updatedChapters = state.chapters.map((c) {
      return c.id == id ? c.copyWith(status: status) : c;
    }).toList();
    state = state.copyWith(chapters: updatedChapters);

    final result = await useCase(UpdateChapterParams(
      chapter: chapter.copyWith(status: status),
    ));
    result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
        _loadChapters();
      },
      (_) {},
    );
  }

  Future<void> replaceAll(String query, String replacement) async {
    if (query.isEmpty) return;
    final useCase = getIt<UpdateChapterUseCase>();
    final affected = <ManuscriptChapter>[];

    for (final chapter in state.chapters) {
      if (chapter.content.contains(query)) {
        final updated = chapter.copyWith(
          content: chapter.content.replaceAll(query, replacement),
        );
        affected.add(updated);

        final updatedChapters = state.chapters.map((c) {
          return c.id == chapter.id ? updated : c;
        }).toList();
        state = state.copyWith(chapters: updatedChapters);

        await useCase(UpdateChapterParams(chapter: updated));
      }
    }
  }

  Future<void> updateChapterPov(String id, String? characterId) async {
    final useCase = getIt<UpdateChapterUseCase>();
    final chapter = state.chapters.firstWhere((c) => c.id == id);
    final updatedChapters = state.chapters.map((c) {
      return c.id == id ? c.copyWith(povCharacterId: characterId) : c;
    }).toList();
    state = state.copyWith(chapters: updatedChapters);
    await useCase(UpdateChapterParams(
        chapter: chapter.copyWith(povCharacterId: characterId)));
  }

  Future<void> updateChapterLocation(String id, String? locationId) async {
    final useCase = getIt<UpdateChapterUseCase>();
    final chapter = state.chapters.firstWhere((c) => c.id == id);
    final updatedChapters = state.chapters.map((c) {
      return c.id == id ? c.copyWith(locationId: locationId) : c;
    }).toList();
    state = state.copyWith(chapters: updatedChapters);
    await useCase(UpdateChapterParams(
        chapter: chapter.copyWith(locationId: locationId)));
  }
}
