import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fictionist/data/repository/plot_repository.dart';
import 'package:fictionist/domain/plot/plot_card.dart';
import 'package:fictionist/injection.dart';
import 'package:fictionist/presentation/common/widget/empty_state.dart';
import 'package:fictionist/presentation/common/widget/loading_indicator.dart';
import 'package:fictionist/presentation/common/widget/page_header.dart';

class PlotCanvasScreen extends ConsumerStatefulWidget {
  const PlotCanvasScreen({super.key});

  @override
  ConsumerState<PlotCanvasScreen> createState() => _PlotCanvasScreenState();
}

class _PlotCanvasScreenState extends ConsumerState<PlotCanvasScreen> {
  List<PlotCard> _cards = [];
  List<PlotConnection> _connections = [];
  bool _loading = true;

  // For connection drawing mode
  String? _connectingFromId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final repo = getIt<PlotRepository>();
    final cards = await repo.getAllCards();
    final conns = await repo.getAllConnections();
    if (mounted) {
      setState(() {
        cards.fold((_) => _cards = [], (c) => _cards = c);
        conns.fold((_) => _connections = [], (c) => _connections = c);
        _loading = false;
      });
    }
  }

  Future<void> _addCard() async {
    final controller = TextEditingController();
    final title = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('New Plot Card'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Card title...', border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text('Create')),
        ],
      ),
    );
    if (title != null && title.trim().isNotEmpty) {
      final repo = getIt<PlotRepository>();
      await repo.createCard(title: title.trim());
      _loadData();
    }
  }

  Future<void> _updateCardPosition(String id, Offset delta) async {
    final card = _cards.firstWhere((c) => c.id == id);
    final repo = getIt<PlotRepository>();
    await repo.updateCardPosition(id, card.xPosition + delta.dx, card.yPosition + delta.dy);
    _loadData();
  }

  Future<void> _deleteCard(String id) async {
    final repo = getIt<PlotRepository>();
    await repo.deleteCard(id);
    _loadData();
  }

  void _toggleConnectionMode(String cardId) {
    setState(() {
      _connectingFromId = _connectingFromId == cardId ? null : cardId;
    });
  }

  Future<void> _createConnection(String targetId) async {
    if (_connectingFromId == null || _connectingFromId == targetId) return;
    final repo = getIt<PlotRepository>();
    await repo.createConnection(_connectingFromId!, targetId);
    setState(() => _connectingFromId = null);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: const Center(child: LoadingIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        toolbarHeight: 48,
        actions: [
          if (_connectingFromId != null)
            TextButton.icon(
              onPressed: () => setState(() => _connectingFromId = null),
              icon: Icon(Icons.close, color: Theme.of(context).colorScheme.error, size: 18),
              label: Text('Cancel Link', style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          IconButton(icon: Icon(Icons.add, color: Theme.of(context).colorScheme.primary), tooltip: 'Add Card', onPressed: _addCard),
          IconButton(icon: Icon(Icons.refresh, color: Theme.of(context).colorScheme.onSurfaceVariant), onPressed: _loadData),
        ],
      ),
      body: _cards.isEmpty
          ? Center(
              child: EmptyState(
                title: 'Corkboard is Empty',
                message: 'Add plot cards to outline story beats and connect them with cause-and-effect arrows.',
                icon: Icons.dashboard_customize_outlined,
              ),
            )
          : Stack(
              children: [
                Positioned(
                  top: 0, left: 0, right: 0,
                  child: PageHeader(
                    title: 'Plot',
                    subtitle: 'Story outline and plot cards',
                  ),
                ),
                InteractiveViewer(
                  constrained: false,
                  boundaryMargin: const EdgeInsets.all(500),
                  minScale: 0.2,
                  maxScale: 3.0,
                  child: SizedBox(
                    width: 2000,
                    height: 2000,
                    child: CustomPaint(
                      painter: _ConnectionPainter(
                        connections: _connections,
                        cards: _cards,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Stack(
                        children: _cards.map((card) {
                          final color = Color(card.colorHex);
                          return Positioned(
                            left: card.xPosition,
                            top: card.yPosition,
                            child: GestureDetector(
                              onPanUpdate: (details) {
                                setState(() {
                                  final idx = _cards.indexWhere((c) => c.id == card.id);
                                  if (idx != -1) {
                                    final current = _cards[idx];
                                    _cards[idx] = current.copyWith(
                                      xPosition: current.xPosition + details.delta.dx,
                                      yPosition: current.yPosition + details.delta.dy,
                                    );
                                  }
                                });
                              },
                              onPanEnd: (details) async {
                                final current = _cards.firstWhere((c) => c.id == card.id);
                                final repo = getIt<PlotRepository>();
                                await repo.updateCardPosition(card.id, current.xPosition, current.yPosition);
                              },
                              child: _PlotCardWidget(
                                card: card,
                                color: color,
                                isConnecting: _connectingFromId == card.id,
                                isConnectTarget: _connectingFromId != null && _connectingFromId != card.id,
                                onDelete: () => _deleteCard(card.id),
                                onConnect: () => _toggleConnectionMode(card.id),
                                onConnectTarget: () => _createConnection(card.id),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                if (_connectingFromId != null)
                  Positioned(
                    bottom: 20, left: 0, right: 0,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(20)),
                        child: const Text('Tap a target card to connect →', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _PlotCardWidget extends StatelessWidget {
  final PlotCard card;
  final Color color;
  final bool isConnecting;
  final bool isConnectTarget;
  final VoidCallback onDelete;
  final VoidCallback onConnect;
  final VoidCallback? onConnectTarget;

  const _PlotCardWidget({
    required this.card,
    required this.color,
    required this.isConnecting,
    required this.isConnectTarget,
    required this.onDelete,
    required this.onConnect,
    this.onConnectTarget,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDraft = card.summary == null || card.summary!.trim().isEmpty;
    final borderColor = isConnecting 
        ? color 
        : (isConnectTarget 
            ? Theme.of(context).colorScheme.primary 
            : (isDraft ? Theme.of(context).colorScheme.outline.withOpacity(0.5) : color.withOpacity(0.8)));

    final int hash = card.id.hashCode;
    final double tiltAngle = (isConnecting || isConnectTarget) ? 0.0 : (((hash % 8) - 4) * 0.006); // -0.024 to +0.024 rad (~ -1.3deg to +1.3deg)

    return Transform.rotate(
      angle: tiltAngle,
      child: CustomPaint(
        painter: isDraft
            ? DashedBorderPainter(
                color: borderColor,
                strokeWidth: isConnecting || isConnectTarget ? 2.0 : 1.2,
              )
            : null,
        child: Container(
          width: 180,
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 20), // Polaroid bottom gap
          decoration: BoxDecoration(
            color: isConnecting ? color.withOpacity(0.12) : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: isDraft
                ? null
                : Border.all(
                    color: borderColor,
                    width: isConnecting || isConnectTarget ? 2.0 : 1.2,
                  ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 6,
                offset: const Offset(1, 3),
              ),
            ],
          ),
          child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Expanded(child: Text(card.title, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis)),
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  iconSize: 16,
                  color: Theme.of(context).colorScheme.surface,
                  onSelected: (v) {
                    if (v == 'delete') onDelete();
                    if (v == 'connect') onConnect();
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'connect', child: Text('Connect', style: TextStyle(fontSize: 13))),
                    PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 13))),
                  ],
                ),
              ],
            ),
            if (card.summary != null && card.summary!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(card.summary!, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 11), maxLines: 3, overflow: TextOverflow.ellipsis),
            ],
            if (isConnectTarget) ...[
              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                height: 28,
                child: FilledButton(onPressed: onConnectTarget, style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2), foregroundColor: Theme.of(context).colorScheme.primary, padding: EdgeInsets.zero),
                  child: const Text('Connect Here', style: TextStyle(fontSize: 11)),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashLength;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.gap = 4.0,
    this.dashLength = 6.0,
    this.borderRadius = 10.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    ));

    final dashPath = Path();
    double distance = 0.0;
    for (final pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        final double len = math.min(dashLength, pathMetric.length - distance);
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + len),
          Offset.zero,
        );
        distance += len + gap;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gap != gap ||
        oldDelegate.dashLength != dashLength;
  }
}

class _ConnectionPainter extends CustomPainter {
  final List<PlotConnection> connections;
  final List<PlotCard> cards;
  final Color color;

  _ConnectionPainter({required this.connections, required this.cards, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = color.withOpacity(0.06)
      ..style = PaintingStyle.fill;
    const double spacing = 32.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.0, gridPaint);
      }
    }

    final paint = Paint()
      ..color = color.withOpacity(0.4)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (final conn in connections) {
      final source = cards.where((c) => c.id == conn.sourceId).firstOrNull;
      final target = cards.where((c) => c.id == conn.targetId).firstOrNull;
      if (source == null || target == null) continue;

      final start = Offset(source.xPosition + 90, source.yPosition + 40);
      final end = Offset(target.xPosition + 90, target.yPosition + 40);

      // Draw arrow
      canvas.drawLine(start, end, paint);

      // Arrowhead
      final angle = math.atan2(end.dy - start.dy, end.dx - start.dx);
      final arrowLen = 10.0;
      final arrowAngle = 0.4;
      final p1 = Offset(end.dx - arrowLen * math.cos(angle - arrowAngle), end.dy - arrowLen * math.sin(angle - arrowAngle));
      final p2 = Offset(end.dx - arrowLen * math.cos(angle + arrowAngle), end.dy - arrowLen * math.sin(angle + arrowAngle));

      final arrowPaint = Paint()..color = color.withOpacity(0.4)..style = PaintingStyle.fill;
      final path = Path()..moveTo(end.dx, end.dy)..lineTo(p1.dx, p1.dy)..lineTo(p2.dx, p2.dy)..close();
      canvas.drawPath(path, arrowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConnectionPainter old) => true;
}
