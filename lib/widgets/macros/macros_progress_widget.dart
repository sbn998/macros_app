import 'package:flutter/material.dart';

class CircularProgressWidget extends StatelessWidget {
  final double currentValue;
  final double totalValue;
  final Color color;

  const CircularProgressWidget({
    super.key,
    required this.color,
    required this.currentValue,
    required this.totalValue,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(160, 10),
      painter: RectangleProgressPainter(currentValue, totalValue, color),
    );
  }
}

class RectangleProgressPainter extends CustomPainter {
  final double currentValue;
  final double totalValue;
  final Color color;

  RectangleProgressPainter(this.currentValue, this.totalValue, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paintBackground = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.fill;

    final Paint paintForeground = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    double percentage = (currentValue / totalValue).clamp(0.0, 1.0);
    double progressWidth = size.width * percentage;

    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), paintBackground);

    canvas.drawRect(
        Rect.fromLTWH(0, 0, progressWidth, size.height), paintForeground);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is RectangleProgressPainter) {
      return oldDelegate.currentValue != currentValue ||
          oldDelegate.totalValue != totalValue;
    }
    return false;
  }
}
