import 'package:flutter/material.dart';

class LaravelBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFF5F5F5);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);


    final rectPaint1 = Paint()
      ..color = const Color(0xFFF687B3).withOpacity(0.5)
      ..style = PaintingStyle.fill;
    final path1 = Path()
      ..moveTo(size.width * 0.1, size.height * 0.2)
      ..lineTo(size.width * 0.4, size.height * 0.1)
      ..lineTo(size.width * 0.5, size.height * 0.4)
      ..lineTo(size.width * 0.2, size.height * 0.5)
      ..close();
    canvas.drawPath(path1, rectPaint1);

    // Rectángulo amarillo
    final rectPaint2 = Paint()
      ..color = const Color(0xFFFBBF24).withOpacity(0.5)
      ..style = PaintingStyle.fill;
    final path2 = Path()
      ..moveTo(size.width * 0.3, size.height * 0.6)
      ..lineTo(size.width * 0.6, size.height * 0.5)
      ..lineTo(size.width * 0.7, size.height * 0.8)
      ..lineTo(size.width * 0.4, size.height * 0.9)
      ..close();
    canvas.drawPath(path2, rectPaint2);

    // Curva naranja
    final curvePaint = Paint()
      ..color = const Color(0xFFF6AD55).withOpacity(0.5)
      ..style = PaintingStyle.fill;
    final path3 = Path()
      ..moveTo(size.width * 0.5, size.height * 0.3)
      ..quadraticBezierTo(
        size.width * 0.7, size.height * 0.1,
        size.width * 0.9, size.height * 0.3,
      )
      ..lineTo(size.width * 0.9, size.height * 0.5)
      ..quadraticBezierTo(
        size.width * 0.7, size.height * 0.7,
        size.width * 0.5, size.height * 0.5,
      )
      ..close();
    canvas.drawPath(path3, curvePaint);

    // Líneas de cuadrícula (simulando el efecto de profundidad)
    final linePaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), linePaint);
    }
    for (double i = 0; i < size.height; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}