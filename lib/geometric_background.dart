import 'package:flutter/material.dart';

class GeometricBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Gradiente de fondo
    final gradient = LinearGradient(
      colors: const [
        Color(0xFF87CEEB), // Azul claro
        Color(0xFF32CD32), // Verde lima
        Color(0xFFFF00), // Amarillo
        Color(0xFF8B008B), // Magenta
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Formas geométricas
    final shapePaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // Rectángulo diagonal
    final path1 = Path()
      ..moveTo(0, size.height * 0.3)
      ..lineTo(size.width * 0.7, 0)
      ..lineTo(size.width, size.height * 0.2)
      ..lineTo(size.width * 0.3, size.height * 0.5)
      ..close();
    canvas.drawPath(path1, shapePaint);

    // Triángulo
    final path2 = Path()
      ..moveTo(size.width * 0.2, size.height * 0.6)
      ..lineTo(size.width * 0.5, size.height * 0.4)
      ..lineTo(size.width * 0.8, size.height * 0.7)
      ..close();
    canvas.drawPath(path2, shapePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}