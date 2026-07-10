import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entity/entity_type.dart';
import '../../../../domain/quick_capture/quick_capture.dart';
import '../../../../domain/use_case/quick_capture/process_quick_capture_use_case.dart';
import '../../../../injection.dart';
import '../../../common/widget/empty_state.dart';
import '../../../common/widget/error_display.dart';
import '../../../common/widget/loading_indicator.dart';
import '../../entity/provider/entity_list_provider.dart';
import '../provider/quick_capture_provider.dart';

class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});
  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  Future<void> _process(QuickCapture capture) async {
    final nameCtrl = TextEditingController();
    EntityType? type = EntityType.character;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (_, setD) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text('Manifest Entity', style: Theme.of(context).textTheme.titleMedium!.copyWith(
          fontFamily: 'Lora', color: Theme.of(context).colorScheme.primary)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFormField(
            controller: nameCtrl,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 13),
            decoration: _inputDeco('Entity Name'),
          ),
          SizedBox(height: 8),
          Text('Capture text: "${capture.rawText}"',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12, fontStyle: FontStyle.italic)),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5), width: 0.6),
            ),
            child: DropdownButtonHideUnderline(child: DropdownButton<EntityType>(
              value: type, isExpanded: true, dropdownColor: Theme.of(context).colorScheme.surface,
              menuMaxHeight: 280,
              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface),
              items: EntityType.values.map((t) => DropdownMenuItem(
                value: t, child: Text(t.label, style: TextStyle(fontSize: 13)))).toList(),
              onChanged: (v) => setD(() => type = v!),
            )),
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))),
          FilledButton(
            onPressed: () { if (nameCtrl.text.trim().isNotEmpty) Navigator.pop(ctx, true); },
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
            child: const Text('Manifest')),
        ],
      )),
    );

    if (confirmed != true) return;
    final useCase = getIt<ProcessQuickCaptureUseCase>();
    final result = await useCase(ProcessQuickCaptureParams(
      captureId: capture.id,
      action: QuickCaptureAction.createEntity,
      entityName: nameCtrl.text.trim(),
      entityType: type!,
      entityIconColor: 0xFF8B5CF6,
    ));
    result.fold(
      (f) => _snack(f.message, Theme.of(context).colorScheme.error),
      (_) {
        ref.invalidate(quickCaptureListProvider);
        ref.invalidate(entityListProvider);
        _snack('Entity manifested: ${nameCtrl.text.trim()}', Theme.of(context).colorScheme.tertiary);
      },
    );
  }

  Future<void> _dismiss(String id) async {
    final useCase = getIt<ProcessQuickCaptureUseCase>();
    final result = await useCase(ProcessQuickCaptureParams(
      captureId: id,
      action: QuickCaptureAction.dismiss,
    ));
    result.fold(
      (f) => _snack(f.message, Theme.of(context).colorScheme.error),
      (_) { ref.invalidate(quickCaptureListProvider); _snack('Dismissed.', Theme.of(context).colorScheme.onSurfaceVariant); },
    );
  }

  InputDecoration _inputDeco(String hint) => InputDecoration(
    labelText: hint, labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5))),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5))),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    filled: true, fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
  );

  void _snack(String msg, Color c) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: c));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quickCaptureListProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface, elevation: 0,
        title: Text('Inbox',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            fontFamily: 'Lora', color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
      ),
      body: state.when(
        data: (captures) {
          if (captures.isEmpty) return const EmptyState(
            title: 'Inbox is Empty',
            message: 'Quick-captured ideas will appear here.',
            icon: Icons.inbox_outlined,
          );
          return ListView.builder(
            padding: EdgeInsets.fromLTRB(14, 4, 14, 80),
            itemCount: captures.length,
            itemBuilder: (_, i) {
              final c = captures[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Dismissible(
                  key: Key(c.id),
                  background: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.add_box, color: Theme.of(context).colorScheme.onTertiary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Manifest Entity',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  secondaryBackground: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Dismiss Note',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onError,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.archive, color: Theme.of(context).colorScheme.onError, size: 20),
                      ],
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      await _process(c);
                      return false;
                    } else {
                      await _dismiss(c.id);
                      return true;
                    }
                  },
                  child: Material(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3), width: 0.5)),
                      padding: const EdgeInsets.all(14),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(
                          width: 34, height: 34,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8)),
                          child: Icon(Icons.lightbulb_outline, color: Theme.of(context).colorScheme.primary, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(c.rawText, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14, height: 1.4)),
                          const SizedBox(height: 6),
                          Text(_timeAgo(c.createdAt), style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 11)),
                        ])),
                        PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
                          color: Theme.of(context).colorScheme.surface,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          onSelected: (v) {
                            if (v == 'manifest') _process(c);
                            if (v == 'dismiss') _dismiss(c.id);
                          },
                          itemBuilder: (_) => [
                            const PopupMenuItem(value: 'manifest',
                              child: Text('Manifest as Entity', style: TextStyle(fontSize: 13))),
                            PopupMenuItem(value: 'dismiss',
                              child: Text('Dismiss', style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 13))),
                          ],
                        ),
                      ]),
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => LoadingIndicator(),
        error: (e, _) => ErrorDisplay(message: e.toString(),
          onRetry: () => ref.refresh(quickCaptureListProvider)),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'just now';
  }
}
