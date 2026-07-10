import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/entity/provider/entity_list_provider.dart';
import '../../features/entity/widget/entity_peek_sheet.dart';

class WikilinkText extends ConsumerWidget {
  final String text;
  final TextStyle? style;

  const WikilinkText({
    super.key,
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entitiesAsync = ref.watch(entityListProvider);

    return entitiesAsync.maybeWhen(
      data: (entities) {
        final matches = RegExp(r'\[\[(.*?)\]\]').allMatches(text);
        if (matches.isEmpty) {
          return Text(text, style: style);
        }

        final spans = <InlineSpan>[];
        int lastIndex = 0;

        for (final match in matches) {
          if (match.start > lastIndex) {
            spans.add(TextSpan(text: text.substring(lastIndex, match.start)));
          }

          final entityName = match.group(1) ?? '';
          final matchedEntity = entities
              .where((e) => e.name.toLowerCase() == entityName.toLowerCase())
              .firstOrNull;

          if (matchedEntity != null) {
            spans.add(
              TextSpan(
                text: entityName,
                style: TextStyle(
                  color: Color(matchedEntity.iconColor),
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: Color(matchedEntity.iconColor).withOpacity(0.4),
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    showEntityPeekSheet(context, entityId: matchedEntity.id);
                  },
              ),
            );
          } else {
            spans.add(TextSpan(text: entityName));
          }

          lastIndex = match.end;
        }

        if (lastIndex < text.length) {
          spans.add(TextSpan(text: text.substring(lastIndex)));
        }

        return Text.rich(
          TextSpan(style: style, children: spans),
        );
      },
      orElse: () => Text(text, style: style),
    );
  }
}
