import 'package:flutter/material.dart';

import '../theme/core_theme.dart';

/// Logo de GameNight: un dado con una luna creciente sobre un mosaico azul
/// noche. Se dibuja con código para verse nítido en cualquier tamaño.
class GameNightLogo extends StatelessWidget {
  final double size;

  const GameNightLogo({super.key, this.size = 72});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Logo de GameNight',
      image: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size * 0.2237),
          boxShadow: [
            BoxShadow(
              color: AppColors.primario.withValues(alpha: 0.3),
              blurRadius: size * 0.28,
              offset: Offset(0, size * 0.1),
            ),
          ],
        ),
        child: CustomPaint(
          size: Size.square(size),
          painter: _GameNightLogoPainter(),
        ),
      ),
    );
  }
}

class _GameNightLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final mosaico = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(s * 0.2237),
    );
    canvas.drawRRect(
      mosaico,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4B45A8), AppColors.primario],
        ).createShader(Offset.zero & size),
    );

    // Luna creciente: un círculo ámbar al que se le "muerde" otro círculo.
    final luna = Path.combine(
      PathOperation.difference,
      Path()..addOval(
        Rect.fromCircle(center: Offset(s * 0.70, s * 0.28), radius: s * 0.14),
      ),
      Path()..addOval(
        Rect.fromCircle(center: Offset(s * 0.77, s * 0.22), radius: s * 0.12),
      ),
    );
    canvas.drawPath(luna, Paint()..color = AppColors.acento);

    // Dado blanco ligeramente girado con cinco puntos.
    canvas.save();
    canvas.translate(s * 0.44, s * 0.58);
    canvas.rotate(-0.18);
    final lado = s * 0.42;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: lado, height: lado),
        Radius.circular(lado * 0.22),
      ),
      Paint()..color = Colors.white,
    );
    final punto = Paint()..color = AppColors.primario;
    final d = lado * 0.26;
    for (final p in [
      Offset(-d, -d),
      Offset(d, -d),
      Offset.zero,
      Offset(-d, d),
      Offset(d, d),
    ]) {
      canvas.drawCircle(p, lado * 0.085, punto);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
