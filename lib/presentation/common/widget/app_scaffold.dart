import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({super.key, required this.child});

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/entities')) return 0;
    if (location.startsWith('/timeline')) return 1;
    if (location.startsWith('/manuscript')) return 2;
    if (location.startsWith('/graph')) return 3;
    if (location.startsWith('/map')) return 4;
    if (location.startsWith('/plot')) return 5;
    if (location.startsWith('/inbox')) return 6;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0: context.go('/entities');
      case 1: context.go('/timeline');
      case 2: context.go('/manuscript');
      case 3: context.go('/graph');
      case 4: context.go('/map');
      case 5: context.go('/plot');
      case 6: context.go('/inbox');
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getSelectedIndex(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outline, width: 0.5)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NavItem(
                  icon: Icons.auto_stories_outlined,
                  activeIcon: Icons.auto_stories,
                  label: 'Codex',
                  index: 0,
                  selectedIndex: selectedIndex,
                  onTap: () => _onItemTapped(0, context),
                ),
                _NavItem(
                  icon: Icons.history,
                  activeIcon: Icons.history,
                  label: 'Timeline',
                  index: 1,
                  selectedIndex: selectedIndex,
                  onTap: () => _onItemTapped(1, context),
                ),
                _NavItem(
                  icon: Icons.edit_note_outlined,
                  activeIcon: Icons.edit_note,
                  label: 'Script',
                  index: 2,
                  selectedIndex: selectedIndex,
                  onTap: () => _onItemTapped(2, context),
                ),
                _NavItem(
                  icon: Icons.hub_outlined,
                  activeIcon: Icons.hub,
                  label: 'Web',
                  index: 3,
                  selectedIndex: selectedIndex,
                  onTap: () => _onItemTapped(3, context),
                ),
                _NavItem(
                  icon: Icons.explore_outlined,
                  activeIcon: Icons.explore,
                  label: 'Map',
                  index: 4,
                  selectedIndex: selectedIndex,
                  onTap: () => _onItemTapped(4, context),
                ),
                _NavItem(
                  icon: Icons.dashboard_outlined,
                  activeIcon: Icons.dashboard,
                  label: 'Plot',
                  index: 5,
                  selectedIndex: selectedIndex,
                  onTap: () => _onItemTapped(5, context),
                ),
                _NavItem(
                  icon: Icons.inbox_outlined,
                  activeIcon: Icons.inbox,
                  label: 'Inbox',
                  index: 6,
                  selectedIndex: selectedIndex,
                  onTap: () => _onItemTapped(6, context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;
  final int selectedIndex;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selectedIndex;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: 22,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6),
            ),
            SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
