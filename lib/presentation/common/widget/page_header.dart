import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/project/provider/active_project_provider.dart';
import '../../features/project/widget/project_switcher_bottom_sheet.dart';

class PageHeader extends ConsumerWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Color? accentColor;

  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final color = accentColor ?? theme.colorScheme.primary;
    final activeProjectVal = ref.watch(activeProjectProvider);
    final activeProject = activeProjectVal.valueOrNull;

    return SafeArea(
      top: true,
      bottom: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 4, 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.outline.withOpacity(0.08),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Left: decorative accent bar
            Container(
              width: 3,
              height: 28,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title + subtitle + active project breadcrumb
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (activeProject != null)
                    GestureDetector(
                      onTap: () => _showProjectSelector(context),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.auto_stories_outlined,
                                size: 12,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                activeProject.name.toUpperCase(),
                                style: theme.textTheme.labelSmall!.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                  fontSize: 10,
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                size: 14,
                                color: theme.colorScheme.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  Text(
                    title,
                    style: theme.textTheme.headlineMedium!.copyWith(
                      fontFamily: theme.textTheme.displayLarge?.fontFamily,
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Trailing widget (actions, dropdown, etc.)
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }

  void _showProjectSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const ProjectSwitcherBottomSheet(),
    );
  }
}
