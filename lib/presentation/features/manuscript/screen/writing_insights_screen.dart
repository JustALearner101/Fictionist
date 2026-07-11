import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fictionist/domain/entity/entity.dart';
import 'package:fictionist/domain/entity/entity_type.dart';
import 'package:fictionist/domain/manuscript/manuscript_chapter.dart';
import 'package:fictionist/presentation/features/entity/provider/entity_list_provider.dart';
import 'package:fictionist/presentation/features/manuscript/provider/manuscript_provider.dart';
import 'package:fictionist/presentation/features/timeline/provider/timeline_provider.dart';

/// A combined consistency dashboard + story health screen.
/// Accessible from the manuscript page.
class WritingInsightsScreen extends ConsumerWidget {
  const WritingInsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chapters = ref.watch(manuscriptNotifierProvider).chapters;
    final entitiesAsync = ref.watch(entityListProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Text('Writing Insights',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontFamily: 'Lora',
                  fontWeight: FontWeight.bold,
                )),
      ),
      body: entitiesAsync.maybeWhen(
        data: (entities) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Consistency Issues ──────────────────────────
            _SectionHeader(title: 'Consistency', icon: Icons.warning_amber_rounded),
            _consistencySection(context, chapters, entities),
            const SizedBox(height: 20),
            // ── Story Health ────────────────────────────────
            _SectionHeader(title: 'Story Health', icon: Icons.favorite_outline),
            _healthSection(context, chapters, entities),
          ],
        ),
        orElse: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _consistencySection(
      BuildContext context, List<ManuscriptChapter> chapters, List<Entity> entities) {
    final theme = Theme.of(context);
    final issues = <_Issue>[];

    // Scenes without POV
    final noPov = chapters.where((c) => c.povCharacterId == null).toList();
    if (noPov.isNotEmpty) {
      issues.add(_Issue(
        icon: Icons.person_off,
        label: '${noPov.length} scene${noPov.length == 1 ? '' : 's'} without POV',
        detail: noPov.map((c) => c.title).join(', '),
        severity: _Severity.warning,
      ));
    }

    // Scenes without location
    final noLoc = chapters.where((c) => c.locationId == null).toList();
    if (noLoc.isNotEmpty) {
      issues.add(_Issue(
        icon: Icons.place_outlined,
        label: '${noLoc.length} scene${noLoc.length == 1 ? '' : 's'} without location',
        detail: noLoc.map((c) => c.title).join(', '),
        severity: _Severity.info,
      ));
    }

    // Unused entities (from entity list)
    // ponytail: simple name scan — full scan via unusedEntitiesReportProvider
    final allText = chapters.map((c) => c.content.toLowerCase()).join(' ');
    final unusedEntities =
        entities.where((e) => !allText.contains(e.name.toLowerCase())).toList();
    if (unusedEntities.isNotEmpty) {
      issues.add(_Issue(
        icon: Icons.visibility_off,
        label: '${unusedEntities.length} unused entit${unusedEntities.length == 1 ? 'y' : 'ies'}',
        detail: unusedEntities.take(5).map((e) => e.name).join(', ') +
            (unusedEntities.length > 5 ? '…' : ''),
        severity: _Severity.info,
      ));
    }

    // Empty chapters
    final empty = chapters.where((c) => c.content.trim().isEmpty).toList();
    if (empty.isNotEmpty) {
      issues.add(_Issue(
        icon: Icons.edit_off,
        label: '${empty.length} empty chapter${empty.length == 1 ? '' : 's'}',
        detail: empty.map((c) => c.title).join(', '),
        severity: _Severity.warning,
      ));
    }

    if (issues.isEmpty) {
      return _EmptyCard(message: 'No consistency issues found. Great job!');
    }

    return Column(
      children: issues.map((issue) => _IssueCard(issue: issue, theme: theme)).toList(),
    );
  }

  Widget _healthSection(
      BuildContext context, List<ManuscriptChapter> chapters, List<Entity> entities) {
    final theme = Theme.of(context);

    final totalChapters = chapters.length;
    final doneChapters = chapters.where((c) => c.status == ChapterStatus.done).length;
    final chapterPct = totalChapters > 0 ? doneChapters / totalChapters : 0.0;

    final charsWithDesc = entities
        .where((e) => e.type == EntityType.character && e.description != null)
        .length;
    final totalChars =
        entities.where((e) => e.type == EntityType.character).length;
    final charPct = totalChars > 0 ? charsWithDesc / totalChars : 0.0;

    final locationsWithDesc = entities
        .where((e) => e.type == EntityType.location && e.description != null)
        .length;
    final totalLocations =
        entities.where((e) => e.type == EntityType.location).length;
    final locationPct =
        totalLocations > 0 ? locationsWithDesc / totalLocations : 0.0;

    final totalWords = chapters.fold<int>(
        0, (sum, c) => sum + c.content.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length);

    return Column(
      children: [
        _ProgressRow(label: 'Draft', value: '$doneChapters/$totalChapters chapters', pct: chapterPct, theme: theme),
        _ProgressRow(label: 'Characters fleshed out', value: '$charsWithDesc/$totalChars', pct: charPct, theme: theme),
        _ProgressRow(label: 'Locations detailed', value: '$locationsWithDesc/$totalLocations', pct: locationPct, theme: theme),
        _ProgressRow(label: 'Total words', value: '$totalWords words', pct: null, theme: theme),
      ],
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(title,
            style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold, fontFamily: 'Lora')),
      ]),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final String value;
  final double? pct;
  final ThemeData theme;
  const _ProgressRow({
    required this.label,
    required this.value,
    this.pct,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(value,
              style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant)),
        ]),
        if (pct != null) ...[
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 6,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
              valueColor: AlwaysStoppedAnimation(pct! >= 1.0
                  ? theme.colorScheme.tertiary
                  : theme.colorScheme.primary),
            ),
          ),
        ],
      ]),
    );
  }
}

enum _Severity { info, warning, error }

class _Issue {
  final IconData icon;
  final String label;
  final String detail;
  final _Severity severity;
  const _Issue({
    required this.icon,
    required this.label,
    required this.detail,
    required this.severity,
  });
}

class _IssueCard extends StatelessWidget {
  final _Issue issue;
  final ThemeData theme;
  const _IssueCard({required this.issue, required this.theme});

  @override
  Widget build(BuildContext context) {
    final color = switch (issue.severity) {
      _Severity.error => theme.colorScheme.error,
      _Severity.warning => const Color(0xFFFBBF24),
      _Severity.info => theme.colorScheme.primary,
    };

    return Card(
      color: theme.colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(issue.icon, size: 18, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(issue.label,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(issue.detail,
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 11),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis),
                ]),
          ),
        ]),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String message;
  const _EmptyCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ),
      ),
    );
  }
}
