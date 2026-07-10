import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../domain/use_case/entity/search_entities_use_case.dart';
import '../../../../injection.dart';
import 'loading_indicator.dart';

class QuickSwitcherDialog extends StatefulWidget {
  const QuickSwitcherDialog({super.key});

  @override
  State<QuickSwitcherDialog> createState() => _QuickSwitcherDialogState();
}

class _QuickSwitcherDialogState extends State<QuickSwitcherDialog> {
  final _controller = TextEditingController();
  List<Entity> _results = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _isLoading = false;
      });
      return;
    }
    setState(() => _isLoading = true);
    final searchUseCase = getIt<SearchEntitiesUseCase>();
    final result = await searchUseCase(query);
    result.fold(
      (failure) => setState(() {
        _results = [];
        _isLoading = false;
      }),
      (entities) => setState(() {
        _results = entities;
        _isLoading = false;
      }),
    );
  }

  Widget _buildHighlightedText(BuildContext context, String text, String query) {
    if (query.isEmpty) {
      return Text(text, style: Theme.of(context).textTheme.titleMedium!);
    }
    final textLower = text.toLowerCase();
    final queryLower = query.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;
    
    while (true) {
      final index = textLower.indexOf(queryLower, start);
      if (index == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: TextStyle(
          fontWeight: FontWeight.extrabold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ));
      start = index + query.length;
    }

    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.titleMedium!,
        children: spans,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Dialog(
        backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.85),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Theme.of(context).colorScheme.outline, width: 1.5),
        ),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.85,
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controller,
                autofocus: true,
                onChanged: _onSearch,
                style: Theme.of(context).textTheme.bodyLarge!,
                decoration: InputDecoration(
                  hintText: 'Quick summon entity...',
                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Theme.of(context).colorScheme.onSurfaceVariant),
                          onPressed: () {
                            _controller.clear();
                            _onSearch('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ),
              SizedBox(height: 16),
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: LoadingIndicator(),
                  ),
                )
              else if (_controller.text.trim().isNotEmpty && _results.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'No entities found matching your query.',
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final entity = _results[index];
                      final iconColor = Color(entity.iconColor);

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: iconColor.withOpacity(0.15),
                          child: Text(
                            entity.name.isNotEmpty
                                ? entity.name.substring(0, 1).toUpperCase()
                                : '?',
                            style: TextStyle(
                              color: iconColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: _buildHighlightedText(context, entity.name, _controller.text.trim()),
                        subtitle: Text(
                          '${entity.type.label.toUpperCase()} · ${entity.status.label.toUpperCase()}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          context.push('/entities/${entity.id}');
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
