import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../domain/repository/entity_repository.dart';
import '../../../../domain/use_case/export/export_database_use_case.dart';
import '../../../../domain/use_case/export/import_database_use_case.dart';
import '../../../../injection.dart';
import '../../../common/widget/confirm_dialog.dart';
import '../../../common/widget/loading_indicator.dart';
import '../../entity/provider/entity_list_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _loading = false;

  Map<String, int> _parseExportDataCounts(String jsonStr) {
    try {
      final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
      final data = decoded['data'] as Map<String, dynamic>?;
      if (data == null) return {};
      return {
        'entities': (data['entities'] as List?)?.length ?? 0,
        'relationships': (data['relationships'] as List?)?.length ?? 0,
        'timeline_entries': (data['timeline_entries'] as List?)?.length ?? 0,
        'templates': (data['templates'] as List?)?.length ?? 0,
        'world_maps': (data['world_maps'] as List?)?.length ?? 0,
        'entity_versions': (data['entity_versions'] as List?)?.length ?? 0,
      };
    } catch (_) {
      return {};
    }
  }

  Future<void> _exportCodex() async {
    setState(() => _loading = true);
    final result = await getIt<ExportDatabaseUseCase>()();
    result.fold(
      (f) => _snack(f.message, Theme.of(context).colorScheme.error),
      (jsonStr) async {
        await Clipboard.setData(ClipboardData(text: jsonStr));
        if (mounted) _showExportDone(jsonStr);
      },
    );
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _importCodex() async {
    final clipboard = await Clipboard.getData(Clipboard.kTextPlain);
    final json = clipboard?.text;
    if (json == null || json.isEmpty) {
      _snack('Clipboard is empty — copy your JSON export first.', Colors.amber);
      return;
    }
    
    final counts = _parseExportDataCounts(json);
    if (counts.isEmpty) {
      _snack('Invalid backup JSON format in clipboard.', Theme.of(context).colorScheme.error);
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text('Import Codex', style: Theme.of(context).textTheme.titleMedium!.copyWith(fontFamily: 'Lora', color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to import this data? Matching records will be updated.',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            Text(
              'Payload Summary:',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildChecklistItem(Icons.category, '${counts['entities'] ?? 0} World Entities'),
            _buildChecklistItem(Icons.link, '${counts['relationships'] ?? 0} Relationships/Links'),
            _buildChecklistItem(Icons.timeline, '${counts['timeline_entries'] ?? 0} Timeline Events'),
            _buildChecklistItem(Icons.map, '${counts['world_maps'] ?? 0} World Maps'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.surface,
            ),
            child: const Text('Import', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    
    final success = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => ImportProgressDialog(
        counts: counts,
        onStartImport: () async {
          final result = await getIt<ImportDatabaseUseCase>()(
            ImportDatabaseParams(jsonContent: json, isReplace: false),
          );
          result.fold(
            (failure) => throw Exception(failure.message),
            (_) => null,
          );
        },
      ),
    );

    if (success == true) {
      ref.invalidate(entityListProvider);
      _showImportDone(counts);
    }
  }

  Future<void> _purgeDeleted() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => ConfirmDialog(title: 'Purge Codex Trash',
        content: 'This will permanently erase all soft-deleted entities, relationships, and events. This action is irreversible.',
        confirmLabel: 'Purge', isDestructive: true),
    );
    if (confirm != true) return;
    setState(() => _loading = true);
    final repo = getIt<EntityRepository>();
    final result = await repo.purgeSoftDeleted();
    setState(() => _loading = false);
    result.fold(
      (f) => _snack(f.message, Theme.of(context).colorScheme.error),
      (_) { ref.invalidate(entityListProvider); _snack('Trash purged.', Theme.of(context).colorScheme.tertiary); },
    );
  }

  void _showExportDone(String jsonStr) {
    final counts = _parseExportDataCounts(jsonStr);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text('Export Complete', style: Theme.of(context).textTheme.titleMedium!.copyWith(fontFamily: 'Lora', color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Icon(Icons.check_circle_outline, color: Theme.of(context).colorScheme.tertiary, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    'Copied to Clipboard! (FileSize: ${(jsonStr.length / 1024).toStringAsFixed(1)} KB)',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Backup Summary:',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildChecklistItem(Icons.category, '${counts['entities'] ?? 0} World Entities'),
            _buildChecklistItem(Icons.link, '${counts['relationships'] ?? 0} Relationships/Links'),
            _buildChecklistItem(Icons.timeline, '${counts['timeline_entries'] ?? 0} Timeline Events'),
            _buildChecklistItem(Icons.description, '${counts['templates'] ?? 0} Archetype Templates'),
            _buildChecklistItem(Icons.map, '${counts['world_maps'] ?? 0} World Maps'),
            _buildChecklistItem(Icons.history, '${counts['entity_versions'] ?? 0} Revision Snapshots'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Share.share(jsonStr, subject: 'Fictionist Codex Backup');
            },
            child: Text('Share File', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Close', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ),
        ],
      ),
    );
  }

  void _showImportDone(Map<String, int> counts) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text('Import Complete', style: Theme.of(context).textTheme.titleMedium!.copyWith(fontFamily: 'Lora', color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline, color: Theme.of(context).colorScheme.tertiary, size: 48),
            const SizedBox(height: 12),
            Text(
              'Imported ${counts['entities'] ?? 0} entities and ${counts['relationships'] ?? 0} connections into your codex library.',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Done', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 13,
                ),
          ),
        ],
      ),
    );
  }

  void _snack(String msg, Color c) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: c));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface, elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 18, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.pop(context)),
        title: Text('Archivist Settings', style: Theme.of(context).textTheme.titleMedium!.copyWith(
          fontFamily: 'Lora', fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
      ),
      body: _loading
          ? LoadingIndicator()
          : ListView(padding: const EdgeInsets.all(16), children: [
              _section('Codex Management'),
              _tile(Icons.upload_file, 'Export Full Codex', 'Copy entire database to clipboard as JSON',
                onTap: _exportCodex),
              _tile(Icons.download, 'Import Codex JSON', 'Merge JSON from clipboard into your codex',
                onTap: _importCodex),
              _tile(Icons.delete_sweep, 'Purge Soft-Deleted Entities', 'Permanently erase all trash',
                onTap: _purgeDeleted, destructive: true),
              const SizedBox(height: 24),
              _section('Appearance'),
              _tile(Icons.palette, 'Theme', 'Customize colors, fonts, and presets',
                onTap: () => GoRouter.of(context).push('/settings/theme')),
              const SizedBox(height: 24),
              _section('About'),
              _tile(Icons.info_outline, 'Fictionist v1.0.0', 'Local-first worldbuilding database',
                onTap: null),
              _tile(Icons.code, 'Dependencies', 'Flutter · Drift · Riverpod · fpdart',
                onTap: null),
            ]),
    );
  }

  Widget _section(String title) => Padding(
    padding: EdgeInsets.only(bottom: 8),
    child: Text(title, style: Theme.of(context).textTheme.labelMedium!.copyWith(
      color: Theme.of(context).colorScheme.primary, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
  );

  Widget _tile(IconData icon, String title, String subtitle, {VoidCallback? onTap, bool destructive = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3), width: 0.5),
            ),
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(children: [
              Icon(icon, size: 20, color: destructive ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary.withValues(alpha: 0.7)),
              SizedBox(width: 14),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w600, fontSize: 14, color: destructive ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.onSurface)),
                  SizedBox(height: 2),
                  Text(subtitle, style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 11)),
                ],
              )),
              if (onTap != null) Icon(Icons.chevron_right, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
            ]),
          ),
        ),
      ),
    );
  }
}

class ImportProgressDialog extends StatefulWidget {
  final Map<String, int> counts;
  final Future<void> Function() onStartImport;

  const ImportProgressDialog({
    super.key,
    required this.counts,
    required this.onStartImport,
  });

  @override
  State<ImportProgressDialog> createState() => _ImportProgressDialogState();
}

class _ImportProgressDialogState extends State<ImportProgressDialog> with SingleTickerProviderStateMixin {
  double _progress = 0.0;
  bool _entitiesDone = false;
  bool _relsDone = false;
  bool _eventsDone = false;
  bool _mapsDone = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startProcess();
  }

  Future<void> _startProcess() async {
    try {
      await widget.onStartImport();
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString());
      }
      return;
    }

    if (!mounted) return;
    
    // Step 1: Entities
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) setState(() { _progress = 0.25; _entitiesDone = true; });
    
    // Step 2: Relationships
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) setState(() { _progress = 0.50; _relsDone = true; });

    // Step 3: Timeline Events
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) setState(() { _progress = 0.75; _eventsDone = true; });

    // Step 4: Maps
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) setState(() { _progress = 1.0; _mapsDone = true; });

    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('Import Failed', style: TextStyle(color: Theme.of(context).colorScheme.error)),
        content: Text(_error!),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('OK'),
          )
        ],
      );
    }

    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      title: Text('Importing Codex Data...', style: Theme.of(context).textTheme.titleMedium!.copyWith(fontFamily: 'Lora', fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _progress,
            backgroundColor: Theme.of(context).colorScheme.outline.withOpacity(0.12),
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 20),
          _buildImportRow(Icons.category, '${widget.counts['entities'] ?? 0} World Entities', _entitiesDone),
          _buildImportRow(Icons.link, '${widget.counts['relationships'] ?? 0} Relationships/Links', _relsDone),
          _buildImportRow(Icons.timeline, '${widget.counts['timeline_entries'] ?? 0} Timeline Events', _eventsDone),
          _buildImportRow(Icons.map, '${widget.counts['world_maps'] ?? 0} World Maps', _mapsDone),
        ],
      ),
    );
  }

  Widget _buildImportRow(IconData icon, String text, bool isDone) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: isDone ? theme.colorScheme.tertiary : theme.colorScheme.outline),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
                color: isDone ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          if (isDone)
            Icon(Icons.check_circle, size: 18, color: theme.colorScheme.tertiary).animate().scale(duration: 200.ms, curve: Curves.easeOutBack)
          else
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 1.5, color: theme.colorScheme.primary),
            ),
        ],
      ),
    );
  }
}
