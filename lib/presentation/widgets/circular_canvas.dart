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

class TimerPainter extends CustomPainter {
  final double progress;
  TimerPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = Color.fromARGB(255, 97, 173, 250).withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0;

    Paint borderBackgroundPaint = Paint()
      ..color = Color.fromARGB(255, 97, 173, 250).withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0)
      ..strokeWidth = 1.0;

    Paint progressPaint = Paint()
      ..color = Color(0xff617AFA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    Paint elapsedPaintCircle = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Paint elapsedBorderPaintCircle = Paint()
      ..color = Color(0xff617AFA)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.0)
      ..style = PaintingStyle.stroke;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2;

    // Draw background circle
    canvas.drawCircle(center, radius, backgroundPaint);
    canvas.drawCircle(center, radius - 10, borderBackgroundPaint);

    // Draw the arc
    double angle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 10),
      -pi / 2,
      angle,
      false,
      borderBackgroundPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 8),
      -pi / 2,
      angle,
      false,
      progressPaint,
    );

    // Draw end circle
    double endX =
        center.dx + (radius - 10) * cos(-3.141592653589793 / 2 + angle);
    double endY =
        center.dy + (radius - 10) * sin(-3.141592653589793 / 2 + angle);
    canvas.drawCircle(Offset(endX, endY), 10, elapsedPaintCircle);

//Draw end circle border
    canvas.drawCircle(Offset(endX, endY), 10, elapsedBorderPaintCircle);
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
