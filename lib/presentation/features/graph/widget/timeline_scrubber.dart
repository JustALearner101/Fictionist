import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A colored era band shown above the timeline scrubber slider.
class EraMarker {
  final String label;
  final int startYear;
  final int endYear;
  final Color color;

  const EraMarker({
    required this.label,
    required this.startYear,
    required this.endYear,
    required this.color,
  });
}

/// An interactive timeline scrubber with auto-play, era markers,
/// entity count, and animated controls.
///
/// Usage:
/// ```dart
/// TimelineScrubber(
///   minYear: 1800,
///   maxYear: 2025,
///   totalEntityCount: 128,
///   visibleEntityCount: 47,
///   eras: [EraMarker(label: 'Victorian', startYear: 1837, endYear: 1901, color: Colors.brown)],
///   onYearChanged: (year) => setState(() => _currentYear = year),
///   onClose: () => setState(() => _scrubberVisible = false),
/// )
/// ```
class TimelineScrubber extends StatefulWidget {
  final int minYear;
  final int maxYear;
  final int totalEntityCount;
  final int visibleEntityCount;
  final List<EraMarker> eras;
  final ValueChanged<int> onYearChanged;
  final VoidCallback? onClose;
  final bool enabled;

  const TimelineScrubber({
    super.key,
    required this.minYear,
    required this.maxYear,
    required this.totalEntityCount,
    required this.visibleEntityCount,
    this.eras = const [],
    required this.onYearChanged,
    this.onClose,
    this.enabled = true,
  });

  @override
  State<TimelineScrubber> createState() => _TimelineScrubberState();
}

class _TimelineScrubberState extends State<TimelineScrubber>
    with SingleTickerProviderStateMixin {
  late AnimationController _playController;
  bool _isPlaying = false;
  int _currentYear = 0;

  @override
  void initState() {
    super.initState();
    _currentYear = widget.minYear;
    final durationSeconds = (widget.maxYear - widget.minYear).clamp(3, 30);
    _playController = AnimationController(
      vsync: this,
      duration: Duration(seconds: durationSeconds),
    );
    _playController.addListener(_onPlayTick);
  }

  @override
  void didUpdateWidget(covariant TimelineScrubber oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.minYear != widget.minYear ||
        oldWidget.maxYear != widget.maxYear) {
      _currentYear = _currentYear.clamp(widget.minYear, widget.maxYear);
      final durationSeconds =
          (widget.maxYear - widget.minYear).clamp(3, 30);
      _playController.duration = Duration(seconds: durationSeconds);
      if (_isPlaying) {
        _playController
          ..reset()
          ..forward();
      }
    }
    if (!widget.enabled && _isPlaying) {
      _togglePlay();
    }
  }

  void _onPlayTick() {
    if (!mounted) return;
    final range = widget.maxYear - widget.minYear;
    if (range <= 0) return;
    final year =
        widget.minYear + (range * _playController.value).round();
    if (year != _currentYear && year >= widget.minYear && year <= widget.maxYear) {
      _currentYear = year;
      widget.onYearChanged(year);
    }
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        if (_playController.isCompleted) {
          _playController.reset();
        }
        _playController.forward();
      } else {
        _playController.stop();
      }
    });
  }

  @override
  void dispose() {
    _playController.stop();
    _playController.removeListener(_onPlayTick);
    _playController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (widget.maxYear <= widget.minYear) return const SizedBox.shrink();

    return Container(
      height: widget.eras.isNotEmpty ? 80 : 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: theme.colorScheme.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Era color bands
          if (widget.eras.isNotEmpty) _buildEraBands(theme),
          // Slider row
          Expanded(
            child: Row(
              children: [
                // Play/Pause button with animation
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: theme.colorScheme.primary,
                  ),
                  onPressed: widget.enabled ? _togglePlay : null,
                  tooltip: _isPlaying ? 'Pause' : 'Auto-play timeline',
                ).animate(target: _isPlaying ? 1 : 0).scaleXY(
                  end: 1.15,
                  duration: 150.ms,
                  curve: Curves.easeOutBack,
                ),
                // Year label
                SizedBox(
                  width: 82,
                  child: Text(
                    'Year: $_currentYear',
                    style: theme.textTheme.labelMedium!.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Slider
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: theme.colorScheme.primary,
                      inactiveTrackColor:
                          theme.colorScheme.outline.withOpacity(0.3),
                      thumbColor: theme.colorScheme.primary,
                      overlayColor:
                          theme.colorScheme.primary.withOpacity(0.12),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: _currentYear.toDouble(),
                      min: widget.minYear.toDouble(),
                      max: widget.maxYear.toDouble(),
                      divisions:
                          (widget.maxYear - widget.minYear).clamp(1, 200),
                      label: '$_currentYear',
                      onChanged: widget.enabled
                          ? (val) {
                              setState(() => _currentYear = val.round());
                              widget.onYearChanged(val.round());
                            }
                          : null,
                    ),
                  ),
                ),
                // Entity count
                SizedBox(
                  width: 48,
                  child: Text(
                    '${widget.visibleEntityCount}/${widget.totalEntityCount}',
                    style: theme.textTheme.labelMedium!.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 4),
                if (widget.onClose != null)
                  IconButton(
                    icon: Icon(Icons.close,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant),
                    onPressed: widget.onClose,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 28,
                      minHeight: 28,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEraBands(ThemeData theme) {
    final range = widget.maxYear - widget.minYear;
    if (range <= 0) return const SizedBox.shrink();

    return SizedBox(
      height: 22,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          return Stack(
            children: widget.eras.map((era) {
              final leftFrac = (era.startYear - widget.minYear) / range;
              final widthFrac =
                  (era.endYear - era.startYear) / range;
              final left = leftFrac * totalWidth;
              final width =
                  (widthFrac * totalWidth).clamp(4.0, totalWidth);
              return Positioned(
                left: left,
                width: width,
                top: 2,
                bottom: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: era.color.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    era.label,
                    style: TextStyle(
                      color: era.color,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
