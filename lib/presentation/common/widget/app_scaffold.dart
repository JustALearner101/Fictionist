import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;
    final inactiveColor = theme.colorScheme.onSurfaceVariant.withOpacity(0.6);

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: SizedBox(
          width: 50,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pill background for active tab
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                width: isSelected ? 44 : 32,
                height: 26,
                decoration: BoxDecoration(
                  color: isSelected
                      ? activeColor.withOpacity(0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: isSelected ? 0.9 : 1.0, end: isSelected ? 1.08 : 1.0),
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutBack,
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: Icon(
                        isSelected ? activeIcon : icon,
                        size: 20,
                        color: isSelected ? activeColor : inactiveColor,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? activeColor : inactiveColor.withOpacity(0.8),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
