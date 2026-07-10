import 'dart:math' as math;
import 'package:flutter/material.dart';

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({super.key});

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Angle oscillates to simulate writing/sketching motion
          final double angle = math.sin(_controller.value * 2 * math.pi) * 0.35;
          final double scale = 1.0 + math.sin(_controller.value * 2 * math.pi) * 0.06;
          return Transform.scale(
            scale: scale,
            child: CustomPaint(
              size: const Size(56, 56),
              painter: WritingQuillPainter(angle: angle, color: color),
            ),
          );
        },
      ),
    );
  }
}

class WritingQuillPainter extends CustomPainter {
  final double angle;
  final Color color;

  WritingQuillPainter({required this.angle, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final fillPaint = Paint()
      ..color = color.withOpacity(0.12)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(angle);

    // Quill nib tip path
    final nibPath = Path();
    nibPath.moveTo(0, 16);
    nibPath.lineTo(-5, 4);
    nibPath.lineTo(-5, -12);
    nibPath.lineTo(0, -28);
    nibPath.lineTo(5, -12);
    nibPath.lineTo(5, 4);
    nibPath.close();

    // Nib slit line
    canvas.drawLine(const Offset(0, 16), const Offset(0, 0), paint);

    // Quill feather vane path
    final featherPath = Path();
    featherPath.moveTo(-2, -8);
    featherPath.quadraticBezierTo(-16, -18, -12, -34);
    featherPath.quadraticBezierTo(-4, -36, 0, -28);
    featherPath.close();

    canvas.drawPath(nibPath, fillPaint);
    canvas.drawPath(nibPath, paint);
    canvas.drawPath(featherPath, fillPaint);
    canvas.drawPath(featherPath, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant WritingQuillPainter oldDelegate) {
    return oldDelegate.angle != angle || oldDelegate.color != color;
  }
}
