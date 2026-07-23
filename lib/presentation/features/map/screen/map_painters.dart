import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../domain/map/map_pin.dart';
import '../../../../domain/manuscript/manuscript_chapter.dart';
import '../../../../domain/relationship/relationship.dart';

class DistanceLinePainter extends CustomPainter {
  final Offset startPercent;
  final Offset? endPercent;
  final Color color;

  DistanceLinePainter({
    required this.startPercent,
    required this.endPercent,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (endPercent == null) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final start = Offset(startPercent.dx * size.width, startPercent.dy * size.height);
    final end = Offset(endPercent!.dx * size.width, endPercent!.dy * size.height);

    final glowPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..strokeWidth = 8.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(start, end, glowPaint);
    canvas.drawLine(start, end, paint);

    final ringPaint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(start, 5, fillPaint);
    canvas.drawCircle(start, 5, ringPaint);
    canvas.drawCircle(start, 2.5, Paint()..color = color);

    canvas.drawCircle(end, 5, fillPaint);
    canvas.drawCircle(end, 5, ringPaint);
    canvas.drawCircle(end, 2.5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant DistanceLinePainter oldDelegate) =>
      oldDelegate.startPercent != startPercent ||
      oldDelegate.endPercent != endPercent ||
      oldDelegate.color != color;
}

class HeatmapPainter extends CustomPainter {
  final List<MapPin> pins;
  final List<Entity> entities;
  final List<Relationship> relationships;
  final List<ManuscriptChapter> chapters;

  HeatmapPainter({
    required this.pins,
    required this.entities,
    required this.relationships,
    required this.chapters,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final pin in pins) {
      final entity = entities.where((e) => e.id == pin.entityId).firstOrNull;
      if (entity == null) continue;

      final relCount = relationships
          .where((r) => r.sourceId == entity.id || r.targetId == entity.id)
          .length;
      final mentionCount = chapters.where((c) {
        final nameLower = entity.name.toLowerCase();
        return c.title.toLowerCase().contains(nameLower) ||
            c.content.toLowerCase().contains(nameLower) ||
            c.locationId == entity.id;
      }).length;

      final score = 1.0 + relCount * 1.5 + mentionCount * 2.0;
      final radius = 30.0 + score * 8.0;
      final maxRadius = radius.clamp(35.0, 160.0);
      final opacity = (0.2 + (score * 0.04)).clamp(0.2, 0.7);

      final pinColor = Color(entity.iconColor);
      final center = Offset(pin.xPercent * size.width, pin.yPercent * size.height);

      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            pinColor.withOpacity(opacity),
            pinColor.withOpacity(opacity * 0.4),
            pinColor.withOpacity(0.0),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: maxRadius));

      canvas.drawCircle(center, maxRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant HeatmapPainter oldDelegate) => true;
}

class JourneyPathPainter extends CustomPainter {
  final List<Offset> pathPercent;
  final Color color;

  JourneyPathPainter({
    required this.pathPercent,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (pathPercent.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..color = color.withOpacity(0.18)
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final arrowPaint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < pathPercent.length - 1; i++) {
      final start =
          Offset(pathPercent[i].dx * size.width, pathPercent[i].dy * size.height);
      final end = Offset(
          pathPercent[i + 1].dx * size.width, pathPercent[i + 1].dy * size.height);

      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..lineTo(end.dx, end.dy);

      canvas.drawPath(path, glowPaint);
      canvas.drawPath(path, paint);

      final mid = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);
      final angle = math.atan2(end.dy - start.dy, end.dx - start.dx);

      final arrowPath = Path()
        ..moveTo(
            mid.dx - 6 * math.cos(angle - math.pi / 6),
            mid.dy - 6 * math.sin(angle - math.pi / 6))
        ..lineTo(mid.dx, mid.dy)
        ..lineTo(
            mid.dx - 6 * math.cos(angle + math.pi / 6),
            mid.dy - 6 * math.sin(angle + math.pi / 6));
      canvas.drawPath(arrowPath, arrowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant JourneyPathPainter oldDelegate) =>
      oldDelegate.pathPercent != pathPercent || oldDelegate.color != color;
}

class CustomRoute {
  final String id;
  final String name;
  final String type;
  final List<Offset> points;

  CustomRoute({
    required this.id,
    required this.name,
    required this.type,
    required this.points,
  });
}

class GridPainter extends CustomPainter {
  final String type;
  final double size;
  final double opacity;
  final Color color;

  GridPainter({
    required this.type,
    required this.size,
    required this.opacity,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    if (type == 'square') {
      for (double x = 0; x < canvasSize.width; x += size) {
        canvas.drawLine(Offset(x, 0), Offset(x, canvasSize.height), paint);
      }
      for (double y = 0; y < canvasSize.height; y += size) {
        canvas.drawLine(Offset(0, y), Offset(canvasSize.width, y), paint);
      }
    } else {
      final double h = size;
      final double w = math.sqrt(3) * h / 2;

      final double rowHeight = h * 0.75;
      final double colWidth = w;

      int rowCount = (canvasSize.height / rowHeight).ceil() + 1;
      int colCount = (canvasSize.width / colWidth).ceil() + 1;

      for (int r = -1; r < rowCount; r++) {
        final double y = r * rowHeight;
        final double xOffset = (r % 2 == 0) ? 0 : colWidth / 2;

        for (int c = -1; c < colCount; c++) {
          final double x = c * colWidth + xOffset;
          final Offset center = Offset(x, y);

          final path = Path();
          for (int i = 0; i < 6; i++) {
            final double angle = 2 * math.pi / 6 * (i + 0.5);
            final double px = center.dx + (h / 2) * math.cos(angle);
            final double py = center.dy + (h / 2) * math.sin(angle);
            if (i == 0) {
              path.moveTo(px, py);
            } else {
              path.lineTo(px, py);
            }
          }
          path.close();
          canvas.drawPath(path, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) =>
      oldDelegate.type != type ||
      oldDelegate.size != size ||
      oldDelegate.opacity != opacity ||
      oldDelegate.color != color;
}

class FogOfWarPainter extends CustomPainter {
  final List<List<Offset>> revealedStrokes;
  final double brushSize;

  FogOfWarPainter({
    required this.revealedStrokes,
    required this.brushSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.saveLayer(rect, Paint());

    final fogPaint = Paint()
      ..color = Colors.black.withOpacity(0.85);
    canvas.drawRect(rect, fogPaint);

    final erasePaint = Paint()
      ..color = Colors.transparent
      ..blendMode = BlendMode.clear
      ..strokeWidth = brushSize
      ..strokeCap = StrokeCap.round;

    for (final stroke in revealedStrokes) {
      if (stroke.length < 2) {
        if (stroke.isNotEmpty) {
          final p = Offset(stroke.first.dx * size.width, stroke.first.dy * size.height);
          canvas.drawCircle(p, brushSize / 2, erasePaint);
        }
        continue;
      }

      final path = Path();
      path.moveTo(stroke.first.dx * size.width, stroke.first.dy * size.height);
      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx * size.width, stroke[i].dy * size.height);
      }
      canvas.drawPath(path, erasePaint..style = PaintingStyle.stroke);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant FogOfWarPainter oldDelegate) => true;
}

class CustomRoutesPainter extends CustomPainter {
  final List<CustomRoute> routes;

  CustomRoutesPainter({
    required this.routes,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final r in routes) {
      if (r.points.length < 2) continue;

      Color routeColor;
      double strokeWidth;
      bool isDashed = false;

      if (r.type == 'river') {
        routeColor = Colors.blue.withOpacity(0.8);
        strokeWidth = 3.5;
      } else if (r.type == 'trade') {
        routeColor = Colors.green;
        strokeWidth = 2.0;
        isDashed = true;
      } else if (r.type == 'magic') {
        routeColor = Colors.purple.withOpacity(0.9);
        strokeWidth = 2.5;
      } else {
        routeColor = Colors.brown.withOpacity(0.9);
        strokeWidth = 3.0;
        isDashed = true;
      }

      final paint = Paint()
        ..color = routeColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final path = Path();
      path.moveTo(r.points.first.dx * size.width, r.points.first.dy * size.height);
      for (int i = 1; i < r.points.length; i++) {
        path.lineTo(r.points[i].dx * size.width, r.points[i].dy * size.height);
      }

      if (isDashed) {
        _drawDashedPath(canvas, path, paint, 6.0, 4.0);
      } else {
        canvas.drawPath(path, paint);
      }
    }
  }

  void _drawDashedPath(
      Canvas canvas, Path path, Paint paint, double dashWidth, double dashSpace) {
    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double length = dashWidth;
        final Path extract = metric.extractPath(distance, distance + length);
        canvas.drawPath(extract, paint);
        distance += length + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomRoutesPainter oldDelegate) => true;
}

class ActiveRoutePainter extends CustomPainter {
  final List<Offset> points;
  final String type;

  ActiveRoutePainter({
    required this.points,
    required this.type,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    Color routeColor = Colors.red;
    if (type == 'river') routeColor = Colors.blue;
    else if (type == 'trade') routeColor = Colors.green;
    else if (type == 'magic') routeColor = Colors.purple;

    final paint = Paint()
      ..color = routeColor.withOpacity(0.6)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final nodePaint = Paint()
      ..color = routeColor
      ..style = PaintingStyle.fill;

    if (points.length >= 2) {
      final path = Path();
      path.moveTo(points.first.dx * size.width, points.first.dy * size.height);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx * size.width, points[i].dy * size.height);
      }
      canvas.drawPath(path, paint);
    }

    for (final pt in points) {
      final center = Offset(pt.dx * size.width, pt.dy * size.height);
      canvas.drawCircle(center, 4.5, nodePaint);
      canvas.drawCircle(
          center, 6.0,
          Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.0);
    }
  }

  @override
  bool shouldRepaint(covariant ActiveRoutePainter oldDelegate) => true;
}
