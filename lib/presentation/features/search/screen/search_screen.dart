import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../provider/entity_search_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});
  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  void _onSearch(String v) => ref.read(entitySearchProvider.notifier).search(v);

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(entitySearchProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface, elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 18, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => context.pop()),
        title: Text('Codex Search', style: Theme.of(context).textTheme.titleMedium!.copyWith(
          fontFamily: Theme.of(context).textTheme.displayLarge?.fontFamily, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
      ),
      body: Column(children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: TextFormField(
            controller: _controller, onChanged: _onSearch, autofocus: true,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search names, notes, custom fields…',
              hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5), fontSize: 14),
              prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary, size: 20),
              suffixIcon: _controller.text.isNotEmpty ? IconButton(
                icon: Icon(Icons.clear, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 18),
                onPressed: () { _controller.clear(); _onSearch(''); },
              ) : null,
              filled: true, fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3), width: 0.5)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3), width: 0.5)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1)),
              contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ),
        Expanded(child: state.when(
          data: (results) {
            if (results.isEmpty) {
              return Center(child: Text(
                _controller.text.isEmpty ? 'Type to search the codex.' : 'No results found.',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14),
              ));
            }
            return ListView.builder(
              padding: EdgeInsets.fromLTRB(14, 4, 14, 20),
              itemCount: results.length,
              itemBuilder: (_, i) {
                final r = results[i];
                final color = Color(r.entity.iconColor);
                return Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Hero(
                    tag: 'entity-card-${r.entity.id}',
                    child: Material(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          context.push('/entities/${r.entity.id}');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3), width: 0.5)),
                          padding: const EdgeInsets.all(14),
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Hero(
                              tag: 'entity-avatar-${r.entity.id}',
                              child: Material(
                                type: MaterialType.transparency,
                                child: Container(
                                  width: 40, height: 40,
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.12),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: color.withValues(alpha: 0.5), width: 1)),
                                  child: Center(child: Text(
                                    r.entity.name.isNotEmpty ? r.entity.name[0].toUpperCase() : '?',
                                    style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 14),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(r.entity.name, style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.w600, fontSize: 14)),
                              SizedBox(height: 3),
                              Row(children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4)),
                                  child: Text(r.entity.type.label, style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: Theme.of(context).colorScheme.primary, fontSize: 9, fontWeight: FontWeight.w600)),
                                ),
                                if (r.snippet.isNotEmpty) ...[
                                  SizedBox(width: 8),
                                  Expanded(child: Text(r.snippet, maxLines: 1, overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12, fontStyle: FontStyle.italic))),
                                ],
                              ]),
                            ])),
                            Icon(Icons.chevron_right, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 200.ms, delay: (i * 30).ms).slideY(begin: 0.12, duration: 200.ms, delay: (i * 30).ms, curve: Curves.easeOutQuad);
              },
            );
          },
          loading: () => Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary)),
          error: (e, _) => Center(child: Text('Error: $e', style: TextStyle(color: Theme.of(context).colorScheme.error))),
        )),
      ]),
    );
  }
}
