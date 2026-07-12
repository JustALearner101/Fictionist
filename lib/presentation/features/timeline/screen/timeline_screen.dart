import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../domain/timeline/timeline_entry.dart';
import '../../../../domain/timeline/chronicle_item.dart';
import '../../../../domain/use_case/manuscript/manuscript_use_cases.dart';
import '../../../../injection.dart';
import '../../../common/widget/confirm_dialog.dart';
import '../../../common/widget/empty_state.dart';
import '../../../common/widget/error_display.dart';
import '../../../common/widget/loading_indicator.dart';
import '../../../common/widget/page_header.dart';
import '../../entity/provider/entity_list_provider.dart';
import '../provider/timeline_provider.dart';

class TimelineScreen extends ConsumerStatefulWidget {
  const TimelineScreen({super.key});
  @override
  ConsumerState<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends ConsumerState<TimelineScreen> {
  bool _isEditing = false;
  List<ChronicleChapter> _datedChapters = [];

  @override
  void initState() {
    super.initState();
    _loadDatedChapters();
  }

  Future<void> _loadDatedChapters() async {
    final result = await getIt<ListChaptersUseCase>()();
    result.fold((_) {}, (chapters) {
      if (mounted) setState(() => _datedChapters = chapters
          .where((c) => c.dateLabel != null && c.dateLabel!.trim().isNotEmpty)
          .map((c) => ChronicleChapter(c)).toList());
    });
  }

  Future<void> _createEntry() async {
    final entitiesResult = await ref.read(entityListProvider.future);
    final tCtrl = TextEditingController(), dCtrl = TextEditingController();
    final dateCtrl = TextEditingController(), eraCtrl = TextEditingController();
    Entity? selEntity;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (_, setD) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text('Record Chronicle Event',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontFamily: 'Lora', color: Theme.of(context).colorScheme.primary)),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            _dialogField(tCtrl, 'Event Title'),
            const SizedBox(height: 10),
            _dialogField(dCtrl, 'Description (Optional)', maxLines: 2),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: _dialogField(dateCtrl, 'Date (e.g. 3019)')),
              const SizedBox(width: 10),
              Expanded(child: _dialogField(eraCtrl, 'Era (e.g. Third Age)')),
            ]),
            SizedBox(height: 10),
            _dialogDropdown<Entity>(
              items: [DropdownMenuItem(value: null, child: Text('None (General Event)')),
                ...entitiesResult.map((e) => DropdownMenuItem(value: e, child: Text(e.name)))],
              onChanged: (v) => setD(() => selEntity = v),
            ),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))),
          FilledButton(
            onPressed: () { if (tCtrl.text.trim().isNotEmpty) Navigator.pop(ctx, true); },
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
            child: const Text('Record'),
          ),
        ],
      )),
    );

    if (confirm == true) {
      await ref.read(timelineListProvider().notifier).createEntry(
        title: tCtrl.text.trim(),
        description: dCtrl.text.trim().isEmpty ? null : dCtrl.text.trim(),
        dateLabel: dateCtrl.text.trim().isEmpty ? null : dateCtrl.text.trim(),
        eraLabel: eraCtrl.text.trim().isEmpty ? null : eraCtrl.text.trim(),
        entityId: selEntity?.id,
      );
    }
  }

  Widget _dialogField(TextEditingController ctrl, String hint, {int maxLines = 1}) => TextFormField(
    controller: ctrl, maxLines: maxLines,
    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 13),
    decoration: InputDecoration(
      labelText: hint, labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      filled: true, fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    ),
  );

  Widget _dialogDropdown<T>({required List<DropdownMenuItem<T>> items, required void Function(T?)? onChanged}) => Container(
    padding: EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5), width: 0.6),
    ),
    child: DropdownButtonHideUnderline(child: DropdownButton<T>(
      items: items, onChanged: onChanged, isExpanded: true, dropdownColor: Theme.of(context).colorScheme.surface,
      menuMaxHeight: 280,
      style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface),
    )),
  );

  Future<void> _deleteEntry(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => const ConfirmDialog(
        title: 'Erase Event', confirmLabel: 'Erase', isDestructive: true,
        content: 'Are you sure you want to erase this event?',
      ),
    );
    if (confirm == true) await ref.read(timelineListProvider().notifier).deleteEntry(id);
  }

  Map<String, List<ChronicleItem>> _groupByEra(List<TimelineEntry> entries, List<ChronicleItem> chapters) {
    final groups = <String, List<ChronicleItem>>{};
    for (final e in entries) {
      final era = (e.eraLabel?.trim().isNotEmpty ?? false) ? e.eraLabel!.trim() : 'General History';
      groups.putIfAbsent(era, () => []).add(ChronicleTimelineEntry(e));
    }
    for (final c in chapters) {
      final era = (c.eraLabel?.trim().isNotEmpty ?? false) ? c.eraLabel!.trim() : 'General History';
      groups.putIfAbsent(era, () => []).add(c);
    }
    return groups;
  }

  Widget _entryCard(TimelineEntry entry, Entity? linked, {bool showDrag = false, EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 5)}) {
    return Padding(
      padding: padding,
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: linked != null ? () => context.push('/entities/${linked.id}') : null,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3), width: 0.5),
            ),
            padding: EdgeInsets.all(14),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (showDrag) ...[
                Icon(Icons.drag_indicator, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 18),
                SizedBox(width: 10),
              ],
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  if (entry.dateLabel != null && entry.dateLabel!.isNotEmpty) ...[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3), width: 0.5),
                      ),
                      child: Text(entry.dateLabel!,
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600, fontSize: 10)),
                    ),
                  ],
                  Expanded(child: Text(entry.title,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontFamily: 'Lora', fontWeight: FontWeight.w600, fontSize: 14, color: Theme.of(context).colorScheme.onSurface))),
                ]),
                if (entry.description != null && entry.description!.trim().isNotEmpty) ...[
                  SizedBox(height: 6),
                  Text(entry.description!,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13)),
                ],
                if (linked != null) ...[
                  SizedBox(height: 8),
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.link, size: 13, color: Color(linked.iconColor)),
                    SizedBox(width: 4),
                    Text(linked.name, style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Color(linked.iconColor), fontWeight: FontWeight.w600, fontSize: 12)),
                  ]),
                ],
              ])),
              IconButton(icon: Icon(Icons.delete_outline, size: 16, color: Theme.of(context).colorScheme.error),
                onPressed: () => _deleteEntry(entry.id), padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32)),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _chapterCard(ChronicleChapter ch, {EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 5)}) {
    return Padding(
      padding: padding,
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3), width: 0.5),
          ),
          padding: EdgeInsets.all(14),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.auto_stories, color: Theme.of(context).colorScheme.secondary, size: 16),
            ),
            SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                if (ch.dateLabel != null && ch.dateLabel!.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(ch.dateLabel!,
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w600, fontSize: 10)),
                  ),
                ],
                Expanded(child: Text(ch.chapter.title,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontFamily: 'Lora', fontWeight: FontWeight.w600, fontSize: 14))),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('CHAPTER', style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.secondary, fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                ),
              ]),
              if (ch.description != null && ch.description!.trim().isNotEmpty) ...[
                SizedBox(height: 4),
                Text(ch.description!, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
              ],
            ])),
          ]),
        ),
      ),
    );
  }

  Widget _getEventIcon(String title, Color dotColor) {
    final t = title.toLowerCase();
    IconData icon;
    if (t.contains('born') || t.contains('birth')) {
      icon = Icons.child_care;
    } else if (t.contains('died') || t.contains('death') || t.contains('slain') || t.contains('fall')) {
      icon = Icons.gavel;
    } else if (t.contains('battle') || t.contains('war') || t.contains('siege') || t.contains('conquest')) {
      icon = Icons.bolt;
    } else if (t.contains('crown') || t.contains('coronation') || t.contains('reign')) {
      icon = Icons.workspace_premium;
    } else if (t.contains('found') || t.contains('built') || t.contains('construct')) {
      icon = Icons.foundation;
    } else if (t.contains('destroy') || t.contains('burn') || t.contains('ruin')) {
      icon = Icons.local_fire_department;
    } else if (t == 'chapter') {
      icon = Icons.auto_stories;
    } else {
      return Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: dotColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.surface,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: dotColor.withOpacity(0.4),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
      );
    }

    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: dotColor,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: dotColor.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: Center(
        child: Icon(icon, size: 11, color: dotColor),
      ),
    );
  }

  Widget _buildTimelineItemRow({required Widget card, required Widget customDot}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 48,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 2.0,
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.35),
                ),
                customDot,
              ],
            ),
          ),
          Expanded(child: card),
        ],
      ),
    );
  }

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(0.0, 6.0, animValue)!;
        return Material(
          elevation: elevation,
          color: Theme.of(context).colorScheme.surface,
          shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.25),
          borderRadius: BorderRadius.circular(12),
          child: child,
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final timelineState = ref.watch(timelineListProvider());
    final allEntitiesState = ref.watch(entityListProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        toolbarHeight: 48,
        actions: [
          IconButton(icon: Icon(_isEditing ? Icons.chrome_reader_mode : Icons.edit, color: Theme.of(context).colorScheme.onSurface, size: 20),
            tooltip: _isEditing ? 'Read Mode' : 'Edit Order',
            onPressed: () => setState(() => _isEditing = !_isEditing)),
          IconButton(icon: Icon(Icons.refresh, color: Theme.of(context).colorScheme.onSurface, size: 20),
            onPressed: () => ref.refresh(timelineListProvider())),
        ],
      ),
      body: Column(
        children: [
          const PageHeader(title: 'Timeline', subtitle: 'Chronicle of eras and historical events'),
          Expanded(
            child: timelineState.when(
        data: (entries) {
          if (entries.isEmpty) return EmptyState(
            title: 'Chronicle is Empty',
            message: 'Drag and reorder events to arrange historical eras.',
            icon: Icons.history,
          );
          return allEntitiesState.when(data: (entitiesList) {
            if (_isEditing) {
              return Theme(
                data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
                child: ReorderableListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: entries.length,
                  proxyDecorator: _proxyDecorator,
                  onReorder: (oldIndex, newIndex) {
                    final target = newIndex > oldIndex ? newIndex - 1 : newIndex;
                    ref.read(timelineListProvider().notifier).reorderEntries(entries[oldIndex].id, target);
                  },
                  itemBuilder: (_, i) {
                    final e = entries[i];
                    final linked = entitiesList.where((x) => x.id == e.entityId).firstOrNull;
                    return _entryCard(e, linked, showDrag: true);
                  },
                ),
              );
            }
            final grouped = _groupByEra(entries, _datedChapters);
            final eras = grouped.keys.toList();
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: eras.length,
              itemBuilder: (_, i) {
                final era = eras[i];
                final items = grouped[era]!;
                return StickyHeader(
                  header: Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.92),
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                          width: 0.5,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Icon(
                          Icons.bookmark_outline,
                          size: 14,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          era.toUpperCase(),
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontFamily: 'Lora',
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  content: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: items.map((item) {
                        if (item is ChronicleTimelineEntry) {
                          final linked = entitiesList.where((x) => x.id == item.entry.entityId).firstOrNull;
                          return _buildTimelineItemRow(
                            customDot: _getEventIcon(item.entry.title, Theme.of(context).colorScheme.primary),
                            card: _entryCard(
                              item.entry,
                              linked,
                              padding: const EdgeInsets.only(right: 14, top: 4, bottom: 4),
                            ),
                          );
                        }
                        if (item is ChronicleChapter) {
                          return _buildTimelineItemRow(
                            customDot: _getEventIcon('chapter', Theme.of(context).colorScheme.secondary),
                            card: _chapterCard(
                              item,
                              padding: const EdgeInsets.only(right: 14, top: 4, bottom: 4),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }).toList(),
                    ),
                  ),
                );
              },
            );
          }, loading: () => LoadingIndicator(), error: (e, _) => ErrorDisplay(message: e.toString()));
        },
        loading: () => LoadingIndicator(),
        error: (e, _) => ErrorDisplay(message: e.toString(), onRetry: () => ref.refresh(timelineListProvider())),
      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createEntry,
        backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Theme.of(context).colorScheme.surface,
        elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add),
      ),
    );
  }
}
