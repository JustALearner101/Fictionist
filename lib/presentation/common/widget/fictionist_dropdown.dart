import 'package:flutter/material.dart';

class FictionistDropdownItem<T> {
  const FictionistDropdownItem({
    required this.value,
    required this.child,
  });

  final T value;
  final Widget child;
}

class FictionistDropdown<T> extends StatefulWidget {
  const FictionistDropdown({
    required this.value,
    required this.items,
    super.key,
    this.onChanged,
    this.hint,
  });

  final T value;
  final List<FictionistDropdownItem<T>> items;
  final ValueChanged<T>? onChanged;
  final Widget? hint;

  @override
  State<FictionistDropdown<T>> createState() => _FictionistDropdownState<T>();
}

class _FictionistDropdownState<T> extends State<FictionistDropdown<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _arrowAnimation;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  bool _showAbove = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _arrowAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 1, curve: Curves.easeInOutCubic),
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _controller.dispose();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    final spaceBelow = screenHeight - offset.dy - renderBox.size.height;
    final spaceAbove = offset.dy;

    setState(() {
      _showAbove = spaceBelow < 250 && spaceAbove > spaceBelow;
      _isOpen = true;
    });

    _overlayEntry = _createOverlayEntry(renderBox.size);
    Overlay.of(context).insert(_overlayEntry!);
    _controller.forward();
  }

  void _closeMenu() {
    if (!_isOpen) return;
    _controller.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      if (mounted) {
        setState(() {
          _isOpen = false;
        });
      }
    });
  }

  OverlayEntry _createOverlayEntry(Size size) {
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _closeMenu,
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          _DropdownOverlayMenu<T>(
            items: widget.items,
            value: widget.value,
            layerLink: _layerLink,
            showAbove: _showAbove,
            width: size.width,
            controller: _controller,
            onSelected: (val) {
              widget.onChanged?.call(val);
            },
            onClose: _closeMenu,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedItem = widget.items.firstWhere(
      (item) => item.value == widget.value,
      orElse: () => widget.items.first,
    );

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: widget.onChanged != null ? _toggleDropdown : null,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _isOpen
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withValues(alpha: 0.4),
              width: _isOpen ? 1.2 : 0.6,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: DefaultTextStyle(
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface,
                  ),
                  child: selectedItem.child,
                ),
              ),
              RotationTransition(
                turns: _arrowAnimation,
                child: Icon(
                  Icons.expand_more,
                  size: 16,
                  color: _isOpen
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DropdownOverlayMenu<T> extends StatelessWidget {
  const _DropdownOverlayMenu({
    required this.items,
    required this.value,
    required this.layerLink,
    required this.showAbove,
    required this.width,
    required this.controller,
    required this.onSelected,
    required this.onClose,
  });

  final List<FictionistDropdownItem<T>> items;
  final T value;
  final LayerLink layerLink;
  final bool showAbove;
  final double width;
  final AnimationController controller;
  final ValueChanged<T> onSelected;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final fadeAnimation = CurvedAnimation(
      parent: controller,
      curve: const Interval(0, 0.85, curve: Curves.easeOutCubic),
    );
    final scaleAnimation = Tween<double>(begin: 0.94, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 1, curve: Curves.easeOutCubic),
      ),
    );
    final slideAnimation = Tween<Offset>(
      begin: showAbove ? const Offset(0, 0.06) : const Offset(0, -0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 1, curve: Curves.easeOutCubic),
      ),
    );

    return CompositedTransformFollower(
      link: layerLink,
      showWhenUnlinked: false,
      followerAnchor: showAbove ? Alignment.bottomLeft : Alignment.topLeft,
      targetAnchor: showAbove ? Alignment.topLeft : Alignment.bottomLeft,
      offset: Offset(0, showAbove ? -4 : 4),
      child: FadeTransition(
        opacity: fadeAnimation,
        child: ScaleTransition(
          scale: scaleAnimation,
          alignment: showAbove ? Alignment.bottomCenter : Alignment.topCenter,
          child: SlideTransition(
            position: slideAnimation,
            child: Container(
              width: width,
              constraints: const BoxConstraints(maxHeight: 250),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.4),
                  width: 0.6,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.28),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Material(
                  color: Colors.transparent,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isSelected = item.value == value;
                      return _DropdownItemWidget(
                        isSelected: isSelected,
                        onTap: () {
                          onSelected(item.value);
                          onClose();
                        },
                        child: item.child,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DropdownItemWidget extends StatefulWidget {
  const _DropdownItemWidget({
    required this.isSelected,
    required this.onTap,
    required this.child,
  });

  final bool isSelected;
  final VoidCallback onTap;
  final Widget child;

  @override
  State<_DropdownItemWidget> createState() => _DropdownItemWidgetState();
}

class _DropdownItemWidgetState extends State<_DropdownItemWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isHighlighted = widget.isSelected || _isHovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          color: isHighlighted
              ? (widget.isSelected
                  ? theme.colorScheme.primary.withValues(alpha: 0.15)
                  : theme.colorScheme.primary.withValues(alpha: 0.08))
              : Colors.transparent,
          child: DefaultTextStyle(
            style: theme.textTheme.bodyMedium!.copyWith(
              color: isHighlighted
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
              fontSize: 12,
              fontWeight: widget.isSelected
                  ? FontWeight.w600
                  : FontWeight.normal,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
