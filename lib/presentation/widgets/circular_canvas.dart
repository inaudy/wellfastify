import 'dart:math';
import 'package:flutter/material.dart';

class CircularCanvas extends StatelessWidget {
  final double progress;
  const CircularCanvas({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size.square(200),
      painter: TimerPainter(progress: progress),
    );
  }
}

Shader _buildGradient(Size size) {
  return const LinearGradient(colors: [
    Colors.deepOrange,
    Colors.amber,
  ], stops: [
    0,
    1,
  ], tileMode: TileMode.clamp)
      .createShader(
    Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2),
  );
}

class TimerPainter extends CustomPainter {
  final double progress;
  TimerPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = Colors.indigo.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0;

    Paint progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 26.0
      ..strokeCap = StrokeCap.round
      ..shader = _buildGradient(size);

    Paint elapsedPaintCircle = Paint()
      ..color = Colors.indigo
      ..style = PaintingStyle.fill;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2;

    // Draw background circle
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw the arc
    double angle = 2 * pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      angle,
      false,
      progressPaint,
    );

    // Draw end circle
    double endX = center.dx + radius * cos(-3.141592653589793 / 2 + angle);
    double endY = center.dy + radius * sin(-3.141592653589793 / 2 + angle);
    canvas.drawCircle(Offset(endX, endY), 14.0, elapsedPaintCircle);
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
