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
      ..strokeWidth = 30.0
      ..strokeCap = StrokeCap.round
      ..shader = _buildGradient(size);

    Paint elapsedPaintCircle = Paint()
      ..color = Colors.indigo
      ..style = PaintingStyle.fill;

    Paint borderPaintStarted = Paint()
      ..color = Colors.indigo
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2;
    canvas.drawCircle(center, radius, backgroundPaint);

    double angle = 2 * pi;
    angle = angle * (progress > 0 ? progress + 0.001 : progress);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      angle,
      false,
      progressPaint,
    );
    double elapsedAngle = -pi / 2 + 2 * pi * progress;
    double elapsedX = center.dx + radius * cos(elapsedAngle);
    double elapsedY = center.dy + radius * sin(elapsedAngle);

    canvas.drawCircle(
      Offset(center.dx + radius * cos(-pi / 2 + 2 * pi),
          center.dy + radius * sin(-pi / 2 + 2 * pi)),
      9.0,
      borderPaintStarted,
    );
    canvas.drawCircle(
      Offset(elapsedX, elapsedY),
      10.0,
      elapsedPaintCircle,
    );
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
